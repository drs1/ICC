package ic.lex;

import java_cup.runtime.Symbol;

/**
 * Just a simple extension to the Symbol class from
 * CUP.  
 */
class Token(id : Int, value : Object, line : Int) extends Symbol(id,line,line,value) {
	
	override def toString() = {
		"[" + this.sym + "," + this.value + "," + this.left + "]";
	}
}
