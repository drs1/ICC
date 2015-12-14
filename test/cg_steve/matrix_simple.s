# File test/cg_steve/matrix_simple.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_MatrixMult_VT:
	.quad _MatrixMult_multiply
	.quad _MatrixMult_initMatrix
	.quad _MatrixMult_printMatrix
	.quad _MatrixMult_main
.quad 0


.text
.align 8
_MatrixMult_multiply:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $384, %rsp

movq $0, %rax
movq %rax, -24(%rbp)

L0:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -136(%rbp)

cmpq $0, -136(%rbp)
je labelNullPtrError

movq -136(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -144(%rbp)

movq -24(%rbp), %rax
cmpq -144(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -128(%rbp)

movq $1, %rax
xorq -128(%rbp), %rax
movq %rax, -152(%rbp)

movq $1, %rax
cmpq -152(%rbp), %rax
je L1

movq $0, %rax
movq %rax, -16(%rbp)

L2:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -176(%rbp)

cmpq $0, -176(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -176(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -176(%rbp), %rax
movq -24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -168(%rbp)

cmpq $0, -168(%rbp)
je labelNullPtrError

movq -168(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -184(%rbp)

movq -16(%rbp), %rax
cmpq -184(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -160(%rbp)

movq $1, %rax
xorq -160(%rbp), %rax
movq %rax, -192(%rbp)

movq $1, %rax
cmpq -192(%rbp), %rax
je L3

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
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

cmpq $0, -200(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -200(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -200(%rbp), %rax
movq -16(%rbp), %rdi
movq $0, %rdx
movq %rdx, (%rax,%rdi,8)

movq $0, %rax
movq %rax, -8(%rbp)

L4:

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
movq (%rax,%rdi,8), %rax
movq %rax, -224(%rbp)

cmpq $0, -224(%rbp)
je labelNullPtrError

movq -224(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -240(%rbp)

movq -8(%rbp), %rax
cmpq -240(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -216(%rbp)

movq $1, %rax
xorq -216(%rbp), %rax
movq %rax, -248(%rbp)

movq $1, %rax
cmpq -248(%rbp), %rax
je L5

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -280(%rbp)

cmpq $0, -280(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -280(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -280(%rbp), %rax
movq -24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -272(%rbp)

cmpq $0, -272(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -272(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -272(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -264(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -312(%rbp)

cmpq $0, -312(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -312(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -312(%rbp), %rax
movq -24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -304(%rbp)

cmpq $0, -304(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -304(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -304(%rbp), %rax
movq -8(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -296(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -336(%rbp)

cmpq $0, -336(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -336(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -336(%rbp), %rax
movq -8(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -328(%rbp)

cmpq $0, -328(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -328(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -328(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -320(%rbp)

movq -296(%rbp), %rax
cqto
movq -320(%rbp), %rdi
mulq %rdi
movq %rax, -288(%rbp)

movq -264(%rbp), %rax
addq -288(%rbp), %rax
movq %rax, -256(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -352(%rbp)

cmpq $0, -352(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -24(%rbp), %rax
jg labelArrayBoundsError
movq -352(%rbp), %rax
movq -8(%rax), %rax
cmpq -24(%rbp), %rax
jle labelArrayBoundsError

movq -352(%rbp), %rax
movq -24(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -344(%rbp)

cmpq $0, -344(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -344(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -344(%rbp), %rax
movq -16(%rbp), %rdi
movq -256(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -360(%rbp)

movq -360(%rbp), %rax
movq %rax, -8(%rbp)

jmp L4

L5:

movq -16(%rbp), %rax
addq $1, %rax
movq %rax, -368(%rbp)

movq -368(%rbp), %rax
movq %rax, -16(%rbp)

jmp L2

L3:

movq -24(%rbp), %rax
addq $1, %rax
movq %rax, -376(%rbp)

movq -376(%rbp), %rax
movq %rax, -24(%rbp)

jmp L0

L1:

epilogue_MatrixMult_multiply:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_MatrixMult_initMatrix:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $176, %rsp

movq $0, %rax
movq %rax, -16(%rbp)

L6:

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -80(%rbp)

movq -16(%rbp), %rax
cmpq -80(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -72(%rbp)

movq $1, %rax
xorq -72(%rbp), %rax
movq %rax, -88(%rbp)

movq $1, %rax
cmpq -88(%rbp), %rax
je L7

movq $0, %rax
movq %rax, -8(%rbp)

L8:

cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -104(%rbp)

cmpq $0, -104(%rbp)
je labelNullPtrError

movq -104(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -112(%rbp)

movq -8(%rbp), %rax
cmpq -112(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -96(%rbp)

movq $1, %rax
xorq -96(%rbp), %rax
movq %rax, -120(%rbp)

movq $1, %rax
cmpq -120(%rbp), %rax
je L9

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -136(%rbp)

movq -136(%rbp), %rax
cqto
movq $2, %rdi
mulq %rdi
movq %rax, -128(%rbp)

movq -128(%rbp), %rdi
call __LIB_random
movq %rax, -144(%rbp)


cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -152(%rbp)

cmpq $0, -152(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -152(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -152(%rbp), %rax
movq -8(%rbp), %rdi
movq -144(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -160(%rbp)

movq -160(%rbp), %rax
movq %rax, -8(%rbp)

jmp L8

L9:

movq -16(%rbp), %rax
addq $1, %rax
movq %rax, -168(%rbp)

movq -168(%rbp), %rax
movq %rax, -16(%rbp)

jmp L6

L7:

epilogue_MatrixMult_initMatrix:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_MatrixMult_printMatrix:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $160, %rsp

movq $0, %rax
movq %rax, -16(%rbp)

L10:

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -80(%rbp)

movq -16(%rbp), %rax
cmpq -80(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -72(%rbp)

movq $1, %rax
xorq -72(%rbp), %rax
movq %rax, -88(%rbp)

movq $1, %rax
cmpq -88(%rbp), %rax
je L11

movq $0, %rax
movq %rax, -8(%rbp)

L12:

cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -104(%rbp)

cmpq $0, -104(%rbp)
je labelNullPtrError

movq -104(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -112(%rbp)

movq -8(%rbp), %rax
cmpq -112(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -96(%rbp)

movq $1, %rax
xorq -96(%rbp), %rax
movq %rax, -120(%rbp)

movq $1, %rax
cmpq -120(%rbp), %rax
je L13

cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -136(%rbp)

cmpq $0, -136(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -136(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -136(%rbp), %rax
movq -8(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -128(%rbp)

movq -128(%rbp), %rdi
call __LIB_printi


movq _str0(%rip), %rdi
call __LIB_print


movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -144(%rbp)

movq -144(%rbp), %rax
movq %rax, -8(%rbp)

jmp L12

L13:

movq _str1(%rip), %rdi
call __LIB_print


movq -16(%rbp), %rax
addq $1, %rax
movq %rax, -152(%rbp)

movq -152(%rbp), %rax
movq %rax, -16(%rbp)

jmp L10

L11:

movq _str1(%rip), %rdi
call __LIB_print


epilogue_MatrixMult_printMatrix:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_MatrixMult_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $280, %rsp

movq $10, %rax
movq %rax, -32(%rbp)

movq $20, %rax
movq %rax, -24(%rbp)

movq $10, %rax
movq %rax, -16(%rbp)

movq -32(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -32(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -160(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -160(%rbp), %rdi
movq %rdi, 8(%rax)

movq $0, %rax
movq %rax, -8(%rbp)

L14:

movq -8(%rbp), %rax
cmpq -32(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -168(%rbp)

movq $1, %rax
xorq -168(%rbp), %rax
movq %rax, -176(%rbp)

movq $1, %rax
cmpq -176(%rbp), %rax
je L15

movq -24(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -24(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -184(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -192(%rbp)

cmpq $0, -192(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -192(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -192(%rbp), %rax
movq -8(%rbp), %rdi
movq -184(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -200(%rbp)

movq -200(%rbp), %rax
movq %rax, -8(%rbp)

jmp L14

L15:

movq -24(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -24(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -208(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -208(%rbp), %rdi
movq %rdi, 24(%rax)

movq $0, %rax
movq %rax, -8(%rbp)

L16:

movq -8(%rbp), %rax
cmpq -24(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -216(%rbp)

movq $1, %rax
xorq -216(%rbp), %rax
movq %rax, -224(%rbp)

movq $1, %rax
cmpq -224(%rbp), %rax
je L17

movq -16(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -16(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -232(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -240(%rbp)

cmpq $0, -240(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -240(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -240(%rbp), %rax
movq -8(%rbp), %rdi
movq -232(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -248(%rbp)

movq -248(%rbp), %rax
movq %rax, -8(%rbp)

jmp L16

L17:

movq _str2(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -256(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-256(%rbp)	#Pushing parameter t12
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$16, %rsp

movq _str3(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -264(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-264(%rbp)	#Pushing parameter t13
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$16, %rsp

movq _str4(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -272(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-272(%rbp)	#Pushing parameter t14
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$16, %rsp

epilogue_MatrixMult_main:
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

       movq $32, %rdi                 # o = new MatrixMult

       call __LIB_allocateObject   
       leaq _MatrixMult_VT(%rip), %rdi       

       movq %rdi, (%rax)
       pushq %rax                        # o.main(args) -> push o
       movq (%rax), %rax            
       call *24(%rax)                   # main is at offset 24 in vtable

       addq $16, %rsp                
       movq $0, %rax                     # __ic_main always returns 0

       movq %rbp,%rsp                    # epilogue
       popq %rbp                    
       ret                         



# ----------------------------
# String Constants

.data
.align 8

.quad 9
  _str3Chars:	.ascii "Matrix B:"
_str3:	.quad _str3Chars
.quad 1
  _str0Chars:	.ascii " "
_str0:	.quad _str0Chars
.quad 17
  _str4Chars:	.ascii "Matrix C = A x B:"
_str4:	.quad _str4Chars
.quad 9
  _str2Chars:	.ascii "Matrix A:"
_str2:	.quad _str2Chars
.quad 1
  _str1Chars:	.ascii "\n"
_str1:	.quad _str1Chars



