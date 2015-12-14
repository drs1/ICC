package ic.asm

/**
 * This file contains case classes for a generic assembly code:
 *   -   ASMComment(comment: String)
 *   -   AbsASMOp(format: String, defines: List[VirtualRegister])
 */


/**
 * A Physical Register. This represents a register of the target machine.
 */
case class PhysicalRegister(val name: String) {
    override def toString() = { name }
   
    /**
     * convert this physical register to a virtual with the same name.
     * Useful in the register allocator.
     */
    def asVirtual() = VirtualRegister(name);

}

/**
 * Implicit method to convert one register to a list.
 */
object PhysicalRegister {
    implicit def PR2List(v: PhysicalRegister) = List(v);

}

/**
 * Superclass of all Assembly Instructions.
 */
abstract class ASMInstr(val comment : String);

/**
 * Comments in the concrete ASM.
 */
case class ASMComment(val lineComment: String) extends ASMInstr("") {
    override def toString() = String.format("# %s", lineComment.replace("\n", "\\n"));
}

/**
 * Analog of AbsASMOp.  See that class for details.  The only difference is that you
 * use Physical Registers here...
 */
case class ASMOp(val instr: String, override val comment : String) extends ASMInstr(comment) {
    override def toString() = instr;
}



object ASMOp {
    /*
     * Helper to convert a format with 'u* and 'd* into one with no
     * placeholders.
     * 
     * Use as:
     * 
     *     ASMOp("movq 'u0, 'd0", reg1, reg2, "comment");
     * 
     */
    def apply(format: String,
                 uses: List[PhysicalRegister] = Nil,
                 defines: List[PhysicalRegister] = Nil,
                 comment : String = "") : ASMOp = {
        var result = format;
        for (i <- 0 until uses.size) {
            result = result.replaceAll("'u" + i, uses(i).toString());
        }
        for (i <- 0 until defines.size) {
            result = result.replaceAll("'d" + i, defines(i).toString());
        }
        ASMOp(result, comment);
    }
}