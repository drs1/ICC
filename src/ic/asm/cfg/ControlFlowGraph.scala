package ic.asm.cfg;

import java.io.File
import java.io.PrintWriter
import java.util.Iterator
import java.util.Vector;
import scala.collection.mutable.MutableList

/**
 * A ControlFlowGraph manages a collection of Basic Blocks and provides
 * some basic operations on them.
 * 
 * This version supports arbitrary nodes with type T
 * 
 * <p>
 * Be sure to inialize the enter and exit
 * blocks with the blocks you are using for those nodes.
 * Those blocks should not contain real instructions from the method
 * being analyzed.  Instead, create two extra blocks with some special
 * instruction values to indicate that they are the enter and exit blocks.
 * See the DataFlowAnalysis documentation for more details.
 * <p>
 * This class implements the Iterable interface, so you can iterate
 * over the blocks in a graph as follows:
 * <pre>
 *   ControlFlowGraph cfg = ...;
 *   for (BasicBlock[T] b :  cfg) {
 *     ...
 *   }
 * </pre>
 */
class ControlFlowGraph[T <: AnyRef] extends Iterable[BasicBlock[T]] {

  val blocks = new MutableList[BasicBlock[T]]();
  var enter: BasicBlock[T] = null;
  var exit: BasicBlock[T] = null;

  /**
   * Allocate a new block that holds the given instruction.
   * A unique number will be assigned to that block.
   * Returns the block.
   */
  def newBlock(instr: T): BasicBlock[T] = {
    val bb = new BasicBlock[T](blocks.size, instr);
    blocks += bb;
    bb;
  }

  /**
   * Return the block representing enter.
   */
  def getEnter() = enter;

  /**
   * Return the block representing exit.
   */
  def getExit() = exit;

  /**
   * Set the block representing enter.
   */
  def setEnter(enter: BasicBlock[T]) = {
    this.enter = enter;
  }

  /**
   * Set the block representing exit.
   */
  def setExit(exit: BasicBlock[T]) = {
    this.exit = exit;
  }

  /**
   * Returns an iterator for the blocks.  The iteration
   * order is the order in which blocks were allocated.
   */
  def iterator() = blocks.iterator;

  /**
   * Returns the block containing i. Throws
   * an exception if not such block exists.
   * 
   * NOTE: This uses pointer equality on elements.
   * 
   */
  def getBlock(i: T): BasicBlock[T] = {
    blocks.find(_.contents eq i).get
  }

  /**
   * Return a string rep for a CFG.
   */
  override def toString() = {
    blocks.mkString("\n");
  }

  /**
   * Writes a dot graph description to the file named fileName.
   * You can visually examine the graph as follows.  After generating
   * graph.dot, execute the following on the command line:
   * <pre>
   *   dot -Tpdf < graph.dot > graph.pdf
   * </pre>
   * Some escape characters and punctuation may confuse dot, in which
   * case you will need to add additional escaping commands, as I have done
   * for the few obvious special cases (", \n, etc).
   */
  def dotToFile(fileName: String) = {
    try {
      val out = new PrintWriter(new File(fileName));
      out.println("digraph G {");
      out.println("   node [shape=record];");
      for (b <- blocks) {
        out.print("B" + b.id + "[");
        out.print("label=\"{Block " + b.id + "|");
        val i = b.contents;
        out.print(i.toString().replace("<", "\\<").replace(">", "\\>").replace("\n", "\\n").replace("\"", "\\\"") + "\\n");
        out.print("}");
        out.println("\"];");
      }
      for (b <- blocks) {
        for (bb <- b.successors) {
          out.println("B" + b.id + " -> " + "B" + bb.id + ";");
        }
      }
      out.println("}");
      out.close();
    } catch {
      case e: Throwable => throw new RuntimeException(e);
    }
  }

  def escape(s: String) = {
    s.replace("<", "\\<").replace(">", "\\>").replace("\n", "\\n").replace("\"", "\\\"")
  }

  /**
   * Generate dot with dataflow info.
   */
  def dotToFile[U](fileName: String, dfa: DataFlowAnalysis[T, U]) = {
    try {
      val out = new PrintWriter(new File(fileName));
      out.println("digraph G {");
      out.println("   node [shape=record];");
      for (b <- blocks) {
        out.print("B" + b.id + "[");
        out.print("label=\"{Block " + b.id + "|");
        val i = b.contents;
        out.print(escape(i.toString()) + "\\n");
        out.print("IN: " + escape(dfa.in(b).toString()) + "\\n");
        out.print("OUT: " + escape(dfa.out(b).toString()) + "\\n");
        out.print("}");
        out.println("\"];");
      }
      for (b <- blocks) {
        for (bb <- b.successors) {
          out.println("B" + b.id + " -> " + "B" + bb.id + ";");
        }
      }
      out.println("}");
      out.close();
    } catch {
      case e : Throwable => throw new RuntimeException(e);
    }
  }

  /**
   * Map from one type of graph to another.  The function f says how to convert
   * a block on the src to the contents of a block in the dst graph.
   */
  def convert[U <: AnyRef](f: (BasicBlock[T] => U)): ControlFlowGraph[U] = {
    val newGraph = new ControlFlowGraph[U]();
    val corr = for (b <- blocks) yield {
      val u = f(b);
      (b, newGraph.newBlock(u));
    }
    val m = corr.toMap
    for ((b, c) <- corr) {
      if (b == enter) newGraph.setEnter(c);
      if (b == exit) newGraph.setExit(c);
      for (bb <- b.getSuccessors) {
        c.addEdge(m(bb));
      }
    }
    newGraph
  }

}

object ControlFlowGraph {

  /**
   * Convert a CFG[List[T]] into a CFG[T].  That is lists are converted into singleton
   * blocks.
   */
  def explode[T <: AnyRef](cfg: ControlFlowGraph[List[T]], emptyVal : T): ControlFlowGraph[T] = {
    val newGraph = new ControlFlowGraph[T]();
    val corr = for (b <- cfg) yield {
      if (b.contents.size == 0) {
        (b, List(newGraph.newBlock(emptyVal)));
      } else {
        (b, b.contents.map(instr => newGraph.newBlock(instr)));
      }
    }
    val m = corr.toMap
    for ((b, c) <- corr) {
      if (b == cfg.getEnter()) newGraph.setEnter(c(0));
      if (b == cfg.getExit()) newGraph.setExit(c(0));
      for (i <- 0 until c.size - 1) {
        c(i).addEdge(c(i + 1));
      }
      for (bb <- b.getSuccessors) {
        c.last.addEdge(m(bb)(0));
      }
    }
    newGraph;
  }
  
  /**
   * Convert from the CFG implementation from PA4.
   */
  def fromBaseCFG(cfg: ic.cfg.ControlFlowGraph): ControlFlowGraph[ic.tac.TACInstr] = {
    val newGraph = new ControlFlowGraph[ic.tac.TACInstr]();
    val corr = for (b <- cfg) yield {
      val u = b.instr;
      (b, newGraph.newBlock(u));
    }
    val m = corr.toMap
    for ((b, c) <- corr) {
      if (b == cfg.getEnter()) newGraph.setEnter(c);
      if (b == cfg.getExit()) newGraph.setExit(c);
      for (bb <- b.getSuccessors) {
        c.addEdge(m(bb));
      }
    }
    newGraph
  }

}
