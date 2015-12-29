package ic.asm

import ic.tac._;
import ic.ast._;


/**
 * This file contains case classes for abstract assembly:
 *   -   AbsASMComment(comment: String, uses: List[VirtualRegister], defines: List[VirtualRegister])
 *         (This can def/use virtual registers to give the reg. allocator information
 *          about register live ranges.)
 *     -   AbsASMMove(src: VirtualRegister, dst: VirtualRegister)
 *     -   AbsASMOp(format: String, uses: List[VirtualRegister], defines: List[VirtualRegister])
 *     -   AbsASMJump(format: String, uses: List[VirtualRegister], defines: List[VirtualRegister])
 *  
 *     See comments below for full description.  A few notes:
 *     - Always use the apply method in VirtualRegister to convert TAC names to VirtualRegister names
 * 
 */ 


/*
 * Represents a register in the virtual ASM.
 */
case class VirtualRegister(val name: String) {
    override def toString() = name;
}

/*
 * Virtual registers for the fixed physical registers, and some implicit conversions.
 */
object VirtualRegister {
    /**
     * Constant representing RBP as a virtual register. You can use this in the
     * Abstract Assembly to refer to the frame pointer.
     */
    val virtualFP = new VirtualRegister("vFP");

    /**
     * Constant representing RIP as a virtual register. You can use this in the
     * Abstract Assembly to refer to the instruction pointer.
     */
    val virtualPC = new VirtualRegister("vPC");

    implicit def VR2List(v: VirtualRegister) = List(v);

    /**
     * Convert a TACOp to a Virtual Register.  Use this to ensure consistency
     * in virtual register naming conventions.
     */
    def apply(v: TACOp): VirtualRegister = {
        v match {
            case y: TAC_Temp => VirtualRegister("_t" + y.name);
            case y: TAC_Var => VirtualRegister(y.decl.id);
        };
    }

    /**
     * Convert a Formal declaration to a Virtual Register.  
     * Use this to ensure consistency
     * in virtual register naming conventions.
     */
    def apply(v: ASTVarDecl): VirtualRegister = {
        VirtualRegister(v.id)
    }

    var count: Int = 0;

    /**
     * Allocate a new fresh Virtual Register with a consistent name
     */
    def alloc() = {
        count = count + 1;
        VirtualRegister("_vr" + count);
    }

}

/**
 * Super class of all Abstract Assembly Instructions.
 * @param uses - list of Virtual Registers used by this instruction
 * @param defines - list of Virtual Registers defined or assigned to by this instruction
 */
abstract class AbsASMInstr(val uses: List[VirtualRegister],
                           val defines: List[VirtualRegister],
                           val comment : String) {

    /**
     * Use the register mapping provided by the allocator to construct
     * a Concrete Assembly Instruction from the Abstract Instruction.
     */
    def devirtualize(regMap: Map[VirtualRegister, PhysicalRegister]): ASMInstr;

}

/**
 * A comment instruction to permit annotations in the ASM.
 */
case class AbsASMComment(val lineComment: String, override val uses: List[VirtualRegister] = Nil, override val defines: List[VirtualRegister] = Nil)
        extends AbsASMInstr(uses, defines, "") {
    override def toString() = String.format("%s", lineComment.replace("\n", "\\n"));
    override def devirtualize(regMap: Map[VirtualRegister, PhysicalRegister]): ASMInstr =
        ASMComment(lineComment);
}



/**
 * Represents most Abstract Assembly instructions using a format string.
 * Following Appel, it should have the form like "addq 'u0, 'd0". The first
 * entry in uses will replace 'u0, the second will replace 'u1, and so on. The
 * first entry in defines will replace 'd0, and so on. Note that if a register
 * is both used and define, you need to include in BOTH lists. So, you will
 * often create instructions like:
 *
 * <pre>
 * new AbsASMOp("addq 'u0, 'd0", List(v1, v2), List(v2));
 * </pre>
 *
 * To represent <pre>v2 = v1 + v2</pre>.
 */
case class AbsASMOp(val format: String,
                    override val uses: List[VirtualRegister] = Nil,
                    override val defines: List[VirtualRegister] = Nil,
                    override val comment : String = "")
        extends AbsASMInstr(uses, defines, comment) {

    override def toString() = {
        var result = format;
        for (i <- 0 until uses.size) {
            result = result.replaceAll("'u" + i, uses(i).toString());
        }
        for (i <- 0 until defines.size) {
            result = result.replaceAll("'d" + i, defines(i).toString());
        }
        result;
    }

    override def devirtualize(regMap: Map[VirtualRegister, PhysicalRegister]): ASMInstr = {
        val pUses = uses map (regMap(_));
        val pDefs = defines map (regMap(_));
        ASMOp(format, pUses, pDefs, this.toString());
    }
}

/**
 * An abstract assembly instruction for moving values from
 * one virtual register to another.  Same as
 * AbsASMOp, but use this when you know you are moving
 * between virtual registers so that the register allocator
 * has that info.
 */
case class AbsASMMove(val format : String, val src: VirtualRegister, val dst: VirtualRegister, override val comment : String = "")
        extends AbsASMInstr(List(src), List(dst), comment) {
    override def toString() = {
        format.replace("'u0", src.toString()).replace("'d0", dst.toString());
    }
    override def devirtualize(regMap: Map[VirtualRegister, PhysicalRegister]): ASMInstr = {
     val (pSrc, pDst) = (regMap(src), regMap(dst));
     if (pSrc == pDst) {
       ASMComment("Redundant Move: " + this.toString() + " on " + pSrc);
     } else {
       ASMOp(format, pSrc, pDst, this.toString());
     }
    }
}


/**
 * Represents jump instructions using a format string.
 * Same representation as normal ops.  This is needed because
 * register allocators often need to know whether an instruction
 * can end a block (and thus insert spill code right before the branch...).
 */
case class AbsASMJump(val format: String,
                      override val uses: List[VirtualRegister] = Nil,
                      override val defines: List[VirtualRegister] = Nil,
                    override val comment : String = "")
        extends AbsASMInstr(uses, defines, comment) {

    override def toString() = {
        var result = format;
        for (i <- 0 until uses.size) {
            result = result.replaceAll("'u" + i, uses(i).toString());
        }
        for (i <- 0 until defines.size) {
            result = result.replaceAll("'d" + i, defines(i).toString());
        }
        result;
    }

    override def devirtualize(regMap: Map[VirtualRegister, PhysicalRegister]): ASMInstr = {
        val pUses = uses map (regMap(_));
        val pDefs = defines map (regMap(_));
        ASMOp(format, pUses, pDefs, this.toString());
    }
}


