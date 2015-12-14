package ic.asm

import scala.collection.immutable.HashMap
import PhysicalRegister._
import VirtualRegister._;
import ic.asm.cfg._
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

class SimpleRegisterAllocator(override val md: MachineDescription) extends RegisterAllocator(md) {

  /**
   * List of currently unassigned registers.
   * Put "funny" registers last so we don't have to deal with them often...
   */
  protected var freeList = md.assignableRegisters();

  /**
   * Map from Virtual to Physical, for those virtual regs currently assigned
   * to physical.
   */
  protected var regMap =
    HashMap[VirtualRegister, PhysicalRegister]((virtualFP -> md.FP()), (virtualPC -> md.PC()));

  
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
    absASM.flatMap(i => {
      (i match {
        case i: AbsASMInstr =>
          val uses = i.uses;
          val defines = i.defines;

          // used registers must have been init'd already and stored, so
          // restore them
          val restores = uses.flatMap(restore _);

          // defined registers need to be allocate, but no loads are
          // necessary unless we must relocate a register
          val allocs = defines.map(alloc _).flatMap( { case (pReg, asm) => asm });

          // replace virtual with physical regs
          val instrs = List(i.devirtualize(regMap));

          // write defined registers to memory
          val writes = defines.flatMap(x => store(getPhysicalForVirtual(x)));

          // forget about used registers
          uses.foreach(x => free(getPhysicalForVirtual(x)));

          // forget about defined registers.
          defines.foreach(vr =>
            if (getOptionalPhysicalForVirtual(vr) != None)
              free(getPhysicalForVirtual(vr)));

          restores ++ allocs ++ instrs ++ writes;
      })
    });
  }

  def devirtualize(absASM: ControlFlowGraph[List[AbsASMInstr]]): ControlFlowGraph[List[ASMInstr]] = {
    absASM.convert { x => this.devirtualize(x.contents, Set()) }
  }

  /*
	 * Print the register file.
	 */
  // helper for toString()
  protected def format(pReg: PhysicalRegister): String = {
    getVirtualRegisterForPhysical(pReg) match {
      case None =>
        if (freeList.contains(pReg)) {
          "FREE";
        } else {
          "RES";
        }
      case Some(vReg) => vReg.toString();
    }
  }

  /* 
	 * Dump register file to a String.
	 */
  override def toString(): String = {
    "[" + (md.assignableRegisters() map (pReg => String.format("%s=%-6s  ", pReg, format(pReg)))).reduce(_ + _) + "]"
  }

  /**
   * Allocate a new register for vReg. The steps are:
   *
   * <pre>
   *    1. if vReg already in pReg, return pReg
   *    2. if vReg is precolored, assign it to the right pReg, 
   *       possibly moving what is there to another pReg.
   *    3. if freelist is not empty, assign vReg
   *       to a new register pReg and return pReg.
   *    4. if freelist is empty, fail.
   *
   */
  protected def alloc(vReg: VirtualRegister): (PhysicalRegister, List[ASMInstr]) = {
    getOptionalPhysicalForVirtual(vReg) match {
      case Some(pReg) => (pReg, Nil);  // 1
      case None =>
        preColored.get(vReg) match {
          case Some(pReg) => // 2
            val asm = reserve(pReg)
            regMap = regMap + (vReg -> pReg);
            freeList = freeList.filterNot (_ == pReg);
            (pReg, asm);
          case None if !freeList.isEmpty => // 3
            val pReg = freeList.head;
            freeList = freeList.tail;
            regMap = regMap + (vReg -> pReg);
            (pReg, Nil);
          case None => // 4
            throw new RuntimeException("No physical registers left");
        }
    }
  }

  /**
   * Reserve register pReg for special use.
   * <p>
   * NOTE: This may shuffle other registers around if pReg is already in use.
   */
  protected def reserve(pReg: PhysicalRegister): List[ASMInstr] = {
    val asm = if (!freeList.contains(pReg)) {
      this.getVirtualRegisterForPhysical(pReg) match {
        case None => Nil; // throw new RuntimeException("Physical Register " + pReg + " is already reserved.");
        case Some(vReg) => 
          regMap = regMap - vReg;
          val (newPReg, asm) = alloc(vReg);
          val x = asm ++ List(md.copyToReg(pReg, newPReg, "realloc vr"))
	  x
      }
    } else {
      freeList = freeList.filter(_ != pReg);
      List();
    }
    asm;
  }

  /**
   * Allocate a register for vReg, and restore vReg's value from memory. This
   * method takes the assembly list being constructed so that it can add the
   * proper load operation. The steps are:
   *
   * <pre>
   *    1. if vReg == virtualRBP/RIP, just return RBP/RIP
   *    2. allocate pReg to vReg.
   *    3. load the value from vReg's home location in pReg.
   *    4. return pReg.
   * </pre>
   *
   * This method will fail if no registers are left, or if vReg wasn't
   * previously initialized.
   */
  protected def restore(vReg: VirtualRegister): List[ASMInstr] = {
    if (vReg == virtualFP || vReg == virtualPC) {
      Nil;
    } else {
      this.homeLocs.get(vReg) match {
        case None => throw new RuntimeException("Cannot load vreg " + vReg + " without prior store");
        case Some(home) =>
          val (pReg, asm) = alloc(vReg);
          asm ++ List(md.copyFromStack(home, pReg, vReg + " -> " + pReg));
      }
    }
  }

  /**
   * Free pReg (without spilling value to memory).   The steps are:
   *
   * <pre>
   *    1. if vReg == virtualRBP/RIP, just return
   *    2. find the vReg assigned to pReg.
   *    3. remove vReg from the register Map if vReg exists.
   *    4. put pReg back on the freelist.
   * </pre>
   *
   */
  protected def free(pReg: PhysicalRegister) = {
    if (pReg != md.FP() && pReg != md.PC()) {
      getVirtualRegisterForPhysical(pReg) match {
        case Some(vReg) => regMap = regMap - vReg;
        case None       =>
      }
      freeList = pReg :: freeList;
    }
  }

  /**
   * Write the value of pReg back to the stack slot for the vReg
   * currently stored in it.
   */
  protected def store(pReg: PhysicalRegister): List[ASMInstr] = {
    if (pReg != md.FP() && pReg != md.PC()) {
      val vReg = getVirtualRegisterForPhysical(pReg).get
      val home = getHomeLocation(vReg);
      List(md.copyToStack(pReg, home, pReg + " -> " + vReg));
    } else {
      Nil;
    }
  }

  /**
   * Find the vReg for a pReg.  Returns null if no vReg is currently
   * stored in pReg.
   */
  protected def getVirtualRegisterForPhysical(pReg: PhysicalRegister): Option[VirtualRegister] = {
    regMap.find(_._2 == pReg) match {
      case None         => None
      case Some((k, v)) => Some(k);
    }
  }

}

object SimpleRegisterAllocator {

  def main(args: Array[String]) = {
    val regs = new SimpleRegisterAllocator(X86MachineDescription);
    println("initial:      " + regs);
    regs.alloc(new VirtualRegister("v1"));
    println("alloc v1:     " + regs);
    regs.alloc(X86MachineDescription.R8.asVirtual());
    println("reserve R8:   " + regs);
    regs.free(X86MachineDescription.R8);
    println("unreserve R8: " + regs);
    val asm2 = regs.reserve(X86MachineDescription.R15);
    println("reserve R15:  " + regs);
    regs.alloc(new VirtualRegister("v2"));
    println("alloc v2:     " + regs);
    regs.alloc(new VirtualRegister("v3"));
    println("alloc v3:     " + regs);

    regs.free(X86MachineDescription.R15);
    println("unreserve R15:" + regs);
    val asm3 = regs.reserve(X86MachineDescription.R15);
    println("reserve R15:  " + regs);
    regs.alloc(new VirtualRegister("v2"));
    println("alloc v2:     " + regs);
    regs.alloc(new VirtualRegister("v3"));
    println("alloc v3:     " + regs);

    regs.free(X86MachineDescription.R15);
    println("unreserve:    " + regs);
    regs.free(regs.getPhysicalForVirtual(new VirtualRegister("v1")));
    println("free v1:      " + regs);
  }
}
