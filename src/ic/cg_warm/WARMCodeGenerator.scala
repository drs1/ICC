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

  def generate() = {
    out.println(";;;  File " + asmFile);
    out.println();
    out.println(".requ	bump, r3");    
    out.println("\t b      main");    
    
    generateVTables();
    generateCode()
    //generateErrorHandlers();


    //Main not found in any of the classes
    if (classForMain.equals("")) {throw new SemanticError("No main method found in the file.");}

    generateMain(classForMain, sizeOfMainObject, offsetOfMainInVT);
  //  generateStringConstants();
    out.close();
  }

  protected def generateVTables() = {
    out.println(";; ----------------------------");
    out.println(";; VTables");

    out.println();
    out.println(".align 4");
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

      out.println("\t.data \t" + vTable.map(x => x._2 + x._3.capitalize).mkString(", "));
      
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
      regAlloc.addVirtualRegister(VirtualRegister(x.id), x.offset * WARMMachineDescription.sizeOfDataElement());
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
    
    out.println("_" + cls.cls_id + "_" + m.id + ":");
    out.println("\t# ----- prologue ------");
    out.println("\tpushq %rbp");
    out.println("\tmovq %rsp, %rbp");
    
    // move %rsp below all allocated virtual register slots.
    out.println("\tsubq $" + -(regAlloc.getMaxHomeOffset() - WARMMachineDescription.firstAvailableOffsetForLocals()) + ", %rsp");
    
    out.println("")
    
    out.println("\t# ---- method instructions ------")
    
    //out.println(ASMPrinter.asmToString(asm.flatMap(_.contents)));

    out.println("")

    out.println("epilogue_" + cls.cls_id + "_" + m.id + ":");
    out.println("movq %rbp,%rsp");
    out.println("popq %rbp");
    out.println("ret");
    out.println("\n");
  }
  
  
  protected def generateErrorHandlers() = {
    out.println(";; ----------------------------");
    out.println(";; Error handling.  Jump to these procedures when a run-time check fails.");
    out.println("");
    out.println(".align 4");
    out.println("strNullPtrError: \n\t .string \t\"Null pointer violation.\"");
    out.println("");
    out.println(".align 4");
    out.println("  strArrayBoundsError: \n\t.string \t \"Array bounds violation.\"");
    out.println("");
    out.println(".align");
    out.println("strArraySizeErrorChars: \n\t	.string \t \"Array size violation.\"");
    out.println("");
    out.println(".align");
    out.println("divByZeroErrorChars:   \n\t  .string \"Divide by 0 violation.\"");
    out.println("");

    out.println(".text");
    out.println(".align 8");
    out.println("labelNullPtrError:");
    out.println("    movq strNullPtrError(%rip), %rdi");
    out.println("    call __LIB_println");
    out.println("    movq $1, %rdi");
    out.println("    call __LIB_exit");
    out.println("");
    out.println(".align 8");
    out.println("labelArrayBoundsError:");
    out.println("    movq strArrayBoundsError(%rip), %rdi");
    out.println("    call __LIB_println");
    out.println("    movq $1, %rdi");
    out.println("    call __LIB_exit");
    out.println("");
    out.println(".align 8");
    out.println("labelArraySizeError:");
    out.println("    movq strArraySizeError(%rip), %rdi");
    out.println("    call __LIB_println");
    out.println("    movq $1, %rdi");
    out.println("    call __LIB_exit");
    out.println("");
    out.println(".align 8");
    out.println("labelDivByZeroError:");
    out.println("    movq divByZeroError(%rip), %rdi");
    out.println("    call __LIB_println");
    out.println("    movq $1, %rdi");
    out.println("    call __LIB_exit");
    out.println("");
    out.println("");
    out.println("");
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
    out.println(".align 4");
    out.println("main:");
    out.println(";;; main, set the bump pointer to the beginning of the heap");
    out.println("\t adr    bump, heap      				")
    out.println("\t stu    lr, [sp, #1]    				");
    out.println("\t stu    fp, [sp, #1]    				");
    out.println("\t mov    fp, sp         			  ");
    out.println("");    
    out.println(s";;; o = new $className          ");
    out.println(s"\t mov    $$${objectSize}, r0   ");
    out.println("\t bl     LIBAllocObject   			");
    out.println(s"\t adr    r1, ${className}VT      ");
    out.println("");
    out.println(";;; move the vptr into the object");          
    out.println("\t str    r1, [r0]               ");
    out.println("");
    out.println("");
    out.println(";;; call the object's main       ");
    out.println(s"\t bl     ${className}Main      ");
    out.println("");
    out.println("");
    out.println(";;;ic_main always returns 0"      );
    out.println("\t mov    r0, #0                 ");
    out.println("\t mov    sp, fp                 ");
    out.println("\t ldu    fp, [sp, #1]           ");
    out.println("\t swi    #SysHalt"               );
    out.println("");
    out.println("heap:");
  }
  /**
   * Iterate over all used string constants and print them into
   * a data segment.  You should not need to change this method.
   */
  protected def generateStringConstants() = {
    out.println("# ----------------------------");
    out.println("# String Constants");

    out.println();
    out.println(".data");
    out.println(".align 8");
    out.println();

    for ((str, label) <- CodeGenerator.stringConstantsToLabel) {
      val len = str.length();
      out.println(s".quad $len");
      val escapedString =
        "\"" + str.replace("\n", "\\n").replace("\t", "\\t").replace("\"", "\\\"").replace("\r", "\\r") + "\"";
      out.println(s"  ${label}Chars:\t.ascii ${escapedString}");
      out.println(s"${label}:\t.quad ${label}Chars");
    }
    out.println("");
    out.println("");
    out.println("");
  }
}

