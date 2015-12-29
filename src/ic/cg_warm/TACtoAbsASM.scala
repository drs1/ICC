package ic.cg_warm

import ic.tac._
import ic.ast._
import ic.asm._
import ic.error._
import java.io.PrintWriter
import scala.collection.mutable.Map
import WARMMachineDescription._

class TACtoAbsASM() {
  
  def convert(list: List[TACInstr]) :List[AbsASMInstr] = {
    list.flatMap(i => gen(i))    
  }
  
  def convert(i: TACInstr): List[AbsASMInstr] = {
    gen(i);
  }
  
  val vBP = BP.asVirtual();
  val vLR = LR.asVirtual();
  val vR0 = R0.asVirtual();
  val vR1 = R1.asVirtual();
  
  val calleeVRs = WARMMachineDescription.calleeSaveRegisters. map {
              x => (x.asVirtual(), VirtualRegister.alloc());
  }
  

//---------------- HELPERS -----------------------------  
    
  private def mkAbsMove(use: TACOp, define: VirtualRegister): AbsASMInstr = {
    use match {
      case v: TAC_Temp => AbsASMMove("mov    'd0, 'u0", opToVR(use), define)
      case v: TAC_Var  => AbsASMMove("mov    'd0, 'u0", opToVR(use), define)
      case l: TAC_Lit  => {
        l.lit_node match {
          case ls: ASTLiteralString =>{
            AbsASMOp("adr      'd0, " + opToARM(use) , List(), define)
          }
          case _ =>{
            AbsASMOp("mov      'd0," + opToARM(use) , List(), define);
          }
        }
      }
    }
  }
  
  private def mkAbsMove(src: TACOp, dst: TACOp) : AbsASMInstr = {
    src match{
      case t: TAC_Temp => AbsASMMove("mov    'd0, 'u0", opToVR(src), opToVR(dst));
      case v: TAC_Var  => AbsASMMove("mov    'd0, 'u0", opToVR(src), opToVR(dst));
      case l: TAC_Lit  => {
        l.lit_node match {
          case ls: ASTLiteralString =>{
            AbsASMOp("adr      'd0, " + opToARM(src) , List(), opToVR(dst))
          }
          case _ => AbsASMOp("mov    'd0, " + opToARM(src), List(), opToVR(dst))
        }
      }
    }
  }
  
  private def mkAbsMove(src: VirtualRegister, dst: VirtualRegister): AbsASMInstr = {
    AbsASMMove("mov    'd0, 'u0", src, dst);
  }
  
  //unops with TACOp
  private def mkAbsOp(format: String, src: TACOp) = {
    src match{
      case t: TAC_Temp   => AbsASMOp(format, opToVR(src), List())
      case v: TAC_Var    => AbsASMOp(format, opToVR(src), List())
      case l: TAC_Lit    => AbsASMOp(format.replace("'u0", opToARM(src)), List(), List());
    }
  }
  
  private def mkAbsOp(format: String, use: TACOp, define: TACOp): AbsASMInstr = {
    mkAbsOp(format, use, opToVR(define));
  }
  
  private def mkAbsOp(format: String, use: VirtualRegister, define: VirtualRegister): AbsASMInstr = {
    AbsASMOp(format, use, define);
  }
  
  private def mkAbsOp(format: String, use: TACOp, define: VirtualRegister): AbsASMInstr = {
    use match{
      case t: TAC_Temp   => AbsASMOp(format, List(opToVR(use), define), define)
      case v: TAC_Var    => AbsASMOp(format, List(opToVR(use), define), define)
      case _             => AbsASMOp(format.replace("'u0", opToARM(use)), define, define);
    }
  }
  
  private def mkAbsOp(format: String, left: VirtualRegister, right: TACOp, define: VirtualRegister): AbsASMInstr = {
    right match {
      case v: TAC_Temp => AbsASMOp(format, List(left,opToVR(right)), define)
      case v: TAC_Var  => AbsASMOp(format, List(left, opToVR(right)), define)
      case _           => AbsASMOp(format.replace("'u1", opToARM(right)), left, define);
    }
  }
  
  //unop with vregsister
  private def mkAbsOp(format: String, src: VirtualRegister) = {
    AbsASMOp(format, src, List())
  }
    
  //HELPER FOR LISTS SO WE CAN USE ++
  implicit def instrToList(v: AbsASMInstr) = List(v)
   
  private def opToVR(op: TACOp): VirtualRegister = {
    op match{
      case v: TAC_Var => VirtualRegister(v.decl.id)
      case t: TAC_Temp => VirtualRegister("_t" + t.name)
    }
  }
  
  private def opToARM(op: TACOp): String = {
    op match{
      case TAC_Lit(ASTLiteralInt(c, _), _, _ )     => "#" + c;
      case TAC_Lit(ASTLiteralBool(true, _),_,_)    => "#1"
      case TAC_Lit(ASTLiteralBool(false, _),_,_)    => "#0"        
      case TAC_Lit(ASTLiteralNull(_),_,_)    => "#0"
        
      case v: TAC_Var =>
        (v.decl.offset * WARMMachineDescription.sizeOfDataElement()) + ""
      case TAC_Lit(ASTLiteralString(s, _), _, _) =>
        CodeGenerator.stringConstantsToLabel.getOrElse(
            s, CodeGenerator.labelForStringConstant(s))
        
    }
  }
  
  
  //t0 = n GT 0 
  private def buildComparison(dst: TACOp, left: TACOp, right: TACOp, op: ASTBinOp) ={
    val vrLeft = VirtualRegister.alloc();
    val vrRight = VirtualRegister.alloc();
    
    mkAbsMove(right, vrRight)++
    mkAbsMove(left, vrLeft)++        
    AbsASMOp("cmp    'u0, 'u1", List(vrLeft, vrRight), Nil)++
    AbsASMOp("mov    'd0, #0", Nil, vR0)++        
    {
      val instr = op match{
        case o: BinEqeq => "moveq"
        case o: BinNe   => "movne"
        case o: BinLt   => "movlt"
        case o: BinLe   => "movle"
        case o: BinGt   => "movgt"
        case o: BinGe   => "movge"
      }
      AbsASMOp(instr + "    'u0, #1", vR0, vR0)      
    }++
    mkAbsMove(vR0, opToVR(dst));
  }
  
  
  // THE MONEYMAKER
  
  private def gen(instr: TACInstr): List[AbsASMInstr] = {
    AbsASMComment(instr.toString) ++ 
      {
      instr match{
        
        case vc: TACCall_VirCall => {
            val offset = vc.decl.offset * WARMMachineDescription.sizeOfDataElement();
          
            val vr = VirtualRegister.alloc();
            vc.paramList.reverse.flatMap(p  => {mkAbsMove(p, vr) ++ mkAbsOp("stu    'u0, [sp, #-1]", vr) }) ++
            mkAbsOp("stu    'u0, [sp, #-1]", vc.receiver) ++ 
            {
                val vrObj = VirtualRegister.alloc();

                mkAbsOp("mov     r1, 'u0", vc.receiver) ++
//                mkAbsMove(vc.receiver, vrObj) ++
                AbsASMOp("add    lr, pc, #4", Nil, Nil)++
                AbsASMOp("ldr    r1, [r1]")++ 
                AbsASMOp("ldr    r1, [r1, #" + offset + "]")++
                AbsASMOp("mov    pc, r1", Nil, WARMMachineDescription.callerSaveRegisters().map { _.asVirtual() })++
                AbsASMOp("add    sp, sp, #" + ( (1 + vc.paramList.length) * WARMMachineDescription.sizeOfDataElement())) ++   // extra 1 for "this'
                (vc.dst match {
                    case None    => List()
                    case Some(l) => mkAbsMove(vR0, opToVR(l))
                })
            } 
         }
        
        case lc: TACCall_LibCall => {
          val hasRetVal = lc.store.isDefined
          val (uses, asm) =
          {
              lc.params.length match {
                  case 0 => (Nil, Nil)
                  case 1 => (List(vR0), List(mkAbsMove(lc.params(0), vR0)))
                  case 2 => (List(vR0,vR1), mkAbsMove(lc.params(0), vR0) ++
                  mkAbsMove(lc.params(1), vR0))
              }
            }
            asm ++
            AbsASMOp("bl LIB" + lc.op.capitalize, uses, WARMMachineDescription.callerSaveRegisters().map { _.asVirtual() }) ++
            (if (hasRetVal) List(mkAbsMove(vR0, opToVR(lc.store.get))) else Nil)
        }
        
        case c: TAC_Copy => {
          mkAbsMove(c.src, c.dst)
        }
        
        case l: TAC_Label => AbsASMOp(l.label + ":");
        case j: TAC_Jump  => AbsASMJump("b    " + j.label.label);
        
        case cj @ TAC_CJump(label, cond, _, _) => {
          println(cond);
          val c = VirtualRegister.alloc()
          
          mkAbsMove(cond, c)++
          mkAbsOp("tst    'u0, #1", cond)++
          AbsASMJump("bne    " + label.label);
        }
        
        case c: TAComment => AbsASMComment(c.comment);
        case b @ TAC_BinOp(dst, lexpr, rexpr, binop, line, comment) => 
          binop match{
            // add   d0, u0, u1
            case BinPlus() => {
              val lvr = VirtualRegister.alloc();
              mkAbsMove(lexpr, lvr) ++
              mkAbsOp("add    'd0, 'u0, 'u1", lvr, rexpr, opToVR(dst));
            }
            
            case BinMinus() => {
              val lvr = VirtualRegister.alloc();
              mkAbsMove(lexpr, lvr) ++
              mkAbsOp("sub    'd0, 'u0, 'u1", lvr, rexpr, opToVR(dst));
            }
            
            case BinMult() => {
              val lvr = VirtualRegister.alloc();
              mkAbsMove(lexpr, lvr) ++
              mkAbsOp("mul    'd0, 'u0, 'u1", lvr, rexpr, opToVR(dst));
            }
            
            case BinDiv() => {
              val lvr = VirtualRegister.alloc()
              mkAbsMove(lexpr, lvr) ++
              mkAbsOp("div    'd0, 'u0, 'u1", lvr, rexpr, opToVR(dst));
            }
            case c: BinEqeq => buildComparison(dst, lexpr, rexpr, binop)
            case c: BinNe   => buildComparison(dst, lexpr, rexpr, binop)
            case c: BinLt   => buildComparison(dst, lexpr, rexpr, binop)
            case c: BinLe   => buildComparison(dst, lexpr, rexpr, binop)
            case c: BinGt   => buildComparison(dst, lexpr, rexpr, binop)
            case c: BinGe   => buildComparison(dst, lexpr, rexpr, binop)
          }
          
        case TAC_Preamble(formals, _) => 
             AbsASMComment("Fake Def of all callee save registers", Nil, calleeSaveRegisters().map { _.asVirtual() }) ++
             calleeVRs.map( { case(x,y) => mkAbsMove(x,y) }) ++
             AbsASMOp("ldr    'd0, [fp, #2]", Nil, VirtualRegister("this")) ++
             formals.flatMap(x => AbsASMOp("ldr    'd0, [fp, #" + (x.offset * WARMMachineDescription.sizeOfDataElement()) + "]", Nil, VirtualRegister(x)));  

        case r: TAC_RET => {
          val (uses, asm) = (
              r.value match{
                case None => (Nil, Nil)
                case Some(v) =>
                  (List(vR0), List(mkAbsMove(v, vR0)))
              })
              asm ++
              calleeVRs.map( { case (x,y) => mkAbsMove(y, x) }) ++  // write back all callee save values
              AbsASMComment("Fake Use of all callee save registers", calleeSaveRegisters().map { _.asVirtual() } ++ uses, Nil) ++
          AbsASMOp("mov    sp, fp", Nil, Nil)++
          AbsASMOp("ldu    fp, [sp, #1]", Nil, Nil)++
          AbsASMOp("ldu    pc, [sp, #1]", Nil, Nil);
        }
        
        case l @ TAC_Length(dst, array, line, comment) => {
          val vr = VirtualRegister.alloc();
          mkAbsMove(array, vr)++
          mkAbsOp("ldr    'd0, ['u0, #-1]", vr, opToVR(dst));
        }
          
        
        case i: TAC_NewClass => {
            //Perform library call to allocate the object
            val size = (1 + i.decl.size) * WARMMachineDescription.sizeOfDataElement();
            //
            val vrVT = VirtualRegister.alloc();
            val vrObj = VirtualRegister(i.dst);
            
            AbsASMOp("mov    'd0, #" + size, Nil, vR0) ++  
            AbsASMOp("bl     LIBAllocateObject")++ 
            AbsASMOp("mov    'd0, 'u0", vR0, vrObj)++
            //Assign vtable ptr into first memory location 
            AbsASMOp("adr    'd0, " + i.decl.cls_id + "VT", Nil, vrVT) ++
            AbsASMOp("str    'u0, ['u1]", List(vrVT, vrObj), Nil);
        }
        
        case al @ TAC_ArrayLoad(dst, array, index, _, _) => {
          val vrArray = VirtualRegister.alloc();
          val vrIndex = VirtualRegister.alloc();
          mkAbsMove(array, vrArray)++
          mkAbsMove(index, vrIndex)++
          AbsASMOp("ldr    'd0, ['u0, 'u1]", List(vrArray, vrIndex), opToVR(dst));
        }
        
        case as @ TAC_ArrayStore(array, index, value, _,_) => {
          val vrIndex = VirtualRegister.alloc();
          val vrArray = VirtualRegister.alloc();
          val vrValue = VirtualRegister.alloc();
          mkAbsMove(array, vrArray)++
          mkAbsMove(index, vrIndex)++
          mkAbsMove(value, vrValue)++
          AbsASMOp("str    'u0, ['u1, 'u2]", List(vrValue, vrArray, vrIndex), Nil);        
        }
        
        case fl @ TAC_FieldLoad(dst, rec, field, _, _) => {
          val vrObj = VirtualRegister.alloc();
          mkAbsMove(rec, vrObj)++
          AbsASMOp("ldr    'd0, ['u0, #" + field.offset * WARMMachineDescription.sizeOfDataElement() + "]", vrObj, opToVR(dst))
        }
        
        case fs @ TAC_FieldStore(rec, field, value, _, _) => {
          val vrObj = VirtualRegister.alloc();
          val vrValue = VirtualRegister.alloc();
          mkAbsMove(rec, vrObj)++
          mkAbsMove(value, vrValue)++
          AbsASMOp("str    'u0, ['u1, #" + field.offset*WARMMachineDescription.sizeOfDataElement() + "]", List(vrValue, vrObj), Nil)  
        }
        
        case TAC_UnOp(dst, expr, unop, _, _) =>{
          val vrDst = opToVR(dst);                                 
          unop match{
            case UnNeg() => {
              AbsASMOp("mvn    'd0, 'u0", opToVR(expr), vR0)++
                AbsASMOp("add    'd0, 'u0, #1", vR0, vR0)++
                  mkAbsMove(vR0, vrDst);              
                
            }
            case UnNot() => {
              AbsASMOp("mov    'd0, #1", Nil, vrDst)++
                mkAbsOp("eor    'd0, 'u0, 'u1", vrDst, expr, vrDst)
            }
          }
        }
        
        //TODO: finish
        case nc: TAC_NullCheck => {
          val obj = VirtualRegister.alloc();
          mkAbsMove(nc.oject, obj)++
          mkAbsOp("cmp    'u0, #0", obj)++
          AbsASMJump("beq labelNullPtrError");
        }
        
        case d0: TAC_DivBy0 => {
          val vVR = VirtualRegister.alloc();
          mkAbsMove(d0.divisor, vVR)++
          mkAbsOp("cmp    'u0, #0", vVR)++
          AbsASMJump("beq labelDivByZeroError");
        }
        
        case ib: TAC_IndexInBounds => {
          val vrIndex = VirtualRegister.alloc();
          mkAbsMove(ib.index, vrIndex)++
          mkAbsOp("cmp    'u0, #0", vrIndex) ++{
            AbsASMJump("blt    labelArrayBoundsError")++
            {
              val vr = VirtualRegister.alloc();
              mkAbsMove(ib.array, vr)
            }
          }
        }
        
        case TAC_GreaterThan0(index, _, _) => {
          AbsASMComment("stub")
        }
      }
    }
  }
}