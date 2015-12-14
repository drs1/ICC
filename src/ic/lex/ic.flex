package ic.lex;

import ic.parser.sym;
import ic.error.*;

%%
%class Lexer
%public
%cup
%line
%column

%{
  /** for use in building string literals in the STRING state */
  StringBuffer stringLiteral = new StringBuffer();
  
  /** Create a token with the given type and the given value */
  Token create(int type, Object value) {
    return new Token(type, value, yyline+1);
  }
  
  /** Create a token with the given type and no value */
  Token create(int type) {
    return create(type, null);
  }
%}

WhiteSpace =  [ \t\n]

Comment = {TraditionalComment} | {EndOfLineComment} 

TraditionalComment   = "/*" ( [^*] | ("*"+ [^*/]) )* "*"+ "/"
EndOfLineComment     = "//" .* 

Identifier = [a-z] [a-zA-Z0-9_]*
ClassIdentifier = [A-Z] [a-zA-Z0-9_]*
DecIntegerLiteral = (0 | [1-9][0-9]*)
BadIntegerLiteral = (0[0-9]+)


%state STRING

%%

/* keywords */
<YYINITIAL> "class"           { return create(sym.CLASS); }
<YYINITIAL> "return"          { return create(sym.RETURN); }
<YYINITIAL> "this"            { return create(sym.THIS); }

<YYINITIAL> "extends"         { return create(sym.EXTENDS); }
<YYINITIAL> "if"              { return create(sym.IF); }
<YYINITIAL> "new"             { return create(sym.NEW); }

<YYINITIAL> "void"            { return create(sym.VOID); }
<YYINITIAL> "else"            { return create(sym.ELSE); }
<YYINITIAL> "length"          { return create(sym.LENGTH); }

<YYINITIAL> "int"             { return create(sym.INT); }
<YYINITIAL> "while"           { return create(sym.WHILE); }

<YYINITIAL> "boolean"         { return create(sym.BOOLEAN); }
<YYINITIAL> "break"           { return create(sym.BREAK); }

<YYINITIAL> "string"          { return create(sym.STRING); }
<YYINITIAL> "continue"        { return create(sym.CONTINUE); }
<YYINITIAL> "null"            { return create(sym.NULL); }

<YYINITIAL> "false"           { return create(sym.BOOL_LIT, false); }
<YYINITIAL> "true"            { return create(sym.BOOL_LIT, true); }
<YYINITIAL> "Library"         { return create(sym.LIBRARY); }

<YYINITIAL> {

  /* identifiers */ 
  {Identifier}                 { return create(sym.ID, yytext()); }
  {ClassIdentifier}            { return create(sym.CLS_ID, yytext()); }
 
  /* literals */
  {DecIntegerLiteral}         { 
  								try {
                                   return create(sym.INT_LIT, new Integer(yytext()));
                                } catch (NumberFormatException e) {
                                   throw new LexicalError(yyline+1, "Bad Number Format: '" + yytext() + "'");
                                }
                              }
  {BadIntegerLiteral}         { throw new LexicalError(yyline+1, "Bad Number Format: '" + yytext() + "'"); }
  
  \"                          { stringLiteral.setLength(0); yybegin(STRING); }

  /* operators */
  "{"   { return create(sym.OBRACE); }
  "}"   { return create(sym.CBRACE); }
  "("   { return create(sym.OPAREN); }
  ")"   { return create(sym.CPAREN); }
  ","   { return create(sym.COMMA); }
  ";"   { return create(sym.SEMI); }
  "["   { return create(sym.OBRACKET); }
  "]"   { return create(sym.CBRACKET); }
  "="   { return create(sym.EQ); }
  "."   { return create(sym.DOT); }
  "+"   { return create(sym.PLUS); }
  "-"   { return create(sym.MINUS); }
  "*"   { return create(sym.MULT); }
  "/"   { return create(sym.DIV); }
  "%"   { return create(sym.MOD); }
  "&&"  { return create(sym.AND); }
  "||"  { return create(sym.OR); }
  "!"   { return create(sym.NOT); }
  "<"   { return create(sym.LT); }
  "<="  { return create(sym.LE); }
  ">"   { return create(sym.GT); }
  ">="  { return create(sym.GE); }
  "=="  { return create(sym.EQEQ); }
  "!="  { return create(sym.NE); }
  
  /* comments */
  {Comment}                      { /* ignore */ }
  
  /* Handled unterminated by matching comment starts.  If nothing else matched, then the rest of the comment patterns failed... */
  "/*"         			 	     { throw new ic.error.LexicalError(yyline, "Unterminated comment"); } 
 
  /* whitespace */
  {WhiteSpace}                   { /* ignore */ }
}

/* make separate state for Strings, since we need to convert
   the escape characters to their actual characters. */
<STRING> {
  \"                             { 
                                   yybegin(YYINITIAL); 
                                   return create(sym.STRING_LIT, stringLiteral.toString()); 
                                 }
  [^\n\"\\\t]+                   { stringLiteral.append( yytext() ); }  /* technically, need to check for printable ASCII codes here... */
  \\t                            { stringLiteral.append('\t'); }
  \\n                            { stringLiteral.append('\n'); }
  \\\"                           { stringLiteral.append('\"'); }
  \\\\                           { stringLiteral.append('\\'); }
  <<EOF>>	 				     { throw new ic.error.LexicalError(yyline, "Unclosed string constant"); }
}

/* error fallback */
.|\n                             { throw new LexicalError(yyline+1, "Illegal character '" + yytext() + "'"); }
