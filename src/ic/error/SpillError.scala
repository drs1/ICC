package ic.error
import ic.asm.VirtualRegister


class SpillError(val message : String, val spill: VirtualRegister) extends Error(message) {
	
	/**
	 * Return the line number of where the error occurred.
	 */
  
}