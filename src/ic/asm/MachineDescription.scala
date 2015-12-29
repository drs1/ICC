package ic.asm

/**
 * A MachineDescription captures all HW-specific traits.  We factor
 * them out into a single class so that our abstract assembly, assembly, and register
 * allocators are all HW independent.
 *
 * You should create a subclass of MachineDescription for each
 * architecture.  See X86MachineDescription for an example.
 */
abstract class MachineDescription {
  
  
    def commentChar(): String;

    /************* Physical Registers ***********/
    
    /** The physical register used to hold the program counter */
    def PC(): PhysicalRegister;

    /** The physical register used to hold the frame pointer */
    def FP(): PhysicalRegister;

    /**
     * All registers that may be used by a register allocator.  This must
     * not include PC or FP.
     */
    def assignableRegisters(): List[PhysicalRegister] = {
      var result = callerSaveRegisters() ++ calleeSaveRegisters()
      result.filter(x => !preColoredRegisters().contains(x))
    }

    /**
     * All caller/callee save registers.  
     */
    def callerSaveRegisters(): List[PhysicalRegister];
    def calleeSaveRegisters(): List[PhysicalRegister];
    def preColoredRegisters(): List[PhysicalRegister];


    /************* Stack Slots for Locals ***********/
    
    /**
     * The first offset from the frame pointer that can be used to store 
     * a local value.  Eg, -8 on x86.  The "free pointer" starts at this
     * offset and is changed by offsetDelta() each time a temporary is
     * allocated by the register allocator.
     */
    def firstAvailableOffsetForLocals(): Int;

    /**
     * The first offset from the frame pointer that can be used to store 
     * a parameter value, including the self refence.  Eg, 16 on x86.  
     */
    def firstAvailableOffsetForParameters(): Int;
    
    /**
     * The size of all pointer and integer values.  Eg, 8 on an x86.  This
     * is also used for the size of fields and vtable entries.
     */    
    def sizeOfDataElement(): Int;
    

    
    /************* Create instructions to move to/from the stack ***********/
    
    /*
     * These are used in the register allocator when it must spill registers
     * or save/restore values on the stack.
     */
    
    /**
     * Return an instruction that loads a value from the stack, using the given
     * offset from the frame pointer.  Store the value in dst. 
     */
    def copyFromStack(offsetFromFP: Int, dst: PhysicalRegister, comment: String): ASMInstr;
    
    /**
     * Return an instruction that stores a value on the stack, using the given
     * offset from the frame pointer.  The value is read from src.
     */
    def copyToStack(src: PhysicalRegister, offsetFromFP: Int, comment: String): ASMInstr;

        /**
     * Return an instruction that stores a value on the stack, using the given
     * offset from the frame pointer.  The value is read from src.
     */
    def copyToReg(src: PhysicalRegister, dst : PhysicalRegister, comment: String): ASMInstr;

    
    /** Same as previous, but for abstract assembly.  Both may be useful. */
    def copyFromStack(offsetFromFP: Int, dst: VirtualRegister, comment : String): AbsASMInstr;
    def copyToStack(src: VirtualRegister, offsetFromFP: Int, comment : String): AbsASMInstr;

}