# File test/fib.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_Fibonacci_VT:
	.quad _Fibonacci_main
	.quad _Fibonacci_fib
.quad 0


.text
.align 8
_Fibonacci_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $64, %rsp

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
movq %rax, -32(%rbp)

movq -32(%rbp), %rax
movq %rax, -24(%rbp)

movq $1, %rax
notq %rax
incq %rax
movq %rax, -40(%rbp)

movq -24(%rbp), %rdi
movq -40(%rbp), %rsi
call __LIB_stoi
movq %rax, -48(%rbp)


movq -48(%rbp), %rax
movq %rax, -16(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-16(%rbp)	#Pushing parameter n
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$16, %rsp
movq %rax, -56(%rbp)

movq -56(%rbp), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rdi
call __LIB_printi


movq _str0(%rip), %rdi
call __LIB_println


epilogue_Fibonacci_main:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Fibonacci_fib:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $64, %rsp

movq 24(%rbp), %rax
cmpq $2, %rax
setl %al
movzbq %al, %rax
movq %rax, -8(%rbp)

movq $1, %rax
xorq -8(%rbp), %rax
movq %rax, -16(%rbp)

movq $1, %rax
cmpq -16(%rbp), %rax
je L0

movq 24(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

L0:

movq 24(%rbp), %rax
subq $1, %rax
movq %rax, -32(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-32(%rbp)	#Pushing parameter t3
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$16, %rsp
movq %rax, -40(%rbp)

movq 24(%rbp), %rax
subq $2, %rax
movq %rax, -48(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-48(%rbp)	#Pushing parameter t5
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$16, %rsp
movq %rax, -56(%rbp)

movq -40(%rbp), %rax
addq -56(%rbp), %rax
movq %rax, -24(%rbp)

movq -24(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Fibonacci_fib:
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

       movq $8, %rdi                 # o = new Fibonacci

       call __LIB_allocateObject   
       leaq _Fibonacci_VT(%rip), %rdi       

       movq %rdi, (%rax)
       pushq %rax                        # o.main(args) -> push o
       movq (%rax), %rax            
       call *0(%rax)                   # main is at offset 0 in vtable

       addq $16, %rsp                
       movq $0, %rax                     # __ic_main always returns 0

       movq %rbp,%rsp                    # epilogue
       popq %rbp                    
       ret                         



# ----------------------------
# String Constants

.data
.align 8

.quad 0
  _str0Chars:	.ascii ""
_str0:	.quad _str0Chars



