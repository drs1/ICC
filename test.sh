#!/bin/bash
#
# Usage:  ./test.sh [-v] dir
#
#    where dir is the directory that contains the files to use.
#          [-v] is optinal flag to turn on verbose output
#

VERBOSE="off"
if [ "$1" == "-v" ]; then
    VERBOSE="on"
    shift
fi

DIR=$1

PASSED=0
FAILED=0

# Iterate over all .ic files in DIR or its subdirectories
for f in `find $DIR -name "*.ic" `; do
    echo $f...

    # Pull expected output out of $f
    grep "//[oO]utput:" $f | cut -d\  -f2- > $f.expected

    # Run the Compiler, catching stdout and stderr
    scala -classpath bin:tools/java-cup-11a.jar ic.Compiler $f -printAST > $f.output 2>&1

    # For now, just compare the last lines of the output and expected
    # The lines should be either "Success." or "Failed."  You can 
    # change these to have the script examine more of the output.
    EXPECT=`tail -1 $f.expected`
    OUTPUT=`tail -1 $f.output`

    # Report failure if we see the wrong result
    if [ "$EXPECT" != "$OUTPUT" ]; then
	
	let FAILED=FAILED+1

	echo "    Expected: $EXPECT"
	echo "    Got:      $OUTPUT"

	
	if [ "$VERBOSE" = "on" ]; then
   	    # Dump $f too, indenting each line with some spaces.
	    echo "    Code:"
	    cat $f | sed -e "s/^/        /g"

	    # Dump full output
	    echo "    Full Output:"
	    cat $f.output | sed -e "s/^/        /g"

	    echo ""
	fi
    else
	let PASSED=PASSED+1
    fi
done

echo "# PASSED: $PASSED"
echo "# FAILED: $FAILED"

exit 0
