# File test/cg_steve/08_continue.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_Continue_VT:
	.quad _Continue_main
.quad 0


.text
.align 8
_Continue_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $224, %rsp

movq $0, %rax
movq %rax, -8(%rbp)

movq $1, %rax
movq %rax, -16(%rbp)

movq $0, %rax
movq %rax, -24(%rbp)

movq $1, %rax
movq %rax, -32(%rbp)

L0:

movq -32(%rbp), %rax
addq -24(%rbp), %rax
movq %rax, -136(%rbp)

movq -136(%rbp), %rax
cmpq $5, %rax
setle %al
movzbq %al, %rax
movq %rax, -128(%rbp)

movq -128(%rbp), %rax
movq %rax, -120(%rbp)

movq $1, %rax
xorq -128(%rbp), %rax
movq %rax, -144(%rbp)

movq $1, %rax
cmpq -144(%rbp), %rax
je L2

movq -16(%rbp), %rax
movq %rax, -120(%rbp)

L2:

movq $1, %rax
xorq -120(%rbp), %rax
movq %rax, -152(%rbp)

movq $1, %rax
cmpq -152(%rbp), %rax
je L1

movq -24(%rbp), %rax
addq $1, %rax
movq %rax, -160(%rbp)

movq -160(%rbp), %rax
movq %rax, -24(%rbp)

L3:

movq $3, %rax
cqto
movq -24(%rbp), %rdi
mulq %rdi
movq %rax, -176(%rbp)

movq -32(%rbp), %rax
cmpq -176(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -168(%rbp)

movq $1, %rax
xorq -168(%rbp), %rax
movq %rax, -184(%rbp)

movq $1, %rax
cmpq -184(%rbp), %rax
je L4

movq -32(%rbp), %rax
addq $1, %rax
movq %rax, -192(%rbp)

movq -192(%rbp), %rax
movq %rax, -32(%rbp)

movq $1, %rax
xorq -8(%rbp), %rax
movq %rax, -200(%rbp)

movq $1, %rax
cmpq -200(%rbp), %rax
je L5

jmp L3

L5:

movq -32(%rbp), %rax
addq $2, %rax
movq %rax, -208(%rbp)

movq -208(%rbp), %rax
movq %rax, -32(%rbp)

jmp L3

L4:

movq $1, %rax
xorq -8(%rbp), %rax
movq %rax, -216(%rbp)

movq -216(%rbp), %rax
movq %rax, -8(%rbp)

jmp L0

L1:

movq -32(%rbp), %rdi
call __LIB_printi


movq _str0(%rip), %rdi
call __LIB_println


movq -24(%rbp), %rdi
call __LIB_printi


movq _str0(%rip), %rdi
call __LIB_println


movq -16(%rbp), %rdi
call __LIB_printb


movq _str0(%rip), %rdi
call __LIB_println


movq -8(%rbp), %rdi
call __LIB_printb


movq _str0(%rip), %rdi
call __LIB_println


epilogue_Continue_main:
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

       movq $8, %rdi                 # o = new Continue

       call __LIB_allocateObject   
       leaq _Continue_VT(%rip), %rdi       

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



