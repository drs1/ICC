package ic.cfg

import ic.tac._
import ic.ast._
import ic.error.SemanticError

class CFGGenerator() {
  
   def makeCFG(method: ASTMethodDecl): ControlFlowGraph = { 
    var cfg = new ControlFlowGraph;
     
    //Set the first instruction block as the enter
    val entry = cfg.newBlock(new TAComment("Entry"));
    val exit = cfg.newBlock(new TAComment("Exit"));
    cfg.setEnter(entry);
    cfg.setExit(exit);    
    var current: BasicBlock = entry;
    
    //create blocks for all tac instructions
    for(instr <- method.tacList.list) { 
      current = cfg.newBlock(instr)
    }
        
    var previous : Option[BasicBlock] = Some(entry);
    
    var cur: BasicBlock = entry; // Must be entry, not null, or it crashes on empty method... - Steve. 
    //Add in edges on jumps and returns
    for(instr <- method.tacList.list){
      
      //if there is a previous block, add the edge from that block to this one
      cur = cfg.getBlock(instr)
      previous match {
        case Some(x) => x.addEdge(cur)
        case None => {}
      }
      
      instr match {
        case j @ TAC_Jump(label: TAC_Label, line: Int, comment: String) => {
          val destination = cfg.getBlock(label)
          cur.addEdge(destination);
          previous = None
        }
        case cj @ TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) => {
          val takeJump = cfg.getBlock(label)
          cur.addEdge(takeJump)
          previous = Some(cur)
          //previous gets assigned because we could have not executed the jump
        }
        
        case tr @ TAC_RET(value: Option[TACOp], line: Int, comment: String) => {
          cur.addEdge(exit)
          previous = None
        }
        
        case other @ _ => {
          previous = Some(cur);
        }
      }
    }
    cur.addEdge(exit)    
    return cfg;
  }
}
