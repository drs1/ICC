package ic.dfa;

import ic.cfg.ControlFlowGraph
import ic.tac.TACInstr
import ic.tac.TAC_Copy
import ic.tac.TAComment

object Test {
	def main(s : Array[String]) = {
    ic.Util.debug = true;
		val cfg = new ControlFlowGraph();
		val enter = new TAComment("enter")
		val enterBlock = cfg.newBlock(enter);
		cfg.setEnter(enterBlock);
		val exit = new TAComment("exit")
		val exitBlock = cfg.newBlock(exit);
		cfg.setExit(exitBlock);
		val t1 = cfg.newBlock(new TAComment("t1"));
    val t2 = cfg.newBlock(new TAComment("t2"));
    val t4 = cfg.newBlock(new TAComment("t4"));
		val t3 = cfg.newBlock(new TAComment("t3"));
		enterBlock.addEdge(t3);
    t3.addEdge(t2);
   // t3.addEdge(t4);
    t2.addEdge(t1);
    t4.addEdge(t1);
		t1.addEdge(exitBlock);
		cfg.dotToFile("a.dot");
		val d = new ReachableAnalysis(cfg);
		d.solve();
		println(d);
	}
}





