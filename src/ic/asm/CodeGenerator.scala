package ic.asm

import ic.ast._
import scala.collection.mutable.HashMap



/**
 * A CodeGenerator takes a program's AST and source file name and produces
 * an assmebly code file.  
 * 
 * Subclasses can target different architectures.
 */
abstract class CodeGenerator(val icFileName : String, val program : ASTProgram) {
  
  /*
   * Do all the work to generate the .s file.
   */
  def generate() : Unit;
  
}

object CodeGenerator {
  
  /* STRING CONSTANTS */
  /**
   * A map from string constant to the assembly code label in
   * the data segment where that constant is stored.  See the
   * labelForStringConstant method.
   */
  val stringConstantsToLabel: HashMap[String, String] = new HashMap[String, String]();

  /*
   * Return a unique label for a string constant.  After
   * translating all code and getting labels for all string
   * constants, the code generator will print out a data segment
   * containing the labels and string constants.  The string may
   * contain only the following escape characters: \n, \r, \t.
   */
  def labelForStringConstant(stringConstant: String): String = {
    stringConstantsToLabel.get(stringConstant) match {
      case None => {
        val label = "_str" + stringConstantsToLabel.size;
        stringConstantsToLabel.put(stringConstant, label);
        label;
      }
      case Some(label) => {
        label;
      }
    }
  }
}
