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
class DeadCodeElimination extends Optimization {

	/**
	 * Apply the optimization to the method md.
	 */
	def optimize(md : ASTMethodDecl) = {
	  val generator = new CFGGenerator();
		val cfg : ControlFlowGraph = generator.makeCFG(md); 		
		val lives = new LiveVariableAnalysis(cfg);
		lives.solve();
				
		// Map each instruction to either the original instruction 
		// or a comment if not reachable.  I could have filtered out the
		// dead code too, but it is easier to read and debug the
		// optimization if you leave comments in where you changed the code
		val optimized = md.tacList.list map
				(instr => 
				  instr match {
				    case TAC_Length(dst: TACOp, array: TACOp, line: Int, comment: String) => {
					     checkOut(instr, lives, cfg, dst);
				    }

				    case TAC_NewClass(dst: TACOp, decl: ASTClassDecl, line: Int, comment: String) => {
				      checkOut(instr, lives, cfg, dst);
				    }

				    //Calls
				    case TACCall_VirCall(dst: Option[TACOp], receiver: TACOp, decl: ASTMethodDecl, paramList: List[TACOp], line: Int, comment: String) => {
				      dst match {
				        case Some(x) => checkOut(instr, lives, cfg, x);
				        case None => instr
				      }
				    }

				    case TACCall_LibCall(store: Option[TACOp], op: String, params: List[TACOp], line: Int, comment: String) => {
				      store match {
				        case Some(x) => checkOut(instr, lives, cfg, x);
				        case None => instr
				      }
				    }

				  //Movement, load store, copy
				    case TAC_Copy(dst: TACOp, src: TACOp, line: Int, comment: String) => {
					    checkOut(instr, lives, cfg, dst);
				    }

				    case TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, line: Int, comment: String) => {
				  	  checkOut(instr, lives, cfg, dst);
				    }

			  	  case TAC_FieldLoad(dst: TACOp, receiver: TACOp, field: ASTFieldDecl, line: Int, comment: String) => {
				    	checkOut(instr, lives, cfg, dst);
				    }

				    //Binary operations
				    case TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, binop: ASTBinOp, line: Int, comment: String) => {
				  	  checkOut(instr, lives, cfg, dst);
				    }

				    //Unops
				    case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) => {
					    checkOut(instr, lives, cfg, dst);
				    }
				    
				    case _ => {instr;}
				  }
				);
		
		md.tacList.list = optimized;
	}
	
	def checkOut(instr: TACInstr, lives: LiveVariableAnalysis, cfg: ControlFlowGraph, dst: TACOp): TACInstr = {
	  if(lives.out(cfg.getBlock(instr)).contains(dst))     
			instr;
		else 
			new TAComment("Removed dead code: " + instr);
	}
	
}
