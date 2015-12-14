package ic.error;
import java_cup.runtime.Symbol;

//An error class that passes up the token the error occurred on and a message

class SyntaxError(val token: Symbol, val message: String) extends Error(message) {
}
