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
  
  private def mkAbsMove(use: TACOp, define: VirtualRegister): AbsASMInstr = {
    use match {
      case v: TAC_Temp => AbsASMMove("movq 'u0, 'd0", opToVR(use), define)
      case v: TAC_Var  => AbsASMMove("movq 'u0, 'd0", opToVR(use), define)
      case _           => AbsASMOp("movq " + opToARM(use) + ", 'd0", List(), define);
    }
  }
  
  private def mkAbsMove(src: TACOp, dst: TACOp) : AbsASMInstr = {
    src match{
      case t: TAC_Temp => AbsASMMove("mov    'd0, 'u0", opToVR(src), opToVR(dst));
      case v: TAC_Var  => AbsASMMove("mov    'd0, 'u0", opToVR(src), opToVR(dst));
      case l: TAC_Lit  => AbsASMOp("mov    'd0, " + opToARM(src), List(), opToVR(dst))
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
  
  //unop with v regsister
  private def mkAbsOp(format: String, src: VirtualRegister) = {
    AbsASMOp(format, src, List())
  }
  
  
  //allows the ++ to work for absASM
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
  
  private def gen(instr: TACInstr): List[AbsASMInstr] = {
    AbsASMComment(instr.toString) ++ 
      {
      instr match{
        
        case vc: TACCall_VirCall => {
          val offset = vc.decl.offset * WARMMachineDescription.sizeOfDataElement();
          
          vc.paramList.reverse.map(p  =>  mkAbsOp("stu    'u0, [sp, #-1]", p)) ++
              mkAbsOp("stu    'u0, [sp, #-1", vc.receiver) ++
              {
                val vr1 = VirtualRegister.alloc();
                
                mkAbsMove(vc.receiver, vr1) ++
                  mkAbsOp("ldr    'd0, ['u0]", vr1, vr1)
                
            
              }
          
          
        }
        
        case l: TAC_Label                =>  
          AbsASMOp(l.label + ":");
        case j: TAC_Jump                 =>
          AbsASMJump("b    " + j.label.label);
        case c: TAComment                =>
          AbsASMComment(c.comment);
        case b @ TAC_BinOp(dst, lexpr, rexpr, binop, line, comment) => 
          binop match{
            
            // add   d0, u0, u1
            case BinPlus() => {
              val lvr = VirtualRegister.alloc();
              mkAbsMove(lexpr, lvr) ++
              mkAbsOp("add    'd0, 'u0, u1", lvr, rexpr, opToVR(dst));
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
            
            case 
            
            
          }


                
      }
    }
  }
}