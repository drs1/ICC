package ic.symtab;
import ic.ast._;
import ic.error._;

//Takes an ASTNode and checks to see if it is a valid reference in its scope
object NameResolver{
  def resolve(node: ASTNode){
    node match{
      case p @ ASTProgram(classes: List[ASTClassDecl], line: Int) => {
        for(decl <- classes){
          resolve(decl)
        }
      }

     case c @ ASTClassDecl(cls_id: String, ext: Option[ASTTypeClass], decls: List[ASTDecl], line: Int) => {
       //resolve the extended type class
       ext match {
         case Some(x) => resolve(x)
         case None => {}
       }
       for(decl <- decls) {
          resolve(decl)
        }
      }
     
      case m @ ASTMethodDecl(_type: ASTType, id: String, formals: List[ASTVarDecl], block: ASTBlock, line: Int) => {
          for(decl <- formals){
            resolve(decl)
          }
          resolve(_type)
          resolve(block)
      }

      case f @ ASTFieldDecl(_type: ASTType, id: String /*, id_list: List[String]*/, line: Int) => {
        resolve(_type);
      }

      case c @ ASTTypeClass(cls_id: String, line: Int) => {
        c.decl = c.scope.getClassDecl(cls_id) match {
          case Some(x) => x;
          case None => throw new SemanticError("No class of name " + cls_id + " found in scope");
         }
      }

      case b @ ASTBlock(decls: List[ASTVarDecl], stmts: List[ASTStmt], line: Int) => {
          for(varDecl <- decls){
            resolve(varDecl)
          }
          for(stmtDecl <- stmts){
            resolve(stmtDecl)
          }
      }

      case v @ ASTVarDecl(_type: ASTType, id: String, optExpr: Option[ASTExpr], isParam: Boolean, line: Int) => {
        optExpr match {
          case Some(x) => resolve(x)
          case None => {}
        }
        resolve(_type);
      }
     
      case v @ ASTVarAccess(id: String, line: Int) => {
          findAccess(v);
      }

      case l @ ASTLocalAccess(id: String, line: Int)=> {
          l.decl = l.scope.getVarDecl(id) match {
            case Some(x) => x;
            case None => throw new SemanticError("No local variable "+ id +" in scope");
          }
      }

      case f @ ASTFieldAccess(receiver: ASTExpr, id: String, line: Int) => {
	resolve(receiver)
      }

      case a @ ASTArrayAccess(array: ASTExpr, index: ASTExpr, line: Int) => {
        resolve(array);
        resolve(index);
      }
   
      case l @ ASTStmtLoc(loc: ASTLoc, expr: ASTExpr, line: Int) => {
        resolve(loc);
        resolve(expr);
      }
     
      case c @ ASTStmtCall(call: ASTCall, line: Int) => {
        resolve(call);
      }
     
      case r @ ASTStmtRet(optExpr: Option[ASTExpr], line: Int) => {
        optExpr match {
          case Some(x) => resolve(x);
          case None => {}
        }
      }
     
      case i @ ASTStmtIf(test: ASTExpr, cond: ASTStmt, opElse: Option[ASTStmt], line: Int) => {
        resolve(test);
        resolve(cond);
        opElse match {
          case Some(x) => resolve(x)
          case None => {}
        }
      }
     
      case b @ ASTStmtBlock(block: ASTBlock, line: Int) => {
        resolve(block); 
      }

      case b @ ASTStmtBreak(line: Int) => {}
      case c @ ASTStmtCont(line: Int) => {}      

      case w @ ASTStmtWhile(test: ASTExpr, stmt: ASTStmt, line: Int) => {
      	resolve(test);
      	resolve(stmt);
      }

      case a @ ASTTypeArray(_type: ASTType, line: Int) => {
        resolve(_type);
      }
     
      case e @ ASTExprArray(_type: ASTType, expr: ASTExpr, line: Int) => {
        resolve(_type);
        resolve(expr);
      }
     
      case l @ ASTExprLen(expr: ASTExpr, line: Int) => {
        resolve(expr);
      }
     
      case eb @ ASTExprBinop(lexpr: ASTExpr, binop: ASTBinOp, rexpr: ASTExpr, line: Int) => {
        resolve(lexpr);
        resolve(rexpr);
      }
     
      case eu @ ASTExprUnop(unop: ASTUnOp, expr: ASTExpr, line: Int) => {
        resolve(expr);
      }
     
      case lc @ ASTLibCall(id: String, opList: List[ASTExpr], line: Int) => {
        for (op <- opList){  
          resolve(op);
        }
      }
     
      case vc @ ASTVirtualCall(opExpr: ASTExpr, id: String, params: List[ASTExpr], line:Int) => {
        resolve(opExpr);
        for (param <- params) {
          resolve(param)
        }
      }
      
      case nc @ ASTExprNewClass(cls_id: String, line: Int) => {
        //set the _type of the new class to be the class of the var decl
        nc._type = nc.scope.getClassDecl(cls_id) match {
          case Some(x) => x.c_type
          case None => throw new SemanticError("No class type " + cls_id + " in scope");
        }        
      }

      case i: ASTTypeVoid => {}
      case i: ASTTypeInt => {}
      case i: ASTTypeString => {}
      case i: ASTTypeBool => {}
      case i: ASTTypeNull => {}

      case n: ASTLiteralString => {}
      case n: ASTLiteralInt => {}
      case n: ASTLiteralBool => {}
      case n: ASTLiteralNull => {}
    }
  }

  def findAccess(node: ASTVarAccess): Unit = {
    val opNode: Option[ASTNode] = node.scope.getVarDecl(node.id);
    opNode match {
      case Some(x) => {
        val local = new ASTLocalAccess(node.id, node.line);
        local.scope = node.scope;
        resolve(local)
        node.resolved = local;
      }
      case None => {
        val rec = new ASTLocalAccess("this", node.line);
        rec.scope = node.scope;
        resolve(rec)
        val fa = new ASTFieldAccess(rec, node.id, node.line);  
	      fa.scope = node.scope;
        node.resolved = fa
      }
    }
  }
}
