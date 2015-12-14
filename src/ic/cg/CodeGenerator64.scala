package ic.cg;

import ic.ast.ASTProgram
import ic.asm._
import ic.error._
import ic.tac._
import ic.ast._
import java.io.PrintWriter
import scala.collection.mutable.HashMap
import java.io.FileWriter


/**
 * A x86_64 CodeGenerator generates the assembly code for a program,
 * after each MethodDecl has been annotated with TACLists.  There is
 * some basic functionality for dealing with string constants and
 * their labels.
 * <p>
 * Feel free to change this code in any way that you find useful,
 * or to ignore it completely and roll your own code generator from 
 * scratch.
 * <p> 
 * This code assumes that your top-level AST node is called
 * Program.  You may need to change this to match your own AST
 * hierarchy.  Usage:
 *
 * <pre>
 *   val cg = new CodeGenerator("file.ic", program);
 *   cg.generate();
 * </pre>
 */
class CodeGenerator64(override val icFileName : String, override val program : ASTProgram) extends CodeGenerator(icFileName, program){

  val asmFile = icFileName.substring(0, icFileName.indexOf('.')) + ".s";
  val out = new PrintWriter(new FileWriter(asmFile));    
  val paramReg: List[String] = List("%rdi", "%rsi", "%rdx", "%rcx", "%r8","%r9");
  
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
    if(classForMain.equals(""))
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
      cls.ext match{
	case Some(x) => {
	  makeVList(x, vTable)
	}
	case None => {}
      }

      for (decl <- cls.decls){
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
  def makeVList(cls: ASTTypeClass, vt: Array[(Int, String, String)]): Array[(Int,String, String)] = {
    var table = vt
    //get the decl of the super
    cls.decl.ext match{
      case Some(x) => makeVList(x, table)
      case None => {
	for(decl <- cls.decl.decls){
	  decl match{
	    case m: ASTMethodDecl => table(m.offset) = (m.offset, cls.decl.cls_id, m.id);
	    case f: ASTFieldDecl => {}
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
    for(cls <- program.classes){
      for(decl <- cls.decls){
	decl match {
	  case m: ASTMethodDecl => {
	    //If we find a main method, set information for it. If we have already found a main method,\
	    //throw error.
	    if(m.id.equals("main")){
	      if(classForMain.equals("")){
		classForMain = cls.cls_id;
		sizeOfMainObject = cls.size * 8;
		offsetOfMainInDV = m.offset * 8;
	      }
	      else
		throw new SemanticError("More than 1 main method found in the same file.");
	    }
	    out.println(".align 8");
	    out.println("_" + cls.cls_id + "_" + m.id + ":");
	    out.println("pushq %rbp                   # prologue");
	    out.println("movq %rsp, %rbp");
	    out.println("subq $" + (m.block.local_size * 8) + ", %rsp"); 
	    out.println("");

	    genList(m.tacList);

	    out.println("epilogue_"+ cls.cls_id + "_" + m.id + ":");         
	    out.println("movq %rbp,%rsp");                
	    out.println("popq %rbp");                
	    out.println("ret");      
	    out.println("\n");
	  }
	  case f: ASTFieldDecl => {}
	}
      }
    }
  }

  //Iterates over a TACList and pattern matches on TAC Instruction.
  //Prints x86 code for that TAC into assembly file.
  def genList(tacList: TACList): Unit = {
    for(instr <- tacList.list){
      instr match{
	
	case TAComment(comment: String, line: Int) => {
	  out.println("#"+comment);  
	}
	
	case TAC_Label(label: String, line: Int, comment: String) => {
	  out.println(label + ":");
	  out.println("");
	}

	case TAC_Jump(label: TAC_Label, line: Int, comment: String) => {
	  out.println("jmp " + label.label);
	  out.println("");
	}

	//Jump if condition is true
	case TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) => {
	  out.println("movq $1, %rax");
	  out.println("cmpq " + x86Operator(condition) + ", %rax");
	  out.println("je " + label.label);
	  out.println("");
	}

	//If method has return value, put it in %rax
	case TAC_RET(value: Option[TACOp], line: Int, comment: String) => {
	  value match {
	    case Some(x: TACOp) => out.println("movq " + x86Operator(x) + ", %rax");
	    case None => {}
	  }             
	  out.println("movq %rbp,%rsp");                
	  out.println("popq %rbp");
	  out.println("ret");
	  out.println("");
	}

	case TAC_NewClass(dst: TACOp, decl: ASTClassDecl, line: Int, comment: String) => {
	  //Sets up VTable for class
	  out.println("       movq $" + (decl.size * 8) + ", %rdi                 # o = new className\n"); 
	  out.println("       call __LIB_allocateObject   ");
	  out.println("       leaq _" + decl.cls_id + "_VT(%rip), %rdi       \n");
	  out.println("       movq %rdi, (%rax)");
	  out.println("       movq %rax, " + x86Operator(dst));
	  out.println("");
	}

	//Length of an array held at position -1
	case TAC_Length(dst: TACOp, array: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(array) + ", %rax");
	  out.println("movq -8(%rax), %rax" );
	  out.println("movq %rax, " + x86Operator(dst));
	  out.println("");
	}

	//Calls
	case TACCall_VirCall(dst: Option[TACOp], rec: TACOp, decl: ASTMethodDecl, paramList: List[TACOp], line: Int, comment: String) => {
	  //Push Params
	  for(param <- paramList.reverse)
	    out.println("pushq\t" + x86Operator(param) + "\t#Pushing parameter " + param);
	  //Push THIS
	  out.println("movq " + x86Operator(rec) + ", %rax");
	  out.println("pushq\t%rax");
	  out.println("movq (%rax), %rax");
	  out.println("call\t*" + (decl.offset * 8) + "(%rax)");
	  //set %rsp (delete params off of stack)
	  out.println("addq\t$" + (8 * (paramList.size + 1)) + ", %rsp"); 

	  dst match {
	    case Some(x) => out.println("movq %rax, " + x86Operator(x));
	    case None => {}
	  }
	  out.println("");
	}

	//Put params in correct registers, call function, get value if not void
	case TACCall_LibCall(store: Option[TACOp], op: String, params: List[TACOp], line: Int, comment: String) => {
	  for((i,j) <- params zip paramReg){
	    out.println("movq " + x86Operator(i) + ", " + j);
	  }
	  out.println("call __LIB_"+op);
	  store match {
	    case Some(x) => out.println("movq %rax, " + x86Operator(x));
	    case None => {}
	  }
	  out.println("\n");
	}

	//Movement, load store, copy
	case TAC_Copy(dst: TACOp, src: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(src) + ", %rax");
	  out.println("movq " + "%rax, " + x86Operator(dst));
	  out.println("");
	}

	case TAC_ArrayStore(array: TACOp, index: TACOp, value: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(array) + ", %rax");
	  out.println("movq " + x86Operator(index) + ", %rdi");
	  out.println("movq " + x86Operator(value) + ", %rdx");
	  out.println("movq %rdx, (%rax,%rdi,8)");
	  out.println("");
	}

	case TAC_FieldStore(receiver: TACOp, field: ASTFieldDecl, value: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(receiver) + ", %rax");
	  out.println("movq " + x86Operator(value) + ", %rdi");
	  out.println("movq %rdi, " + (field.offset * 8) + "(%rax)");
	  out.println("");
	}

	case TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(array) + ", %rax");
	  out.println("movq " + x86Operator(index) + ", %rdi");
	  out.println("movq (%rax,%rdi,8), %rax");
	  out.println("movq %rax, " + x86Operator(dst));
	  out.println("");
	}

	case TAC_FieldLoad(dst: TACOp, receiver: TACOp, field: ASTFieldDecl, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(receiver) + ", %rax");
	  out.println("movq " + (field.offset * 8) + "(%rax), %rax");
	  out.println("movq %rax, " + x86Operator(dst));
	  out.println("");
	}

	//Binary Operations.  Use operation cqto to sign extend for mult and div.
	//Use movzbq to sign extend %rax from set operation.
	case TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, binop: ASTBinOp, line: Int, comment: String) => {
	  val lOp: String = x86Operator(lExpr);
	  val rOp: String = x86Operator(rExpr);
	  val dOp: String = x86Operator(dst);
	  binop match {
	    case BinMult() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cqto");
	      out.println("movq " + rOp + ", %rdi")
	      out.println("mulq %rdi");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinDiv() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cqto");
	      out.println("movq " + rOp + ", %rdi")
	      out.println("divq %rdi");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinMod() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cqto");
	      out.println("movq " + rOp + ", %rdi")
	      out.println("divq %rdi");
	      out.println("movq %rdx, " + dOp);
	    }
	    case BinPlus() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("addq " + rOp + ", %rax");
	      out.println("movq %rax, " + dOp);
	    }   
	    case BinMinus() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("subq " + rOp + ", %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinLt() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cmpq " + rOp + ", %rax");
	      out.println("setl %al");
	      out.println("movzbq %al, %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinLe() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cmpq " + rOp + ", %rax");
	      out.println("setle %al");
	      out.println("movzbq %al, %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinGt() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cmpq " + rOp + ", %rax");
	      out.println("setg %al");
	      out.println("movzbq %al, %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinGe() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cmpq " + rOp + ", %rax");
	      out.println("setge %al");
	      out.println("movzbq %al, %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinEqeq() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cmpq " + rOp + ", %rax");
	      out.println("sete %al");
	      out.println("movzbq %al, %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    case BinNe() => {
	      out.println("movq " + lOp + ", %rax");
	      out.println("cmpq " + rOp + ", %rax");
	      out.println("setne %al");
	      out.println("movzbq %al, %rax");
	      out.println("movq %rax, " + dOp);
	    }
	    //Never reached due to short circuit at TAC level
	    case BinAnd() => {}
	    case BinOr() => {}
	  }
	  out.println("");
	}

	//Unops
	case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) => {
	  unop match {
	    case UnNeg() => {
	      out.println("movq " + x86Operator(expr) + ", %rax");
	      out.println("notq %rax");
	      out.println("incq %rax");
	    }
	    case UnNot() => {
	      out.println("movq $1, %rax");
	      out.println("xorq " + x86Operator(expr) + ", %rax");
	    }
	  }
	  if(!dst.isInstanceOf[TAC_Lit])
	    out.println("movq %rax, " + x86Operator(dst));
	  out.println("");
	}

	//Run time checks
	case TAC_NullCheck(oject: TACOp, line: Int, comment: String) => {
	  out.println("cmpq $0, " + x86Operator(oject));
	  out.println("je labelNullPtrError");
	  out.println("");
	}

	case TAC_IndexInBounds(array: TACOp, index: TACOp, line: Int, comment: String) => {
	  val ind: String = x86Operator(index);
	  out.println("movq $0, %rax");
	  out.println("cmpq " + ind + ", %rax");
	  out.println("jg labelArrayBoundsError");
	  out.println("movq " + x86Operator(array) + ", %rax");
	  out.println("movq -8(%rax), %rax" );
	  out.println("cmpq " + ind + ", %rax");
	  out.println("jle labelArrayBoundsError");
	  out.println("");
	}

	case TAC_DivBy0(divisor: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(divisor) + ", %rax");
	  out.println("cmpq $0, %rax");
	  out.println("je labelDivByZeroError");
	  out.println("");
	}

	case TAC_GreaterThan0(index: TACOp, line: Int, comment: String) => {
	  out.println("movq " + x86Operator(index) + ", %rax");
	  out.println("cmpq $0, %rax");
	  out.println("jl labelArraySizeError");
	  out.println("");
	}
      }
    }
  }

  //Takes a TACOp and returns the x86 code to access it.
  //For temps and vars, returns an offset from the stack.
  //For literals, returns a constant.
  def x86Operator(op: TACOp): String = {
    op match {
      case i: TAC_Var => {
	//println(i.decl.id + " " + i.decl.offset *8);
	return (i.decl.offset*8) + "(%rbp)";
      }
      case i: TAC_Temp => return (i.offset*8) + "(%rbp)";
      case i: TAC_Lit => {
	i.lit_node match {
	  case j: ASTLiteralInt => return "$"+j.i;
	  case j: ASTLiteralString => {
	    val label: String = labelForStringConstant(j.s);
	    return label+"(%rip)";
	  }
	  case j: ASTLiteralBool => {
	    if(j.b) return "$1";
	    return "$0";
	  }
	  case j: ASTLiteralNull => return "$0";
	}
      }
    }
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
  protected def generateMain(className : String, objectSize : Int, indexOfMainInVTable : Int) = {
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


  /* STRING CONSTANTS */ 
  /** A map from string constant to the assembly code label in
   * the data segment where that constant is stored.  See the
   * labelForStringConstant method.
   */
  protected val stringConstantsToLabel : HashMap[String,String] = new HashMap[String,String]();

  /*
   * Return a unique label for a string constant.  After
   * translating all code and getting labels for all string
   * constants, the code generator will print out a data segment
   * containing the labels and string constants.  The string may
   * contain only the following escape characters: \n, \r, \t.
   */
  protected def labelForStringConstant(stringConstant : String) : String = {
    stringConstantsToLabel.get(stringConstant) match {
      case None => { 
	val label = "_str" + stringConstantsToLabel.size;
	stringConstantsToLabel.put(stringConstant, label);
	label;
      }
      case Some(label) => {
	label;
      }
    }
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

    for ((str, label) <- stringConstantsToLabel) {
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
  
