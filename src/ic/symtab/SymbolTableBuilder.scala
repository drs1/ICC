package ic.symtab;
import ic.ast._;
import ic.error._;

//Build the symbol tables for the given program allowing scoping rules to be enforced.
//Pattern matches on different ASTNodes and either adds it to the passed scope or
//builds a new scope and recurses on its variables.
object SymbolTableBuilder {
  def buildSymbols(current: SymbolTable, node: ASTNode): Unit ={
    
    node.scope = current;
    
    node match{
      case n: ASTProgram => {
	for(classDecl <- n.classes){
	  buildSymbols(current, classDecl);
	}
      }
      
      case n: ASTClassDecl => {
	val parent = n.ext match{
	  case Some(x) => {
	    buildSymbols(current, x);
	    x.decl = current.getClassDecl(x.cls_id) match{
	      case Some(x) => x;
	      case None => throw new SemanticError("Couldn't resolve extended class "+n.cls_id+" on line "+n.line);
	    }
	    x.decl.bodyScope;
	  }
	  case None => current
	}
	n.bodyScope = new SymbolTable("Class Decl"+ n.cls_id, Some(parent));
	
	//add "this"
	val thisID = new ASTTypeClass(n.cls_id, n.line);
	//resolve pointers for the new node
	thisID.decl = n
	current.add(n.cls_id, n);	
	buildSymbols(current, thisID);
	
	//Create this instance, which always has offset 2
	val t = new ASTVarDecl(thisID, "this", None, false, n.line);
	t.offset = 2;
	n.bodyScope.add("this", t);

	for(decl <- n.decls) {
	  buildSymbols(n.bodyScope, decl);
	}
      }
      
      case n: ASTMethodDecl => {
        current.add(n.id, n);
	      val scope = new SymbolTable(n.id + "Method Decl", Some(current));
	      for(formal <- n.forms) {
	        buildSymbols(scope, formal);
	      }
	      buildSymbols(scope, n._type);
	      buildSymbols(scope, n.block);
      }

      case n: ASTFieldDecl => {
        buildSymbols(current, n._type);
	      current.add(n.id, n);
//	      for(id <- n.id_list){
//	        current.add(id, n);
//	      }
      }
      
      case n: ASTBlock => {
	val scope = new SymbolTable("Block at line "+n.line, Some(current));
	for(varDecl <- n.decls){
	  buildSymbols(scope, varDecl);
	}
	for(stmtDecl <- n.stmts){
	  buildSymbols(scope, stmtDecl);
	}
      }
      
      case n: ASTVarDecl => {
        buildSymbols(current, n._type);
	current.add(n.id, n);
	n.optExpr match {
	  case Some(x) => {
	    current.parent match {
	      case Some(y) => buildSymbols(y, x);
	      case None => throw new SemanticError("Can't use variable in same scope as it is declared on line: "+n.line);
	    }
	  }
	  case None => {}
	}
      }
      
      case n: ASTStmtLoc => {
        buildSymbols(current, n.loc);
        buildSymbols(current, n.expr);
      }
      
      case n: ASTStmtCall => {
        buildSymbols(current, n.call);
      }
      
      case n: ASTStmtRet => {
        n.optExpr match {
          case Some(x) => buildSymbols(current, x);
          case None => {}
        }
      }
      
      case n: ASTStmtIf => {
        buildSymbols(current, n.test);
        buildSymbols(current, n.cond);
        n.opElse match {
          case Some(x) => buildSymbols(current, x)
          case None => {}
        }
      }
      
      case n: ASTStmtWhile => {
        buildSymbols(current, n.test);
        buildSymbols(current, n.stmt);
      }
      
      case n: ASTStmtBlock => {
        buildSymbols(current, n.block);  
      }
      
      case n: ASTExprArray => {
        buildSymbols(current, n._type);
        buildSymbols(current, n.expr);
      }
      
      case n: ASTExprLen => {
        buildSymbols(current, n.expr);
      }
      
      case n: ASTExprBinop => {
        buildSymbols(current, n.lExpr);
        buildSymbols(current, n.rExpr);
      }
      
      case n: ASTExprUnop => {
        buildSymbols(current, n.expr);
      }
      
      case n: ASTLibCall => {
        for (op <- n.opList){   
          buildSymbols(current, op);
        }
      }
      
      case n: ASTVirtualCall => {
        buildSymbols(current, n.opExpr);
        for (param <- n.params) {
          buildSymbols(current, param);
        }
      }
      
      case n: ASTFieldAccess => {
        buildSymbols(current, n.receiver);
      }
      
      case n: ASTArrayAccess => {
        buildSymbols(current, n.array);
        buildSymbols(current, n.index);
      }

      case n: ASTLiteralString => {}
      case n: ASTLiteralInt => {}
      case n: ASTLiteralBool => {}
      case n: ASTVarAccess => {}
      case n: ASTStmtBreak => {}
      case n: ASTTypeVoid => {}
      case n: ASTTypeArray => buildSymbols(current, n._type)
      case n: ASTTypeString => {}
      case n: ASTTypeBool => {}
      case n: ASTTypeNull => {}
      case n: ASTLiteralNull => {}
      case n: ASTStmtCont => {}
      case n: ASTTypeClass => {}
      
      case nc @ ASTExprNewClass(_,_) => {}
      
      case i @ ASTTypeInt(_) =>{}
      
    }
  }
}
