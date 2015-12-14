package ic.tac
import ic._
import ic.ast._;

object TACOPrinter{
  
  val out = new IndentingPrintStream(System.out);
  //most of the printing should be from an indented baseline
  out.indentMore();
 
  //print out the tac offsets
  def tacoPrintOffset(program: ASTProgram): Unit = {
    out.indentLess()
    out.println("Offsets:");
    for (c <- program.classes) {
      out.println("CLASS " + c.cls_id + ": ");
      out.println("Number of fields: " + c.f_size);
      out.println("Size of v table: " + c.v_size );
      out.println("Total class size: " + c.size);
      out.indentMore();
      for (decl <- c.decls){
        //print out the offsets for all the ASTDecls
        decl match {
          case n: ASTMethodDecl => {
            out.println("METHOD " + n.id + ": " + (n.offset*8));
            out.indentMore();
            for (variable <- n.forms) {
              out.println("FORMAL VAR " + variable.id + ": " + (variable.offset*8))
            }
            for (variable <- n.block.decls) {
              out.println("VAR " + variable.id + ": " + (variable.offset*8))
            }
            out.indentLess()
          }
          case n: ASTFieldDecl => out.println("FIELD " + n.id + ": " + (n.offset*8))
        }
      }
      out.indentLess();
    }
    out.indentMore();
  }
  
  //traverse the AST tree and find all the sections of TAC code.  Print each one
  def printAllTAC(program: ASTProgram): Unit = {
    for (c <- program.classes) {
      for (decl <- c.decls){
        //print out the taclist for all the ASTMethodDecls
        decl match {
          case mDec: ASTMethodDecl => {
            out.println(mDec.id);
            mDec.tacList.list.foreach(tac => tacoPrint(tac));
            out.println("--------------------")
          }
          case ASTFieldDecl(_, _, _) =>
        }
      }
    }
  }

  //Print the statements, put newlines at the end
  def tacoPrint(instr: TACInstr): Unit = {
     instr match{
       
       case TAComment(comment, line) => {
         out.indentMore();
         out.print("# " + comment);
         out.indentLess();
       }
       
       //Branching, control flow
        case TAC_Label(label: String, line: Int, comment: String) => {
          //print the label to the left of other code
          out.indentLess();
          out.print(label + ":");
          out.indentMore();
        }
       
        case TAC_Jump(label: TAC_Label, line: Int, comment: String) => {
          out.print("Jump " + label.label);
        }
       
        case TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) => {
          out.print("CJump ");
          tacoPrint(condition);
          out.print(" " + label.label);
        }
       
        case TAC_RET(value: Option[TACOp], line: Int, comment: String) => {
          out.print("Return ");
          value match {
            case Some(x) => tacoPrint(x);
            case None =>
          }
        }

        case TAC_Length(dst: TACOp, array: TACOp, line: Int, comment: String) => {
          tacoPrint(dst);
          out.print(" = Length ");
          tacoPrint(array);
        }

        //Calls
        case TACCall_VirCall(dst: Option[TACOp],receiver: TACOp, decl: ASTMethodDecl, paramList: List[TACOp], line: Int, comment: String) => {
          dst match{
            case Some(x) => {
              tacoPrint(x);
              out.print(" = Call "+ receiver + "." + decl.id + "(");
            }
            case None => {
              out.print(decl.id + "(");  
            }
          }
          if(!paramList.isEmpty){
            tacoPrint(paramList.head);
            paramList.tail.foreach(a => {
              out.print(", ");
              tacoPrint(a);
            })
          }  
          out.print(")");
        }
       
        case TACCall_LibCall(store: Option[TACOp], op: String, params: List[TACOp], line: Int, comment: String) => {
          store match {
            case Some(x) => {
              tacoPrint(x);
              out.print(" = ");
            }
            case None =>
          }
          out.print("Library." + op + "(");
          if(!params.isEmpty){
            tacoPrint(params.head);
            params.tail.foreach(p => {
              out.print(", ");
              tacoPrint(p);
            });
          }
          out.print(")");
        }

        //Movement, load store, copy
        case TAC_Copy(dst: TACOp, src: TACOp, line: Int, comment: String) => {
          tacoPrint(dst);
          out.print(" = ");
          tacoPrint(src);
        }
       
        case TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, line: Int, comment: String) => {
          tacoPrint(dst);
          out.print(" = ");
          tacoPrint(array);
          out.print("[");
          tacoPrint(index);
          out.print("]")
        }
        
        case TAC_ArrayStore(array: TACOp, index: TACOp, value: TACOp, line: Int, comment: String) => {
          tacoPrint(array);
          out.print("[");
          tacoPrint(index);
          out.print("] = ");
          tacoPrint(value);
        }
       
        case TAC_FieldLoad(dst: TACOp, receiver: TACOp, field: ASTFieldDecl, line: Int, comment: String) => {
          tacoPrint(dst);
          out.print(" = ");
          tacoPrint(receiver);
          out.print("." + field);
        }
        
        case TAC_NewClass(dst: TACOp, decl: ASTClassDecl, line: Int, comment: String) => {
          tacoPrint(dst);
          out.print(" = new " + decl.cls_id);
        }
        
        case TAC_FieldStore(receiver: TACOp, field: ASTFieldDecl, value: TACOp, line: Int, comment: String) => {
          tacoPrint(receiver);
          out.print("." + field.id + " = ");
          tacoPrint(value);
        }

        case TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, binop: ASTBinOp, line: Int, comment: String) => {
          binop match {
            case BinPlus() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" + ");
              tacoPrint(rExpr);
            }   
            case BinMinus() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" - ");
              tacoPrint(rExpr);
            }
            case BinMult() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" * ");
              tacoPrint(rExpr);
            }
            case BinDiv() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" / ");
              tacoPrint(rExpr);
            }
            case BinMod() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" % ");
              tacoPrint(rExpr);
            }
            case BinAnd() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" AND ");
              tacoPrint(rExpr);
            }
            case BinOr() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" OR ");
              tacoPrint(rExpr);
            }
            case BinLt() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" LT ");
              tacoPrint(rExpr);
            }
            case BinLe() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" LEQ ");
              tacoPrint(rExpr);
            }
            case BinGt() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" GT ");
              tacoPrint(rExpr);
            }
            case BinGe() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" GEQ ");
              tacoPrint(rExpr);
            }
            case BinEqeq() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" EQEQ ");
              tacoPrint(rExpr);
            }
            case BinNe() => {
              tacoPrint(dst);
              out.print(" = ");
              tacoPrint(lExpr);
              out.print(" NEQ ");
              tacoPrint(rExpr);
            }
          }
        }
        
        //Unops
        case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) => {
          unop match {
            case UnNeg() => {
              tacoPrint(dst);
              out.print(" = MINUS ");
              tacoPrint(expr);
            }
            case UnNot() => {
              tacoPrint(dst);
              out.print(" = NOT ");
              tacoPrint(expr);
            }
          }
        }

        //Run time checks
        case TAC_NullCheck(oject: TACOp, line: Int, comment: String) => {
          out.print("NullCheck ");
          tacoPrint(oject);
        }

        case TAC_IndexInBounds(array: TACOp, index: TACOp, line: Int, comment: String) => {
          out.print("IndexInBounds ");
          tacoPrint(array);
          out.print("[");
          tacoPrint(index);
          out.print("]");
        }

        case TAC_DivBy0(divisor: TACOp, line: Int, comment: String) => {
          out.print("DivBy0 ");
          tacoPrint(divisor);
        }

        case TAC_GreaterThan0(index: TACOp, line: Int, comment: String) => {
          out.print("GreaterThan0 ");
          tacoPrint(index);
        }
     }
     if(instr.com != ""){
       out.print("\t" + "#" + instr.com);
     }
     out.println("");
  }
 
  //print the Ops, dont put newlines in these because they are in exprs
  def tacoPrint(op: TACOp): Unit = {
    op match{
     case TAC_Var(decl: ASTVarDecl, line: Int, comment: String) => out.print(decl.id)

     case TAC_Lit(lit_node: ASTLiteral,  line: Int, comment: String) => {
       val sc = new StringContext();
       lit_node match{
         case ASTLiteralInt(i: Int, line: Int) => out.print(i)
         case ASTLiteralString(s: String, line: Int) => out.print("\"" + s + "\"")
         case ASTLiteralBool(b: Boolean, line: Int) => out.print(b)
         case ASTLiteralNull(line: Int) => out.print("NULL")
       }
     }

     case TAC_Temp(name: String, offset: Int, line: Int, comment: String) => out.print(name)
    }
  }
}
