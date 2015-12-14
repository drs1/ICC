# File test/matrix_mult_test.s


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
movq 24(%rax), %rax
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
movq 8(%rax), %rax
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
movq 24(%rax), %rax
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
movq 8(%rax), %rax
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
movq 24(%rax), %rax
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
movq 16(%rax), %rax
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
movq 8(%rax), %rax
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
subq $5424, %rsp

cmpq $0, 24(%rbp)
je labelNullPtrError

movq 24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -5128(%rbp)

movq -5128(%rbp), %rax
cmpq $3, %rax
setne %al
movzbq %al, %rax
movq %rax, -5120(%rbp)

movq $1, %rax
xorq -5120(%rbp), %rax
movq %rax, -5136(%rbp)

movq $1, %rax
cmpq -5136(%rbp), %rax
je L14

movq _str2(%rip), %rdi
call __LIB_println


movq $1, %rdi
call __LIB_exit


L14:

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
movq %rax, -5144(%rbp)

movq -5144(%rbp), %rdi
movq $0, %rsi
call __LIB_stoi
movq %rax, -5152(%rbp)


movq -5152(%rbp), %rax
movq %rax, -32(%rbp)

cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $1, %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq $1, %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq $1, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -5160(%rbp)

movq -5160(%rbp), %rdi
movq $0, %rsi
call __LIB_stoi
movq %rax, -5168(%rbp)


movq -5168(%rbp), %rax
movq %rax, -24(%rbp)

cmpq $0, 24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $2, %rax
jg labelArrayBoundsError
movq 24(%rbp), %rax
movq -8(%rax), %rax
cmpq $2, %rax
jle labelArrayBoundsError

movq 24(%rbp), %rax
movq $2, %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -5176(%rbp)

movq -5176(%rbp), %rdi
movq $0, %rsi
call __LIB_stoi
movq %rax, -5184(%rbp)


movq -5184(%rbp), %rax
movq %rax, -16(%rbp)

movq -32(%rbp), %rax
cmpq $1, %rax
setl %al
movzbq %al, %rax
movq %rax, -5192(%rbp)

movq $1, %rax
xorq -5192(%rbp), %rax
movq %rax, -5200(%rbp)

movq $1, %rax
cmpq -5200(%rbp), %rax
je L15

movq _str3(%rip), %rdi
call __LIB_println


movq $1, %rdi
call __LIB_exit


L15:

movq -24(%rbp), %rax
cmpq $1, %rax
setl %al
movzbq %al, %rax
movq %rax, -5208(%rbp)

movq $1, %rax
xorq -5208(%rbp), %rax
movq %rax, -5216(%rbp)

movq $1, %rax
cmpq -5216(%rbp), %rax
je L16

movq _str4(%rip), %rdi
call __LIB_println


movq $1, %rdi
call __LIB_exit


L16:

movq -16(%rbp), %rax
cmpq $1, %rax
setl %al
movzbq %al, %rax
movq %rax, -5224(%rbp)

movq $1, %rax
xorq -5224(%rbp), %rax
movq %rax, -5232(%rbp)

movq $1, %rax
cmpq -5232(%rbp), %rax
je L17

movq _str5(%rip), %rdi
call __LIB_println


movq $1, %rdi
call __LIB_exit


L17:

movq -32(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -32(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -5240(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -5240(%rbp), %rdi
movq %rdi, 24(%rax)

movq $0, %rax
movq %rax, -8(%rbp)

L18:

movq -8(%rbp), %rax
cmpq -32(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -5248(%rbp)

movq $1, %rax
xorq -5248(%rbp), %rax
movq %rax, -5256(%rbp)

movq $1, %rax
cmpq -5256(%rbp), %rax
je L19

movq -24(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -24(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -5264(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -5272(%rbp)

cmpq $0, -5272(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -5272(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -5272(%rbp), %rax
movq -8(%rbp), %rdi
movq -5264(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -5280(%rbp)

movq -5280(%rbp), %rax
movq %rax, -8(%rbp)

jmp L18

L19:

movq -24(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -24(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -5288(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -5288(%rbp), %rdi
movq %rdi, 16(%rax)

movq $0, %rax
movq %rax, -8(%rbp)

L20:

movq -8(%rbp), %rax
cmpq -24(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -5296(%rbp)

movq $1, %rax
xorq -5296(%rbp), %rax
movq %rax, -5304(%rbp)

movq $1, %rax
cmpq -5304(%rbp), %rax
je L21

movq -16(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -16(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -5312(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -5320(%rbp)

cmpq $0, -5320(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -5320(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -5320(%rbp), %rax
movq -8(%rbp), %rdi
movq -5312(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -5328(%rbp)

movq -5328(%rbp), %rax
movq %rax, -8(%rbp)

jmp L20

L21:

movq -32(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -32(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -5336(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -5336(%rbp), %rdi
movq %rdi, 8(%rax)

movq $0, %rax
movq %rax, -8(%rbp)

L22:

movq -8(%rbp), %rax
cmpq -32(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -5344(%rbp)

movq $1, %rax
xorq -5344(%rbp), %rax
movq %rax, -5352(%rbp)

movq $1, %rax
cmpq -5352(%rbp), %rax
je L23

movq -16(%rbp), %rax
cmpq $0, %rax
jl labelArraySizeError

movq -16(%rbp), %rdi
call __LIB_allocateArray
movq %rax, -5360(%rbp)


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -5368(%rbp)

cmpq $0, -5368(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -8(%rbp), %rax
jg labelArrayBoundsError
movq -5368(%rbp), %rax
movq -8(%rax), %rax
cmpq -8(%rbp), %rax
jle labelArrayBoundsError

movq -5368(%rbp), %rax
movq -8(%rbp), %rdi
movq -5360(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

movq -8(%rbp), %rax
addq $1, %rax
movq %rax, -5376(%rbp)

movq -5376(%rbp), %rax
movq %rax, -8(%rbp)

jmp L22

L23:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -5384(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-5384(%rbp)	#Pushing parameter t33
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$16, %rsp

movq _str6(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -5392(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-5392(%rbp)	#Pushing parameter t34
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$16, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -5400(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-5400(%rbp)	#Pushing parameter t35
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*8(%rax)
addq	$16, %rsp

movq _str7(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 16(%rax), %rax
movq %rax, -5408(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-5408(%rbp)	#Pushing parameter t36
movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$16, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$8, %rsp

movq _str8(%rip), %rdi
call __LIB_println


cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 8(%rax), %rax
movq %rax, -5416(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

pushq	-5416(%rbp)	#Pushing parameter t37
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
  _str7Chars:	.ascii "Matrix B:"
_str7:	.quad _str7Chars
.quad 31
  _str3Chars:	.ascii "Invalid value for parameter `m'"
_str3:	.quad _str3Chars
.quad 1
  _str0Chars:	.ascii " "
_str0:	.quad _str0Chars
.quad 29
  _str2Chars:	.ascii "Invalid number of parameters."
_str2:	.quad _str2Chars
.quad 17
  _str8Chars:	.ascii "Matrix C = A x B:"
_str8:	.quad _str8Chars
.quad 9
  _str6Chars:	.ascii "Matrix A:"
_str6:	.quad _str6Chars
.quad 1
  _str1Chars:	.ascii "\n"
_str1:	.quad _str1Chars
.quad 31
  _str4Chars:	.ascii "Invalid value for parameter `n'"
_str4:	.quad _str4Chars
.quad 31
  _str5Chars:	.ascii "Invalid value for parameter `p'"
_str5:	.quad _str5Chars



