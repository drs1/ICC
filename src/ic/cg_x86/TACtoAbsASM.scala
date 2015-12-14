package ic.cg_x86

import ic.tac._
import ic.ast._
import ic.asm._
import ic.error._
import java.io.PrintWriter
import scala.collection.mutable.Map
import X86MachineDescription._

/**
 * Based on code by Nathan Bricault & Ethan Gracer
 *
 * Convert TAC to Abstract Assembly code.
 */

class TACtoAbsASM() {

  /**
   * Convert list of TAC to AbsASM
   */
  def convert(list: List[TACInstr]): List[AbsASMInstr] = {
    list.flatMap(i => gen(i))
  }

  /**
   * Convert a single TAC instr to AbsASM
   */
  def convert(i: TACInstr): List[AbsASMInstr] = {
    gen(i)
  }


  /**
   * The virtual registers we need to name.
   */
  val vRAX = RAX.asVirtual();
  val vRDX = RDX.asVirtual();
  val vRDI = RDI.asVirtual();
  val vRSI = RSI.asVirtual();

  /**
   * All of the callee save registers get a virtual register.  We copy
   * the callee saves into them at the beginning of the method and
   * restore the callee saves right before exiting, so that
   * those virtual registers have very small live ranges.
   */
  val calleeVRs = X86MachineDescription.calleeSaveRegisters().map {
                x => (x.asVirtual(), VirtualRegister.alloc());
  }
  /* 
	 * These helpers all convert operands to virtual registers or asm fragments.
	 * There should be a better way to factor them to avoid the large number
	 * of cases.  
	 */

  private def mkAbsMove(use: TACOp, define: TACOp): AbsASMInstr = {
    mkAbsMove(use, opToVR(define));
  }

  private def mkAbsMove(use: TACOp, define: VirtualRegister): AbsASMInstr = {
    use match {
      case v: TAC_Temp => AbsASMMove("movq 'u0, 'd0", opToVR(use), define)
      case v: TAC_Var  => AbsASMMove("movq 'u0, 'd0", opToVR(use), define)
      case _           => AbsASMOp("movq " + opTo86(use) + ", 'd0", List(), define);
    }
  }

  private def mkAbsMove(use: VirtualRegister, define: VirtualRegister): AbsASMInstr = {
    AbsASMMove("movq 'u0, 'd0", use, define)
  }

  private def mkAbsOp(format: String, use: TACOp, define: TACOp): AbsASMInstr = {
    mkAbsOp(format, use, opToVR(define));
  }

  private def mkAbsOp(format: String, use: VirtualRegister, define: VirtualRegister): AbsASMInstr = {
    AbsASMOp(format, use, define)
  }

  private def mkAbsOp(format: String, use: TACOp, define: VirtualRegister): AbsASMInstr = {
    use match {
      case v: TAC_Temp => AbsASMOp(format, opToVR(use), define)
      case v: TAC_Var  => AbsASMOp(format, opToVR(use), define)
      case _           => AbsASMOp(format.replace("'u0", opTo86(use)), List(), define);
    }
  }

  private def mkAbsOpAndUseDef(format: String, use: TACOp, define: VirtualRegister): AbsASMInstr = {
    use match {
      case v: TAC_Temp => AbsASMOp(format, List(opToVR(use), define), define)
      case v: TAC_Var  => AbsASMOp(format, List(opToVR(use), define), define)
      case _           => AbsASMOp(format.replace("'u0", opTo86(use)), define, define);
    }
  }

  private def mkAbsOp(format: String, use: TACOp) = {
    use match {
      case v: TAC_Temp => AbsASMOp(format, opToVR(use), List())
      case v: TAC_Var  => AbsASMOp(format, opToVR(use), List())
      case _           => AbsASMOp(format.replace("'u0", opTo86(use)), List(), List());
    }
  }

  private def mkAbsOp(format: String, use: VirtualRegister) = {
    AbsASMOp(format, use, List())
  }

  implicit def instrToList(v: AbsASMInstr) = List(v);

  /*
	 * The big case switch for conversion...
	 */
  private def gen(instr: TACInstr): List[AbsASMInstr] = {
    AbsASMComment(instr.toString) ++
      {
        instr match {

          case i: TACCall_VirCall =>
            val offset = i.decl.offset * X86MachineDescription.sizeOfDataElement();

            // Push arguments onto stack in reverse order, so top element of the stack
            // is the implicit 'this', followed by the arguments in the order they
            // appear in the method declaration

              i.paramList.reverse.map(j => mkAbsOp("pushq 'u0", j)) ++
              mkAbsOp("pushq 'u0", i.receiver) ++
              {
                val vr1 = VirtualRegister.alloc();

                mkAbsMove(i.receiver, vr1) ++
                  mkAbsOp("movq ('u0), 'd0", vr1, vr1) ++
                  AbsASMOp("call *" + offset + "('u0)", vr1, X86MachineDescription.callerSaveRegisters().map { _.asVirtual() }) ++
                  AbsASMOp("addq $" + ( (1 + i.paramList.length) * X86MachineDescription.sizeOfDataElement()) + ", %rsp") ++   // extra 1 for "this'
                  (i.dst match {
                    case None    => List()
                    case Some(l) => mkAbsMove(vRAX, opToVR(l))
                  })
              } 

          case i: TACCall_LibCall =>
            val hasRetVal = i.store.isDefined
            val (uses, asm) =
            {
              i.params.length match {
                case 0 => (Nil, Nil)
                case 1 => (List(vRDI), List(mkAbsMove(i.params(0), vRDI)))
                case 2 => (List(vRDI,vRSI), mkAbsMove(i.params(0), vRDI) ++
                  mkAbsMove(i.params(1), vRSI))
              }
            }
            asm ++
              AbsASMOp("call __LIB_" + i.op, uses, X86MachineDescription.callerSaveRegisters().map { _.asVirtual() }) ++
              (if (hasRetVal) List(mkAbsMove(vRAX, opToVR(i.store.get))) else Nil)

          case i: ic.tac.TAC_Label =>
            AbsASMOp(i.label + ":")

          case i @ TAC_Preamble(formals, _) => 
             AbsASMComment("Fake Def of all callee save registers", Nil, calleeSaveRegisters().map { _.asVirtual() }) ++
             calleeVRs.map( { case (x,y) => mkAbsMove(x,y) }) ++ 
             AbsASMOp("movq " + 16 + "(%rbp), 'd0", Nil, VirtualRegister("this")) ++
             formals.flatMap(x => AbsASMOp("movq " + (x.offset * X86MachineDescription.sizeOfDataElement()) + "(%rbp), 'd0", Nil, VirtualRegister(x)));

          case i: ic.tac.TAComment =>
            AbsASMComment(i.comment)

          case i: TAC_RET =>
            val (uses, asm) = (i.value match {
                case None => (Nil, Nil)
                case Some(r) =>
                  (List(vRAX), List(mkAbsMove(r, vRAX)))
              }) 
	      asm ++
              calleeVRs.map( { case (x,y) => mkAbsMove(y, x) }) ++  // write back all callee save values
              AbsASMComment("Fake Use of all callee save registers", calleeSaveRegisters().map { _.asVirtual() } ++ uses, Nil) ++
              AbsASMOp("movq %rbp, %rsp") ++
              AbsASMOp("popq %rbp") ++
              AbsASMOp("ret") 

          case i: TAC_NewClass =>
            //Perform library call to allocate the object
            val size = i.decl.size * X86MachineDescription.sizeOfDataElement();
            val vrVT = VirtualRegister.alloc();
            val vrObj = VirtualRegister(i.dst);
            gen(new TACCall_LibCall(Some(i.dst), "allocateObject", List(new TAC_Lit(ASTLiteralInt(size, i.line), i.line, "")), i.line, "")) ++
              //Assign vtable ptr into first memory location 
              AbsASMOp("\tleaq _" + i.decl.cls_id + "_VT('u0), 'd0", VirtualRegister.virtualPC, vrVT) ++
              AbsASMOp("movq 'u0, ('u1)", List(vrVT, vrObj), Nil)

          //                    case i: TACAllocArray =>
          //                        gen(new TACLibCall(i.location, "allocateArray", List(i.size), ""))

          case i @ TAC_Length(dst, array, line, comment) =>
            val vr = VirtualRegister.alloc();
            mkAbsMove(array, vr) ++
              mkAbsOp("movq -8('u0), 'd0", vr, opToVR(dst))

          case i @ TAC_CJump(label, condition, line, comment) =>
            val cond = VirtualRegister.alloc();
            mkAbsMove(condition, cond) ++
              mkAbsOp("testq $1, 'u0", cond) ++
              AbsASMJump("jne   " + i.label.label)

          case i: ic.tac.TAC_Jump =>
            AbsASMJump("jmp  " + i.label.label)

          case i: ic.tac.TAC_NullCheck =>
            val obj = VirtualRegister.alloc();
            mkAbsMove(i.oject, obj) ++
              mkAbsOp("cmpq $0, 'u0", obj) ++
              AbsASMJump("je labelNullPtrError");

          case i: ic.tac.TAC_DivBy0 =>
            val vVR = VirtualRegister.alloc();
            mkAbsMove(i.divisor, vVR) ++
              mkAbsOp("cmpq $0, 'u0", vVR) ++
              AbsASMJump("je labelDivByZeroError");

          case i: ic.tac.TAC_IndexInBounds =>
            val index = VirtualRegister.alloc();
            mkAbsMove(i.index, index) ++
              mkAbsOp("cmpq $0, 'u0", index) ++ {
                AbsASMJump("jl labelArrayBoundsError") ++
                  {
                    val vr = VirtualRegister.alloc();
                    mkAbsMove(i.array, vr) ++
                      mkAbsOp("movq -" + X86MachineDescription.sizeOfDataElement() + "('u0), 'd0", vr, vr) ++
                      AbsASMOp("cmpq 'u0, 'u1", List(index, vr)) ++
                      AbsASMJump("jle labelArrayBoundsError")
                  }
              }

          case TAC_GreaterThan0(index: TACOp, line: Int, comment: String) => {
              val vrIndex = VirtualRegister.alloc();
              mkAbsMove(index, vrIndex) ++
              mkAbsOp("cmpq $0, 'u0", vrIndex) ++
              AbsASMJump("jl labelArraySizeError")
          }

          case i @ TAC_BinOp(dst, lExpr, rExpr, binop, line, comment) =>
            binop match {
              case o: ic.ast.BinEqeq => buildComparison(dst, lExpr, rExpr, binop)
              case o: ic.ast.BinNe   => buildComparison(dst, lExpr, rExpr, binop)
              case o: ic.ast.BinLt   => buildComparison(dst, lExpr, rExpr, binop)
              case o: ic.ast.BinLe   => buildComparison(dst, lExpr, rExpr, binop)
              case o: ic.ast.BinGt   => buildComparison(dst, lExpr, rExpr, binop)
              case o: ic.ast.BinGe   => buildComparison(dst, lExpr, rExpr, binop)
              case o: ic.ast.BinPlus =>
                mkAbsMove(lExpr, dst) ++
                  mkAbsOpAndUseDef("addq 'u0, 'd0", rExpr, opToVR(dst))

              case o: ic.ast.BinMinus =>
                mkAbsMove(lExpr, dst) ++
                  mkAbsOpAndUseDef("subq 'u0, 'd0", rExpr, opToVR(dst))

              case o: ic.ast.BinMult =>
                  mkAbsMove(lExpr, vRAX) ++
                  AbsASMOp("cqto", List(vRAX), List(vRDX)) ++ {
                    val vr = VirtualRegister.alloc();
                    mkAbsMove(rExpr, vr) ++
                      AbsASMOp("imulq 'u0", List(vr, vRAX,vRDX), List(vRAX,vRDX)) ++
                      mkAbsMove(vRAX, opToVR(dst))
                  }

              case o: ic.ast.BinDiv =>
                  mkAbsMove(lExpr, vRAX) ++
                  AbsASMOp("cqto", List(vRAX), List(vRAX,vRDX)) ++ {
                    val vr = VirtualRegister.alloc();
                    mkAbsMove(rExpr, vr) ++
                      AbsASMOp("idivq 'u0", List(vr,vRAX,vRDX), List(vRAX,vRDX)) ++
                      mkAbsMove(vRAX, opToVR(dst))
                  }

              case o: ic.ast.BinMod =>
                  mkAbsMove(lExpr, vRAX) ++
                  AbsASMOp("cqto", List(vRAX), List(vRAX,vRDX)) ++ {
                    val vr = VirtualRegister.alloc();
                    mkAbsMove(rExpr, vr) ++
                      AbsASMOp("idivq 'u0", List(vr,vRAX,vRDX), List(vRAX,vRDX)) ++
                      mkAbsMove(vRDX, opToVR(dst))
                  }
	    }
          case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) => {
            unop match {
              case UnNeg() => {
                val vr = opToVR(dst);
                AbsASMOp("movq $0, 'd0", Nil, vr) ++
                  mkAbsOpAndUseDef("subq 'u0, 'd0", expr, vr);
              }
              case UnNot() => {
                val vr = opToVR(dst);
                AbsASMOp("movq $1, 'd0", Nil, vr) ++
                  mkAbsOpAndUseDef("subq 'u0, 'd0", expr, vr);
              }
            }
          }

          case i: TAC_Copy =>
            mkAbsMove(i.src, i.dst)

          case i: TAC_ArrayLoad =>
            val vrArray = VirtualRegister.alloc();
            val vrIndex = VirtualRegister.alloc();
            mkAbsMove(i.array, vrArray) ++
              mkAbsMove(i.index, vrIndex) ++
              AbsASMOp("movq ('u0, 'u1, " + X86MachineDescription.sizeOfDataElement() + "), 'd0", List(vrArray, vrIndex), opToVR(i.dst))

          case i: TAC_ArrayStore =>
            val vrArray = VirtualRegister.alloc();
            val vrIndex = VirtualRegister.alloc();
            val vrValue = VirtualRegister.alloc();
            mkAbsMove(i.value, vrValue) ++
              mkAbsMove(i.array, vrArray) ++
              mkAbsMove(i.index, vrIndex) ++
              AbsASMOp("movq 'u2, ('u0, 'u1, " + X86MachineDescription.sizeOfDataElement() + ")", List(vrArray, vrIndex, vrValue))

          case i: TAC_FieldLoad =>
            val vrObj = VirtualRegister.alloc();
            mkAbsMove(i.receiver, vrObj) ++
              mkAbsOp("movq " + (i.field.offset * X86MachineDescription.sizeOfDataElement()) + "('u0), 'd0", vrObj, opToVR(i.dst));

          case i: TAC_FieldStore =>
            val vrObj = VirtualRegister.alloc();
            val vrValue = VirtualRegister.alloc();
            mkAbsMove(i.receiver, vrObj) ++
              mkAbsMove(i.value, vrValue) ++
              AbsASMOp("movq 'u1, " + (i.field.offset * X86MachineDescription.sizeOfDataElement()) + "('u0)", List(vrObj, vrValue), Nil);
        }
      }
  }

  /* ************ Helper Methods ************* */

  private def opTo86(op: TACOp): String = {
    op match {
      case TAC_Lit(ic.ast.ASTLiteralInt(c, _), _, _)      => "$" + c
      case TAC_Lit(ic.ast.ASTLiteralBool(true, _), _, _)  => "$1"
      case TAC_Lit(ic.ast.ASTLiteralBool(false, _), _, _) => "$0"
      case TAC_Lit(ic.ast.ASTLiteralNull(_),_,_) => "$0"
      case v: TAC_Var =>
        // Formals & local vars just use their offset from %rbp
        (v.decl.offset * X86MachineDescription.sizeOfDataElement()) + "(%rbp)"

      case TAC_Lit(ic.ast.ASTLiteralString(s, _), _, _) =>
        CodeGenerator.stringConstantsToLabel.getOrElse(
          s, CodeGenerator.labelForStringConstant(s)) + "(%rip)"
    }
  }

  private def opToVR(op: TACOp): VirtualRegister = {
    op match {
      case v: TAC_Var  => VirtualRegister(v.decl.id)
      case v: TAC_Temp => VirtualRegister("_t" + v.name)
    }
  }

  private def buildComparison(dst: TACOp, left: TACOp, right: TACOp, op: ic.ast.ASTBinOp) = {
    val vrLeft = VirtualRegister.alloc();
    val vrRight = VirtualRegister.alloc();
    mkAbsMove(right, vrRight) ++
      mkAbsMove(left, vrLeft) ++
      AbsASMOp("cmpq 'u0, 'u1", List(vrLeft, vrRight), Nil) ++
      AbsASMOp("movq $0, 'd0", Nil, vRAX) ++
      {
        val instr = op match {
          case o: ic.ast.BinEqeq => "sete"
          case o: ic.ast.BinNe   => "setne"
          case o: ic.ast.BinLt   => "setg"
          case o: ic.ast.BinLe   => "setge"
          case o: ic.ast.BinGt   => "setl"
          case o: ic.ast.BinGe   => "setle"
        }
        AbsASMOp(instr + " %al", vRAX, vRAX)
      } ++
      mkAbsMove(vRAX, opToVR(dst))
  }
}
