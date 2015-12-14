# File test/steve_pass_simple.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_A_VT:
	.quad _A_main
	.quad _A_doStuff
	.quad _A_a
.quad 0


.text
.align 8
_A_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $16, %rsp

       movq $8, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _A_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -8(%rbp)

cmpq $0, -8(%rbp)
je labelNullPtrError

movq -8(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$8, %rsp

epilogue_A_main:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_A_doStuff:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $32, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -8(%rbp)

       movq $8, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _A_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -16(%rbp)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$8, %rsp
movq %rax, -24(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq -24(%rbp), %rax
movq -8(%rbp), %rdi
movq %rdi, 8(%rax)

epilogue_A_doStuff:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_A_a:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

movq 16(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_A_a:
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

       movq $8, %rdi                 # o = new A

       call __LIB_allocateObject   
       leaq _A_VT(%rip), %rdi       

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




