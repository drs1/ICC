package ic.asm

import scala.collection.mutable.HashMap
import scala.collection.mutable.MutableList

// A class to hold the conflict graph for Register Allocation

class ConflictGraph() {
  var edges: HashMap[VirtualRegister, Set[VirtualRegister]]= HashMap()
  var marked: HashMap[VirtualRegister, Boolean] = HashMap()
  
  def addEdge(e: Tuple2[VirtualRegister, VirtualRegister]) = {
    //update edge lists for both nodes
    edges += e._1 -> (edges.getOrElse(e._1, Set()) + e._2)
    edges += e._2 -> (edges.getOrElse(e._2, Set()) + e._1)
  }
  
  
  //print out the edge map
  override def toString() = {
    var result = "Conflict Graph: \n"
    for (edge <- edges.keys) {
      result = result + edge + ":"
      for (node <- edges(edge)) {
        result = result + " " + node
      }
      result = result + "\n"
    }
    result
  }
  
  //"delete" node from graph
  def turnOff(mark: VirtualRegister) = {
    marked += mark -> true
  }
  
  //re-add node from graph
  def turnOn(mark: VirtualRegister) = {
    marked += mark -> false
  }
  
  //return list of the live edges from a node
  def liveNeighbors(node: VirtualRegister): Set[VirtualRegister] = {
    var lNeighbors: Set[VirtualRegister] = Set()
    val neighbors: Set[VirtualRegister] = edges.getOrElse(node, Set())
    for(n <- neighbors) {
      //if the neighbor is not marked, add it
      if (!marked.getOrElse(n, false)) {
        lNeighbors = lNeighbors + n
      }
    }
    lNeighbors
  }
  
  //return all neighbors, live or not
  def neighbors(node: VirtualRegister): Set[VirtualRegister] = {
    edges.getOrElse(node, Set())
  }
  
  //return number of live edges from a node
  def degree(node: VirtualRegister) = {
    liveNeighbors(node).size
  }
  
  //return the live nodes
  def liveNodes(): Set[VirtualRegister] = {
    var lNodes: Set[VirtualRegister] = Set()
    for (node <- edges.keys) {
      if (!marked.getOrElse(node, false)) {
        lNodes = lNodes + node
      }
    }
    return lNodes
  }
}
