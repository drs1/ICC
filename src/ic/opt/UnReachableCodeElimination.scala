package ic.opt;

import ic.ast._;
import ic.dfa._;
import ic.cfg.ControlFlowGraph;
import ic.tac.TAComment;

/**
 * Illustrates an Optimization that removes unreachable code.
 * This shows how to stage creating a CFG, performing analysis,
 * and then transforming the code based on the results.
 */
class UnReachableCodeElimination extends Optimization {

	/**
	 * Apply the optimization to the method md.
	 */
	def optimize(md : ASTMethodDecl) = {
		val cfg : ControlFlowGraph = null; 		
		val reaches = new ReachableAnalysis(cfg);
		reaches.solve();
				
		// Map each instruction to either the original instruction 
		// or a comment if not reachable.  I could have filtered out the
		// dead code too, but it is easier to read and debug the
		// optimization if you leave comments in where you changed the code
		val optimized = md.tacList.list map
				(instr => 
					if (reaches.in(cfg.getBlock(instr))) {
						instr;
					} else {
						new TAComment("Removed dead code: " + instr);
					}
				);
		
		md.tacList.list = optimized;
	}
	
}