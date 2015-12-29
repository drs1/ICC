package ic.cg_x86

import ic.asm._

/**
 * X86-Specific details.
 */
object X86MachineDescription extends MachineDescription {

    /* All the physical registers: */
    val RAX = new PhysicalRegister("%rax");
    val RBX = new PhysicalRegister("%rbx");
    val RCX = new PhysicalRegister("%rcx");
    val RDX = new PhysicalRegister("%rdx");
    val RSI = new PhysicalRegister("%rsi");
    val RDI = new PhysicalRegister("%rdi");
    val RBP = new PhysicalRegister("%rbp");
    val RSP = new PhysicalRegister("%rsp");
    val R8 = new PhysicalRegister("%r8");
    val R9 = new PhysicalRegister("%r9");
    val R10 = new PhysicalRegister("%r10");
    val R11 = new PhysicalRegister("%r11");
    val R12 = new PhysicalRegister("%r12");
    val R13 = new PhysicalRegister("%r13");
    val R14 = new PhysicalRegister("%r14");
    val R15 = new PhysicalRegister("%r15");
    val RIP = new PhysicalRegister("%rip");

    def PC(): PhysicalRegister = RIP;
    def FP(): PhysicalRegister = RBP;
    
    // leave of RIP and RBP!  Also, put funny regs RAX-RDI last so they are not used
    // as often...
    def callerSaveRegisters(): List[PhysicalRegister] =
        List[PhysicalRegister](R8, R9, R10, R11, RAX, RCX, RDX, RSI, RDI);

    def calleeSaveRegisters(): List[PhysicalRegister] =
        List[PhysicalRegister](R12, R13, R14, R15, RBX);
    
    //precolored: rax rdx rsi rdi
    def preColoredRegisters(): List[PhysicalRegister] =
        List[PhysicalRegister]();
      

        
    def firstAvailableOffsetForLocals(): Int = -8;
    def firstAvailableOffsetForParameters(): Int = 16;
    def sizeOfDataElement(): Int = 8;
    
    def commentChar() = "#"
    
    /*
     * Standard movq instructions with frame-relative offets.  Both abstract and actual ASM
     * versions included --- not sure which will be more useful...
     */
    def copyFromStack(offsetFromFP: Int, dst: PhysicalRegister, comment : String): ASMInstr = {
        ASMOp("movq " + offsetFromFP + "(" + FP() + "), 'd0", Nil, dst, comment);
    }
    
    def copyToStack(src: PhysicalRegister, offsetFromFP: Int, comment : String): ASMInstr = {
        ASMOp("movq 'u0, " + offsetFromFP + "(" + FP() + ")", src, Nil, comment);
    }

    def copyToReg(src: PhysicalRegister, dst: PhysicalRegister, comment : String): ASMInstr = {
        ASMOp("movq 'u0, 'd0", src, dst, comment);
    }

    def copyFromStack(offsetFromFP: Int, dst: VirtualRegister, comment : String): AbsASMInstr = {
        AbsASMOp("movq " + offsetFromFP + "(" + FP() + "), 'd0", Nil, dst, comment);
    }
    
    def copyToStack(src: VirtualRegister, offsetFromFP: Int, comment : String): AbsASMInstr = {
        AbsASMOp("movq 'u0, " + offsetFromFP + "(" + FP() + ")", src, Nil, comment);
    }


}