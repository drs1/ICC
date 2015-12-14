# File test/cg_steve/coin.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_TestCoin_VT:
	.quad _TestCoin_main
_Coin_VT:
	.quad _Coin_flip
	.quad _Coin_getFace
	.quad _Coin_toString
	.quad _Coin_getValue
_MoneyCoin_VT:
	.quad _Coin_flip
	.quad _Coin_getFace
	.quad _MoneyCoin_toString
	.quad _MoneyCoin_getValue
_OldMoneyCoin_VT:
	.quad _Coin_flip
	.quad _Coin_getFace
	.quad _OldMoneyCoin_toString
	.quad _OldMoneyCoin_getValue
	.quad _OldMoneyCoin_setup2
.quad 0


.text
.align 8
_TestCoin_main:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $264, %rsp

movq $0, %rax
movq %rax, -8(%rbp)

movq $0, %rax
movq %rax, -16(%rbp)

movq $10, %rax
cmpq $0, %rax
jl labelArraySizeError

movq $10, %rdi
call __LIB_allocateArray
movq %rax, -80(%rbp)


movq -80(%rbp), %rax
movq %rax, -24(%rbp)

       movq $32, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _Coin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -88(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $0, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $0, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $0, %rdi
movq -88(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $40, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _MoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -96(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $1, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $1, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $1, %rdi
movq -96(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $40, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _MoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -104(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $2, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $2, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $2, %rdi
movq -104(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $40, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _MoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -112(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $3, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $3, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $3, %rdi
movq -112(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $40, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _MoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -120(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $4, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $4, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $4, %rdi
movq -120(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $40, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _MoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -128(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $5, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $5, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $5, %rdi
movq -128(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $64, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _OldMoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -136(%rbp)

movq -136(%rbp), %rax
movq %rax, -32(%rbp)

cmpq $0, -32(%rbp)
je labelNullPtrError

pushq	$1920	#Pushing parameter 1920
pushq	$5	#Pushing parameter 5
movq -32(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*32(%rax)
addq	$24, %rsp

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $6, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $6, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $6, %rdi
movq -32(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

       movq $64, %rdi                 # o = new className

       call __LIB_allocateObject   
       leaq _OldMoneyCoin_VT(%rip), %rdi       

       movq %rdi, (%rax)
       movq %rax, -144(%rbp)

movq -144(%rbp), %rax
movq %rax, -32(%rbp)

cmpq $0, -32(%rbp)
je labelNullPtrError

pushq	$1965	#Pushing parameter 1965
pushq	$5	#Pushing parameter 5
movq -32(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*32(%rax)
addq	$24, %rsp

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq $7, %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq $7, %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq $7, %rdi
movq -32(%rbp), %rdx
movq %rdx, (%rax,%rdi,8)

L0:

cmpq $0, -24(%rbp)
je labelNullPtrError

movq -24(%rbp), %rax
movq -8(%rax), %rax
movq %rax, -168(%rbp)

movq -16(%rbp), %rax
cmpq -168(%rbp), %rax
setl %al
movzbq %al, %rax
movq %rax, -160(%rbp)

movq -160(%rbp), %rax
movq %rax, -152(%rbp)

movq $1, %rax
xorq -160(%rbp), %rax
movq %rax, -176(%rbp)

movq $1, %rax
cmpq -176(%rbp), %rax
je L2

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -192(%rbp)

movq -192(%rbp), %rax
cmpq $0, %rax
setne %al
movzbq %al, %rax
movq %rax, -184(%rbp)

movq -184(%rbp), %rax
movq %rax, -152(%rbp)

L2:

movq $1, %rax
xorq -152(%rbp), %rax
movq %rax, -200(%rbp)

movq $1, %rax
cmpq -200(%rbp), %rax
je L1

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -208(%rbp)

cmpq $0, -208(%rbp)
je labelNullPtrError

movq -208(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*0(%rax)
addq	$8, %rsp

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -224(%rbp)

cmpq $0, -224(%rbp)
je labelNullPtrError

movq -224(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*24(%rax)
addq	$8, %rsp
movq %rax, -232(%rbp)

movq -8(%rbp), %rax
addq -232(%rbp), %rax
movq %rax, -216(%rbp)

movq -216(%rbp), %rax
movq %rax, -8(%rbp)

cmpq $0, -24(%rbp)
je labelNullPtrError

movq $0, %rax
cmpq -16(%rbp), %rax
jg labelArrayBoundsError
movq -24(%rbp), %rax
movq -8(%rax), %rax
cmpq -16(%rbp), %rax
jle labelArrayBoundsError

movq -24(%rbp), %rax
movq -16(%rbp), %rdi
movq (%rax,%rdi,8), %rax
movq %rax, -240(%rbp)

cmpq $0, -240(%rbp)
je labelNullPtrError

movq -240(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*16(%rax)
addq	$8, %rsp
movq %rax, -248(%rbp)

movq -248(%rbp), %rdi
call __LIB_println


movq -16(%rbp), %rax
addq $1, %rax
movq %rax, -256(%rbp)

movq -256(%rbp), %rax
movq %rax, -16(%rbp)

jmp L0

L1:

movq -8(%rbp), %rdi
call __LIB_printi


movq _str0(%rip), %rdi
call __LIB_println


epilogue_TestCoin_main:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Coin_flip:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $24, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -16(%rbp)

movq -16(%rbp), %rax
addq $1, %rax
movq %rax, -8(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -8(%rbp), %rdi
movq %rdi, 24(%rax)

epilogue_Coin_flip:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Coin_getFace:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $16, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Coin_getFace:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Coin_toString:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $48, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rax), %rax
movq %rax, -32(%rbp)

movq $2, %rax
cmpq $0, %rax
je labelDivByZeroError

movq -32(%rbp), %rax
cqto
movq $2, %rdi
divq %rdi
movq %rdx, -24(%rbp)

movq -24(%rbp), %rax
cmpq $0, %rax
sete %al
movzbq %al, %rax
movq %rax, -16(%rbp)

movq $1, %rax
xorq -16(%rbp), %rax
movq %rax, -40(%rbp)

movq $1, %rax
cmpq -40(%rbp), %rax
je L3

movq _str1(%rip), %rax
movq %rax, -8(%rbp)

jmp L4

L3:

movq _str2(%rip), %rax
movq %rax, -8(%rbp)

L4:

movq -8(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Coin_toString:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_Coin_getValue:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

movq $0, %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_Coin_getValue:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_MoneyCoin_getValue:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $64, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 32(%rax), %rax
movq %rax, -32(%rbp)

movq -32(%rbp), %rax
cmpq $0, %rax
sete %al
movzbq %al, %rax
movq %rax, -24(%rbp)

movq $1, %rax
xorq -24(%rbp), %rax
movq %rax, -40(%rbp)

movq $1, %rax
cmpq -40(%rbp), %rax
je L5

movq $10, %rdi
call __LIB_random
movq %rax, -48(%rbp)


movq -48(%rbp), %rax
movq %rax, -8(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -8(%rbp), %rdi
movq %rdi, 32(%rax)

L5:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 32(%rax), %rax
movq %rax, -56(%rbp)

movq -56(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_MoneyCoin_getValue:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_MoneyCoin_toString:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $48, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
pushq	%rax
movq (%rax), %rax
call	*24(%rax)
addq	$8, %rsp
movq %rax, -32(%rbp)

movq -32(%rbp), %rax
cmpq $1, %rax
sete %al
movzbq %al, %rax
movq %rax, -24(%rbp)

movq $1, %rax
xorq -24(%rbp), %rax
movq %rax, -40(%rbp)

movq $1, %rax
cmpq -40(%rbp), %rax
je L6

movq _str3(%rip), %rax
movq %rbp,%rsp
popq %rbp
ret

jmp L7

L6:

movq _str4(%rip), %rax
movq %rbp,%rsp
popq %rbp
ret

L7:

movq _str5(%rip), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_MoneyCoin_toString:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_OldMoneyCoin_setup2:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $40, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rbp), %rdi
movq %rdi, 32(%rax)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 32(%rbp), %rdi
movq %rdi, 40(%rax)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq $1950, %rdi
movq %rdi, 56(%rax)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 56(%rax), %rax
movq %rax, -16(%rbp)

movq 32(%rbp), %rax
cmpq -16(%rbp), %rax
setle %al
movzbq %al, %rax
movq %rax, -8(%rbp)

movq $1, %rax
xorq -8(%rbp), %rax
movq %rax, -24(%rbp)

movq $1, %rax
cmpq -24(%rbp), %rax
je L8

movq $2, %rax
cqto
movq 24(%rbp), %rdi
mulq %rdi
movq %rax, -32(%rbp)

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq -32(%rbp), %rdi
movq %rdi, 48(%rax)

jmp L9

L8:

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 24(%rbp), %rdi
movq %rdi, 48(%rax)

L9:

epilogue_OldMoneyCoin_setup2:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_OldMoneyCoin_getValue:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $16, %rsp

cmpq $0, 16(%rbp)
je labelNullPtrError

movq 16(%rbp), %rax
movq 48(%rax), %rax
movq %rax, -8(%rbp)

movq -8(%rbp), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_OldMoneyCoin_getValue:
movq %rbp,%rsp
popq %rbp
ret


.align 8
_OldMoneyCoin_toString:
pushq %rbp                   # prologue
movq %rsp, %rbp
subq $8, %rsp

movq _str6(%rip), %rax
movq %rbp,%rsp
popq %rbp
ret

epilogue_OldMoneyCoin_toString:
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

       movq $8, %rdi                 # o = new TestCoin

       call __LIB_allocateObject   
       leaq _TestCoin_VT(%rip), %rdi       

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

.quad 9
  _str4Chars:	.ascii "Not penny"
_str4:	.quad _str4Chars
.quad 5
  _str1Chars:	.ascii "heads"
_str1:	.quad _str1Chars
.quad 5
  _str3Chars:	.ascii "penny"
_str3:	.quad _str3Chars
.quad 3
  _str5Chars:	.ascii "XXX"
_str5:	.quad _str5Chars
.quad 4
  _str6Chars:	.ascii "old "
_str6:	.quad _str6Chars
.quad 5
  _str2Chars:	.ascii "tails"
_str2:	.quad _str2Chars
.quad 0
  _str0Chars:	.ascii ""
_str0:	.quad _str0Chars



