package ic.dfa;

import ic.cfg.ControlFlowGraph;
import ic.tac._;
import ic.ast._;

class LiveVariableAnalysis(override val cfg : ControlFlowGraph) extends DataFlowAnalysis[Set[TACOp]](cfg)  {
  //IN[EXIT] should remain empty
	def boundary() = Set[TACOp]();
	
	//Set unioned with empty set returns itself
	def top() = Set[TACOp]();
	
	//Two sets are equal if they are both subsets of each other
	def equals(t1 : Set[TACOp], t2: Set[TACOp]): Boolean = t1.equals(t2);
	
	//Backwards Analysis
	def isForward() = false;
	
	
	// Define as union
	def meet(t1 : Set[TACOp], t2: Set[TACOp]): Set[TACOp] = t1 | t2;
	
	//
	def transfer(instr : TACInstr, out: Set[TACOp]): Set[TACOp] = {
	  val useB: Set[TACOp] = use(instr);
	  val defB: Set[TACOp] = define(instr);
	  return useB | (out -- defB);
	}
	
	//only adds the variable to the set if it is a temp or a variable
	def addIfVar(in: Set[TACOp]): Set[TACOp] = {
	  in.filter(x => x.isInstanceOf[TAC_Var] || x.isInstanceOf[TAC_Temp])
	}
	
	
	def use(instr: TACInstr):Set[TACOp] = {
	  instr match {
	    case TAComment(comment: String, line) => {Set()}

      //Branching, control flow
      case TAC_Label(label: String, line: Int, comment: String) => {Set()}
      case TAC_Jump(label: TAC_Label, line: Int, comment: String) => {Set()}
      case TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) => {
        addIfVar(Set(condition))
      }
      case TAC_RET(value: Option[TACOp], line: Int, comment: String) => {
        value match {
          case Some(x) => addIfVar(Set(x));
          case None => {Set()}
        }
      }
      case TAC_Length(dst: TACOp, array: TACOp, line: Int, comment: String) => {
        addIfVar(Set(array));       
      }

      case TAC_NewClass(dst: TACOp, decl: ASTClassDecl, line: Int, comment: String) => {Set()}

      //Calls
      case TACCall_VirCall(dst: Option[TACOp], receiver: TACOp, decl: ASTMethodDecl, paramList: List[TACOp], line: Int, comment: String) => {
        addIfVar(paramList.toSet + receiver)
      }
      
      case TACCall_LibCall(store: Option[TACOp], op: String, params: List[TACOp], line: Int, comment: String) => {
        addIfVar(params.toSet)
      }

      //Movement, load store, copy
      case TAC_Copy(dst: TACOp, src: TACOp, line: Int, comment: String) => {
        addIfVar(Set(src));
      }
      
      case TAC_ArrayStore(array: TACOp, index: TACOp, value: TACOp, line: Int, comment: String) => {
        addIfVar(Set(array, index, value))
      }
      
      case TAC_FieldStore(receiver: TACOp, field: ASTFieldDecl, value: TACOp, line: Int, comment: String) => {
        addIfVar(Set(value, receiver));
      }
      
      case TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, line: Int, comment: String) => {
        addIfVar(Set(array, index));
      }
      
      case TAC_FieldLoad(dst: TACOp, receiver: TACOp, field: ASTFieldDecl, line: Int, comment: String) => {
        addIfVar(Set(receiver));
      }

      //Binary operations
      case TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, binop: ASTBinOp, line: Int, comment: String) => {
        addIfVar(Set(lExpr, rExpr));
      }

      //Unops
      case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) => {
        addIfVar(Set(expr))
      }

      //Run time checks
      case TAC_NullCheck(oject: TACOp, line: Int, comment: String) => {
        addIfVar(Set(oject))
      }
      
      case TAC_IndexInBounds(array: TACOp, index: TACOp, line: Int, comment: String) => {
        addIfVar(Set(index, array));
      }
      
      case TAC_DivBy0(divisor: TACOp, line: Int, comment: String) => {
        addIfVar(Set(divisor));
      }
      
      case TAC_GreaterThan0(index: TACOp, line: Int, comment: String) => {
        addIfVar(Set(index));
      }
	  }
	}

	 //We need to make sure the variables we added to "defined" were not used on the same instruction
	  //This is because the used variables in an instruction will be used before we 
	  //define them by storing them.
	def define(instr: TACInstr): Set[TACOp] = {
	  instr match {
	    case TAComment(comment: String, line) => {Set()}

      //Branching, control flow
      case TAC_Label(label: String, line: Int, comment: String) => {Set()}
      case TAC_Jump(label: TAC_Label, line: Int, comment: String) => {Set()}
      case TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) => {Set()}
      case TAC_RET(value: Option[TACOp], line: Int, comment: String) => {Set()}
      case TAC_Length(dst: TACOp, array: TACOp, line: Int, comment: String) => {
        addIfVar(Set(dst)) -- use(instr);       
      }

      case TAC_NewClass(dst: TACOp, decl: ASTClassDecl, line: Int, comment: String) => {Set()}

      //Calls
      case TACCall_VirCall(dst: Option[TACOp], receiver: TACOp, decl: ASTMethodDecl, paramList: List[TACOp], line: Int, comment: String) => {
        dst match {
          case Some(x) => {
            addIfVar(Set(x)) -- use(instr);
          }
          case None => {Set()}
        }
      }
      
      case TACCall_LibCall(store: Option[TACOp], op: String, params: List[TACOp], line: Int, comment: String) => {
        store match {
          case Some(x) => {
            addIfVar(Set(x)) -- use(instr);
          }
          case None => {Set()}
        }
      }

      //Movement, load store, copy
      case TAC_Copy(dst: TACOp, src: TACOp, line: Int, comment: String) => {
        addIfVar(Set(dst)) -- use(instr); 
      }
      
      case TAC_ArrayStore(array: TACOp, index: TACOp, value: TACOp, line: Int, comment: String) => {Set()}
      
      case TAC_FieldStore(receiver: TACOp, field: ASTFieldDecl, value: TACOp, line: Int, comment: String) => {Set()}
      
      case TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, line: Int, comment: String) => {
        addIfVar(Set(dst)) -- use(instr);
      }
      
      case TAC_FieldLoad(dst: TACOp, receiver: TACOp, field: ASTFieldDecl, line: Int, comment: String) => {
        addIfVar(Set(dst)) -- use(instr);
      }

      //Binary operations
      case TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, binop: ASTBinOp, line: Int, comment: String) => {
        addIfVar(Set(dst)) -- use(instr);
      }

      //Unops
      case TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) => {
        addIfVar(Set(dst)) -- use(instr);
      }

      //Run time checks
      case TAC_NullCheck(oject: TACOp, line: Int, comment: String) => {Set()}
      
      case TAC_IndexInBounds(array: TACOp, index: TACOp, line: Int, comment: String) => {Set()}
      
      case TAC_DivBy0(divisor: TACOp, line: Int, comment: String) => {Set()}
      
      case TAC_GreaterThan0(index: TACOp, line: Int, comment: String) => {Set()}
	  }
	}
}
