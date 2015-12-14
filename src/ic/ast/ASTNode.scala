// (c) 2015 drsmith bijan jcf1
package ic.ast

import ic.lex._;
import ic.symtab._;
import ic.tac._;

//Case classes for the required nodes of the Abstract Syntax Tree for the program
//Each holds a SymbolTable pointer to check its scope

//All Abstract Node Types
abstract class ASTNode(line: Int) {
    var scope: SymbolTable = null;
}
abstract class ASTDecl(_type: ASTType, id: String, line: Int) extends ASTNode(line){};
abstract class ASTType(line: Int) extends ASTNode(line){}
abstract class ASTStmt(line: Int) extends ASTNode(line){};
abstract class ASTExpr(line: Int) extends ASTNode(line){};
abstract class ASTCall(line: Int) extends ASTExpr(line){}
abstract class ASTLoc(line: Int) extends ASTExpr(line){};
abstract class ASTBinOp{};
abstract class ASTUnOp{};
abstract class ASTLiteral(line: Int) extends ASTExpr(line){};

//Root Node
case class ASTProgram(classes: List[ASTClassDecl], line: Int) extends ASTNode(line){}

//Class declaration Node
case class ASTClassDecl(cls_id: String, ext: Option[ASTTypeClass], decls: List[ASTDecl], line: Int) extends ASTNode(line){
  override def toString(): String = cls_id;  
  var bodyScope: SymbolTable = null;
  var c_type = new ASTTypeClass(cls_id, line)
  c_type.decl = this 
  var size = 0;
  var f_size = 0;
  var v_size = 0;
}

//Decl Nodes

// not the best -- id should be part of id_list
class ASTFieldDeclWithList(_type: ASTType, id_list: List[String], line: Int) {
  def toDecls() : List[ASTDecl] = {
    id_list map (x => ASTFieldDecl(_type, x, line))
  }
}

case class ASTFieldDecl(_type: ASTType, id: String, line: Int) extends ASTDecl(_type, id, line){
  override def toString(): String = id;
  var offset: Int = 0;
}

case class ASTMethodDecl(_type: ASTType, id: String, forms: List[ASTVarDecl], block: ASTBlock, line: Int) extends ASTDecl(_type, id, line){
  override def toString(): String = id;
  var tacList: TACList = null;
  var offset: Int = 0;
}

//Type Nodes: ASTSType is any non array type
case class ASTTypeVoid(line: Int) extends ASTType(line){}
case class ASTTypeInt(line: Int) extends ASTType(line){}
case class ASTTypeBool(line: Int) extends ASTType(line){}
case class ASTTypeString(line: Int) extends ASTType(line){}
case class ASTTypeNull(line: Int) extends ASTType(line){}
case class ASTTypeClass(cls_id: String, line: Int) extends ASTType(line){
   var decl: ASTClassDecl = null;
}
case class ASTTypeArray(_type: ASTType, line: Int) extends ASTType(line){}

//Block node that creates a new scope
case class ASTBlock(decls: List[ASTVarDecl], stmts: List[ASTStmt], line: Int) extends ASTNode(line){
  override def toString(): String = "Block line " + line;
  var local_size = 0;
}

//Variable declare node
case class ASTVarDecl(_type: ASTType, id: String, optExpr: Option[ASTExpr], isParam: Boolean, line: Int) extends ASTNode(line){
  override def toString(): String = id;
  var offset = 0;
}
//Partial Var Decls for making ;lists of var decls
case class ASTPartialVarDecl(val id: String, val expr: Option[ASTExpr], val line: Int) extends ASTNode(line){}

//Stmt Nodes
case class ASTStmtLoc(loc: ASTLoc, expr: ASTExpr, line: Int) extends ASTStmt(line) {}
case class ASTStmtCall(call: ASTCall, line: Int) extends ASTStmt(line) {}
case class ASTStmtRet(optExpr: Option[ASTExpr], line: Int) extends ASTStmt(line) {}
case class ASTStmtIf(test: ASTExpr, cond: ASTStmt, opElse: Option[ASTStmt], line: Int) extends ASTStmt(line) {}
case class ASTStmtWhile(test: ASTExpr, stmt: ASTStmt, line: Int) extends ASTStmt(line) {}
case class ASTStmtBreak(line: Int) extends ASTStmt(line) {}
case class ASTStmtCont(line: Int) extends ASTStmt(line) {}
case class ASTStmtBlock(block: ASTBlock, line: Int) extends ASTStmt(line) {}

//Expr Nodes
case class ASTExprNewClass(cls_id: String, line: Int) extends ASTExpr(line){
  var _type: ASTTypeClass = null;  
}

case class ASTExprArray(_type: ASTType, expr: ASTExpr, line: Int) extends ASTExpr(line){}
case class ASTExprLen(expr: ASTExpr, line: Int) extends ASTExpr(line){}
case class ASTExprBinop(lExpr: ASTExpr, binop: ASTBinOp, rExpr: ASTExpr, line: Int) extends ASTExpr(line){}
case class ASTExprUnop(unop: ASTUnOp, expr: ASTExpr, line: Int) extends ASTExpr(line){}

//Call Nodes
case class ASTLibCall(id: String, opList: List[ASTExpr], line: Int) extends ASTCall(line){}
case class ASTVirtualCall(opExpr: ASTExpr, id: String, params: List[ASTExpr], line:Int) extends ASTCall(line){
  var decl: ASTMethodDecl = null;
}

//Location Nodes
//Need a decl node to point to where the variable was declared for name resolution and type checking
case class ASTVarAccess(id: String, line: Int) extends ASTLoc(line){
  var resolved: ASTLoc = null;
}
case class ASTFieldAccess(receiver: ASTExpr, id: String, line: Int) extends ASTLoc(line){
  var _type: ASTType = null;
  var decl: ASTFieldDecl = null;
}
case class ASTLocalAccess(id: String, line: Int) extends ASTLoc(line){
  var decl: ASTVarDecl = null;
}
case class ASTArrayAccess(array: ASTExpr, index: ASTExpr, line: Int) extends ASTLoc(line){}

//Binary Operation
case class BinPlus() extends ASTBinOp {
  var plusType: ASTType = null;
  override def toString(): String = {"+";}
}
case class BinMinus() extends ASTBinOp {
  override def toString(): String = {"-";}
}
case class BinMult() extends ASTBinOp {
  override def toString(): String = {"*";}
}
case class BinDiv() extends ASTBinOp {
  override def toString(): String = {"/";}
}
case class BinMod() extends ASTBinOp {
  override def toString(): String = {"%";}
}
case class BinAnd() extends ASTBinOp {
  override def toString(): String = {"&&";}
}
case class BinOr() extends ASTBinOp {
  override def toString(): String = {"||";}
}
case class BinLt() extends ASTBinOp {
  override def toString(): String = {"<";}
}
case class BinLe() extends ASTBinOp {
  override def toString(): String = {"<=";}
}
case class BinGt() extends ASTBinOp {
  override def toString(): String = {">";}
}
case class BinGe() extends ASTBinOp {
  override def toString(): String = {">=";}
}
case class BinEqeq() extends ASTBinOp {
  override def toString(): String = {"==";}
}
case class BinNe() extends ASTBinOp {
  override def toString(): String = {"!=";}
}

//Unary Operation
case class UnNeg() extends ASTUnOp {
  override def toString(): String = {"-";}
}
case class UnNot() extends ASTUnOp {
  override def toString(): String = {"!";}
}

//Literal Nodes
case class ASTLiteralInt(i: Int, line: Int) extends ASTLiteral(line){
  override def toString(): String = i.toString();
  def equals(other: ASTLiteral): Boolean = {
    other match {
      case ASTLiteralInt(j, _) => i == j
      case _ => false
    }
  }
}
case class ASTLiteralString(s: String, line: Int) extends ASTLiteral(line){
  override def toString(): String = s;
  def equals(other: ASTLiteral): Boolean = {
    other match {
      case ASTLiteralString(j, _) => s == j
      case _ => false
    }
  }
}
case class ASTLiteralBool(b: Boolean, line: Int) extends ASTLiteral(line){
  override def toString(): String = "\"" + b.toString() + "\"";
  def equals(other: ASTLiteral): Boolean = {
    other match {
      case ASTLiteralBool(j, _) => b == j
      case _ => false
    }
  }
}
case class ASTLiteralNull(line: Int) extends ASTLiteral(line){
  override def toString(): String = "null";
  def equals(other: ASTLiteral): Boolean = {
    other match {
      case ASTLiteralNull(_) => true
      case _ => false
    }
  }
}

