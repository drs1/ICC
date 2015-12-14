# File test/pass_01_assign.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_A_VT:
	.quad _A_main
	.quad _A_test
	.quad _A_m
	.quad _A_n
.quad 0


.text
.align 8
_A_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

epilogue_A_main:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_A_test:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $160, %rsp

cmpq $0, -32(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $0, %rax
jg labelArrayBoundsError
movq -32(%rbp), %rax
movq -8(%rax), %rax
cmpq $0, %rax
jle labelArrayBoundsError

movq -32(%rbp), %rax
movq $0, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -56(%rbp)

movq -56(%rbp), %rax
movq %rax, -48(%rbp)

cmpq $0, -32(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $1, %rax
jg labelArrayBoundsError
movq -32(%rbp), %rax
movq -8(%rax), %rax
cmpq $1, %rax
jle labelArrayBoundsError

movq -32(%rbp), %rax
movq $1, %rdi
movq -48(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$8, %rsp
movq %rax, -64(%rbp)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$8, %rsp
movq %rax, -72(%rbp)

cmpq $0, -72(%rbp)
je labelNullPtrError

pushq	-64(%rbp)	#Pushing parameter t1
movq -72(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*24(%rax)
addq	$16, %rsp
movq %rax, -80(%rbp)

movq -80(%rbp), %rax
movq %rax, -48(%rbp)

movq $2, %rax
cmpq $0, %rax
jl labelArraySizeError

movq $2, %rdi
call __LIB_allocateArray
movq %rax, -88(%rbp)


movq -88(%rbp), %rax
movq %rax, -32(%rbp)

movq $2, %rax
cmpq $0, %rax
jl labelArraySizeError

movq $2, %rdi
call __LIB_allocateArray
movq %rax, -112(%rbp)


cmpq $0, -112(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $2, %rax
jg labelArrayBoundsError
movq -112(%rbp), %rax
movq -8(%rax), %rax
cmpq $2, %rax
jle labelArrayBoundsError

movq -112(%rbp), %rax
movq $2, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -104(%rbp)

cmpq $0, -104(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $1, %rax
jg labelArrayBoundsError
movq -104(%rbp), %rax
movq -8(%rax), %rax
cmpq $1, %rax
jle labelArrayBoundsError

movq -104(%rbp), %rax
movq $1, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -96(%rbp)

movq -96(%rbp), %rax
movq %rax, -48(%rbp)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
movq -48(%rbp), %rdi
movq %rdi, 16(%rax)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -120(%rbp)

cmpq $0, -16(%rbp)
je labelNullPtrError

movq -16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -128(%rbp)

cmpq $0, -8(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -128(%rbp), %rax
jg labelArrayBoundsError
movq -8(%rbp), %rax
movq -8(%rax), %rax
cmpq -128(%rbp), %rax
jle labelArrayBoundsError

movq -8(%rbp), %rax
movq -128(%rbp), %rdi
movq -120(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -136(%rbp)

cmpq $0, -32(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $0, %rax
jg labelArrayBoundsError
movq -32(%rbp), %rax
movq -8(%rax), %rax
cmpq $0, %rax
jle labelArrayBoundsError

movq -32(%rbp), %rax
movq $0, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -152(%rbp)

movq -152(%rbp), %rax
addq -48(%rbp), %rax
movq %rax, -144(%rbp)

cmpq $0, -8(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -144(%rbp), %rax
jg labelArrayBoundsError
movq -8(%rbp), %rax
movq -8(%rax), %rax
cmpq -144(%rbp), %rax
jle labelArrayBoundsError

movq -8(%rbp), %rax
movq -144(%rbp), %rdi
movq -136(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

epilogue_A_test:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_A_m:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $16, %rsp

       movq $24, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _A_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -8(%rbp)

movq -8(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_A_m:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_A_n:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $24, %rsp

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -16(%rbp)

movq -16(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_A_n:
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

       movq $24, %rdi                 # o = new A

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




