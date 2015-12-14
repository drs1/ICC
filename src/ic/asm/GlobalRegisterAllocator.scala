package ic.asm

import ic.asm.cfg._

/**
 * Starter for Global Allocators.  Shows how to manipulate the CFGs.
 *
 * Notes:
 *
 *  -  When adding code to spill/load registers, you may wish to use the
 *     cfg.convert method, which maps a function over all blocks.  That function
 *     can identify the blocks that must be modified and insert new instructions
 *     into them.
 *
 */

class GlobalRegisterAllocator(override val md: MachineDescription) extends RegisterAllocator(md) {

  /**
   * Convert one or more abs instructions, with liveAtEnd data.  This version may not
   * actually be useful if it's a global allocator.
   */
  override def devirtualize(absASM: List[AbsASMInstr], liveAtEnd: Set[VirtualRegister]): List[ASMInstr] = {
    Nil;
  }

  /**
   * Convert entire CFG by computing liveness and then iterating over exploded graph's instructions
   * one at a time.
   *
   * Assumptions about AbsASM for a method:
   *
   *   1) The first instruction defines all callee-save registers, so that the allocator can stashing
   *      the values if those registers are over-written.  Example:
   *
   *      AbsASMComment("Callee Save Defs", Nil, md.calleeSaveRegisters.map(x => x.asVirtual()));
   *
   *   2) All parameters are loaded into virtual registers at the start of the method.
   *      This should happen if there is a TAC_Preamble instruction.  This makes it so the
   *      allocator only has to worry about virtual registers and not parameter memory
   *      locations.
   * 
   *   3) Before the epilogue for a return instruction, there is an instruction that uses
   *      all callee-save registers, so the allocator will be forced to restore them:
   *
   *      AbsASMComment("Calles Save Uses", md.calleeSaveRegisters.map(x => x.asVirtual()), Nil);
   *
   *   4) All operations that require special physical registers must include the correct
   *      virtual registers in their use/def sets.  Example: the imul instruction
   *      uses/defines both RAX and RDX, so "imulq vr10" is:
   *
   *      val vRAX = X86MachineInstruction.RAX.asVirtual();
   *      val vRDX = X86MachineInstruction.RDX.asVirtual();
   *
   *      AbsASM("imulq 'u0", List(vr10, RAX.asVirtual(), RDX.asVirtual()),
   *                          List(RAX.asVirtual(), RDX.asVirtual()));
   *
   *
   */
  override def devirtualize(absASM: ControlFlowGraph[List[AbsASMInstr]]): ControlFlowGraph[List[ASMInstr]] = {

    // take cfg with blocks containing lists and create one with each block having 1 instruction.
    val explodedAbsASM: ControlFlowGraph[AbsASMInstr] = ControlFlowGraph.explode(absASM, AbsASMComment("Empty Block"));

    // compute liveness info
    val liveness = new LiveVirtualRegisterAnalysis(explodedAbsASM);
    liveness.solve();

    // this is what you need to compute...
    val coloring = Map[VirtualRegister,PhysicalRegister]();

    explodedAbsASM.convert { x => List(x.contents.devirtualize(coloring)); }
  }
}
