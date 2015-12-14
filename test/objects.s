# File test/objects.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_A_VT:
	.quad _A_m
_B_VT:
	.quad _B_m
_C_VT:
	.quad _C_main
.quad 0


.text
.align 8
_A_m:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $32, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -16(%rbp)

movq -16(%rbp), %rdi
call __LIB_itos
movq %rax, -24(%rbp)


movq _str0(%rip), %rdi
movq -24(%rbp), %rsi
call __LIB_stringCat
movq %rax, -8(%rbp)


movq -8(%rbp), %rdi
call __LIB_println


epilogue_A_m:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_B_m:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $24, %rsp

movq _str1(%rip), %rdi
call __LIB_print


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rdi
call __LIB_printi


movq _str2(%rip), %rdi
call __LIB_print


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -16(%rbp)

movq -16(%rbp), %rdi
call __LIB_printb


movq _str3(%rip), %rdi
call __LIB_println


epilogue_B_m:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_C_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $64, %rsp

       movq $24, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _B_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -24(%rbp)

movq -24(%rbp), %rax
movq %rax, -8(%rbp)

       movq $16, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _A_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -32(%rbp)

movq -32(%rbp), %rax
movq %rax, -16(%rbp)

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -48(%rbp)

movq -48(%rbp), %rax
cmpq $0, %rax
setne %al
movzbq %al, %rax
movq %rax, -40(%rbp)

movq $1, %rax
xorq -40(%rbp), %rax
movq %rax, -56(%rbp)

movq $1, %rax
cmpq -56(%rbp), %rax
je L0

movq -8(%rbp), %rax
movq %rax, -16(%rbp)

L0:

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
movq $412, %rdi
movq %rdi, 8(%rax)

cmpq $0, -8(%rbp)
je labelNullPtrError

movq -8(%rbp), %rax
movq $413, %rdi
movq %rdi, 8(%rax)

cmpq $0, -8(%rbp)
je labelNullPtrError

movq -8(%rbp), %rax
movq $1, %rdi
movq %rdi, 16(%rax)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$8, %rsp

cmpq $0, -8(%rbp)
je labelNullPtrError

movq -8(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$8, %rsp

epilogue_C_main:
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

       movq $8, %rdi                 # o = new C

       call __LIB_allocateObject   
       leaq _C_VT(%rip), %rdi       

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
  _str2Chars:	.ascii ", "
_str2:	.quad _str2Chars
.quad 10
  _str0Chars:	.ascii "A fields: "
_str0:	.quad _str0Chars
.quad 0
  _str3Chars:	.ascii ""
_str3:	.quad _str3Chars
.quad 10
  _str1Chars:	.ascii "B fields: "
_str1:	.quad _str1Chars



