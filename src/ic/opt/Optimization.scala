package ic.opt;

import ic.ast._;

/**
 * To create an optimization, simply subclass this class and define
 * optimize(md) to compute any dataflow information necessary to
 * perform the optimization on md and then modify the method's TAC
 * list. You can either provide methods in your TACList class to
 * modify an existing list, or you can construct a new list to replace
 * the old one.
 */
abstract class Optimization {

  /**
   * Apply the optimization to each Method in p.
   */
  def optimize(p : ASTProgram) : Unit = {

    /* 
     * Change this code to call optimize on each MethodDecl.
     */
    for (c <- p.classes;
	 elem <- c.decls) {
      elem match {
	case e: ASTMethodDecl => optimize(e);
	case _ => {}
      }
    }
  }


  /**
   * Apply the optimization to the method md.
   */
  def optimize(md : ASTMethodDecl) : Unit;
}
