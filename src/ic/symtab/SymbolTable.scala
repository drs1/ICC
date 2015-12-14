package ic.symtab;
import ic.ast._;
import ic.error._;

//Holds information for a given scope in a program including all local variables
//and its parent scope
class SymbolTable (val description: String, val parent: Option[SymbolTable]){
  
  //Distinguish between different types of ASTNodes
  var classMap: Map[String, ASTClassDecl] = Map();
  var methodMap: Map[String, ASTMethodDecl] = Map();
  var fieldMap: Map[String, ASTFieldDecl] = Map();
  var varMap: Map[String, ASTVarDecl] = Map();
    
  def add(id: String, d: ASTClassDecl): Unit = {
    classMap.get(id) match{
      case Some(x) => throw new SemanticError("Cannot redeclare class "+ id +" on line: "+d.line); 
      case None => classMap += (id -> d);
    }
  }
  def add(id: String, d: ASTMethodDecl): Unit = {
    methodMap.get(id) match{
      case Some(x) => throw new SemanticError("Method "+ id +" already declared"); 
      case None => methodMap += (id -> d);
    }
  }
  
  // make sure that field decl isn't already defined in super class
  def add(id: String, d: ASTFieldDecl): Unit = {
    getFieldDecl(id) match{
      case Some(x) => throw new SemanticError("Field "+ id +" already declared");
      case None => fieldMap += (id -> d);
    }
  }
  
  //Distinguishes between Formal parameters and variables
  //Formal parameters are not allowed to be redefined
  def add(id: String, d: ASTVarDecl): Unit = {
    if(varMap.keySet.contains(id))
      throw new SemanticError("Variable "+id+" already declared");
    else{
      getVarDecl(id) match {
        case Some(x) => {
      	  if(!x.isParam)
  	        varMap += (id -> d)
	        else 
	          throw new SemanticError("Vairable "+id+" already defined as a formal parameter");
          }
	       case None => varMap += (id -> d);
      }
    }
  }
  
  def getClassDecl(id: String): Option[ASTClassDecl] = {
    return classMap.get(id) match{
      case Some(x) => Some(x);
      case None => {
      	parent match{
	        case Some(p) => p.getClassDecl(id);
	        case None => None;
	      }    
      }
    }
  }

  def getMethodDecl(id: String): Option[ASTMethodDecl] = {
    return methodMap.get(id) match{
      case Some(x) => Some(x);
      case None => {
	parent match{
	  case Some(p) => p.getMethodDecl(id);
	  case None => None;
	}
      }
    }
  }
  def getFieldDecl(id: String): Option[ASTFieldDecl] = {
    return fieldMap.get(id) match{
      case Some(x) => Some(x);
      case None => {
	      parent match{
	        case Some(p) => p.getFieldDecl(id);
	        case None => None;
	      }
      }
    }
  }

  def getVarDecl(id: String): Option[ASTVarDecl] = {
    return varMap.get(id) match{
      case Some(x) => Some(x);
      case None => {
	      parent match{
	        case Some(p) => p.getVarDecl(id);
	        case None => None;
	      }
      }
    }
  }
  
  override def toString(): String = {
    val scopeStr: String = "Scope: " + description + "\n";
    val classStr: String = "Classes: " + classMap.keySet.mkString(", ") + "\n";
    val methodStr: String = "Methods: " + methodMap.keySet.mkString(", ") + "\n";
    val fieldStr: String = "Fields: " + fieldMap.keySet.mkString(", ") + "\n";
    val varStr: String = "Variables: " + varMap.keySet.mkString(", ") + "\n"
    val parentStr: String = parent match {
      case Some(x) => "Parent: " + x.description;
      case None => "Parent: None";
    } 
    scopeStr + classStr + methodStr + fieldStr + varStr + parentStr;
  }
  
  def getParent(): Option[SymbolTable] = {
    parent;
  }
}
