package ic.asm.cfg;


import scala.collection.mutable.HashMap;

/**
 * 
 * Same as PA4, but with CFG[S] instead of the fixed graph type.
 * 
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
abstract class DataFlowAnalysis[S <: AnyRef,T](val cfg : ControlFlowGraph[S]) {

  /** Map for the in values */
  val ins : HashMap[BasicBlock[S], T] = new HashMap();

  /** Map for the out values */
  val outs : HashMap[BasicBlock[S], T] = new HashMap();

  /**
   * Return in[b].
   */
  def in(b : BasicBlock[S]) : T = ins.getOrElse(b, top());

  /**
   * Return out[b].
   */
  def out(b : BasicBlock[S]) : T = outs.getOrElse(b, top());

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
     * Fold f over every block in the cfg.  In any change occurs
     * do the same thing... We know we eventually reach a fixed point.
     */
    protected def fix(f : BasicBlock[S] => Boolean) : Unit = {
      do {
         // println("Iterating Over Blocks...");
      }  while (((false /: cfg) ((changed, b) => f(b) || changed)));       
    }

  /**
   * Solve a forward analysis and set up in and out.
   */
  protected def solveForward() = {
    // initialize out[enter], which is
    // the boundary value.
    outs.put(cfg.getEnter(), boundary());

    // Iterate over blocks until no more changes.
    fix(b => {
      if (b == cfg.getEnter()) {
        false
      } else {
        // compute the meet of the out[pred] for all pred.
        val oldValue : T = out(b);
        val newValue : T = (top() /: b.getPredecessors().map(out(_)))(meet(_, _));
        ins.put(b, newValue);

        // apply the transfer function
        val newValueOut : T = transfer(b.contents, newValue);
        outs.put(b, newValueOut);
        !equals(oldValue, newValueOut)
      }
    });
  }

  /**
   * Solve a backward analysis.  This is the same as above, except
   * we do everything backwards...
   */
  protected def solveBackward() = {

    ins.put(cfg.getExit(), boundary());

    fix(b => {

      if (b == cfg.getExit()) { // skip the enter/exit block 
        false;
      } else {

        val oldValue = in(b);
        val newValue = (top() /: b.getSuccessors().map(in(_)))(meet(_, _));

        outs.put(b, newValue);

        val newValueIn = transfer(b.contents, newValue);
        ins.put(b, newValueIn);

        !equals(oldValue, newValueIn);
      }
    });
  }

  /**
   * Print out the in/out values for each basic block.
   */
  override def toString() : String = {
    ("" /: cfg)((str : String, b : BasicBlock[S]) => str +
      "BLOCK " + b.id
      + "\n  IN:  " + in(b)
      + "  " + b
      + "\n  OUT: " + out(b)
      + "\n")
  }

  /*
     * These six methods define a dataflow instance and are
     * defined differently in each subclass.
     */

  /**
   * Return true iff the analysis is a forward analysis.
   */
  def isForward() : Boolean;

  /**
   * Initial value for out[enter] or in[exit], depending on direction.
   */
  def boundary() : T;

  /**
   * Top value in the lattice of T elements.
   */
  def top() : T;

  /**
   * Return the meet of t1 and t2 in the lattice.
   */
  def meet(t1 : T, t2 : T) : T;

  /**
   * Return true if t1 and t2 are equivalent.
   */
  def equals(t1 : T, t2 : T) : Boolean;

  /**
   * Return the result of applying the transfer function for
   * instr to t.
   */
  def transfer(instr : S, t : T) : T;
}
