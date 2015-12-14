package ic;

import java.io.PrintStream;

/**
 * A class to print with tabbing.  See the example main() at the
 * end of the file.
 *
 * To use:
 *
 * <ul>
 * <li> Create a new IndentingPrintStream "out" using System.out as
 * the constructor parameter.
 * 
 * <li> Whenever you enter a scope and wish to indent output more, 
 * call out.indentMore().
 * 
 * <li> Whenever you exit a scope and wish to indent output less, 
 * call out.indentLess().
 * 
 * <li> Don't print to the underlying print stream directly. 
 * </ul>
 *
 */
public class IndentingPrintStream {

    /** The number levels we wish to indent the next line */
    private int indentLevel = 0;

    /** Was the last thing printed a new line? */
    private boolean atStartOfLine = true;

    /** The stream to which to print everything */
    private final PrintStream out;

    /**
     * Create a new IndentingPrintStream to delegates all actual printing to out.
     */
    public IndentingPrintStream(PrintStream out) {
	this.out = out;
    }

    /**
     * Indicate that you would like to indent all subsequent lines
     * one more tab level than the current line.
     */
    public void indentMore() {
	indentLevel++;
    }

    /**
     * Indicate that you would like to indent all subsequent lines
     * one less tab level than the current line.
     */
    public void indentLess() {
	indentLevel--;
    }

    /**
     * Split a String into pieces with not internal \n characters, and print
     * each one, separating them with the right amount of padding.
     */
    private void printWithTabbing(String s) {
	String[] lines = s.split("\n", -1);
	if (atStartOfLine) pad();
	for (int i = 0; i < lines.length - 1; i++) {
	    out.println(lines[i]);
	    pad();
	}
	out.print(lines[lines.length-1]);
    }

    /**
     * Insert spaces proportional to the current depth of
     * tabbing.  This is called in the above methods whenever
     * we start printing after a new line.
     */
    private void pad() {
	for (int i = 0; i < indentLevel; i++) {
	    System.out.print("  ");
	}
	atStartOfLine = false;
    }


    /**
     * A variant of printf that is aware of line starts and 
     * indentation.
     */
    public void printf(String s, Object... args) {
	String toPrint = String.format(s, args);
	printWithTabbing(toPrint);
    }

    /**
     * A variant of print that is aware of line starts and 
     * indentation.
     */
    public void print(String s) {
	printWithTabbing(s);
    }


    /**
     * A variant of println that is aware of line starts and 
     * indentation.
     */
    public void println(String s) {
	printWithTabbing(s);
	println();
    }

    /**
     * A variant of println that is aware of line starts and 
     * indentation.
     */
    public void println() {
	out.println();
	atStartOfLine = true;
    }

    // All the other expected methods to print common built-in types
    public void print(boolean x) { print(Boolean.toString(x)); }
    public void print(char x)    { print(Character.toString(x)); }
    public void print(int x)     { print(Integer.toString(x)); }
    public void print(long x)    { print(Long.toString(x)); }
    public void print(double x)  { print(Double.toString(x)); }
    public void print(float x)   { print(Float.toString(x)); }
    public void print(Object x)  { printWithTabbing(x.toString()); }

    public void println(boolean x) { println(Boolean.toString(x)); }
    public void println(char x)    { println(Character.toString(x)); }
    public void println(int x)     { println(Integer.toString(x)); }
    public void println(long x)    { println(Long.toString(x)); }
    public void println(double x)  { println(Double.toString(x)); }
    public void println(float x)   { println(Float.toString(x)); }
    public void println(Object x)  { printWithTabbing(x.toString()); println(); }


    /*
     * The following example prints out:
	 
     class Moo {
       void cow() {
         This
         is
         { a }
         test.
       3

       true
       }
     }

    */
    public static void main(String args[]) {
	IndentingPrintStream out = new IndentingPrintStream(System.out);
	out.println("class Moo {");
	out.indentMore();
	out.print("void cow()");
	out.print(" {");
	out.println();
	out.indentMore();
	out.println("This\nis\n{ a }\ntest.");
	out.indentLess();
	out.print(3);
	out.print("\n\n");
	out.println(true);
	out.println("}");
	out.indentLess();
	out.println("}");
    }
}
