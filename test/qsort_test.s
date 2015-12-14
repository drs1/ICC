# File test/qsort_test.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_Quicksort_VT:
	.quad _Quicksort_partition
	.quad _Quicksort_quicksort
	.quad _Quicksort_initArray
	.quad _Quicksort_printArray
	.quad _Quicksort_main
.quad 0


.text
.align 8
_Quicksort_partition:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $264, %rsp

movq 32(%rbp), %rax
movq %rax, -16(%rbp)

movq 24(%rbp), %rax
movq %rax, -24(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -88(%rbp)

cmpq $0, -88(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq 24(%rbp), %rax
jg labelArrayBoundsError
movq -88(%rbp), %rax
movq -8(%rax), %rax
cmpq 24(%rbp), %rax
jle labelArrayBoundsError

movq -88(%rbp), %rax
movq 24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -80(%rbp)

movq -80(%rbp), %rax
movq %rax, -32(%rbp)

L0:

movq $1, %rax
xorq $1, %rax
movq %rax, -96(%rbp)

movq $1, %rax
cmpq -96(%rbp), %rax
je L1

L2:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -120(%rbp)

cmpq $0, -120(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -120(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -120(%rbp), %rax
movq -24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -112(%rbp)

movq -112(%rbp), %rax
cmpq -32(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -104(%rbp)

movq $1, %rax
xorq -104(%rbp), %rax
movq %rax, -128(%rbp)

movq $1, %rax
cmpq -128(%rbp), %rax
je L3

movq -24(%rbp), %rax
addq $1, %rax
movq %rax, -136(%rbp)

movq -136(%rbp), %rax
movq %rax, -24(%rbp)

jmp L2

L3:

L4:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -160(%rbp)

cmpq $0, -160(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -160(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -160(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -152(%rbp)

movq -152(%rbp), %rax
cmpq -32(%rbp), %rax
setg %al
movzbq %al, %rax
movq %rax, -144(%rbp)

movq $1, %rax
xorq -144(%rbp), %rax
movq %rax, -168(%rbp)

movq $1, %rax
cmpq -168(%rbp), %rax
je L5

movq -16(%rbp), %rax
subq $1, %rax
movq %rax, -176(%rbp)

movq -176(%rbp), %rax
movq %rax, -16(%rbp)

jmp L4

L5:

movq -24(%rbp), %rax
cmpq -16(%rbp), %rax
setge %al
movzbq %al, %rax
movq %rax, -184(%rbp)

movq $1, %rax
xorq -184(%rbp), %rax
movq %rax, -192(%rbp)

movq $1, %rax
cmpq -192(%rbp), %rax
je L6

jmp L1

L6:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -208(%rbp)

cmpq $0, -208(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -208(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -208(%rbp), %rax
movq -24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -200(%rbp)

movq -200(%rbp), %rax
movq %rax, -8(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -224(%rbp)

cmpq $0, -224(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -224(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -224(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -216(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -232(%rbp)

cmpq $0, -232(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -232(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -232(%rbp), %rax
movq -24(%rbp), %rdi
movq -216(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -240(%rbp)

cmpq $0, -240(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -240(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -240(%rbp), %rax
movq -16(%rbp), %rdi
movq -8(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -24(%rbp), %rax
addq $1, %rax
movq %rax, -248(%rbp)

movq -248(%rbp), %rax
movq %rax, -24(%rbp)

movq -16(%rbp), %rax
subq $1, %rax
movq %rax, -256(%rbp)

movq -256(%rbp), %rax
movq %rax, -16(%rbp)

jmp L0

L1:

movq -16(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Quicksort_partition:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Quicksort_quicksort:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $56, %rsp

movq 24(%rbp), %rax
cmpq 32(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -24(%rbp)

movq $1, %rax
xorq -24(%rbp), %rax
movq %rax, -32(%rbp)

movq $1, %rax
cmpq -32(%rbp), %rax
je L7

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	32(%rbp)	#Pushing parameter high
pushq	24(%rbp)	#Pushing parameter low
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$24, %rsp
movq %rax, -40(%rbp)

movq -40(%rbp), %rax
movq %rax, -8(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-8(%rbp)	#Pushing parameter mid
pushq	24(%rbp)	#Pushing parameter low
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$24, %rsp

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -48(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	32(%rbp)	#Pushing parameter high
pushq	-48(%rbp)	#Pushing parameter t3
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$24, %rsp

L7:

epilogue_Quicksort_quicksort:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Quicksort_initArray:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $112, %rsp

movq $0, %rax
movq %rax, -8(%rbp)

L8:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -40(%rbp)

cmpq $0, -40(%rbp)
je labelNullPtrError

movq -40(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -48(%rbp)

movq -8(%rbp), %rax
cmpq -48(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -32(%rbp)

movq $1, %rax
xorq -32(%rbp), %rax
movq %rax, -56(%rbp)

movq $1, %rax
cmpq -56(%rbp), %rax
je L9

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -72(%rbp)

cmpq $0, -72(%rbp)
je labelNullPtrError

movq -72(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -80(%rbp)

movq -80(%rbp), %rax
cqto
movq $2, %rdi
mulq %rdi
movq %rax, -64(%rbp)

movq -64(%rbp), %rdi
call __LIB_random
movq %rax, -88(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -96(%rbp)

cmpq $0, -96(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -96(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -96(%rbp), %rax
movq -8(%rbp), %rdi
movq -88(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -104(%rbp)

movq -104(%rbp), %rax
movq %rax, -8(%rbp)

jmp L8

L9:

epilogue_Quicksort_initArray:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Quicksort_printArray:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $88, %rsp

movq $0, %rax
movq %rax, -8(%rbp)

movq _str0(%rip), %rdi
call __LIB_print


L10:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -40(%rbp)

cmpq $0, -40(%rbp)
je labelNullPtrError

movq -40(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -48(%rbp)

movq -8(%rbp), %rax
cmpq -48(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -32(%rbp)

movq $1, %rax
xorq -32(%rbp), %rax
movq %rax, -56(%rbp)

movq $1, %rax
cmpq -56(%rbp), %rax
je L11

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -72(%rbp)

cmpq $0, -72(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -72(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -72(%rbp), %rax
movq -8(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -64(%rbp)

movq -64(%rbp), %rdi
call __LIB_printi


movq _str1(%rip), %rdi
call __LIB_print


movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -80(%rbp)

movq -80(%rbp), %rax
movq %rax, -8(%rbp)

jmp L10

L11:

movq _str2(%rip), %rdi
call __LIB_print


epilogue_Quicksort_printArray:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Quicksort_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $136, %rsp

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -72(%rbp)

movq -72(%rbp), %rax
cmpq $1, %rax
setne %al
movzbq %al, %rax
movq %rax, -64(%rbp)

movq $1, %rax
xorq -64(%rbp), %rax
movq %rax, -80(%rbp)

movq $1, %rax
cmpq -80(%rbp), %rax
je L12

movq _str3(%rip), %rdi
call __LIB_println


movq $1, %rdi
call __LIB_exit


L12:

cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $0, %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq $0, %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq $0, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -88(%rbp)

movq -88(%rbp), %rdi
movq $0, %rsi
call __LIB_stoi
movq %rax, -96(%rbp)


movq -96(%rbp), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rax
cmpq $0, %rax
setle %al
movzbq %al, %rax
movq %rax, -104(%rbp)

movq $1, %rax
xorq -104(%rbp), %rax
movq %rax, -112(%rbp)

movq $1, %rax
cmpq -112(%rbp), %rax
je L13

movq _str4(%rip), %rdi
call __LIB_println


movq $1, %rdi
call __LIB_exit


L13:

movq -8(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -8(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -120(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -120(%rbp), %rdi
movq %rdi, 8(%rax)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$8, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*24(%rax)
addq	$8, %rsp

movq -8(%rbp), %rax
subq $1, %rax
movq %rax, -128(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-128(%rbp)	#Pushing parameter t8
pushq	$0	#Pushing parameter 0
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$24, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*24(%rax)
addq	$8, %rsp

epilogue_Quicksort_main:
movq %rbp,%rsp
popq %rbp
ret


# ----------------------------
# Error handling.  Jump to these procedures when a run-time check fails.

.data
.align 8

.quad 23
  strNullPtrErrorChars:     .ascii "Null pointer violation."
strNullPtrError: .quad strNullPtrErrorChars

.quad 23
  strArrayBoundsErrorChars: .ascii "Array bounds violation."
strArrayBoundsError: .quad strArrayBoundsErrorChars

.quad 21
  strArraySizeErrorChars:   .ascii "Array size violation."
strArraySizeError: .quad strArraySizeErrorChars

.quad 22
  divByZeroErrorChars:      .ascii "Divide by 0 violation."
divByZeroError: .quad divByZeroErrorChars

.text
.align 8
labelNullPtrError:
    movq strNullPtrError(%rip), %rdi
    call __LIB_println
    movq $1, %rdi
    call __LIB_exit

.align 8
labelArrayBoundsError:
    movq strArrayBoundsError(%rip), %rdi
    call __LIB_println
    movq $1, %rdi
    call __LIB_exit

.align 8
labelArraySizeError:
    movq strArraySizeError(%rip), %rdi
    call __LIB_println
    movq $1, %rdi
    call __LIB_exit

.align 8
labelDivByZeroError:
    movq divByZeroError(%rip), %rdi
    call __LIB_println
    movq $1, %rdi
    call __LIB_exit



# The main entry point.  Allocate object and invoke main on it.

.text
.align 8
.globl __ic_main
__ic_main:
       pushq %rbp                        # prologue
       movq %rsp,%rbp                
       pushq %rdi                        # o.main(args) -> push args

       movq $16, %rdi                 # o = new Quicksort

       call __LIB_allocateObject   
       leaq _Quicksort_VT(%rip), %rdi       

       movq %rdi, (%rax)
       pushq %rax                        # o.main(args) -> push o
       movq (%rax), %rax            
       call *32(%rax)                   # main is at offset 32 in vtable

       addq $16, %rsp                
       movq $0, %rax                     # __ic_main always returns 0

       movq %rbp,%rsp                    # epilogue
       popq %rbp                    
       ret                         



# ----------------------------
# String Constants

.data
.align 8

.quad 1
  _str1Chars:	.ascii " "
_str1:	.quad _str1Chars
.quad 1
  _str2Chars:	.ascii "\n"
_str2:	.quad _str2Chars
.quad 20
  _str4Chars:	.ascii "Invalid array length"
_str4:	.quad _str4Chars
.quad 24
  _str3Chars:	.ascii "Unspecified array length"
_str3:	.quad _str3Chars
.quad 16
  _str0Chars:	.ascii "Array elements: "
_str0:	.quad _str0Chars



