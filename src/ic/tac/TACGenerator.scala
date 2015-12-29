package ic.tac

import ic.ast._;
import ic.error._;

object TACGenerator {
	var labelCount = 0;

	//Generates TAC Instructions for all classes in a program
	def gen(p: ASTProgram): Unit = {
			for(c <- p.classes){
				gen(c);
			}
	}

	//Generates TAC instructions for all methods in a class
	def gen(c: ASTClassDecl): Unit = {
	  for(decl <- c.decls){
			decl match {
  			case f @ ASTFieldDecl(_type: ASTType, id: String /*, id_list: List[String]*/, line: Int) => {}

	  		case m @ ASTMethodDecl(_type: ASTType, id: String, formals: List[ASTVarDecl], block: ASTBlock, line: Int) => {
		 			// pass the empty tacList down through gen of the block
		  		// so the block gets an empty list and adds all instructions of the block to this list
			  	m.tacList = new TACList(block.local_size);
			    m.tacList.add(TAC_Preamble(formals, line));  // for cg_x86 -- need to mark preamble.
				  gen(block, m.tacList, null, null);
				  m.tacList.add(new TAC_RET(None, line, "")); // for cg_x86 -- need return on all paths through TAC
	      }
		  }
		}
  }

	
	//we're in a block, recursively add all the instructions to this list
	def gen(b: ASTBlock, tacList: TACList, topLoop: TAC_Label, botLoop: TAC_Label): Unit = {
		for(v <- b.decls){
		  gen(v, tacList, topLoop, botLoop)
		}

		for(stmt <- b.stmts){
			gen(stmt, tacList, topLoop, botLoop);
			b.local_size = tacList.size();
		}
	}

	//
	def gen(v: ASTVarDecl, tacList: TACList, topLoop: TAC_Label, botLoop: TAC_Label): Unit = {
		v.optExpr match {
		case Some(x) => {
			val varOp = new TAC_Var(v, v.line, "");
			val temp = gen(x, tacList);
			tacList.add(new TAC_Copy(varOp, temp, v.line, ""));
		}
		case None => {}
		}
  }

	def gen(loc: ASTLoc, expr: TACOp, tacList: TACList, line: Int): Unit = {
		loc match{
			case va @ ASTVarAccess(id: String, line: Int) =>	gen(va.resolved, expr, tacList, line);
			case l @ ASTLocalAccess(id: String, line: Int) => {
				val v = new TAC_Var(l.decl, line, "");
				tacList.add(new TAC_Copy(v, expr, line, ""));
			}
			case fa @ ASTFieldAccess(receiver: ASTExpr, id: String, line: Int) => {
				val rec: TACOp = gen(receiver, tacList);
			  tacList.add(new TAC_NullCheck(rec, line, ""));
			  tacList.add(new TAC_FieldStore(rec, fa.decl, expr, line, ""));
			}
			case aa @ ASTArrayAccess(array: ASTExpr, index: ASTExpr, line: Int) => {
				val arr: TACOp = gen(array, tacList);
			  val ind: TACOp = gen(index, tacList);
			  tacList.add(new TAC_NullCheck(arr, line, ""));
			  tacList.add(new TAC_IndexInBounds(arr, ind, line, ""));
			  tacList.add(new TAC_ArrayStore(arr, ind, expr, line, ""));
			}
		}
	}

	//Generate TAC Instructions for a Statement Node in the AST and adds them to the TACList for the current method
	def gen(stmt: ASTStmt, tacList: TACList, topLoop: TAC_Label, botLoop: TAC_Label): Unit = {
			stmt match{
			  case l @ ASTStmtLoc(loc: ASTLoc, expr: ASTExpr, line: Int) => {
				  val exprGen: TACOp = gen(expr, tacList);
			    gen(loc, exprGen, tacList, line)
			  }

			  case c @ ASTStmtCall(call: ASTCall, line: Int) => {
  				call match {
	    			case lc @ ASTLibCall(id: String, opList: List[ASTExpr], line: Int) => {
			  		  val paramList: List[TACOp] = makeParams(opList, tacList);

				      if(id.startsWith("print") || id.equals("exit")){
  					    tacList.add(new TACCall_LibCall(None, id, paramList, line, ""));
	  			    }else {
		  			    val temp: TACOp = tacList.alloc(line);
			  	      tacList.add(new TACCall_LibCall(Some(temp), id, paramList, line, "")); 
				      }
				    }
				    case vc @ ASTVirtualCall(opExpr: ASTExpr, id: String, params: List[ASTExpr], line:Int) => {
					    val paramList: List[TACOp] = makeParams(params, tacList);

    				  val rec = gen(opExpr, tacList);
		    		  tacList.add(new TAC_NullCheck(rec, line, ""));
				      vc.decl._type match {
				        case ASTTypeVoid(line: Int) => {
					        tacList.add(new TACCall_VirCall(None, rec, vc.decl, paramList, line, "Virtual Call with no return"));
		  	        }
				        case _ => {
					        val temp: TACOp = tacList.alloc(line)
							    tacList.add(new TACCall_VirCall(Some(temp),rec,  vc.decl, paramList, line, "Virtual Call with return"));
				        }  
				      }
				    }
  				}
			  }

  			case r @ ASTStmtRet(optExpr: Option[ASTExpr], line: Int) => {
	  			optExpr match{
		    		case Some(x: ASTExpr) => tacList.add(new TAC_RET(Some(gen(x, tacList)), line, ""));
				    case None =>  tacList.add(new TAC_RET(None, line, ""));
				  }
			  }

			case i @ ASTStmtIf(test: ASTExpr, cond: ASTStmt, opElse: Option[ASTStmt], line: Int) => {
				//conditional jump
				val testGen: TACOp = gen(test, tacList);
  			val label: TAC_Label = new TAC_Label("L"+labelCount, line, "End of IF statement, start of ELSE for " + testGen + " from line " + line);
	  		//revert the test, then jump to the label if the test was false
		  	val temp = tacList.alloc(line);
			  tacList.add(new TAC_UnOp(temp, testGen, new UnNot(), line, ""));
			  tacList.add(new TAC_CJump(label, temp, line, ""));
			  labelCount = labelCount+1
				gen(cond, tacList, topLoop, botLoop) //code for IF
				opElse match{
			  	case Some(x: ASTStmt) => {
				  	val endLabel: TAC_Label = new TAC_Label("L"+labelCount, line, "End of ELSE statement from line " + line);
  					tacList.add(new TAC_Jump(endLabel, line, ""));
	  				tacList.add(label);
		  			labelCount = labelCount+1;
			  		gen(x, tacList, topLoop, botLoop); //code for ELSE
				  	tacList.add(endLabel);
				  }
				  case None => tacList.add(label);
			  }
			}

			case w @ ASTStmtWhile(test: ASTExpr, stmt: ASTStmt, line: Int) => {
				//loop w/ conditional jump
				val top: TAC_Label = new TAC_Label("L"+labelCount, line, "Top of while loop on line " + line);
			labelCount = labelCount + 1;
			tacList.add(top);
			val bottom: TAC_Label = new TAC_Label("L"+labelCount, line, "Bottom of while loop on line " + line);
			labelCount = labelCount + 1;	
			val testGen: TACOp = gen(test, tacList);
			val temp = tacList.alloc(line);
			tacList.add(new TAC_UnOp(temp, testGen, new UnNot(), line, ""));
			tacList.add(new TAC_CJump(bottom, temp, line, ""));
			gen(stmt, tacList, top, bottom);
			tacList.add(new TAC_Jump(top, line, ""));
			tacList.add(bottom);
			}

			case b @ ASTStmtBreak(line: Int) => {
				//jump to next label
				tacList.add(new TAC_Jump(botLoop, line, ""));
			}

			case c @ ASTStmtCont(line: Int) => {
				//jump to previous label, or if in while jump to end
				tacList.add(new TAC_Jump(topLoop, line, ""));
			}      

			case b @ ASTStmtBlock(block: ASTBlock, line: Int) => {
				//block, but preserve toploop and botloop
				gen(block, tacList, topLoop, botLoop);
			}
			}
	}


	//Generate TAC Instructions for an Expression Node in the AST and returns where the result is held
	def gen(node: ASTExpr, tacList: TACList): TACOp = {
			node match{
			case nc @ ASTExprNewClass(cls_id: String, line: Int) => {
				//return new class
				// allocate a new object with the lib_allocClass
				val temp: TAC_Temp = tacList.alloc(line)
						tacList.add(new TAC_NewClass(temp, nc._type.decl, line, ""));
			return temp;
			}

			case e @ ASTExprArray(_type: ASTType, index: ASTExpr, line: Int) => {
				//return new array
				// check if
				val ind: TACOp = gen(index, tacList);
			tacList.add(new TAC_GreaterThan0(ind, line, ""));
			val temp: TAC_Temp = tacList.alloc(line);
			val params: List[TACOp] = List(ind);
			tacList.add(new TACCall_LibCall(Some(temp), "allocateArray", params, line, ""));
			return temp;
			}

			case l @ ASTExprLen(array: ASTExpr, line: Int) => {
				//returns an int of the length of the array
				val temp: TACOp = gen(array, tacList);
			tacList.add(new TAC_NullCheck(temp, line, ""))
			val params: List[TACOp] = List(temp);
			val temp2: TACOp = tacList.alloc(line);
			tacList.add(new TAC_Length(temp2, temp, line, ""));
			return temp2;
			}

			case eb @ ASTExprBinop(lexpr: ASTExpr, binop: ASTBinOp, rexpr: ASTExpr, line: Int) => {
				//returns the destination operand of the final TACInstruction	
				binop match {
				case i: BinPlus => {
					i.plusType match{ 
					case j: ASTTypeString => {
						val temp: TACOp = tacList.alloc(line);
					val left: TACOp = gen(lexpr, tacList);
					val right: TACOp = gen(rexpr, tacList);
					val paramList: List[TACOp] = List(left, right);
					tacList.add(new TACCall_LibCall(Some(temp), "stringCat",paramList, line, ""));
					return temp;
					}
					case j: ASTTypeInt =>
					makeBinop(tacList, lexpr, rexpr, binop, line);
					}
				}   
				case BinDiv() =>
				makeDivMod(tacList, lexpr, rexpr, binop, line);
				case BinMod() =>
				makeDivMod(tacList, lexpr, rexpr, binop, line);

				//Short-circuit AND and OR
				case BinAnd() => {
					val temp: TACOp = tacList.alloc(line);
				val left: TACOp = gen(lexpr, tacList);
				val label: TAC_Label = new TAC_Label("L"+labelCount, line, "")
				labelCount = labelCount + 1;
				tacList.add(new TAC_Copy(temp, left, line, ""));
				val temp2: TACOp = tacList.alloc(line);
				tacList.add(new TAC_UnOp(temp2, left, new UnNot(), line, ""));
				tacList.add(new TAC_CJump(label, temp2, line, ""));
				val right: TACOp = gen(rexpr, tacList);
				tacList.add(new TAC_Copy(temp, right, line, ""));
				tacList.add(label);
				return temp;
				}
				case BinOr() => {
					val temp: TACOp = tacList.alloc(line);
				val left: TACOp = gen(lexpr, tacList);
				val label: TAC_Label = new TAC_Label("L"+labelCount, line, "")
				labelCount = labelCount + 1;
				tacList.add(new TAC_Copy(temp, left, line, ""));
				tacList.add(new TAC_CJump(label, left, line, ""));
				val right: TACOp = gen(rexpr, tacList);
				tacList.add(new TAC_Copy(temp, right, line, ""));
				tacList.add(label);
				return temp;
				}
				case BinMinus() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinMult() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinLt() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinLe() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinGt() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinGe() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinEqeq() =>
				makeBinop(tacList, lexpr, rexpr, binop, line);
				case BinNe() => 
				makeBinop(tacList, lexpr, rexpr, binop, line);
				}
			}

			case eu @ ASTExprUnop(unop: ASTUnOp, expr: ASTExpr, line: Int) => {
				val temp: TACOp = tacList.alloc(line)
						val ex: TACOp = gen(expr, tacList);
				tacList.add(new TAC_UnOp(temp, ex, unop, line, ""));
				return temp;
			}

			case lc @ ASTLibCall(id: String, opList: List[ASTExpr], line: Int) => {
				val paramList: List[TACOp] = makeParams(opList, tacList);
			val temp: TACOp = tacList.alloc(line);
			tacList.add(new TACCall_LibCall(Some(temp), id, paramList, line, ""));
			return temp;
			}

			case vc @ ASTVirtualCall(opExpr: ASTExpr, id: String, params: List[ASTExpr], line:Int) => {
				val paramList: List[TACOp] = makeParams(params, tacList)

						val rec = gen(opExpr, tacList);
			tacList.add(new TAC_NullCheck(rec, line, ""));
			val temp: TACOp = tacList.alloc(line)
					tacList.add(new TACCall_VirCall(Some(temp), rec, vc.decl, paramList, line, ""));
			return temp;
			}

			case v @ ASTVarAccess(id: String, line: Int) => {
				gen(v.resolved, tacList);
			}

			case l @ ASTLocalAccess(id: String, line: Int)=> {
				return new TAC_Var(l.decl, line, "");
			}

			case f @ ASTFieldAccess(receiver: ASTExpr, id: String, line: Int) => {
				val temp: TACOp = tacList.alloc(line);
			val rec: TACOp = gen(receiver, tacList);
			tacList.add(new TAC_NullCheck(rec, line, ""));
			tacList.add(new TAC_FieldLoad(temp, rec, f.decl, line, ""));
			return temp;
			}

			case a @ ASTArrayAccess(array: ASTExpr, index: ASTExpr, line: Int) => {
				val temp: TACOp = tacList.alloc(line);
			val arr: TACOp = gen(array, tacList);
			val ind: TACOp = gen(index, tacList);
			tacList.add(new TAC_NullCheck(arr, line, ""));
			tacList.add(new TAC_IndexInBounds(arr, ind, line, ""));
			tacList.add(new TAC_ArrayLoad(temp, arr, ind, line, ""));
			return temp;
			}

			case li @ ASTLiteralInt(i: Int, line: Int) => {
				return new TAC_Lit(li, line, "")
			}
			case ls @ ASTLiteralString(s: String, line: Int) => {
			  val temp = tacList.alloc(line);
			  val stubCopy = new TAC_Copy(temp, new TAC_Lit(ls, line, ""),line, "")
			  tacList.add(stubCopy);
				return temp
			}
			case lb @ ASTLiteralBool(b: Boolean, line: Int) => {
				return new TAC_Lit(lb, line, "");
			}
			case ln @ ASTLiteralNull(line: Int) => {
				return new TAC_Lit(ln, line, "");
			}
			}
	}

	//Helper method for Mod and Div
	def makeDivMod(tacList: TACList, lexpr: ASTExpr, rexpr: ASTExpr, binop: ASTBinOp, line: Int): TACOp = {
			val temp: TACOp = tacList.alloc(line);
	val left: TACOp = gen(lexpr, tacList);
	val right: TACOp = gen(rexpr, tacList);
	tacList.add(new TAC_DivBy0(right, line, ""));
	tacList.add(new TAC_BinOp(temp, left, right, binop, line, ""));
	return temp;
	}

	//Helper method for other binary expressions
	def makeBinop(tacList: TACList, lexpr: ASTExpr, rexpr: ASTExpr, binop: ASTBinOp, line: Int): TACOp = {
			val temp: TACOp = tacList.alloc(line);
	val left: TACOp = gen(lexpr, tacList);
	val right: TACOp = gen(rexpr, tacList);
	tacList.add(new TAC_BinOp(temp, left, right, binop, line, ""));
	return temp;
	}

	//Creates parameter list for Virtual Call and Library Call
	def makeParams(params: List[ASTExpr], tacList: TACList): List[TACOp] = {
			val paramList: List[TACOp] = params.map(gen(_,tacList));
	return paramList;
	}
}
