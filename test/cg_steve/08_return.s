# File test/cg_steve/08_return.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_Return_VT:
	.quad _Return_m_void
	.quad _Return_m_int
	.quad _Return_m_Return
	.quad _Return_main
	.quad _Return_test
_A_VT:
	.quad _A_m
.quad 0


.text
.align 8
_Return_m_void:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

movq %rbp,%rsp
popq %rbp
ret

epilogue_Return_m_void:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Return_m_int:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $40, %rsp

movq $1, %rax
addq 24(%rbp), %rax
movq %rax, -16(%rbp)

movq $3, %rax
cqto
movq $4, %rdi
mulq %rdi
movq %rax, -32(%rbp)

movq -32(%rbp), %rax
cqto
movq 24(%rbp), %rdi
mulq %rdi
movq %rax, -24(%rbp)

movq -16(%rbp), %rax
subq -24(%rbp), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Return_m_int:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Return_m_Return:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

movq 16(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Return_m_Return:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Return_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $16, %rsp

       movq $8, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _Return_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -8(%rbp)

cmpq $0, -8(%rbp)
je labelNullPtrError

movq -8(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*32(%rax)
addq	$8, %rsp

epilogue_Return_main:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Return_test:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $96, %rsp

       movq $8, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _A_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -40(%rbp)

movq -40(%rbp), %rax
movq %rax, -16(%rbp)

cmpq $0, -16(%rbp)
je labelNullPtrError

pushq	$0	#Pushing parameter 0
movq -16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$16, %rsp
movq %rax, -48(%rbp)

movq -48(%rbp), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rax
cmpq -16(%rbp), %rax
setne %al
movzbq %al, %rax
movq %rax, -56(%rbp)

movq $1, %rax
xorq -56(%rbp), %rax
movq %rax, -64(%rbp)

movq $1, %rax
cmpq -64(%rbp), %rax
je L0

movq _str0(%rip), %rdi
call __LIB_println


L0:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$8, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	$2	#Pushing parameter 2
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$16, %rsp
movq %rax, -72(%rbp)

movq -72(%rbp), %rax
movq %rax, -24(%rbp)

movq -24(%rbp), %rdi
call __LIB_printi


movq _str1(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$8, %rsp
movq %rax, -80(%rbp)

cmpq $0, -8(%rbp)
je labelNullPtrError

pushq	$0	#Pushing parameter 0
movq -8(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$16, %rsp
movq %rax, -88(%rbp)

movq -88(%rbp), %rax
movq %rax, -16(%rbp)

epilogue_Return_test:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_A_m:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

movq 16(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_A_m:
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

       movq $8, %rdi                 # o = new Return

       call __LIB_allocateObject   
       leaq _Return_VT(%rip), %rdi       

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

.quad 4
  _str0Chars:	.ascii "hmm?"
_str0:	.quad _str0Chars
.quad 0
  _str1Chars:	.ascii ""
_str1:	.quad _str1Chars



