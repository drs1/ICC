package ic.cg_x86

import ic.ast._
import java.io._
import ic.error._
import ic.tac._
import ic.asm._
import ic.asm.cfg._
import ic.Util
import scala.collection.mutable.HashMap


/**
 * CodeGenerator: Generates x86 assembly code for the IC program, allocating
 * class virtual-lookup tables, string constants, error messages, and method
 * instructions (based on the corresponding TACLists).
 *
 * This version converts TAC -> AbsAssembly -> Assembly using a
 * simple register allocator.
 * 
 * The CodeGenerator is also configurable to use different register allocators.
 * SPecifically, the makeRegAlloc parameter refers to a function that takes
 * a machine description and returns an allocator for that machine type.
 * 
 * Example:
 * 
 *   val gen = new SimpleX86CodeGenerator("a.ic", ast, { new SimpleRegisterAllocator(_) });
 * 
 */
class SimpleX86CodeGenerator(override val icFileName: String, override val program: ASTProgram, val makeRegAlloc: () => RegisterAllocator)
    extends CodeGenerator(icFileName, program) {

  val asmFile = icFileName.substring(0, icFileName.indexOf('.')) + ".s";
  val out = new PrintWriter(new FileWriter(asmFile));
  val paramReg: List[String] = List("%rdi", "%rsi", "%rdx", "%rcx", "%r8", "%r9");

  //We check for a main method while iterating over methods of classes
  //in file.  Set these if we see a main.
  var classForMain = "";
  var sizeOfMainObject = -1;
  var offsetOfMainInDV = -1;

  /**
   * The main method to call when you wish to perform the
   * translation.
   */
  def generate() = {

    out.println("# File " + asmFile);
    out.println();
    out.println();
    out.println(".globl __ic_main");

    generateVTables();
    out.println(".text");
    generateCode();
    generateErrorHandlers();

    //Main not found in any of the classes
    if (classForMain.equals(""))
      throw new SemanticError("No main method found in the file.");

    generateMain(classForMain, sizeOfMainObject, offsetOfMainInDV);

    generateStringConstants();

    out.close();
  }

  /**
   * Print the VTable for all the classes.  You'll need to change this.
   *
   */
  protected def generateVTables() = {
    out.println("# ----------------------------");
    out.println("# VTables");

    out.println();
    out.println(".data");
    out.println(".align 8");
    out.println("");

    for (cls <- program.classes) {
      out.println("_" + cls.cls_id + "_VT:");

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

      for ((_, cls_name, method_id) <- vTable) {
        out.println("\t.quad _" + cls_name + "_" + method_id);
      }
    }

    out.println(".quad 0");
    out.println("");
    out.println("");
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
            println("-----------------------")
            println(m.id)
            println(m.offset)

            //If we find a main method, set information for it. If we have already found a main method,\
            //throw error.
            if (m.id.equals("main")) {
              if (classForMain.equals("")) {
                classForMain = cls.cls_id;
                sizeOfMainObject = cls.size * X86MachineDescription.sizeOfDataElement();
                offsetOfMainInDV = m.offset * X86MachineDescription.sizeOfDataElement();
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
      regAlloc.addVirtualRegister(VirtualRegister(x.id), x.offset * X86MachineDescription.sizeOfDataElement());
    }
    regAlloc.addVirtualRegister(VirtualRegister("this"), 2 * X86MachineDescription.sizeOfDataElement());

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
    out.println("\tsubq $" + -(regAlloc.getMaxHomeOffset() - X86MachineDescription.firstAvailableOffsetForLocals()) + ", %rsp");
    
    out.println("")
    
    out.println("\t# ---- method instructions ------")
    
    out.println(ASMPrinter.asmToString(asm.flatMap(_.contents)));

    out.println("")

    out.println("epilogue_" + cls.cls_id + "_" + m.id + ":");
    out.println("movq %rbp,%rsp");
    out.println("popq %rbp");
    out.println("ret");
    out.println("\n");
  }

  /**
   * Print out the assembly code to print run-time errors and
   * exit gracefully.  You should jump to these labels on
   * run-time check failure.  You should not need to change this
   * method.
   */
  protected def generateErrorHandlers() = {
    out.println("# ----------------------------");
    out.println("# Error handling.  Jump to these procedures when a run-time check fails.");
    out.println("");
    out.println(".data");
    out.println(".align 8");
    out.println("");
    out.println(".quad 23");
    out.println("  strNullPtrErrorChars:     .ascii \"Null pointer violation.\"");
    out.println("strNullPtrError: .quad strNullPtrErrorChars");
    out.println("");
    out.println(".quad 23");
    out.println("  strArrayBoundsErrorChars: .ascii \"Array bounds violation.\"");
    out.println("strArrayBoundsError: .quad strArrayBoundsErrorChars");
    out.println("");
    out.println(".quad 21");
    out.println("  strArraySizeErrorChars:   .ascii \"Array size violation.\"");
    out.println("strArraySizeError: .quad strArraySizeErrorChars");
    out.println("");
    out.println(".quad 22");
    out.println("  divByZeroErrorChars:      .ascii \"Divide by 0 violation.\"");
    out.println("divByZeroError: .quad divByZeroErrorChars");
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
    out.println("# The main entry point.  Allocate object and invoke main on it.");
    out.println("");
    out.println(".text");
    out.println(".align 8");
    out.println(".globl __ic_main");
    out.println("__ic_main:");
    out.println("       pushq %rbp                        # prologue");
    out.println("       movq %rsp,%rbp                ");
    out.println("       pushq %rdi                        # o.main(args) -> push args");
    out.println("");
    out.println(s"       movq $$${objectSize}, %rdi                 # o = new $className\n");
    out.println("       call __LIB_allocateObject   ");
    out.println(s"       leaq _${className}_VT(%rip), %rdi       \n");
    out.println("       movq %rdi, (%rax)");
    out.println("       pushq %rax                        # o.main(args) -> push o");
    out.println("       movq (%rax), %rax            ");
    out.println(s"       call *${indexOfMainInVTable}(%rax)                   # main is at offset $indexOfMainInVTable in vtable\n");
    out.println("       addq $16, %rsp                ");
    out.println("       movq $0, %rax                     # __ic_main always returns 0");
    out.println("");
    out.println("       movq %rbp,%rsp                    # epilogue");
    out.println("       popq %rbp                    ");
    out.println("       ret                         ");
    out.println("");
    out.println("");
    out.println("");
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
