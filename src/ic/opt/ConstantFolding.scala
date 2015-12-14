package ic.opt

import ic.ast._;
import ic.dfa._;
import ic.cfg._;
import ic.tac._;

class ConstantFolding extends Optimization {

  def optimize(md: ASTMethodDecl) : Unit = {
    val gen = new CFGGenerator();
    val cfg : ControlFlowGraph = gen.makeCFG(md); 		
    val cfa = new ConstantFoldingAnalysis(cfg);
    cfa.solve();
    
    
    val optimized = md.tacList.list map 
    (instr => 
      {
        val m = cfa.in(cfg.getBlock(instr));
        instr match{
          case TAC_Copy(dst, src, line, c) => new TAC_Copy(dst, getOp(src, m), line, c);
          case TAC_BinOp(dst, lExpr, rExpr, binop, l, c) => new TAC_BinOp(dst, getOp(lExpr, m), getOp(rExpr, m), binop, l, c);
	        case TAC_UnOp(dst, expr, unop, l, c) => new TAC_UnOp(dst, getOp(expr, m), unop, l, c);
	        case TAC_ArrayStore(array, index, value, l, c) => new TAC_ArrayStore(array, getOp(index, m), getOp(value, m), l, c);
	        case TAC_ArrayLoad(dst, array, index, l, c) => new TAC_ArrayLoad(dst, array, getOp(index, m), l, c);
	        case TAC_FieldStore(rec, field, value, l, c) => new TAC_FieldStore(rec, field, getOp(value, m), l, c);
	        case TAC_CJump(label, cond, l, c) => new TAC_CJump(label, getOp(cond, m), l, c);
	        case r @ TAC_RET(value, l, c) => value match{
	          case Some(x) => new TAC_RET(Some(getOp(x, m)), l, c)
	          case None => r 
	        }
	        
	        //leave all other instructions as themselves	        
	        case x => x 
        }  
      }
   );
    md.tacList.list = optimized
  }
  
  
  def getOp(op: TACOp, m:Map[TACOp, LatVal]): TACOp = {
    m.getOrElse(op, UNDEF()) match{
      case NAC() | UNDEF() => op
      case LIT(x) => new TAC_Lit(x, op.line, "Replaced " + op + " with constant " + x)
    }
  }
}
