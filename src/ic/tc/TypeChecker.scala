package ic.tc

import ic.error._
import ic.ast._;

object TypeChecker {
  
  //Map that matches library methods to a tuple containing their list of parameters and
  //their return type
  val libMap: Map[String, Tuple2[List[ASTType], ASTType]] = Map(
      "println" -> (List(new ASTTypeString(0)), new ASTTypeVoid(0)), 
      "print" -> (List(new ASTTypeString(0)), new ASTTypeVoid(0)),
      "printi" -> (List(new ASTTypeInt(0)), new ASTTypeVoid(0)),
      "printb" -> (List(new ASTTypeBool(0)), new ASTTypeVoid(0)),
      "readi" -> (List(), new ASTTypeInt(0)),
      "readln" -> (List(), new ASTTypeString(0)),
      "eof" -> (List(), new ASTTypeBool(0)),
      "stoi" -> (List(new ASTTypeString(0), new ASTTypeInt(0)), new ASTTypeInt(0)),
      "itos" -> (List(new ASTTypeInt(0)), new ASTTypeString(0)),
      "stoa" -> (List(new ASTTypeString(0)), new ASTTypeArray(new ASTTypeInt(0), 0)),
      "atos" -> (List(new ASTTypeArray(new ASTTypeInt(0), 0)), new ASTTypeString(0)),
      "random" -> (List(new ASTTypeInt(0)), new ASTTypeInt(0)),
      "time" -> (List(), new ASTTypeInt(0)),
      "exit" -> (List(new ASTTypeInt(0)), new ASTTypeVoid(0)));
  
  //Type checks Expressions and returns its type
  def typeCheck(node: ASTExpr): ASTType = {
    node match {
      case nc @ ASTExprNewClass(cls_id: String, line: Int) => nc._type  
      
      //Checks that array is instantiated by an int
      case ea @ ASTExprArray(_type: ASTType, expr: ASTExpr, line: Int) => {
        val exprType: ASTType = typeCheck(expr);
        if(!isSubtypeOf(exprType, new ASTTypeInt(line)))
          throw new SemanticError("Can't define the length of an array with type " + exprType+" on line: "+line);
        new ASTTypeArray(_type, line);
      }
      
      //Checks that length is only applied to an array
      case l @ ASTExprLen(expr: ASTExpr, line: Int) => {
        if(!typeCheck(expr).isInstanceOf[ASTTypeArray])
          throw new SemanticError("Length can only be applied to arrays on line: "+line);
        new ASTTypeInt(line);
      }
      
      //Checks to make sure all possible binary operations are performed on correct types of
      //expressions
      case eb @ ASTExprBinop(lexpr: ASTExpr, binop: ASTBinOp, rexpr: ASTExpr, line: Int) => {
        val lType: ASTType = typeCheck(lexpr);
        val rType: ASTType = typeCheck(rexpr);
        binop match {
          //Check to make sure plus is applied to either two strings or two ints
          case i: BinPlus => {
            if(!binopStringStringString(lType, rType, eb)){
              i.plusType = binopIntIntInt(lType, rType, eb, "Can't apply binary plus to types "+lType+" and "+rType+" on line: "+line);
              i.plusType;
            } else{
              i.plusType = new ASTTypeString(0);
              i.plusType;
	          }
          }   
          case BinMinus() => {
            binopIntIntInt(lType, rType, eb, "Can't apply binary minus to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinMult() => {
            binopIntIntInt(lType, rType, eb, "Can't apply binary mult to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinDiv() => {
            binopIntIntInt(lType, rType, eb, "Can't apply binary div to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinMod() => {
            binopIntIntInt(lType, rType, eb, "Can't apply binary mod to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinAnd() => {
            binopBoolBoolBool(lType, rType, eb, "Can't apply binary and to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinOr() => {
            binopBoolBoolBool(lType, rType, eb, "Can't apply binary or to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinLt() => {
            binopIntIntBool(lType, rType, eb, "Can't apply binary < to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinLe() => {
            binopIntIntBool(lType, rType, eb, "Can't apply binary <= to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinGt() => {
            binopIntIntBool(lType, rType, eb, "Can't apply binary > to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinGe() => {
            binopIntIntBool(lType, rType, eb, "Can't apply binary >= to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinEqeq() => {
            binopTTBool(lType, rType, eb, "Can't apply binary == to types "+lType+" and "+rType+" on line: "+line);
          }
          case BinNe() => {
            binopTTBool(lType, rType, eb, "Can't apply binary != to types "+lType+" and "+rType+" on line: "+line);
          }
        }
      }
      
      //Checks to make sure unary operations are performed on correct types of
      //expressions (neg to int and not to bool) 
      case eu @ ASTExprUnop(unop: ASTUnOp, expr: ASTExpr, line: Int) => {
        val exprType: ASTType = typeCheck(expr);
        unop match {
          case UnNeg() => {
            assertType(exprType, new ASTTypeInt(line), "Can't apply unary negation on type "+exprType+" on line: "+line);
            new ASTTypeInt(line)
          }
          case UnNot() => {
            assertType(exprType, new ASTTypeBool(line), "Can't apply unary not on type "+exprType+" on line: "+line);
            new ASTTypeBool(line);
          }    
        }
      }
      
      //Beautiful Scala Code Going on Here.  Odersky would be proud.
      //Tests that a library call is applied to correct types of parameters
      case lc @ ASTLibCall(id: String, opList: List[ASTExpr], line: Int) => {
        libMap.get(id) match {
          case Some((args, ret)) => {
	          if(opList.length != args.length)
	            throw new SemanticError("Incorrect number of arguments to Library method "+id+" on line:" + line);
            for((i,j) <- opList zip args)
              if(!isSubtypeOf(typeCheck(i), j))
                throw new SemanticError("Library method "+id+" expected "+args+" found "+opList+" on line: "+line);
            ret;
          }
          case None =>  throw new SemanticError("Method "+id+" is not a valid Library call on line: "+line);
        }
      }
      
      //Tests that a method call is applied to correct types of parameters
      case vc @ ASTVirtualCall(opExpr: ASTExpr, id: String, params: List[ASTExpr], line:Int) => {
       //get the class decl
        val classDecl = typeCheck(opExpr) match {
          case classId: ASTTypeClass => {
            classId.decl
          }
          case _ => throw new SemanticError(opExpr.toString() + " must be a class to call a method on it.")         
        }
        //get the method decl for the method
        classDecl.bodyScope.getMethodDecl(id) match{
          case Some(x) => vc.decl = x;
          case None => throw new SemanticError("Method " + id + " is not defined on class " + classDecl.cls_id + " on line" + line);           
        }
        //check every parameter's type
        var index = 0;
        val forms = vc.decl.forms
        if(forms.size == params.size){
          for((i,j) <- params zip forms){
            val paramType: ASTType = typeCheck(i);
            assertType(typeCheck(i), j._type, "Parameter " + paramType + " is not a subtype of " + j._type+" on line "+line)
          }
        } else 
          throw new SemanticError("Method " + id + " does not have right number of parameters on line" + line);
        vc.decl._type;
      }
      
      case v @ ASTVarAccess(id: String, line: Int) => {
        typeCheck(v.resolved)
      }
      
      case f @ ASTFieldAccess(receiver: ASTExpr, id: String, line: Int) => {
	val receiverType = typeCheck(receiver)
	val receiverDecl = receiverType match{
	  case classID: ASTTypeClass => classID.decl
	  case _ => throw new SemanticError("Reciever must be a class to look up field " + id);
	}
	f.decl = receiverDecl.bodyScope.getFieldDecl(id) match{
	  case Some(x) => x
	  case None => throw new SemanticError("Field " +id+" not defined on class on line " + line);
	}
	f.decl._type
      }
      
      case l @ ASTLocalAccess(id: String, line: Int)=> {
        l.decl._type
      }
      
      //Checks we have types array and int and returns the type of the array
      case a @ ASTArrayAccess(array: ASTExpr, index: ASTExpr, line: Int) => {
        val arrayT = typeCheck(array);
        val indexT = typeCheck(index);
        arrayT match {
          case c: ASTTypeArray => {
            if(!isSubtypeOf(indexT, new ASTTypeInt(line))){
              throw new SemanticError("Can't apply an array access to types "+arrayT+" indexed by "+indexT+"on line: "+line);
	          } else {
	            val a: ASTTypeArray = arrayT.asInstanceOf[ASTTypeArray]
              a._type
	          }
          }
          case _ => {
            throw new SemanticError("Can't apply an array access to types "+arrayT+" indexed by "+indexT+"on line: "+line);
          }
        }
      }
      
      //Literals return their type
      case li @ ASTLiteralInt(i: Int, line: Int) => new ASTTypeInt(line);
      case ls @ ASTLiteralString(str: String, line: Int) => new ASTTypeString(line);
      case lb @ ASTLiteralBool(b: Boolean, line: Int) => new ASTTypeBool(line);
      case ln @ ASTLiteralNull(line: Int) => new ASTTypeNull(line);
    }
  }
  
  
  //Type checks Statements
  def typeCheck(node: ASTStmt, tNode: ASTType, inLoop: Boolean): Unit = {
    node match {
      case l @ ASTStmtLoc(loc: ASTLoc, expr: ASTExpr, line: Int) => {
        val locType: ASTType = typeCheck(loc);
        val exprType: ASTType = typeCheck(expr);
        if(!isSubtypeOf(exprType, locType))
          throw new SemanticError("Can't assign a value of type "+exprType+" to a location of type "+locType+" on line: "+line);
      }
      
      case c @ ASTStmtCall(call: ASTCall, line: Int) => {
        typeCheck(call);
      }
      
      //Check that the return type of matches the type of the method it appears in
      case r @ ASTStmtRet(optExpr: Option[ASTExpr], line: Int) => {
        optExpr match {
          case Some(x) =>{
            val xType: ASTType = typeCheck(x);
            if(!isSubtypeOf(xType, tNode)){
              throw new SemanticError("Invalid type "+xType+" for "+tNode+" method on line: "+line)
	          }
          }
          case None => { 
            if(!isSubtypeOf(tNode, new ASTTypeVoid(line))){
               throw new SemanticError("Invalid type "+tNode+" for void method on line: "+line)
	          }
          }
        }
      }
      
      //Checks that the test of the if statement is a bool 
      case i @ ASTStmtIf(test: ASTExpr, cond: ASTStmt, opElse: Option[ASTStmt], line: Int) => {
         if(!isSubtypeOf(typeCheck(test), new ASTTypeBool(line))){
           throw new SemanticError("Expression inside if statment must be of type bool on line: "+line);
	 }

        typeCheck(cond, tNode, inLoop);
        opElse match {
          case Some(x) => typeCheck(x, tNode, inLoop)
          case None => {}
        }
      }
      
      //Checks that the test of the while loop is a bool
      case w @ ASTStmtWhile(test: ASTExpr, stmt: ASTStmt, line: Int) => {
        if(!isSubtypeOf(typeCheck(test), new ASTTypeBool(line)))
          throw new SemanticError("Expression tested by while loop must be of type bool on line: "+line);
        typeCheck(stmt, tNode, true);
      }
      
      //Checks that break only occurs inside a loop
      case b @ ASTStmtBreak(line: Int) => {
        if(!inLoop){
          throw new SemanticError("Can't use the keyword \"break\" outside a loop on line: "+line);
	}
      }
      
      //Checks that continue only occurs inside a loop
      case c @ ASTStmtCont(line: Int) => {      
        if(!inLoop){
          throw new SemanticError("Can't use the keyword \"continue\" outside a loop on line: "+line);
	}
      }
      
      case b @ ASTStmtBlock(block: ASTBlock, line: Int) => {
        typeCheck(block, tNode, inLoop);  
      }
    }
  }
  
  //Type Checks all other nodes that are not statements or expressions
  def typeCheck(node: ASTNode, tNode: ASTType = new ASTTypeNull(0), inLoop: Boolean = false){
    node match {
      case p @ ASTProgram(classes: List[ASTClassDecl], line: Int) => {
      	for(classDecl <- classes){
      	  typeCheck(classDecl);
	}
      }
      
    case c @ ASTClassDecl(cls_id: String, ext: Option[ASTTypeClass], decls: List[ASTDecl], line: Int) => {
      for(decl <- decls) {
	typeCheck(decl);
      }
    }
      
    case m @ ASTMethodDecl(m_type: ASTType, id: String, formals: List[ASTVarDecl], block: ASTBlock, line: Int) => {
      typeCheck(block, m_type)
      m.scope.parent match {
        case Some(x) => {
          //if we have a parent, check to see if this method has been defined before
          x.getMethodDecl(id) match {
            case Some(y) => {
              //first check to see if same number of params
              if(y.forms.length != formals.length) {
                throw new SemanticError("Cannot redefine method " + id + " with a different number of parameters on line: " + line);
              }
              
              for((i,j) <- y.forms zip formals)
                if (!sameType(i._type, j._type))
                  throw new SemanticError("Cannot redefine method " + id + " with new parameter types on line: " + line);
              
              if (!sameType(y._type, m_type))
                throw new SemanticError("Cannot redefine method " + id + " with new return types on line: " + line)
            }
            case None => {}
          }
        }
        case None => {
          //then we are fine
        }
      }
    }

    case f @ ASTFieldDecl(_type: ASTType, id: String /*, id_list: List[String]*/, line: Int) => {}

    case b @ ASTBlock(decls: List[ASTVarDecl], stmts: List[ASTStmt], line: Int) => {
      for(varDecl <- decls){
	typeCheck(varDecl);
      }
      for(stmtDecl <- stmts){
	typeCheck(stmtDecl, tNode, inLoop);
      }
    }
      
    case v @ ASTVarDecl(_type: ASTType, id: String, optExpr: Option[ASTExpr], isParam: Boolean, line: Int) => {
      optExpr match {
	case Some(x) => {
	  val xtype = typeCheck(x)
	  if(!isSubtypeOf(xtype, _type)){

	    throw new SemanticError("Can't set the value of "+id+" to be "+xtype+" on line: "+line);
	  }
	}
	case None => {}
      }
    }
    }
  }
  
  
  //Helper methods of ExprBinop
  def binopStringStringString(lExpr: ASTType, rExpr: ASTType, node: ASTExpr): Boolean = {
    val str: ASTTypeString =  new ASTTypeString(0);
    if(isSubtypeOf(lExpr, str) && isSubtypeOf(rExpr, str)){
      return true;
    }
    return false;
  }
  
  def binopIntIntInt(lExpr: ASTType, rExpr: ASTType, node: ASTExpr, message: String): ASTType = {
    val intNode: ASTTypeInt = new ASTTypeInt(0);
    checkBinopExpr(lExpr, rExpr, intNode, intNode, node, message);
  }
  
  def binopIntIntBool(lExpr: ASTType, rExpr: ASTType, node: ASTExpr, message: String): ASTType = {
    checkBinopExpr(lExpr, rExpr, new ASTTypeInt(0), new ASTTypeBool(0), node, message);
  }
  
  def binopBoolBoolBool(lExpr: ASTType, rExpr: ASTType, node: ASTExpr, message: String): ASTType = {
    val boolNode = new ASTTypeBool(0);
    checkBinopExpr(lExpr, rExpr, boolNode, boolNode, node, message);
  }
  
  def binopTTBool(lExpr: ASTType, rExpr: ASTType, node: ASTExpr, message: String): ASTType = {
     if(isSubtypeOf(lExpr, rExpr) || isSubtypeOf(rExpr, lExpr))
       new ASTTypeBool(0);
     else 
       throw new SemanticError(message);
  }
  
  def checkBinopExpr(lExpr: ASTType, rExpr: ASTType, expected: ASTType, output: ASTType, node: ASTExpr, message: String): ASTType = {
    assertType(lExpr, expected, message);  
    assertType(rExpr, expected, message);
    output;
  }
  
  def assertType(actual: ASTType, expected: ASTType, message: => String): Unit = {
    if(!isSubtypeOf(actual, expected)){ 
      throw new SemanticError(message);
    }
  }
  
  //Returns whether a is a subtype of b
  def isSubtypeOf(a: ASTType, b: ASTType): Boolean = {
    (a, b) match {
      case (ASTTypeVoid(_), ASTTypeVoid(_)) => true;
      case (ASTTypeInt(_), ASTTypeInt(_)) => true;
      case (ASTTypeBool(_), ASTTypeBool(_)) => true;
      case (ASTTypeString(_), ASTTypeString(_)) => true;
      case (a @ ASTTypeClass(idA, lineA), b @ ASTTypeClass(idB, lineB)) => {
        //we need to follow ClassDecl -> SymbolTable
          if (a.cls_id == b.cls_id) {
            return true;
          }
          a.decl.ext match {
            case Some(x) =>
              //if we extend B, then we are a subclass, otherwise look what B extends
              return ((x.cls_id == b.cls_id) || (isSubtypeOf(x, b)))
            case None => false
          }
      }
      case (ASTTypeArray(typeA, lineA), ASTTypeArray(typeB, lineB)) => sameType(typeA, typeB);
      case (ASTTypeNull(_), ASTTypeNull(_)) => true;
      case (ASTTypeNull(_), ASTTypeArray(_, _)) => true;
      case (ASTTypeNull(_), ASTTypeString(_)) => true;
      case (ASTTypeNull(_), ASTTypeClass(_, _)) => true;
      case _ => false;
    }
  }
    
   //helper method for ASTArray
   def sameType(a: ASTType, b: ASTType): Boolean = {
      (a, b) match {
        case (ASTTypeVoid(_), ASTTypeVoid(_)) => true;
        case (ASTTypeInt(_), ASTTypeInt(_)) => true;
        case (ASTTypeBool(_), ASTTypeBool(_)) => true;
        case (ASTTypeString(_), ASTTypeString(_)) => true;
        case (ASTTypeClass(idA, lineA), ASTTypeClass(idB, lineB)) => idA==idB;
        case (ASTTypeArray(typeA, lineA), ASTTypeArray(typeB, lineB)) => sameType(typeA, typeB);
        case (ASTTypeNull(_), ASTTypeNull(_)) => true;
        case _ => false;
     }
   }
}
