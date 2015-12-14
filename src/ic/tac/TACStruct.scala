package ic.tac

import ic.ast._;

abstract class TACInstr(line: Int, comment: String){
  val com = comment;
  
  override def equals(o : Any) = {
    o.isInstanceOf[AnyRef] && (this eq o.asInstanceOf[AnyRef]);
  }
}
abstract class TACBranch(line: Int, comment: String) extends TACInstr(line, comment);
abstract class TACCall(line: Int, comment: String) extends TACInstr(line, comment);
abstract class TACMove(line: Int, comment: String) extends TACInstr(line, comment);
abstract class TACRunTimeCheck(line: Int, comment: String) extends TACInstr(line, comment)

abstract class TACOp(val line: Int, comment: String){}

case class TAComment(comment: String, line: Int = 0) extends TACInstr(line, comment){
  override def toString(): String = {comment;}
}

/*
 * Used in TAC->AbsASM generator to mark the beginning of an instruction right after the
 * frame pointer has been set.
 */ 
case class TAC_Preamble(formals : List[ASTVarDecl], line : Int) extends TACInstr(line, "");

//Branching, control flow
case class TAC_Label(label: String, line: Int, comment: String) extends TACBranch(line, comment){
  override def toString(): String = {label + ":";}
}
case class TAC_Jump(label: TAC_Label, line: Int, comment: String) extends TACBranch(line, comment){
  override def toString(): String = {"jump " + label;}
}
case class TAC_CJump(label: TAC_Label, condition: TACOp, line: Int, comment: String) extends TACBranch(line, comment){
  override def toString(): String = {"cjump " + label;}
}
case class TAC_RET(value: Option[TACOp], line: Int, comment: String) extends TACBranch(line, comment){
  override def toString(): String = {
    value match {
      case Some(x) => { "return " + x; }
      case None => {"return";}
    }
  }
}


// dst = Length array
case class TAC_Length(dst: TACOp, array: TACOp, line: Int, comment: String) extends TACInstr(line, comment){
  override def toString(): String = {dst + " = " + array + ".length";}
}

// dst = new class
case class TAC_NewClass(dst: TACOp, decl: ASTClassDecl, line: Int, comment: String) extends TACCall(line, comment){
  override def toString(): String = {dst + " = new " + decl.cls_id + "()";}
}

//Calls
case class TACCall_VirCall(dst: Option[TACOp], receiver: TACOp, decl: ASTMethodDecl, paramList: List[TACOp], line: Int, comment: String) extends TACCall(line, comment){
  override def toString(): String = {
    dst match {
      case Some(x) => {x + " = " + receiver + "." + decl.id + "(" + paramList.mkString + ")"; }
      case None => {receiver + "." + decl.id + "(" + paramList.mkString + ")"; }
    }
  }
}
case class TACCall_LibCall(store: Option[TACOp], op: String, params: List[TACOp], line: Int, comment: String) extends TACCall(line, comment){
    override def toString(): String = {
    store match {
      case Some(x) => {x + " = Library." + op + "(" + params.mkString + ")"; }
      case None => {"Library." + op + "(" + params.mkString + ")"; }
    }
  }
}

//Movement, load store, copy
case class TAC_Copy(dst: TACOp, src: TACOp, line: Int, comment: String) extends TACMove(line, comment){
  override def toString(): String = {dst + " = " + src;}
}
case class TAC_ArrayStore(array: TACOp, index: TACOp, value: TACOp, line: Int, comment: String) extends TACMove(line, comment){
  override def toString(): String = {array + "[" + index + "]" + " = " + value;}
}
case class TAC_FieldStore(receiver: TACOp, field: ASTFieldDecl, value: TACOp, line: Int, comment: String) extends TACMove(line, comment){
  override def toString(): String = {receiver + "." + field.id + " = " + value;}
}
case class TAC_ArrayLoad(dst: TACOp, array: TACOp, index: TACOp, line: Int, comment: String) extends TACMove(line, comment){
  override def toString(): String = {dst + " = " + array + "[" + index + "]";}
}
case class TAC_FieldLoad(dst: TACOp, receiver: TACOp, field: ASTFieldDecl, line: Int, comment: String) extends TACMove(line, comment){
  override def toString(): String = {dst + " = " + receiver + "." + field.id;}
}

//Binary operations
case class TAC_BinOp(dst: TACOp, lExpr: TACOp, rExpr: TACOp, binop: ASTBinOp, line: Int, comment: String) extends TACInstr(line, comment){
  override def toString(): String = {dst + " = " + lExpr + " " + binop + " " + rExpr;}
}

//Unops
case class TAC_UnOp(dst: TACOp, expr: TACOp, unop: ASTUnOp, line: Int, comment: String) extends TACInstr(line, comment){
  override def toString(): String = {dst + " = " + unop + expr;}
}

//Run time checks
case class TAC_NullCheck(oject: TACOp, line: Int, comment: String) extends TACRunTimeCheck(line, comment){
  override def toString(): String = {"Null check " + oject;}
}
case class TAC_IndexInBounds(array: TACOp, index: TACOp, line: Int, comment: String) extends TACRunTimeCheck(line, comment){
  override def toString(): String = {"Check if " + index + " in bounds " + array;}
}
case class TAC_DivBy0(divisor: TACOp, line: Int, comment: String) extends TACRunTimeCheck(line, comment){
  override def toString(): String = {"Divide by 0 check " + divisor;}
}
case class TAC_GreaterThan0(index: TACOp, line: Int, comment: String) extends TACRunTimeCheck(line, comment){
  override def toString(): String = {"Greater than 0 check " + index;}
}

//TACOP's
case class TAC_Var(decl: ASTVarDecl, override val line: Int, comment: String) extends TACOp(line, comment){
  override def toString(): String = decl.toString();
  override def hashCode() = decl.hashCode;
  override def equals(o: Any): Boolean = {
    o.isInstanceOf[TAC_Var] && (decl == o.asInstanceOf[TAC_Var].decl);
  }
}
case class TAC_Lit(lit_node: ASTLiteral,  override val line: Int, comment: String) extends TACOp(line, comment){
  override def toString(): String = lit_node.toString();
  
  override def equals(o: Any): Boolean = {
    o.isInstanceOf[TAC_Lit] && (lit_node == o.asInstanceOf[TAC_Lit].lit_node);
  }
}
case class TAC_Temp(name: String, val offset: Int, override val line: Int, comment: String) extends TACOp(line, comment){
  override def toString(): String = name;
  override def hashCode() = name.hashCode;
  override def equals(o: Any): Boolean = {
    o.isInstanceOf[TAC_Temp] && (name.equals(o.asInstanceOf[TAC_Temp].name));
  }
}


class TACList(t_size: Int){
  // start from the size after the local vars have been allocated
  var list = List[TACInstr]();
  var tempCount = 0;

  def add(t:TACInstr){
    list = list :+ t;
  }

  def alloc(line: Int): TAC_Temp = {
    val t = new TAC_Temp("t"+tempCount, (-1*(t_size+tempCount)), line, "Allocate t"+tempCount);
    tempCount = tempCount + 1;
    return t;
  }
  
  def size(): Int = {
    return tempCount + t_size; 
  }
}
