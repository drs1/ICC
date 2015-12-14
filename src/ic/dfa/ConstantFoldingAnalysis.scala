package ic.dfa;

import ic.cfg.ControlFlowGraph;
import ic.tac._;
import ic.ast._;
import ic.error._;
/**
 * Analysis to propagate all constants downward in a data flow analysis
 *   D  : forward
 *   V  : { all variables in the program }  
 *   Top: UNDEF
 *	 Bottom: NAC
 *   f  : f_Assign(s) = m(s) 
 *        f
 *   
 *   
 *   
 *   
 *   boundary:  OUT[s] = UNDEF
 *    * </pre>
 * After dataflow analysis, unreachable blocks will have IN[b] == false.
 */
class ConstantFoldingAnalysis(override val cfg: ControlFlowGraph) extends DataFlowAnalysis[Map[TACOp, LatVal]](cfg){

  // we want maps of variables to their value
  // value can take on either a constant, NAC, or UNDEF 
  // TODO: figure out how to represent NAC and UNDEF
  
  // work forward, propagating constants down
  def isForward() = true;
  def boundary() = Map[TACOp, LatVal]()
  def top() = Map[TACOp, LatVal]()
  def getUnopLat(op: ASTUnOp, expr: LatVal): LatVal ={
    expr match{
      case NAC() => new NAC()
      case UNDEF() => new UNDEF()
      case LIT(x) => {
        x match {
          case ASTLiteralInt(i, line) => {
            op match{
              case UnNeg() => new LIT(new ASTLiteralInt(-i, line));
              case UnNot() => throw new SemanticError("Can't apply 'Unary Not' to integer operand");  
            }
          }
          case ASTLiteralBool(b, line) => {
            op match{
              case UnNot() => new LIT(new ASTLiteralBool(!b, line));
              case UnNeg() => throw new SemanticError("Can't apply 'Unary Negation' to boolean operand");
            }
          }
          case _ => throw new SemanticError("Can't apply unary operation to opeand of type String or null"); 
        }
      }
    }
  }
    
  def getBinopLat(op: ASTBinOp, e1: LatVal, e2: LatVal): LatVal = {
    (e1, e2) match{
      case(NAC(), _) => new NAC()
      case(_, NAC()) => new NAC()
      case(UNDEF(), UNDEF()) => new UNDEF()
      case(x @ LIT(_), UNDEF()) => x
      case(UNDEF(), x @ LIT(_)) => x
      case(LIT(x), LIT(y)) => {
        (x,y) match{
          case (ASTLiteralInt(i, line), ASTLiteralInt(j, _)) => {
            op match{
              case BinMinus() => new LIT(new ASTLiteralInt(i-j, line));             
              case BinPlus() => new LIT(new ASTLiteralInt(i+j, line));
              case BinDiv() => new LIT(new ASTLiteralInt(i/j, line));
              case BinMod() => new LIT(new ASTLiteralInt(i%j, line));
              case _ => throw new SemanticError("Can't perform operation on literals of type " + x + " , "+ y)
            }
          }
          case (ASTLiteralString(s1,line), ASTLiteralString(s2, _)) => {
            op match{
              case BinPlus() => new LIT(new ASTLiteralString(s1+s2, line));
              case _ => throw new SemanticError("Can't perform operation on literals of type " + x + " , "+ y)
            }
          }
          case (ASTLiteralBool(b1, line), ASTLiteralBool(b2, _)) => {
            op match{
              case BinAnd() => new LIT(new ASTLiteralBool(b1 && b2, line));
              case BinOr() => new LIT(new ASTLiteralBool(b1 || b2, line));
              case BinLt() => new LIT(new ASTLiteralBool(b1 < b2, line));
              case BinLe() => new LIT(new ASTLiteralBool(b1 <= b2, line));
              case BinGt() => new LIT(new ASTLiteralBool(b1 > b2, line));
              case BinGe() => new LIT(new ASTLiteralBool(b1 >= b2, line));
              case BinEqeq() => new LIT(new ASTLiteralBool(b1 == b2, line));
              case BinNe() => new LIT(new ASTLiteralBool(b1 != b2, line));              
              case _ => throw new SemanticError("Can't perform operation on literals of type " + x + " , "+ y);
            }
          }
          case (other , ASTLiteralNull(line)) => {
            op match{
              case BinEqeq() => new LIT(new ASTLiteralBool(other == new ASTLiteralNull(line), line));
              case _ => throw new SemanticError("Can't perform operation on literals of type " + x + " , "+ y);              
            }
          }
        }
      }
    }
  }
  
  // two blocks met at a fixed point along an execution path, and I took the one less traveled by
  def meet(m1: Map[TACOp, LatVal], m2: Map[TACOp, LatVal]): Map[TACOp, LatVal] = {
    var newMap: Map[TACOp, LatVal] = Map[TACOp, LatVal]();
    //iterate through all of the entries in both maps and meet them
    for ((k, v1) <- m1) {      
      //First find the second LatVal (if it is not in the map, it is undefined)
      var v2: LatVal = m2.getOrElse(k, UNDEF());              
      //meet the individual variables and replace them in the new map (store in newMap)
      newMap += (k -> meetVars(v1, v2));
    }
    for ((k, v1) <- m2) {      
      //First find the second LatVal (if it is not in the map, it is undefined)
      var v2: LatVal = m1.getOrElse(k, UNDEF());              
      //meet the individual variables and replace them in the new map (store in newMap)
      newMap += (k -> meetVars(v1, v2));
    }
    newMap
  }
  
  def meetVars(v1: LatVal, v2: LatVal): LatVal ={
    (v1, v2) match{
      case (NAC(), _) => NAC();
      case (_, NAC()) => NAC();
      case (UNDEF(), x) => x;
      case (x, UNDEF()) => x;
      case (LIT(c1), LIT(c2)) => {
        //check to make sure the literals are the same
        //Note that .equals() has been overrided for ASTLiterals in ASTNode.scala
        if (c1.equals(c2)) {
          LIT(c1)
        } else {
          NAC()
        }
      }
    }
  }

  def equals(m1: Map[TACOp, LatVal], m2: Map[TACOp, LatVal]): Boolean = {
    for((k,v) <- m1){
      m2.get(k) match{
        case Some(x) => if (x != v) return false;
        case None => return false;
      }
    }
    for((i,j) <- m2){
      m1.get(i) match{
        case Some(x) => if (x != j) return false;
        case None => return false;
      }
    }
    return true;
  }
    
  //TODO: if we're given an instruction, what do we add to the map?
  def transfer(instr: TACInstr, in: Map[TACOp, LatVal]): Map[TACOp, LatVal] = {
    instr match{
      case TAComment(_,_) => in;
      case TAC_Label(_,_,_) | TAC_Jump(_,_,_) | TAC_CJump(_,_,_,_) | TAC_RET(_,_,_)  => in;
      case TAC_Length(dst,_,_,_) => in + (dst -> new NAC());
      case TAC_NewClass(dst,_,_,_) => in + (dst -> new NAC());
      case TAC_NullCheck(_,_,_) => in;
      case TAC_IndexInBounds(_, _, _, _) => in;
      case TAC_DivBy0(_,_,_) => in;
      case TAC_GreaterThan0(_,_,_) => in;
      case TAC_FieldStore(receiver, _, _, _, _) => in + (receiver -> new NAC());
      case TAC_ArrayLoad(dst, _, _, _, _) => in + (dst -> new NAC());
      case TAC_FieldLoad(dst, _, _, _, _) => in + (dst -> new NAC());
      case TACCall_VirCall(dst,_,_,_,_,_) => {
        dst match{
          case Some(x) => in + (x -> new NAC());
          case None => in;
        }
      }
      case TACCall_LibCall(store, _, _, _, _) => {
        store match{
          case Some(x) => in + (x -> new NAC());
          case None => in;
        }
      }
      //x = y 
      //these are the tricky ones now
      case TAC_Copy(dst, src, _, _) =>{
        src match{
          // RHS is a constant
          case TAC_Lit(lit_node,_,_) => {
            in + (dst -> new LIT(lit_node))
          }
          //RHS is a variable, is it in the map?
          case op @ _  => {
            in + (dst -> (in.getOrElse(op, new UNDEF()))); 
          }
        }
      }
      
      // most of the heavy lifting is done by getBinopLat and getUnopLat
      // given a binop and two other ops, give me back the lattice value
      // and assign it to the dst in the map
      case TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, op: ASTBinOp, _, _) => in + (dst -> getBinopLat(op, in.getOrElse(lExpr, new UNDEF()), in.getOrElse(rExpr, new UNDEF()))); 
      case TAC_UnOp(dst, expr, op, _, _) => in + (dst -> getUnopLat(op, in.getOrElse(expr, new UNDEF())));
      case TAC_ArrayStore(array, index, _, _, _) => {
        in.get(index) match{
          case Some(i) => {
            in + (array -> new NAC())
          }
          case None => {
            index match{
              case TAC_Lit(lit_node, _, _) =>{
                in + (array -> new NAC(), index -> new LIT(lit_node))
              }
            }
          }
        }
      }
    }
  }
}

//encapsulate possible lattice values
abstract class LatVal();
case class UNDEF() extends LatVal();
case class NAC() extends LatVal();
case class LIT(v: ASTLiteral) extends LatVal();
