package ic.asm.cfg

import ic.asm._

/*
 * Live Virtual register analysis for CFG[List[AbsASMInstr]].
 */
class LiveVirtualRegisterAnalysis(override val cfg: ControlFlowGraph[AbsASMInstr]) extends DataFlowAnalysis[AbsASMInstr, Set[VirtualRegister]](cfg) {
   
    override def boundary() = Set[VirtualRegister]();
    override def top() = Set[VirtualRegister]();
    override def equals(t1: Set[VirtualRegister], t2: Set[VirtualRegister]): Boolean = t1 == t2;
    override def isForward() = false;
    override def meet(t1: Set[VirtualRegister], t2: Set[VirtualRegister]): Set[VirtualRegister] = t1 ++ t2;

    override def transfer(instr: AbsASMInstr, out: Set[VirtualRegister]): Set[VirtualRegister] = { 
        val x = instr;
        (out -- x.defines) ++ x.uses;
    }

}


