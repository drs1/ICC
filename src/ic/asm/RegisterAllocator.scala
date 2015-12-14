package ic.asm;

import ic.asm.cfg._
import scala.collection.immutable.HashMap

/**
 * The abstract class to describe register allocators. This class provides
 * <pre>
 *   - methods to keep track of stack space usage
 *   - a method to convert an abstract ASM list into an ASM list.
 * </pre>
 *
 * It can convert either an entire method, represented as a CFG[List[absASM]] 
 * or a single block (if liveness information for block exit is known).
 *
 * Usage:
 * <pre>
 *      RegisterAllocator alloc = new SimpleRegisterAllocator(machineDesc);
 *      ... Add any parameter names as VirtualRegisters at the proper offset
 *      ... eg: alloc.addVirtualRegister(VirtualRegister(this), 16);
 *              alloc.addVirtualRegister(formal1, 24);
 *      ...
 *      asm = alloc.devirtualize(abs);
 *      int offsetToLastUseStackSlot = alloc.getMaxHomeOffset();
 *      // be sure the preamble changes stack pointer by at least offsetToLastUseStackSlot - machineDesc.firstAvailableOffset() bytes.
 * </pre>
 */

/**
 * Create a Register Allocator.
 */
abstract class RegisterAllocator(val md: MachineDescription) {

  /* Home location management: */

  /**
   * next offset in stack frame that the allocator can use to stash a virtual
   * register value.
   */
  var currentOffsetForHome = md.firstAvailableOffsetForLocals();

  /** map from virtual registers to their home location offsets from rbp. */
  var homeLocs = new HashMap[VirtualRegister, Int]();

  /**
   * Return the home location for a virtual register. If no location has been
   * allocated, allocate a new spot for it.
   */
  def getHomeLocation(reg: VirtualRegister): Int = {
    homeLocs.get(reg) match {
      case None    => addVirtualRegister(reg, -1); homeLocs(reg);
      case Some(h) => h;
    }
  }

  /**
   * Return the large offset for a home location used by the allocator.
   */
  def getMaxHomeOffset(): Int = {
    this.currentOffsetForHome;
  }

  /** built in virtual registers */
  {
    this.addVirtualRegister(VirtualRegister.virtualPC, -1);
    this.addVirtualRegister(VirtualRegister.virtualFP, -1);
  }

  /**
   * Add a new virtual register at the given offset.  reg should not have
   * been added before.  Pass -1 as the offsetFromRBP if you wish to
   * allocate a new space to the stack frame.  (For params, local vars, you will
   * probably pass an explicit pre-computed offset.)
   */
  def addVirtualRegister(reg: VirtualRegister, offsetFromFramePointer: Int) = {
    if (homeLocs.get(reg) != None) {
      throw new RuntimeException(reg + " already assigned a home location");
    }
    if (offsetFromFramePointer != -1 && homeLocs.values.find(_ == offsetFromFramePointer) != None) {
      throw new RuntimeException(offsetFromFramePointer + " already assigned to other virtual register");
    }
    if (offsetFromFramePointer == -1) {
      val offset = this.currentOffsetForHome;
      homeLocs = homeLocs + (reg -> offset);
      this.currentOffsetForHome -= md.sizeOfDataElement();
    } else {
      if (offsetFromFramePointer < md.firstAvailableOffsetForLocals()) {
        throw new RuntimeException(reg + " bad offset " + offsetFromFramePointer + " for " + reg);
      }
      homeLocs = homeLocs + (reg -> offsetFromFramePointer);
    }
  }

  /**
   * Convert abstract assembly into normal assembly, using the liveAtEnd info for
   * end of sequence.  Useful only for SimpleAllocator and testing.
   */
  def devirtualize(absASM: List[AbsASMInstr], liveAtEnd: Set[VirtualRegister]): List[ASMInstr];

  /**
   * Convert abstract assembly into normal assembly using a CFG.
   */
  def devirtualize(absASM: ControlFlowGraph[List[AbsASMInstr]]): ControlFlowGraph[List[ASMInstr]];

}
