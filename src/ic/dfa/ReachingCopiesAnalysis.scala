package ic.dfa;

import ic.cfg.ControlFlowGraph;
import ic.tac._;

class ReachingCopiesAnalysis(override val cfg : ControlFlowGraph) extends DataFlowAnalysis[Map[TACOp,TACOp]](cfg)  {
  
  var liveVar = Map();
  
  val empty: Map[TACOp,TACOp] = Map[TACOp,TACOp]();
  
  //IN[OUT] should remain empty
	def boundary() = empty;
	
	//Set to null since can't create a Map with all possible copies
	//Make top null and check if a map is null in the meet operation
	//to perform the same functionality as T
	def top() = null;
	
	//Check if two Maps are equal
	def equals(t1 : Map[TACOp,TACOp], t2: Map[TACOp,TACOp]): Boolean = {
	  if(t1 == null && t2 == null)
	    return true;
	  if(t1 == null || t2 == null)
	    return false;
	  t1.equals(t2);
	}
	
	//Forwards Analysis
	def isForward() = true;
	
	// Define as intersect
	//Check to see if t1 or t2 is null and, therefore, the top element and 
	//if one is, return the other Map
	def meet(t1 : Map[TACOp,TACOp], t2: Map[TACOp,TACOp]): Map[TACOp,TACOp] = {
	  if(t1 == null){
	    return t2;
	  }
	  if(t2 == null){
	    return t1;
	  }
	  
	  t1.filter{ case (k,v) => (t2.get(k) == v) };
	}
	
	// check if the l or r value has been defined
	def transfer(instr : TACInstr, in: Map[TACOp,TACOp]): Map[TACOp,TACOp] = {
	  instr match{
	    case TAC_Copy(dst: TACOp, src: TACOp, _, _) => checkMember(dst, in) + (dst -> src)
	    case TAC_BinOp(dst, _, _, _, _, _) => checkMember(dst, in)
	    case TAC_UnOp(dst, _, _, _, _) => checkMember(dst, in)
	    case TAC_NewClass(dst, _, _, _) => checkMember(dst, in)
	    case TAC_Length(dst, _, _, _) => checkMember(dst, in)
	    case TACCall_VirCall(dst, _, _, _, _ , _) => {
	      dst match{
	        case Some(x) => checkMember(x, in)
	        case None => in
	      }
	    }
	    case TACCall_LibCall(dst, _, _, _, _) => {
	     dst match{
	       case Some(x) => checkMember(x, in)
	       case None => in
	      }
	    }
	    case _ => {in}
	  }
	}
	
	def checkMember(t: TACOp, set: Map[TACOp, TACOp]) : Map[TACOp, TACOp] = {
	  set.filterNot{ case (k,v) => (k == t || v == t) }
	}
}