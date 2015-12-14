package ic.cg_warm;
import ic.asm._

/**
 * WARM-specific details
 */
object WARMMachineDescription extends MachineDescription{

  /* All the physical registers */
  val R0     = new PhysicalRegister("r0");
  val R1     = new PhysicalRegister("r1");
  val R2     = new PhysicalRegister("r2");
  val BP     = new PhysicalRegister("r3");
  val R4     = new PhysicalRegister("r4");
  val R5     = new PhysicalRegister("r5");
  val R6     = new PhysicalRegister("r6");
  val R7     = new PhysicalRegister("r7");
  val R8     = new PhysicalRegister("r8");
  val R9     = new PhysicalRegister("r9");
  val R10    = new PhysicalRegister("r10");
  val WFP    = new PhysicalRegister("r11");
  val R12    = new PhysicalRegister("r12");
  val SP     = new PhysicalRegister("r13");
  val LR    = new PhysicalRegister("r14");
  val WPC    = new PhysicalRegister("r15");
  
  def PC(): PhysicalRegister = WPC;
  def FP(): PhysicalRegister = WFP;

  
  def callerSaveRegisters(): List[PhysicalRegister] =
    List[PhysicalRegister](R0, R1, R2);
 
  def calleeSaveRegisters(): List[PhysicalRegister] =
    List[PhysicalRegister](R4, R5, R6, R7, R8, R9, R10)
    
  def firstAvailableOffsetForLocals(): Int = -1
  def firstAvailableOffsetForParameters(): Int = 2
  def sizeOfDataElement(): Int = 1;
  
  def copyFromStack(offsetFromFP: Int, dst: PhysicalRegister, comment: String): ASMInstr = {
      ASMOp("ldr " + "'do, [fp, " + offsetFromFP + " ]", Nil, dst, comment); 
  }
  
  def copyToStack(src: PhysicalRegister, offsetFromFP: Int, comment : String): ASMInstr = {
      ASMOp("str " + "'u0, [fp, " + offsetFromFP + " ]", src, Nil, comment);
  }
  
  def copyToReg(src: PhysicalRegister, dst: PhysicalRegister, comment : String): ASMInstr = {
      ASMOp("mov	'd0, 'u0", src, dst, comment);
  }
  
  def copyFromStack(offsetFromFP: Int, dst: VirtualRegister, comment : String): AbsASMInstr = {
      AbsASMOp("ldr " + "'do, [fp, " + offsetFromFP + " ]", Nil, dst, comment);     
  }
  
  def copyToStack(src: VirtualRegister, offsetFromFP: Int, comment : String): AbsASMInstr = {
      AbsASMOp("str " + "'u0, [fp, " + offsetFromFP + " ]", src, Nil, comment);    
  }
}
