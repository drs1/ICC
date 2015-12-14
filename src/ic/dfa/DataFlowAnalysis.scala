package ic.dfa;

import ic.cfg.BasicBlock;
import ic.cfg.ControlFlowGraph;
import ic.tac._;
import ic.Util;

import scala.collection.mutable.HashMap;

/**
 * Abstract Dataflow analysis engine. This is a general class for
 * solving dataflow instances. It is parameterized by the type T,
 * which is the type of value contained in the lattice. The solve
 * method is responsible for computing the solution for the CFG passed
 * into the constructor. After calling solve, the in and out methods
 * can be used to access the dataflow facts for each basic block.
 * <p>
 * To use the framework, you extend this class with a new class ---
 * LiveVariableAnalysis, for example --- which defines the six
 * abstract methods describing the lattice, transfer functions, meet
 * operator, boundary value, and direction of the analysis.
 * <p>
 * This implementation assumes the the enter and exit blocks for the CFG
 * do not contain instructions that are part of the code.  It will
 * not apply transfer functions to those blocks.  You can insert a simple
 * "NoOp" TAC Instruction into those blocks.
 * <p>
 * Note that for forward analysis, in[enter] is typically undefined,
 * but I set it to Top for simplicity.  Similarly, for backward
 * analysis, out[exit] is set to Top.
 */
abstract class DataFlowAnalysis[T](val cfg: ControlFlowGraph) {

  /** Map for the in values */
  val ins: HashMap[BasicBlock, T] = new HashMap();

  /** Map for the out values */
  val outs: HashMap[BasicBlock, T] = new HashMap();

  /**
   * Return in[b].
   */
  def in(b: BasicBlock): T = ins.getOrElse(b, top());

  /**
   * Return out[b].
   */
  def out(b: BasicBlock): T = outs.getOrElse(b, top());

  /**
   * Solve a dataflow instance with the iterative algorithm.
   */
  def solve() = {
    if (isForward()) {
      solveForward();
    } else {
      solveBackward();
    }
  }

  /*
     * Apply f to every block.  If any change occurs
     * do the same thing... We know we eventually reach a fixed point.
     */
  protected def fix(f: BasicBlock => Boolean): Unit = {
    do {
      println("\nIterating Over Blocks...");
    } while (cfg.map(f).reduce(_||_)); 
  }

  /**
   * Solve a forward analysis and set up in and out.
   */
  protected def solveForward() = {
    // initialize out[enter], which is
    // the boundary value.
    outs.put(cfg.getEnter(), boundary());

    // Iterate over blocks until no more changes.
    fix((b: BasicBlock) => {
      if (b == cfg.getEnter()) {
        false
      } else {
        val oldValueOut: T = out(b); // old value for out

        // compute the meet of the out[pred] for all pred.
        val predecessorOuts = b.getPredecessors().map(out(_))
        val newValue: T = (top() /: predecessorOuts)(meet(_, _));
        ins.put(b, newValue);

        // apply the transfer function
        val newValueOut: T = transfer(b.instr, newValue);
        outs.put(b, newValueOut);

        // did the out change?  If so, we'll need to iterate longer...
        val changed = !equals(oldValueOut, newValueOut);

        // debugging output
        Util.debug(s" ${b.toString}");
        Util.debug(s"    OUT[Preds]: ${predecessorOuts.mkString(", ")}");
        Util.debug(s"    IN[B]:      ${newValue}");
        Util.debug(s"    OUT[B]:     ${newValueOut}");
        if (changed) {
          Util.debug(s"    (OUT[B] changed from ${oldValueOut})");
        }
        // end debugging output

        changed;
      }
    });
  }

  /**
   * Solve a backward analysis.  This is the same as above, except
   * we do everything backwards...
   */
  protected def solveBackward() = {

    ins.put(cfg.getExit(), boundary());

    fix((b: BasicBlock) => {

      if (b == cfg.getExit()) { // skip the enter/exit block 
        false;
      } else {

        val oldValueIn = in(b);

        val successorIns = b.getSuccessors().map(in(_));
        val newValue = (top() /: successorIns)(meet(_, _));
        outs.put(b, newValue);

        val newValueIn = transfer(b.instr, newValue);
        ins.put(b, newValueIn);

        val changed = !equals(oldValueIn, newValueIn);

        // debugging output
        Util.debug(s" ${b.toString}");
        Util.debug(s"    OUT[Preds]: ${successorIns.mkString(", ")}");
        Util.debug(s"    IN[B]:      ${newValueIn}");
        Util.debug(s"    OUT[B]:     ${newValue}");
        if (changed) {
          Util.debug(s"    (IN[B] changed from ${oldValueIn})");
        }
        // end debugging output

        changed;
      }
    });
  }

  /**
   * Print out the in/out values for each basic block.
   */
  override def toString(): String = {
    ("" /: cfg)((str: String, b: BasicBlock) => str +
      "Block " + b.id
      + "\n   IN:  " + in(b)
      + "\n " + b.instr
      + "\n   OUT: " + out(b)
      + "\n\n")
  }

  /*
     * These six methods define a dataflow instance and are
     * defined differently in each subclass.
     */

  /**
   * Return true iff the analysis is a forward analysis.
   */
  def isForward(): Boolean;

  /**
   * Initial value for out[enter] or in[exit], depending on direction.
   */
  def boundary(): T;

  /**
   * Top value in the lattice of T elements.
   */
  def top(): T;

  /**
   * Return the meet of t1 and t2 in the lattice.
   */
  def meet(t1: T, t2: T): T;

  /**
   * Return true if t1 and t2 are equivalent.
   */
  def equals(t1: T, t2: T): Boolean;

  /**
   * Return the result of applying the transfer function for
   * instr to t.
   */
  def transfer(instr: TACInstr, t: T): T;
}
