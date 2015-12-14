# File test/batman.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_A_VT:
_B_VT:
_C_VT:
_Batman_VT:
	.quad _Batman_main
.quad 0


.text
.align 8
_Batman_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $104, %rsp

movq $1, %rax
movq %rax, -8(%rbp)

L0:

movq -8(%rbp), %rax
cmpq $14, %rax
setle %al
movzbq %al, %rax
movq %rax, -64(%rbp)

movq $1, %rax
xorq -64(%rbp), %rax
movq %rax, -72(%rbp)

movq $1, %rax
cmpq -72(%rbp), %rax
je L1

movq _str0(%rip), %rdi
call __LIB_println


movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -80(%rbp)

movq -80(%rbp), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rax
cmpq $14, %rax
sete %al
movzbq %al, %rax
movq %rax, -88(%rbp)

movq $1, %rax
xorq -88(%rbp), %rax
movq %rax, -96(%rbp)

movq $1, %rax
cmpq -96(%rbp), %rax
je L2

movq _str1(%rip), %rdi
call __LIB_println


jmp L1

jmp L3

L2:

jmp L0

L3:

jmp L0

L1:

epilogue_Batman_main:
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

       movq $8, %rdi                 # o = new Batman

       call __LIB_allocateObject   
       leaq _Batman_VT(%rip), %rdi       

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

.quad 2
  _str0Chars:	.ascii "na"
_str0:	.quad _str0Chars
.quad 10
  _str1Chars:	.ascii "BATMANNNNN"
_str1:	.quad _str1Chars



