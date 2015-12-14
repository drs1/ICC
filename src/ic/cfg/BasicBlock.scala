package ic.cfg;

import ic.tac._
import scala.collection.mutable.HashSet

/**
 * Represents one BasicBlock in a CFG.  This implementation
 * permits only a single instruction per block.  Each block
 * has an id number to enable you to distinguish blocks in client
 * code, a single instruction, and a set of successor and
 * predecessor blocks.
 */
class BasicBlock(val id : Int, val instr : TACInstr)  {

	private val successors = new HashSet[BasicBlock]();
	private val predecessors = new HashSet[BasicBlock]();
 
	/**
	 * Add an edge from this block to successor.  This method
	 * properly maintains the predecessor list as well.
	 */
	def addEdge(successor : BasicBlock) = {
		successors.add(successor);
		successor.predecessors.add(this);
	}

	/**
	 * Return a list of predecessors that you can iterator over.
	 */
	def getPredecessors() = {
		predecessors.toList;
	}

	def getSuccessors() = {
		successors.toList;
	}

	/**
	 * A printable rep for a block.  Change as you see fit.
	 */
	override def toString() = {
		String.format("Block %-3s: %-20s       [pred=%-15s ; succ=%-15s]", 
				id.toString, 
				instr, 
				predecessors.map(_.id).mkString(","), 
				successors.map(_.id).mkString(","));
	}
	
}
