package ic
import ic.error._
import ic.opt._
import ic.cfg._
import ic.cg._
import ic.ast._
import ic.tac._
import ic.dfa._
import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import ic.parser._
import ic.lex.Lexer
import ic.symtab._
import ic.tc._
import ic.cg_x86._
import ic.cg_warm._
import ic.asm._

/**
 * The main class for the IC Compiler.  The Compiler
 * expects the name of the file to process on the command line,
 * as in:
 * <pre>
 *   scala -classpath bin ic.Compiler test.ic
 * </pre>
 * An optional flag <tt>-d<tt> can be provided, as in:
 * <pre>
 *   scala -classpath bin ic.Compiler -d test.ic
 * </pre>
 * In this case, messages created by calling {@link ic.Util#debug(String)}
 * or {@link ic.Util#debug(String, Object...)} will be printed to the
 * terminal.  If <tt>-d</tt> is not provided, these messages will
 * be silently ignored.
 */

object Compiler {

	val out = new IndentingPrintStream(System.out);

	def main(args : Array[String]) = {
		var n = 0;

		// If first command line argument is -d, turn on debugging
		if (args.length > n && args(n).equals("-d")) {
			Util.debug = true;
			n = n + 1;
		}

		// Get name of file
		if (args.length == n) {
			System.out.println("No file given.");    
		} else {
			val file = args(n);
			n = n + 1;
			// example of debug message: This message will only be printed if
			// you provide "-d" on the command line.
			Util.debug("Processing %s...", file);

			val programParser = new parser(new Lexer(new FileReader(file)));
			try{
				val resultValue = programParser.parse().value;
				val ast = resultValue.asInstanceOf[ASTProgram];

				//Check to see if we should print the Abstract Syntax Tree
				if(args.length > n && args(n).equals("-printAST")) {
					stringASTNode(ast);
					n = n + 1;
				}

				//Traverses the tree and creates Symbol Tables
				SymbolTableBuilder.buildSymbols(new SymbolTable("Global", None), ast);

				//Checks to see if we should print the Symbol Tables of the program
				if(args.length > n && args(n).equals("-printSymTab")){
					stringSymTab(ast);
					n = n + 1
				}

				//Traverses the tree and resolves names
				NameResolver.resolve(ast);

				//Traverses the tree and type checks
				TypeChecker.typeCheck(ast);
				OffsetGenerator.gen(ast)
				TACGenerator.gen(ast);
				
				
			  val cfgList = createCFG(ast);

				//Check to see if we should print DFA
				while(n < args.length){
  				if(args(n).equals("-printIR")){
	  				TACOPrinter.printAllTAC(ast)
					  TACOPrinter.tacoPrintOffset(ast)
  				}
				  
				  if(args(n).equals("-dce")) {
				    doOptimization(ast, new DeadCodeElimination());
				  }
				  
				  if(args(n).equals("-cpp")) {
				    doOptimization(ast, new CopyPropagation());
				  }
				  
				  if(args(n).equals("-opt")) {
				    doOptimization(ast, new CopyPropagation());
				    doOptimization(ast, new DeadCodeElimination());
				  }
				  
				  if(args(n).equals("-printDFA")) {
				    val cfgList = createCFG(ast);
				    
				    for((cfg, name) <- cfgList){
				      val lva = new LiveVariableAnalysis(cfg);
		          lva.solve();
				      print(lva);
				    }
				    
				    for((cfg, name) <- cfgList){
				      val rca = new ReachingCopiesAnalysis(cfg);
				      rca.solve();
				      print(rca);
				      cfg.dotToFile(file.substring(0, file.indexOf('.')) + "_" + name +".dot");
				    }
				    
				    for((cfg, name) <- cfgList){
				      val cfa = new ConstantFoldingAnalysis(cfg);
				      cfa.solve();
				      print(cfa)
				    }
				  }
				  n = n + 1;
				}

         val codeGen = new WARMCodeGenerator(file, ast, () => new SimpleRegisterAllocator(WARMMachineDescription));
         //if (args.contains("-x86")) {
            //new SimpleX86CodeGenerator(file, ast, () => new SimpleRegisterAllocator(X86MachineDescription));
         //} else if (args.contains("-regs")) {
 //        new SimpleX86CodeGenerator(file, ast, () => new BijansRegisterAllocator(X86MachineDescription));
//           null
  //       } else if (args.contains("-warm")) {
    //        new WARMCodeGenerator(file, ast, () => new SimpleRegisterAllocator(WARMMachineDescription));
           //null
         //} else {
          //new CodeGenerator64(file, ast);
         //}
				
//				val codeGen: CodeGenerator64 = new CodeGenerator64(file, ast);
         codeGen.generate();

				println("Success.")
				
			} catch {
			  case e: LexicalError => {
				  println(e.message);
				  println("Failed.")
			  }
			  //then we have failed
			  case e: SyntaxError => {
				  println(e.message);
			  	println("Failed.");
		  	}
		  	case e: SemanticError => {
		  		println(e.message);
		  		println("Failed.");
		  	}
        // Don't catch this case so we can see where things failed... - Steve.
//		  	case ex: Exception => {
//		  		println(ex);
//		  		println("Failed.");   
//		  	} 
			}   
		}     
	}   
	
	def doOptimization(prog: ASTProgram, opt: Optimization): Unit = {
	  for(cls <- prog.classes) {
	    for(decl <- cls.decls) {
	      decl match {
	        case m: ASTMethodDecl => {
	          opt.optimize(m);
	        }
	        case _ => {}
	      }
	    }
	  }
	}
	
	def createCFG(prog: ASTProgram): List[(ControlFlowGraph,String)] = {
	  var list: List[(ControlFlowGraph,String)] = List[(ControlFlowGraph,String)]();
	  val cfgGen = new CFGGenerator();
	  for(cls <- prog.classes) {
	    for(decl <- cls.decls) {
	      decl match {
	        case m: ASTMethodDecl => {
	          list = list :+ (cfgGen.makeCFG(m), m.id);
	        }
	        case _ => {}
	      }
	    }
	  }
	  return list;
	}
	
	//Prints out the String version of all the symbol tables of the program
	def stringSymTab(node : ASTNode) : Unit = {
		node match {
		case n: ASTProgram => {
			out.print(n.scope);
			out.println("\n");
			out.indentMore();
			n.classes.foreach(stringSymTab);
			out.indentLess();
		}
		case n: ASTClassDecl => {
			out.print(n.bodyScope);
			out.println("\n")
			out.indentMore();
			n.decls.foreach(stringSymTab);
			out.indentLess();
		}
		case n: ASTMethodDecl => {
			stringSymTab(n.block);
		}
		case n: ASTBlock => {
			out.print(n.scope);
			out.println("\n");
			out.indentMore();
			if(n.stmts.nonEmpty)
				out.println(n.stmts.head.scope+"\n");
			else 
				out.print(n.decls.head.scope+"\n");
			out.indentLess()
		}
		case _ => {}
		}
	}

	//Prints out the String version of all the ASTNodes of the program
	def stringASTNode(node : ASTNode) : Unit  = {
		node match{
		case ASTProgram(cls : List[ASTClassDecl], l: Int) => cls.foreach(stringASTNode)
		case ASTClassDecl(cls_id : String, ext: Option[ASTTypeClass], decls : List[ASTDecl], l : Int) => {
			ext match {
			case Some(x) => {
				out.print("class "+cls_id+" extends ")
				stringASTNode(x);
				out.print(" { ");
			}
			case None => {
				out.print("class "+cls_id+" { ");
			}
			}
			out.indentMore();
			out.println("");
			decls.reverse.foreach(stringASTNode);
			out.indentLess();
			out.print("\n}\n\n");
		}
		case ASTBlock(varDecls: List[ASTVarDecl], stmts: List[ASTStmt], line: Int) => {
			out.print("{");
			out.indentMore();
			out.print("\n\n");
			varDecls.reverse.foreach(stringASTNode)
			stmts.reverse.foreach(stringASTNode);
			out.indentLess();
			out.print("\n}\n");
		}
		case ASTFieldDecl(t: ASTType, id: String /*, extIDList: List[String]*/ , line: Int) => {
			stringASTNode(t);
			out.println(" "+id+/*","+extIDList.mkString(",")+*/";\n");
		}
		case ASTMethodDecl(t: ASTType, id: String, forms: List[ASTVarDecl], block: ASTBlock, line: Int) => {
			stringASTNode(t);
			out.print(" "+id+"(");
			forms.foreach{
				item => 
				stringASTNode(item);
				out.print(", ");
			}
			out.print(")");
			stringASTNode(block);
		}
		case ASTVarDecl(t: ASTType, id: String, optExpr: Option[ASTExpr], isParam: Boolean, line: Int) => {
			optExpr match {
			case Some(x) => {
				stringASTNode(t);
				out.print(" " + id + " = ");
				stringASTNode(x);
				out.print("\n");
			}
			case None => {
				stringASTNode(t);
				out.print(" " + id + ";\n");
			}
			}
		}
		case ASTTypeVoid(line: Int) => out.print("void");
		case ASTTypeInt(line: Int) => out.print("int");
		case ASTTypeBool(line: Int) => out.print("boolean");
		case ASTTypeString(line: Int) => out.print("String");
		case ASTTypeClass(clsID: String, line: Int) => out.print(clsID);
		case ASTTypeArray(t: ASTType, line: Int) => {
			stringASTNode(t)
			out.print("[]");
		}
		case ASTVarAccess(id: String, line: Int) => out.print(id);

		//Stmts
		case ASTStmtLoc(loc: ASTLoc, expr: ASTExpr, line: Int) => {
			stringASTNode(loc);
			out.print(" = ");
			stringASTNode(expr);
			out.print(";\n");
		}
		case ASTStmtCall(call: ASTCall, line: Int) => {
			stringASTNode(call);
		}
		case ASTStmtRet(expr: Option[ASTExpr], line: Int) => expr match{
		case Some(x) => {
			out.print("return ");
			stringASTNode(x);
			out.print(";\n");
		}
		case None => out.print("return;\n");
		}
		case ASTStmtIf(cond: ASTExpr, stmt: ASTStmt, optElse: Option[ASTStmt], line: Int) => optElse match {
		case Some(x) => {
			out.print("if(");
			stringASTNode(cond);
			out.print(") ");
			stringASTNode(stmt);
			out.print(" else ");
			stringASTNode(x);
		}
		case None => {
			out.print("if(");
			stringASTNode(cond);
			out.print(") ");
			stringASTNode(stmt);          
		}
		}
		case ASTStmtWhile(expr: ASTExpr, stmt: ASTStmt, line: Int) => {
			out.print("while(");
			stringASTNode(expr);
			out.print(") ");
			stringASTNode(stmt);
		}
		case ASTStmtBreak(line: Int) => out.print("break;");
		case ASTStmtCont(line: Int) => out.print("continue;");
		case ASTStmtBlock(block: ASTBlock, line: Int) => stringASTNode(block);
		case ASTExprNewClass(cls_id: String, line: Int) => out.print("new " + cls_id + " ()");
		case ASTExprArray(t: ASTType, expr: ASTExpr, line: Int) => {
			out.print("new ");
			stringASTNode(t);
			out.print("[");
			stringASTNode(expr);
			out.print("]");
		}
		case ASTExprLen(expr: ASTExpr, line: Int) => {
			stringASTNode(expr);
			out.print(".length");
		}
		case ASTExprUnop(unop: ASTUnOp, expr: ASTExpr, line: Int) => {
			val op: String = unop match {
			case UnNeg() => "-";
			case UnNot() => "!";
		}
		out.print(op);
		stringASTNode(expr);
		}
		case ASTLibCall(id: String, opList: List[ASTExpr], line: Int) => {
			out.print("Library."+id+"(");
			opList.foreach{
				item =>
				stringASTNode(item);
				out.print(", ");
			}
			out.print("); \n");
		}
		case ASTVirtualCall(opExpr: ASTExpr, id: String, opList: List[ASTExpr], line: Int) => {
			stringASTNode(opExpr)
			out.print("."+id+"(");
			opList.foreach(stringASTNode);
			out.print(");\n");
		}
		case ASTExprBinop(lExpr: ASTExpr, binop: ASTBinOp, rExpr: ASTExpr, line: Int) => {
			val op: String = binop match{
			case BinPlus() => "+";
			case BinMinus() => "-";
			case BinMult() => "*";
			case BinDiv() => "/";
			case BinMod() => "%";
			case BinAnd() => "&&";
			case BinOr() => "||";
			case BinLt() => "<";
			case BinLe() => "<=";
			case BinGt() => ">";
			case BinGe() => ">=";
			case BinEqeq() => "==";
			case BinNe() => "!=";
		}
		stringASTNode(lExpr);
		out.print(op);
		stringASTNode(rExpr);
		}
		case ASTFieldAccess(expr: ASTExpr, id: String, line: Int) => {
			stringASTNode(expr);
			out.print("."+id);
		}
		case ASTArrayAccess(lExpr: ASTExpr, rExpr: ASTExpr, line: Int) => {
			stringASTNode(lExpr);
			out.print("[");
			stringASTNode(rExpr);
			out.print("]");
		}
		case ASTLiteralInt(i: Int, line: Int) => out.print(i.toString);
		case ASTLiteralString(s: String, line: Int) => out.print("\"" + s + "\"");
		case ASTLiteralBool(b: Boolean, line: Int) => out.print(b.toString);
		case ASTLiteralNull(line: Int) => out.print("null");
		}
	}
}
