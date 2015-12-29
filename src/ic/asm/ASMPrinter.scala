package ic.asm

import java.io.PrintWriter;

/**
 * Pretty printers for AbsASM and ASM instructions.  To print a list, eg:
 * 
 *   absASM foreach prettyPrint(_, out)
 * 
 */
object ASMPrinter {

    // how far to indent a comment instruction
    val COMMENT_INDENT = "    "
    
    // how far to indent a normal instr
    val OP_INDENT = COMMENT_INDENT + "   "

    // how far to indent a label
    val LABEL_INDENT = ""
    
    // how wide to make instr part
    val INSTR_WIDTH = 50

    def toString(a: AbsASMInstr): String = {
        val indent = a match {
            case AbsASMComment(c, _, _) => COMMENT_INDENT
            case AbsASMOp(format, uses, defines, comment) if (format.contains(":")) => LABEL_INDENT
            case AbsASMOp(format, uses, defines, comment) => OP_INDENT
            case AbsASMMove(_,_, _, _) |
                 AbsASMJump(_, _, _, _) => OP_INDENT
        }
        String.format("%-50s# %40s # %43s # %s", String.format("%s%s", indent, a), a.uses.mkString(","), a.defines.mkString(","), a.comment);
    }
    
    def absToString(a : Iterable[AbsASMInstr]): String = {
        String.format("\n%-50s# %40s # %43s # %s\n", "Instruction", "Uses", "Defs", "Comment") +
        (a.map(toString(_))).mkString("\n");
    }

    def toString(a: ASMInstr): String = {
        val indent = a match {
            case ASMComment(c)                         => COMMENT_INDENT
            case ASMOp(format, comment) if (format.contains(":")) => LABEL_INDENT
            case ASMOp(format, comment) => OP_INDENT
        }
        String.format("%-50s"+ ASMInstr.commentSequence + "%s", String.format("%s%s", indent, a), a.comment);
    }
    
     def asmToString(a : Iterable[ASMInstr]): String = {
        (a.map(toString(_))).mkString("\n");
    }

}
