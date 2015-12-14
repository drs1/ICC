package ic.tac

import ic.ast._;
import ic.error._;

import ic.symtab._;

object OffsetGenerator{
	val NEG_STORE = -1;

	def gen(program: ASTProgram){
		program.classes.foreach(gen(_))
	}

	def gen(cls: ASTClassDecl){
		//how big is the super? what methods do we override? how big does the v table need to be?
		cls.f_size = cls.ext match{
		case Some(x) => {
			x.decl.f_size 
		}
		case None => { 0 }
		}

		cls.v_size = cls.ext match{
		case Some(x) => {
			x.decl.v_size 
		}
		case None => { 0 }
		}

		for(decl <- cls.decls){
			decl match{
			case f: ASTFieldDecl => {
				// the field decl needs to get an offset, based off of the super types stuff
				cls.f_size += 1
						gen(f, cls.f_size)
			}

			case m @ ASTMethodDecl(_type: ASTType, id: String, formals: List[ASTVarDecl], block: ASTBlock, line: Int) => {
				// find out if the super class has a decl of this same id, if it does
				//get it's offset and store this one at the same offset
				m.scope.parent match {
				case Some(x) => {
					//if we have a parent, check to see if this method has been defined before
					x.getMethodDecl(id) match {
					case Some(y) => {
						gen(m, y.offset)		      
					}
					case None => {
						gen(m, cls.v_size)
						cls.v_size += 1
					}
					}
				}
				case None => {
					//then we are fine
					gen(m, cls.v_size)
					cls.v_size += 1
				}
				}
				cls.size = cls.f_size + 1;   //for the v table
				block.local_size = gen(block, 1)
			}
			} 
		}
	}

	//Recurse down on blocks and keep tack of local_offset based on outer block
	def gen(stmt: ASTStmt, local_offset: Int): Int = {
			stmt match{
			case l @ ASTStmtLoc(loc: ASTLoc, expr: ASTExpr, line: Int) => {0}
			case c @ ASTStmtCall(call: ASTCall, line: Int) => {0}
			case r @ ASTStmtRet(optExpr: Option[ASTExpr], line: Int) => {0}
			case i @ ASTStmtIf(test: ASTExpr, cond: ASTStmt, opElse: Option[ASTStmt], line: Int) => {
			  val locCount = gen(cond, local_offset);
			  opElse match {
			    case Some(x) => locCount + gen(x, local_offset);
			    case None => { locCount }
			  }
			}
			case w @ ASTStmtWhile(test: ASTExpr, stmt: ASTStmt, line: Int) => {
			  gen(stmt, local_offset);
			}
			case b @ ASTStmtBreak(line: Int) => {0}
			case c @ ASTStmtCont(line: Int) => {0}      
			case b @ ASTStmtBlock(block: ASTBlock, line: Int) => {
				gen(block, local_offset)
			}
			}
	}

	def gen(block: ASTBlock, local_offset: Int): Int ={
	  var offset = local_offset
			for(v <- block.decls){
				gen(v, offset*NEG_STORE)
			///	println(v.id + " " + local_offset )  					
				offset = offset+ 1
			}

			for(stmt <- block.stmts){
				offset += gen(stmt, offset)
			}
			return offset
	}

	def gen(node: ASTFieldDecl, offset: Int){
		node.offset = offset
	}

	def gen(node: ASTMethodDecl, offset: Int){
		//fix the offset's of the var decls
		//set the v offset to some number
		node.offset = offset;

		var form_offset: Int = 3;
		for(form <- node.forms){
			gen(form, form_offset);
			form_offset = form_offset + 1;
		}
	}

	def gen(node: ASTVarDecl, offset: Int){
			node.offset = offset;
	}
}
