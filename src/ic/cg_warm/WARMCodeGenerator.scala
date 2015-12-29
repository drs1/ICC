package ic.cg_warm

import ic.ast._
import java.io._
import ic.error._
import ic.tac._
import ic.asm._
import ic.asm.cfg._
import ic.Util
import scala.collection.mutable.HashMap

class WARMCodeGenerator(override val icFileName: String, override val program: ASTProgram, val makeRegAlloc: () => RegisterAllocator) 
    extends CodeGenerator(icFileName, program){

  val asmFile = icFileName.substring(0, icFileName.indexOf('.')) + ".s";
  val out = new PrintWriter(new FileWriter(asmFile));

  val paramReg: List[String] = List("r0", "r1", "r2", "r3");

  var classForMain = ""
  var sizeOfMainObject = -1;
  var offsetOfMainInVT = -1;
  
  ASMInstr.commentSequence = ";;;"

  def generate() = {
    out.println(";;;  File " + asmFile);
    out.println();
    out.println("\t .requ	bump, r3");    
    out.println("\t b      main");    
    
    generateVTables();
    out.println("\n")
    
    out.println("\n")    
    generateCode()
    generateErrorHandlers();


    //Main not found in any of the classes
    if (classForMain.equals("")) {throw new SemanticError("No main method found in the file.");}

    generateMain(classForMain, sizeOfMainObject, offsetOfMainInVT);
    generateStringConstants();
    genLibCalls();
    generateHeap();
    out.close();
  }
  
  protected def generateHeap() = {
    out.println("heap:")
  }

  protected def generateVTables() = {
    out.println(";; ----------------------------");
    out.println(";; VTables");

    out.println();

    out.println("");

    for (cls <- program.classes) {
      out.println(cls.cls_id + "VT:");

      // v table size is known already, we can do this all with an array
      // because we know any subclass is going to have at least as many 
      // methods as the superclass, and the super will have no more methods than
      // the child
      var vTable: Array[(Int, String, String)] = Array.ofDim[(Int, String, String)](cls.v_size)
      //structured weird because of the recursion
      cls.ext match {
        case Some(x) => {
          makeVList(x, vTable)
        }
        case None => {}
      }

      for (decl <- cls.decls) {
        decl match {
          case n: ASTMethodDecl => {
            vTable(n.offset) = (n.offset, cls.cls_id, n.id);
          }
          case n: ASTFieldDecl => {}
        }
      }

      out.println("\t.data \t" + vTable.map(x => x._2 + x._3.capitalize).mkString(", ") + "," + 0);
      out.println("")
      
    }
  }
  
  //recurse up to the highest super class. Add all the methods
  def makeVList(cls: ASTTypeClass, vt: Array[(Int, String, String)]): Array[(Int, String, String)] = {
    var table = vt
    //get the decl of the super
    cls.decl.ext match {
      case Some(x) => makeVList(x, table)
      case None => {
        for (decl <- cls.decl.decls) {
          decl match {
            case m: ASTMethodDecl => table(m.offset) = (m.offset, cls.decl.cls_id, m.id);
            case f: ASTFieldDecl  => {}
          }
        }
        return table;
      }
    }
  }
  
  //Iterate over classes in program.  When a method is found, create the
  //prologue and epilogue of the method along with generating the code based on the list
  //of TAC Instructions associated with the method.
  protected def generateCode() = {
    for (cls <- program.classes) {
      for (decl <- cls.decls) {
        decl match {
          case m: ASTMethodDecl => {
            //If we find a main method, set information for it. If we have already found a main method,\
            //throw error.
            if (m.id.equals("main")) {
              if (classForMain.equals("")) {
                classForMain = cls.cls_id;
                sizeOfMainObject = cls.size * WARMMachineDescription.sizeOfDataElement();
                offsetOfMainInVT = m.offset * WARMMachineDescription.sizeOfDataElement();
              } else
                throw new SemanticError("More than 1 main method found in the same file.");
            }

            genBody(cls, m);
          }
          case f: ASTFieldDecl => {}
        }
      }
    }
  }
  
  def genBody(cls: ASTClassDecl, m: ASTMethodDecl) = {

     val regAlloc = makeRegAlloc();

    // Add formals and "this" to virtual register offset map so
    // we can find them later
    for (x <- m.forms) {
      println(x + " " + x.offset);
      regAlloc.addVirtualRegister(VirtualRegister(x.id), (x.offset * WARMMachineDescription.sizeOfDataElement()));
    }
    regAlloc.addVirtualRegister(VirtualRegister("this"), 2 * WARMMachineDescription.sizeOfDataElement());

     /* ********* The BIG STEPS ******** */
     
     // Translate TAC -> CFG and CFG -> CFG[TACInstr]  
     val cfgBuilder = new ic.cfg.CFGGenerator();
     val cfg = ControlFlowGraph.fromBaseCFG(cfgBuilder.makeCFG(m));
     
     // Translate CFG[TACInstr] > CFG[List[AbsASM]]
     val tac2Abs = new TACtoAbsASM();
     val absCFG = cfg.convert(x => tac2Abs.convert(List(x.contents)));
     
     Util.debug("ABS: ")
     Util.debug(ASMPrinter.absToString(absCFG.flatMap(_.contents)));
     
     // Translate CFG[List[AbsASM]] -> CFG[List[ASM]].
     val asm = regAlloc.devirtualize(absCFG);
     
     Util.debug("ASM: ")
     Util.debug(ASMPrinter.asmToString(asm.flatMap(_.contents)));
     
     /*************************************/
    
    out.println(cls.cls_id + m.id.capitalize + ":");
    
    out.println("\tstu    lr, [sp, #-1]")
    out.println("\tstu    fp, [sp, #-1]");
    out.println("\tmov    fp, sp");
    // move sp below all allocated virtual register slots.
    out.println("\tsub    sp, sp, #" + -(regAlloc.getMaxHomeOffset() - WARMMachineDescription.firstAvailableOffsetForLocals()));
    
    out.println("")
    
    out.println("\t;;; ---- method instructions ------")
    
    out.println(ASMPrinter.asmToString(asm.flatMap(_.contents)));

    out.println("")

    //out.println("\tmov    sp, fp");
    //out.println("\tldu    fp, [sp, #1]");
    //out.println("\tldu    pc, [sp, #1]");
    //out.println("\n");
  }
  
  
  protected def generateErrorHandlers() = {
    out.println(";; ----------------------------");
    out.println(";; Error handling.  Jump to these procedures when a run-time check fails.");
    out.println("");
    out.println("strNullPtrError: \n\t .string \t\"Null pointer violation.\"");
    out.println("");
    out.println("strArrayBoundsError: \n\t.string \t \"Array bounds violation.\"");
    out.println("");
    out.println("strArraySizeError: \n\t	.string \t \"Array size violation.\"");
    out.println("");
    out.println("strdivByZeroError:   \n\t  .string \"Divide by 0 violation.\"");
    out.println("");

    out.println("labelNullPtrError:");
    out.println("\t adr    r0, strNullPtrError");
    out.println("\t bl     LIBPrintln");
    out.println("\t mov    r0, #1");
    out.println("\t swi    #SysHalt");
    out.println("\n");

    out.println("labelArrayBoundsError:");
    out.println("\t adr    r0, strArrayBoundsError");
    out.println("\t bl     LIBPrintln");
    out.println("\t mov    r0, #1");
    out.println("\t swi    #SysHalt");
    out.println("\n");
    out.println("labelArraySizeError:");
    out.println("\t adr    r0, strArraySizeError");
    out.println("\t bl     LIBPrintln");
    out.println("\t mov    r0, #1");
    out.println("\t swi    #SysHalt");
    out.println("\n");
    out.println("labelDivByZeroError:");
    out.println("\t adr    r0, strdivByZeroError");
    out.println("\t bl     LIBPrintln");
    out.println("\t mov    r0, #1");
    out.println("\t swi    #SysHalt");
    out.println("\n\n");
  }

  /**
   * Generate the __ic_main stub that creates and calls main on
   * the right object.  You should not need to change this
   * method.
   * @param className                name of the class containing main
   * @param objectSize               size of objects of that class
   * @param indexOfMainInVTable      index on that class's vtable for main
   */
  protected def generateMain(className: String, objectSize: Int, indexOfMainInVTable: Int) = {
    out.println("");

    out.println("main:");
    out.println(";;; main, set the bump pointer to the beginning of the heap");
    out.println("\t adr    bump, heap      				")
    out.println("\t stu    lr, [sp, #-1]    				");
    out.println("\t stu    fp, [sp, #-1]    				");
    out.println("\t mov    fp, sp         			  ");
    out.println("");    
    out.println(s";;; o = new $className          ");
    out.println(s"\t mov    r0,  #${objectSize}   ");
    out.println("\t bl     LIBAllocateObject   			");
    out.println(s"\t adr    r1, ${className}VT      ");
    out.println("");
    out.println(";;; move the vptr into the object");          
    out.println("\t str    r1, [r0]               ");
    out.println("");
    out.println("");
    out.println(";;; call the object's main       ");
    out.println("\t stu    r0, [sp, #-1]  ");
    out.println("\t stu    r0, [sp, #-1]  ");
    out.println(s"\t bl     ${className}Main      ");
    out.println("");
    out.println("");
    out.println(";;;ic_main always returns 0"      );
    out.println("\t mov    r0, #0                 ");
    out.println("\t mov    sp, fp                 ");
    out.println("\t ldu    fp, [sp, #1]           ");
    out.println("\t swi    #SysHalt"               );
    out.println("");
  }
  /**
   * Iterate over all used string constants and print them into
   * a data segment.  You should not need to change this method.
   */
  protected def generateStringConstants() = {
    out.println(";;; ----------------------------");
    out.println(";;; String Constants");

    out.println("\n");
    
    for ((str, label) <- CodeGenerator.stringConstantsToLabel) {
      val escapedString =
        "\"" + str.replace("\n", "\\n").replace("\t", "\\t").replace("\"", "\\\"").replace("\r", "\\r") + "\"";
      out.println(s"${label}:\t.string ${escapedString}");
      }
    out.println("");
    out.println("");
    out.println("");
  }
  
  
  protected def genLibCalls() = {
    out.println(";;; ------------------------------")
    out.println(";;; Library Calls")
    out.println("");
    out.println("");
    out.println("LIBAllocateObject:");
    out.println(";;; object size gets passed in r0");                                                    out.println("\tstu     lr, [sp, #-1]");
    out.println("\tmov     r1, bump");
    out.println("\tadd     bump, r0, bump");
    out.println("\tmov     r0, r1");
    out.println("\tldu     pc, [sp, #1]");
    out.println("\n")

    out.println("LIBRandom:");
    out.println("\t	stu	lr, [sp, #-1]	");
    out.println("\t	mov	r1, r0");
    out.println("randLoop:");
    out.println("\t	swis	#SysEntropy")

    out.println(";;; make sure it's not negative");
    out.println("\t	blt	randLoop");
    out.println("\t	cmp	r1, r0");
    out.println("\t blt	randLoop");
    out.println("\t ldu	pc, [sp, #1]");
    out.println("\n")	


    out.println("LIBAllocateArray:");
    out.println("\tstu	   lr, [sp, #-1]");
    out.println("\tstr     r0, [bump]");
    out.println("\tmov	   r1, bump");
    out.println("\tadd	   bump, r0, bump");
    out.println("\tmov	   r0, r1");
    out.println("\tldu	   pc, [sp, #1]");
    out.println("\n")

    out.println("LIBPrintln:");
    out.println(";;; address of the string is in r0");
    out.println("\t stu	lr, [sp, #-1]");
    out.println("\t mov	r1, r0");
    out.println("\n");

    out.println("printlnLoop:	")
    out.println("\t ldrs   r0, [r1]");
    out.println("\t beq    printlnDone");
    out.println("\t swi    #SysPutChar");
    out.println("\t add    r1, r1, #1");
    out.println("\t b      printlnLoop");
    out.println("\n")

    out.println("printlnDone:");
    out.println("\t mov	   r0, #10");
    out.println("\t swi	   #SysPutChar");
    out.println("\t ldu	   pc, [sp, #1]");
    out.println("\t \n");

    out.println("LIBPrint:")
    out.println("\tstu	lr, [sp, #-1]");
    out.println("\tmov	r1, r0");
	
    out.println("printLoop:")
    out.println("\tldrs    r0, [r1]");
    out.println("\tbeq	   printDone");
    out.println("\tswi	   #SysPutChar");
    out.println("\tadd	   r1, r1, #1");
    out.println("\tb	     printLoop");
    out.println("printDone:");
    out.println("\tldu	   pc, [sp, #1]");
    

    out.println("LIBPrinti:");
    out.println("\tstu	   lr, [sp, #-1]");
    out.println("\tswi	   #SysPutNum");
    out.println("\tldu	   pc, [sp, #1]");
    out.println("\n\n")
	
    out.println("LIBPrintb:");
    out.println("\tstu	   lr, [sp, #-1]");
    out.println("\tcmp	   r0, #1");
    out.println("\tbeq	   true");
    out.println("\n")

    out.println("false:	mov	r0, #'F");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tmov	  r0, #'a");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tmov	  r0, #'l");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tmov	  r0, #'s");
    out.println("\tswi 	  #SysPutChar")
    out.println("\tmov	  r0, #'e");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tldu	  pc, [sp, #1]");

    out.println("true:	mov    r0, #'T");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tmov	  r0, #'r");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tmov	  r0, #'u");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tmov	  r0, #'e");
    out.println("\tswi 	  #SysPutChar");
    out.println("\tldu	  pc, [sp, #1]");

    out.println("LIBExit:");
    out.println("\tswi	  #SysHalt")    
  }
}

