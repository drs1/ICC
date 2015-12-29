package ic.asm

import scala.collection.mutable.HashMap
import scala.collection.mutable.MutableList
import scala.collection.mutable.Stack
import util.control.Breaks._
import PhysicalRegister._
import VirtualRegister._;
import ic.asm.cfg._
import ic.error._
import ic.cg_x86.X86MachineDescription

/**
 * A simple register allocator that assigns each Virtual Register to a stack
 * home location. Each use of a register requires a load from memory, and each
 * write to a register requires a store to memory. Obviously, this is slow ---
 * especially since local vars already require load/stores on each use. However,
 * it gets the job done.
 *
 * The allocator is parameterized by the machine description for the target
 * architecture.
 *
 * Virtual registers for physical registers must be assigned to the proper
 * physical register.  This may require extra loads/stores as it discovers
 * conflicts with already assigned registers and shuffles the assignment
 * around.
 *
 * Run on the main method to see it in action on a small "program".
 *
 */

class BijanRegisterAllocator(override val md: MachineDescription) extends RegisterAllocator(md) {

  /**
   * List of currently unassigned registers.
   * Put "funny" registers last so we don't have to deal with them often...
   */
  protected var freeList: List[PhysicalRegister] = md.assignableRegisters();
  //precolored: rax rdx rsi rdi

  /**
   * Map from Virtual to Physical, for those virtual regs currently assigned
   * to physical.
   */
  protected var regMap = {
    //add in preliminary colorings
    var result = Map[VirtualRegister, PhysicalRegister]((virtualFP -> md.FP()), (virtualPC -> md.PC()));
    //color every virtual version of physical registers as themselves
    for (physReg <- (md.assignableRegisters() ++ md.preColoredRegisters())) {
      result = result + (physReg.asVirtual() -> physReg)
    }
    result
  }
  
  protected var spills: List[VirtualRegister] = {
    var result: List[VirtualRegister] = List()
    for (physReg <- md.assignableRegisters() ++ md.preColoredRegisters()) {
      result = result :+ physReg.asVirtual()
    }
    result
  }

  /**
   * Assign a home location all callee-save registers, which will be stashed on entry.
   * This assumes a preamble instruction that has all callee saves listed as
   * defined by that instruction to force stores...
   */
  md.calleeSaveRegisters().foreach { x =>
    val vr = x.asVirtual();
    getHomeLocation(vr);
    regMap += (vr -> x)
  }

  /**
   * This map indicates which virtual registers must be bound to specific physical registers.
   */
  protected val preColored = md.assignableRegisters().map { x => (x.asVirtual(), x) }.toMap

  /**
   * Return the physical register currently allocated to the virtual register.
   * If vReg is not assigned, return null;
   */
  def getPhysicalForVirtual(vReg: VirtualRegister): PhysicalRegister = {
    regMap.get(vReg) match {
      case None     => throw new RuntimeException("No Physical Register for Virtual: " + vReg);
      case Some(pr) => pr;
    }
  }

  /**
   * Return the physical register currently allocated to the virtual register.
   * If vReg is not assigned, return null;
   */
  protected def getOptionalPhysicalForVirtual(vReg: VirtualRegister): Option[PhysicalRegister] = {
    regMap.get(vReg);
  }

  /**
   * Convert abstract assembly into normal assembly.
   */
  def devirtualize(absASM: List[AbsASMInstr], liveAtEnd: Set[VirtualRegister]): List[ASMInstr] = {
    var x: List[ASMInstr] = List();
    return x;
  }

  def devirtualize(absASM: ControlFlowGraph[List[AbsASMInstr]]): ControlFlowGraph[List[ASMInstr]] = {
    //absASM.convert { x => this.devirtualize(x.contents, Set()) }
    //run data flow analysis to get conflict info
    val cfg = ControlFlowGraph.explode(absASM, AbsASMComment("Empty"))
    val dfa = new LiveVirtualRegisterAnalysis(cfg)
    dfa.solve();
//    print(dfa);
    var cGraph = buildConflictGraph(cfg, dfa);
    print(cGraph)

    //SIMPLIFY
    //find a degree <k node, markDelete it and push it on the stack
    //repeat until nothing is left
    println("Simplifying");
    var unmovableNodes: Set[VirtualRegister] = md.assignableRegisters().map(x => x.asVirtual()).toSet
    var liveNodes: Set[VirtualRegister] = cGraph.liveNodes() -- unmovableNodes;
    var k = md.assignableRegisters.length;
    println("We can use " + k + "registers")
    var nodeStack: Stack[VirtualRegister] = Stack()

    while (!liveNodes.isEmpty) {
      val minDegreeNode = liveNodes.minBy(node => cGraph.degree(node))
        
      if (cGraph.degree(minDegreeNode) < k) {
        //Then we can remove it and continue
        nodeStack.push(minDegreeNode)
        println("Turning off " + minDegreeNode + " " + cGraph.degree(minDegreeNode))
        cGraph.turnOff(minDegreeNode)
      } else {
        //We need to spill
        //pick the cheapest spill
        println("Min degree node: " + minDegreeNode + " degree: " + cGraph.degree(minDegreeNode));
        var possiblSpills = cGraph.liveNeighbors(minDegreeNode) + minDegreeNode;
        //Dont spill the same thing twice
        possiblSpills = possiblSpills.filter(x => !spills.contains(x));
        println("Possible spills: " + possiblSpills)
        println("Spills: " + spills)
        val spill = possiblSpills.minBy(node => spillCost(cfg, node, dfa))
        println("Spilling " + spill)
        spills = spills :+ spill
        var newCFG: ControlFlowGraph[List[AbsASMInstr]] = new ControlFlowGraph()
        newCFG = spillGraph(cfg, spill)
        //now recursively call on spilled graph
        return devirtualize(newCFG)
      }
        
      //reset
      liveNodes = cGraph.liveNodes() -- unmovableNodes;
    }
    
    //Now COLOR
    println("putting nodes back")
    while(!nodeStack.isEmpty) {
      val nodeToAdd = nodeStack.pop()
      val conflictingRegs = cGraph.neighbors(nodeToAdd) + nodeToAdd
      println("trying to color " + nodeToAdd)
      //if this node is already colored, we can continue
      val physReg = regMap.get(nodeToAdd) match
      {
        case Some(x) => x
        case None => {
          //Now, create a list of all the registers that are not conflicting
          var freeRegs: Set[PhysicalRegister] = freeList.toSet
          for (reg <- conflictingRegs) {
            regMap.get(reg) match {
              case Some(physReg) => {
                freeRegs = freeRegs - physReg;
                println("colors left: " + freeRegs)
              }
              case None => { }
            }
          }
          println("Free registers to chose from: " + freeRegs)
          freeRegs.head
        }
      }
      
      println("Coloring " + nodeToAdd + " with " + physReg)
      regMap += (nodeToAdd -> physReg)
      cGraph.turnOn(nodeToAdd);
    }
    
    //for testing
    //var ret = new ControlFlowGraph[List[ASMInstr]];
    //return ret
    
    //Now go through and devirtualize everything using regMap
    println(regMap);
    val devirtualizedCFG: ControlFlowGraph[List[ASMInstr]] = cfg.convert(block => {
      val instr = block.contents
      List(instr.devirtualize(regMap))
    } )
    
    return devirtualizedCFG
  }

  
  def spillGraph(cfg: ControlFlowGraph[AbsASMInstr], 
      spillNode: VirtualRegister):ControlFlowGraph[List[AbsASMInstr]] = {
    
    println("In Spillgraph");
    cfg.convert(block => {
      val uses = block.contents.uses;
      val defines = block.contents.defines;

      var AbsASMList: List[AbsASMInstr] = List()
      //LOAD if we use it
      if(uses.contains(spillNode)){
        AbsASMList = AbsASMList :+ md.copyFromStack(getHomeLocation(spillNode), spillNode, "Spilled Load")
      }
      AbsASMList = AbsASMList :+ block.contents
      //STORE if we define it
      if(defines.contains(spillNode)){
        AbsASMList = AbsASMList :+ md.copyToStack(spillNode, getHomeLocation(spillNode), "Spilled Store")
      }
      //println(AbsASMList)
      AbsASMList
    } )
  }
  
  def buildConflictGraph(cfg: ControlFlowGraph[AbsASMInstr], 
      dfa: LiveVirtualRegisterAnalysis): ConflictGraph = {
    
    var cGraph = new ConflictGraph;
    println("Building Conflict Graph");
    //println(dfa);
    for (block <- cfg) {
      val instruct = block.contents
      val uses = instruct.uses;
      val defines = instruct.defines;

      uses.foreach (x => cGraph.edges += (x -> Set()));
      defines.foreach (x => cGraph.edges += (x -> Set()));
    }

    for (block <- cfg) {
      val instruct = block.contents
      val uses = instruct.uses;
      val defines = instruct.defines;

      //add edges between defined nodes and nodes that are live afterwards
      var edges = for (define <- defines; live <- dfa.out(block)) yield (define, live)
	
      for (edge <- edges) {
        cGraph.addEdge(edge)
      }

    }
    cGraph
  }

  def spillCost(cfg: ControlFlowGraph[AbsASMInstr], reg: VirtualRegister, dfa: LiveVirtualRegisterAnalysis) = {
    var cost: Integer = 0;
    for (block <- cfg.iterator) {
      cost += use(reg, block) + 2 * live(reg, block, dfa)
    }
  }

  //number of times register is used in the block (max of 1 because it is one instruction)
  def use(reg: VirtualRegister, block: BasicBlock[AbsASMInstr]): Integer = {
    val uses = block.contents.uses;
    
    if (uses.contains(reg)) {
      1
    } else {
      0
    }
    /*
    block.contents match {
      case AbsASMMove(format, src, dst, comment) => {
        if (src == reg) {
          1
        } else {
          0
        }
      }
      case AbsASMOp(format, uses, defines, comment) => {
        if (uses.contains(reg)) {
          1
        } else {
          0
        }
      }
      case _ => 0
    }
    * */
  }

  //1 if register is live on exit of the block and the register is defined, 0 otherwise
  def live(reg: VirtualRegister, block: BasicBlock[AbsASMInstr], dfa: LiveVirtualRegisterAnalysis) = {

    if (!dfa.out(block).contains(reg)) {
      //if not live on exit from block, return 0
      0
    } else {
      val defines = block.contents.defines;
      if (defines.contains(reg)) {
        1
      } else {
        0
      }
      /*
      block.contents match {
        case AbsASMMove(format, src, dst, comment) => {
          if (dst == reg) {
            1
          } else {
            0
          }
        }
        case AbsASMOp(format, uses, defines, comment) => {
          if (defines.contains(reg)) {
            1
          } else {
            0
          }
        }
        case _ => 0 */
    }
  }
}

object BijanRegisterAllocator {

  def main(args: Array[String]) = {

  }
}
