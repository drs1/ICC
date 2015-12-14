package ic.opt;

import ic.ast._;
import ic.dfa._;
import ic.cfg._;
import ic.tac._;

/**
 * Illustrates an Optimization that removes unreachable code.
 * This shows how to stage creating a CFG, performing analysis,
 * and then transforming the code based on the results.
 */
class CopyPropagation extends Optimization {

	/**
	 * Apply the optimization to the method md.
	 */
	def optimize(md : ASTMethodDecl) = {
	  val gen = new CFGGenerator();
	  val cfg : ControlFlowGraph = gen.makeCFG(md)
	  val copies = new ReachingCopiesAnalysis(cfg);
	  copies.solve();
				
	  // Map each instruction to either the original instruction 
	  // or a comment if not reachable.  I could have filtered out the
	  // dead code too, but it is easier to read and debug the
	  // optimization if you leave comments in where you changed the code
	  val optimized = md.tacList.list map
	  (instr => 
	    {
	      val m = copies.in(cfg.getBlock(instr));
	      instr match {
  	      case TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) =>  new TAC_CJump(label, getOp(condition, m), line, comment);
	        //Movement, load store, copy
	        case TAC_Copy(dst: TACOp, src: TACOp, l, c) => new TAC_Copy(dst, getOp(src,m), l, c);
  	      case TAC_ArrayStore(array: TACOp, index: TACOp, value: TACOp, l, c) => new TAC_ArrayStore(array, getOp(index, m), getOp(value, m), l ,c);
	        case TAC_FieldStore(rec: TACOp, field: ASTFieldDecl, value: TACOp, l, c) => new TAC_FieldStore(rec, field, getOp(value, m), l, c);
		      case TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, l, c) => new TAC_ArrayLoad(dst, array, getOp(index, m), l, c);
			      //Binary operations
	        case TAC_BinOp(dst: TACOp, lexpr, rexpr, binop, l, c) => new TAC_BinOp(dst, getOp(lexpr, m), getOp(rexpr, m), binop, l, c);
	        
  	      case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, l, c) => new TAC_UnOp(dst, getOp(expr, m), unop, l, c)
		      case TAC_IndexInBounds(array: TACOp, index: TACOp, l, c) => new TAC_IndexInBounds(array, getOp(index, m), l, c); 
	        case TAC_DivBy0(divisor, line: Int, comment: String) => new TAC_DivBy0(getOp(divisor,m), line, comment);
	        case TAC_GreaterThan0(index: TACOp, l, c) => new TAC_GreaterThan0(getOp(index, m), l, c);
		      case _ => instr;
	       }
	    }
	 );
	  
	  md.tacList.list = optimized;
	} 
	
	def getOp(op: TACOp, m: Map[TACOp, TACOp]): TACOp = {
	  m.getOrElse(op, op);
	}
}

