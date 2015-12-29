# File test/fib2.s


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
_Fibonacci_main:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $96, %rsp

	# ---- method instructions ------
    # Entry                                       #
    # Entry                                       #
    # Exit                                        #
    # Exit                                        #
    # TAC_Preamble(List(args),2)                  #
    # Fake Def of all callee save registers       #
       movq %r12, %rsi                            #movq %r12, _vr1
       movq %rsi, -88(%rbp)                       #movq _vr1, -88(%rbp)
       movq %r13, %rsi                            #movq %r13, _vr2
       movq %rsi, -80(%rbp)                       #movq _vr2, -80(%rbp)
       movq %r14, %rsi                            #movq %r14, _vr3
       movq %rsi, -64(%rbp)                       #movq _vr3, -64(%rbp)
       movq %r15, %rsi                            #movq %r15, _vr4
       movq %rsi, -96(%rbp)                       #movq _vr4, -96(%rbp)
       movq %rbx, %rsi                            #movq %rbx, _vr5
       movq %rsi, -72(%rbp)                       #movq _vr5, -72(%rbp)
       movq 16(%rbp), %rcx                        #movq 16(%rbp), this
       movq %rcx, 16(%rbp)                        #movq this, 16(%rbp)
       movq 24(%rbp), %rcx                        #movq 24(%rbp), args
    # Null check args                             #
       movq %rcx, %rsi                            #movq args, _vr6
       cmpq $0, %rsi                              #cmpq $0, _vr6
       je labelNullPtrError                       #je labelNullPtrError
    # Check if 0 in bounds args                   #
       movq $0, %rsi                              #movq $0, _vr7
       cmpq $0, %rsi                              #cmpq $0, _vr7
       jl labelArrayBoundsError                   #jl labelArrayBoundsError
       movq %rcx, %r8                             #movq args, _vr8
       movq -8(%r8), %r8                          #movq -8(_vr8), _vr8
       cmpq %rsi, %r8                             #cmpq _vr7, _vr8
       jle labelArrayBoundsError                  #jle labelArrayBoundsError
    # t0 = args[0]                                #
       movq %rcx, %rsi                            #movq args, _vr9
       movq $0, %rcx                              #movq $0, _vr10
       movq (%rsi, %rcx, 8), %rsi                 #movq (_vr9, _vr10, 8), _tt0
    # s = t0                                      #
       movq %rsi, %rcx                            #movq _tt0, s
    # t1 = -1                                     #
       movq $0, %rsi                              #movq $0, _tt1
       subq $1, %rsi                              #subq $1, _tt1
    # t2 = Library.stoi(st1)                      #
       movq %rcx, %rdi                            #movq s, %rdi
    # Redundant Move: movq _tt1, %rsi on %rsi     #
       call __LIB_stoi                            #call __LIB_stoi
       movq %rax, %rsi                            #movq %rax, _tt2
    # n = t2                                      #
    # Redundant Move: movq _tt2, n on %rsi        #
    # Null check this                             #
       movq 16(%rbp), %rcx                        #movq 16(%rbp), this
    # Redundant Move: movq this, _vr11 on %rcx    #
       cmpq $0, %rcx                              #cmpq $0, _vr11
       je labelNullPtrError                       #je labelNullPtrError
    # t3 = this.fib(n)                            #
       pushq %rsi                                 #pushq n
       movq 16(%rbp), %rcx                        #movq 16(%rbp), this
       pushq %rcx                                 #pushq this
       movq 16(%rbp), %rcx                        #movq 16(%rbp), this
       movq %rcx, %rsi                            #movq this, _vr12
       movq (%rsi), %rsi                          #movq (_vr12), _vr12
       call *8(%rsi)                              #call *8(_vr12)
       addq $16, %rsp                             #addq $16, %rsp
       movq %rax, %rsi                            #movq %rax, _tt3
    # r = t3                                      #
       movq %rsi, %r13                            #movq _tt3, r
    # t4 = Fib2:                                  #
       movq str0(%rip), %rsi                      #movq str0(%rip), _tt4
    # Library.println(t4)                         #
       movq %rsi, %rdi                            #movq _tt4, %rdi
       call __LIB_println                         #call __LIB_println
    # Library.printi(r)                           #
       movq %r13, %rdi                            #movq r, %rdi
       call __LIB_printi                          #call __LIB_printi
    # t5 =                                        #
       movq str1(%rip), %rsi                      #movq str1(%rip), _tt5
    # Library.println(t5)                         #
       movq %rsi, %rdi                            #movq _tt5, %rdi
       call __LIB_println                         #call __LIB_println
    # return                                      #
       movq -88(%rbp), %rsi                       #movq -88(%rbp), _vr1
       movq %rsi, %r12                            #movq _vr1, %r12
       movq -80(%rbp), %rsi                       #movq -80(%rbp), _vr2
       movq %rsi, %r13                            #movq _vr2, %r13
       movq -64(%rbp), %rsi                       #movq -64(%rbp), _vr3
       movq %rsi, %r14                            #movq _vr3, %r14
       movq -96(%rbp), %rsi                       #movq -96(%rbp), _vr4
       movq %rsi, %r15                            #movq _vr4, %r15
       movq -72(%rbp), %rsi                       #movq -72(%rbp), _vr5
       movq %rsi, %rbx                            #movq _vr5, %rbx
    # Fake Use of all callee save registers       #
       movq %rbp, %rsp                            #movq %rbp, %rsp
       popq %rbp                                  #popq %rbp
       ret                                        #ret

epilogue_Fibonacci_main:
movq %rbp,%rsp
popq %rbp
ret


_Fibonacci_fib:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $96, %rsp

	# ---- method instructions ------
    # Entry                                       #
    # Entry                                       #
    # Exit                                        #
    # Exit                                        #
    # TAC_Preamble(List(n),14)                    #
    # Fake Def of all callee save registers       #
       movq %r12, %rsi                            #movq %r12, _vr13
       movq %rsi, -72(%rbp)                       #movq _vr13, -72(%rbp)
       movq %r13, %rsi                            #movq %r13, _vr14
       movq %rsi, -88(%rbp)                       #movq _vr14, -88(%rbp)
       movq %r14, %rsi                            #movq %r14, _vr15
       movq %rsi, -96(%rbp)                       #movq _vr15, -96(%rbp)
       movq %r15, %rsi                            #movq %r15, _vr16
       movq %rsi, -80(%rbp)                       #movq _vr16, -80(%rbp)
       movq %rbx, %rsi                            #movq %rbx, _vr17
       movq %rsi, -64(%rbp)                       #movq _vr17, -64(%rbp)
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
       movq %rsi, 16(%rbp)                        #movq this, 16(%rbp)
       movq 24(%rbp), %r13                        #movq 24(%rbp), n
    # t0 = Fibbing:                               #
       movq str2(%rip), %rsi                      #movq str2(%rip), _tt0
    # Library.println(t0)                         #
       movq %rsi, %rdi                            #movq _tt0, %rdi
       call __LIB_println                         #call __LIB_println
    # Library.printi(n)                           #
       movq %r13, %rdi                            #movq n, %rdi
       call __LIB_printi                          #call __LIB_printi
    # t1 =                                        #
       movq str1(%rip), %rsi                      #movq str1(%rip), _tt1
    # Library.println(t1)                         #
       movq %rsi, %rdi                            #movq _tt1, %rdi
       call __LIB_println                         #call __LIB_println
    # t2 = n == 1                                 #
       movq $1, %rsi                              #movq $1, _vr19
       movq %r13, %rcx                            #movq n, _vr18
       cmpq %rcx, %rsi                            #cmpq _vr18, _vr19
       movq $0, %rax                              #movq $0, %rax
       sete %al                                   #sete %al
       movq %rax, %rsi                            #movq %rax, _tt2
    # t3 = !t2                                    #
       movq $1, %rcx                              #movq $1, _tt3
       subq %rsi, %rcx                            #subq _tt2, _tt3
    # cjump L0:                                   #
       movq %rcx, %rsi                            #movq _tt3, _vr20
       testq $1, %rsi                             #testq $1, _vr20
       jne   L0                                   #jne   L0
    # return 1                                    #
       movq $1, %rax                              #movq $1, %rax
       movq -72(%rbp), %rsi                       #movq -72(%rbp), _vr13
       movq %rsi, %r12                            #movq _vr13, %r12
       movq -88(%rbp), %rsi                       #movq -88(%rbp), _vr14
       movq %rsi, %r13                            #movq _vr14, %r13
       movq -96(%rbp), %rsi                       #movq -96(%rbp), _vr15
       movq %rsi, %r14                            #movq _vr15, %r14
       movq -80(%rbp), %rsi                       #movq -80(%rbp), _vr16
       movq %rsi, %r15                            #movq _vr16, %r15
       movq -64(%rbp), %rsi                       #movq -64(%rbp), _vr17
       movq %rsi, %rbx                            #movq _vr17, %rbx
    # Fake Use of all callee save registers       #
       movq %rbp, %rsp                            #movq %rbp, %rsp
       popq %rbp                                  #popq %rbp
       ret                                        #ret
    # L0:                                         #
L0:                                               #L0:
    # t4 = n - 1                                  #
       movq %r13, %rcx                            #movq n, _tt4
       subq $1, %rcx                              #subq $1, _tt4
    # Null check this                             #
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
    # Redundant Move: movq this, _vr21 on %rsi    #
       cmpq $0, %rsi                              #cmpq $0, _vr21
       je labelNullPtrError                       #je labelNullPtrError
    # t5 = this.fib(t4)                           #
       pushq %rcx                                 #pushq _tt4
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
       pushq %rsi                                 #pushq this
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
    # Redundant Move: movq this, _vr22 on %rsi    #
       movq (%rsi), %rsi                          #movq (_vr22), _vr22
       call *8(%rsi)                              #call *8(_vr22)
       addq $16, %rsp                             #addq $16, %rsp
       movq %rax, %rsi                            #movq %rax, _tt5
    # Library.printi(t5)                          #
       movq %rsi, %rdi                            #movq _tt5, %rdi
       call __LIB_printi                          #call __LIB_printi
    # t6 =                                        #
       movq str1(%rip), %rsi                      #movq str1(%rip), _tt6
    # Library.println(t6)                         #
       movq %rsi, %rdi                            #movq _tt6, %rdi
       call __LIB_println                         #call __LIB_println
    # t8 = n - 1                                  #
       movq %r13, %rcx                            #movq n, _tt8
       subq $1, %rcx                              #subq $1, _tt8
    # Null check this                             #
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
    # Redundant Move: movq this, _vr23 on %rsi    #
       cmpq $0, %rsi                              #cmpq $0, _vr23
       je labelNullPtrError                       #je labelNullPtrError
    # t9 = this.fib(t8)                           #
       pushq %rcx                                 #pushq _tt8
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
       pushq %rsi                                 #pushq this
       movq 16(%rbp), %rsi                        #movq 16(%rbp), this
    # Redundant Move: movq this, _vr24 on %rsi    #
       movq (%rsi), %rsi                          #movq (_vr24), _vr24
       call *8(%rsi)                              #call *8(_vr24)
       addq $16, %rsp                             #addq $16, %rsp
       movq %rax, %rsi                            #movq %rax, _tt9
    # t7 = n * t9                                 #
       movq %r13, %rax                            #movq n, %rax
       cqto                                       #cqto
    # Redundant Move: movq _tt9, _vr25 on %rsi    #
       imulq %rsi                                 #imulq _vr25
       movq %rax, %rsi                            #movq %rax, _tt7
    # return t7                                   #
       movq %rsi, %rax                            #movq _tt7, %rax
       movq -72(%rbp), %rsi                       #movq -72(%rbp), _vr13
       movq %rsi, %r12                            #movq _vr13, %r12
       movq -88(%rbp), %rsi                       #movq -88(%rbp), _vr14
       movq %rsi, %r13                            #movq _vr14, %r13
       movq -96(%rbp), %rsi                       #movq -96(%rbp), _vr15
       movq %rsi, %r14                            #movq _vr15, %r14
       movq -80(%rbp), %rsi                       #movq -80(%rbp), _vr16
       movq %rsi, %r15                            #movq _vr16, %r15
       movq -64(%rbp), %rsi                       #movq -64(%rbp), _vr17
       movq %rsi, %rbx                            #movq _vr17, %rbx
    # Fake Use of all callee save registers       #
       movq %rbp, %rsp                            #movq %rbp, %rsp
       popq %rbp                                  #popq %rbp
       ret                                        #ret
    # return                                      #
       movq -72(%rbp), %rsi                       #movq -72(%rbp), _vr13
       movq %rsi, %r12                            #movq _vr13, %r12
       movq -88(%rbp), %rsi                       #movq -88(%rbp), _vr14
       movq %rsi, %r13                            #movq _vr14, %r13
       movq -96(%rbp), %rsi                       #movq -96(%rbp), _vr15
       movq %rsi, %r14                            #movq _vr15, %r14
       movq -80(%rbp), %rsi                       #movq -80(%rbp), _vr16
       movq %rsi, %r15                            #movq _vr16, %r15
       movq -64(%rbp), %rsi                       #movq -64(%rbp), _vr17
       movq %rsi, %rbx                            #movq _vr17, %rbx
    # Fake Use of all callee save registers       #
       movq %rbp, %rsp                            #movq %rbp, %rsp
       popq %rbp                                  #popq %rbp
       ret                                        #ret

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

.quad 5
  str0Chars:	.ascii "Fib2:"
str0:	.quad str0Chars
.quad 9
  str2Chars:	.ascii "Fibbing: "
str2:	.quad str2Chars
.quad 0
  str1Chars:	.ascii ""
str1:	.quad str1Chars



