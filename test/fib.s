# File test/fib.s


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
	subq $56, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(args),2)                  # 
    # Fake Def of all callee save registers       # 
       movq %r12, %r13                            # movq %r12, _vr1
       movq %r13, %r8                             # movq %r13, _vr2
       movq %r14, %r11                            # movq %r14, _vr3
       movq %r15, %rcx                            # movq %r15, _vr4
       movq %rbx, %r15                            # movq %rbx, _vr5
       movq 16(%rbp), %rbx                        # movq 16(%rbp), this
       movq 24(%rbp), %r14                        # movq 24(%rbp), args
    # Null check args                             # 
       movq %r14, %r12                            # movq args, _vr6
       cmpq $0, %r12                              # cmpq $0, _vr6
       je labelNullPtrError                       # je labelNullPtrError
    # Check if 0 in bounds args                   # 
       movq $0, %r12                              # movq $0, _vr7
       cmpq $0, %r12                              # cmpq $0, _vr7
       jl labelArrayBoundsError                   # jl labelArrayBoundsError
       movq %r14, %r10                            # movq args, _vr8
       movq -8(%r10), %r10                        # movq -8(_vr8), _vr8
       cmpq %r12, %r10                            # cmpq _vr7, _vr8
       jle labelArrayBoundsError                  # jle labelArrayBoundsError
    # t0 = args[0]                                # 
       movq %r14, %r12                            # movq args, _vr9
       movq $0, %r14                              # movq $0, _vr10
       movq (%r12, %r14, 8), %r12                 # movq (_vr9, _vr10, 8), _tt0
    # s = t0                                      # 
       movq %r12, %r14                            # movq _tt0, s
    # t1 = -1                                     # 
       movq $0, %r12                              # movq $0, _tt1
       subq $1, %r12                              # subq $1, _tt1
    # t2 = Library.stoi(st1)                      # 
       movq %r14, %rdi                            # movq s, %rdi
       movq %r12, %rsi                            # movq _tt1, %rsi
       call __LIB_stoi                            # call __LIB_stoi
       movq %rax, %r12                            # movq %rax, _tt2
    # n = t2                                      # 
    # Redundant Move: movq _tt2, n on %r12        # 
    # Null check this                             # 
       movq %rbx, %r14                            # movq this, _vr11
       cmpq $0, %r14                              # cmpq $0, _vr11
       je labelNullPtrError                       # je labelNullPtrError
    # t3 = this.fib(n)                            # 
       pushq %r12                                 # pushq n
       pushq %rbx                                 # pushq this
    # Redundant Move: movq this, _vr12 on %rbx    # 
       movq (%rbx), %rbx                          # movq (_vr12), _vr12
       call *8(%rbx)                              # call *8(_vr12)
       addq $16, %rsp                             # addq $16, %rsp
       movq %rax, %rbx                            # movq %rax, _tt3
    # r = t3                                      # 
    # Redundant Move: movq _tt3, r on %rbx        # 
    # Library.printi(r)                           # 
       movq %rbx, %rdi                            # movq r, %rdi
       call __LIB_printi                          # call __LIB_printi
    # Library.println()                           # 
       movq _str0(%rip), %rdi                     # movq _str0(%rip), %rdi
       call __LIB_println                         # call __LIB_println
    # return                                      # 
       movq %r13, %r12                            # movq _vr1, %r12
       movq %r8, %r13                             # movq _vr2, %r13
       movq %r11, %r14                            # movq _vr3, %r14
       movq %rcx, %r15                            # movq _vr4, %r15
       movq %r15, %rbx                            # movq _vr5, %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_Fibonacci_main:
movq %rbp,%rsp
popq %rbp
ret


_Fibonacci_fib:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $64, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(n),13)                    # 
    # Fake Def of all callee save registers       # 
       movq %r15, -48(%rbp)                       # movq %r15, -48(%rbp)
       movq %r13, -32(%rbp)                       # movq %r13, -32(%rbp)
       movq %r12, %r8                             # movq %r12, _vr13
       movq -32(%rbp), %r13                       # movq -32(%rbp), %r13
    # Redundant Move: movq %r13, _vr14 on %r13    # 
       movq %r14, %r15                            # movq %r14, _vr15
       movq -48(%rbp), %r15                       # movq -48(%rbp), %r15
       movq %r15, %rcx                            # movq %r15, _vr16
    # Redundant Move: movq %rbx, _vr17 on %rbx    # 
       movq %rbx, -64(%rbp)                       # movq _vr17, -64(%rbp)
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
       movq %r11, 16(%rbp)                        # movq this, 16(%rbp)
       movq 24(%rbp), %rbx                        # movq 24(%rbp), n
    # Library.println(fibbing: )                  # 
       movq _str1(%rip), %rdi                     # movq _str1(%rip), %rdi
       call __LIB_println                         # call __LIB_println
    # Library.printi(n)                           # 
       movq %rbx, %rdi                            # movq n, %rdi
       call __LIB_printi                          # call __LIB_printi
    # Library.println()                           # 
       movq _str0(%rip), %rdi                     # movq _str0(%rip), %rdi
       call __LIB_println                         # call __LIB_println
    # t0 = n < 2                                  # 
       movq $2, %r12                              # movq $2, _vr19
       movq %rbx, %r11                            # movq n, _vr18
       cmpq %r11, %r12                            # cmpq _vr18, _vr19
       movq $0, %rax                              # movq $0, %rax
       setg %al                                   # setg %al
       movq %rax, %r11                            # movq %rax, _tt0
    # t1 = !t0                                    # 
       movq $1, %r12                              # movq $1, _tt1
       subq %r11, %r12                            # subq _tt0, _tt1
    # cjump L0:                                   # 
    # Redundant Move: movq _tt1, _vr20 on %r12    # 
       testq $1, %r12                             # testq $1, _vr20
       jne   L0                                   # jne   L0
    # Library.println(Terminal: )                 # 
       movq _str2(%rip), %rdi                     # movq _str2(%rip), %rdi
       call __LIB_println                         # call __LIB_println
    # Library.println()                           # 
       movq _str0(%rip), %rdi                     # movq _str0(%rip), %rdi
       call __LIB_println                         # call __LIB_println
    # return n                                    # 
       movq %rbx, %rax                            # movq n, %rax
       movq %r8, %r12                             # movq _vr13, %r12
    # Redundant Move: movq _vr14, %r13 on %r13    # 
       movq %r13, -32(%rbp)                       # movq %r13, -32(%rbp)
       movq %r15, %r14                            # movq _vr15, %r14
       movq %rcx, %r15                            # movq _vr16, %r15
       movq %r15, -48(%rbp)                       # movq %r15, -48(%rbp)
       movq -64(%rbp), %rbx                       # movq -64(%rbp), _vr17
    # Redundant Move: movq _vr17, %rbx on %rbx    # 
       movq -32(%rbp), %r13                       # movq -32(%rbp), %r13
       movq -48(%rbp), %r15                       # movq -48(%rbp), %r15
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret
    # L0:                                         # 
L0:                                               # L0:
    # t3 = n - 1                                  # 
       movq %rbx, %r12                            # movq n, _tt3
       subq $1, %r12                              # subq $1, _tt3
    # Null check this                             # 
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
    # Redundant Move: movq this, _vr21 on %r11    # 
       cmpq $0, %r11                              # cmpq $0, _vr21
       je labelNullPtrError                       # je labelNullPtrError
    # t4 = this.fib(t3)                           # 
       pushq %r12                                 # pushq _tt3
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
       pushq %r11                                 # pushq this
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
       movq %r11, %r12                            # movq this, _vr22
       movq (%r12), %r12                          # movq (_vr22), _vr22
       call *8(%r12)                              # call *8(_vr22)
       addq $16, %rsp                             # addq $16, %rsp
       movq %rax, %r12                            # movq %rax, _tt4
    # t5 = n - 2                                  # 
    # Redundant Move: movq n, _tt5 on %rbx        # 
       subq $2, %rbx                              # subq $2, _tt5
    # Null check this                             # 
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
    # Redundant Move: movq this, _vr23 on %r11    # 
       cmpq $0, %r11                              # cmpq $0, _vr23
       je labelNullPtrError                       # je labelNullPtrError
    # t6 = this.fib(t5)                           # 
       pushq %rbx                                 # pushq _tt5
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
       pushq %r11                                 # pushq this
       movq 16(%rbp), %r11                        # movq 16(%rbp), this
       movq %r11, %rbx                            # movq this, _vr24
       movq (%rbx), %rbx                          # movq (_vr24), _vr24
       call *8(%rbx)                              # call *8(_vr24)
       addq $16, %rsp                             # addq $16, %rsp
       movq %rax, %rbx                            # movq %rax, _tt6
    # t2 = t4 + t6                                # 
    # Redundant Move: movq _tt4, _tt2 on %r12     # 
       addq %rbx, %r12                            # addq _tt6, _tt2
    # return t2                                   # 
       movq %r12, %rax                            # movq _tt2, %rax
       movq %r8, %r12                             # movq _vr13, %r12
    # Redundant Move: movq _vr14, %r13 on %r13    # 
       movq %r13, -32(%rbp)                       # movq %r13, -32(%rbp)
       movq %r15, %r14                            # movq _vr15, %r14
       movq %rcx, %r15                            # movq _vr16, %r15
       movq %r15, -48(%rbp)                       # movq %r15, -48(%rbp)
       movq -64(%rbp), %rbx                       # movq -64(%rbp), _vr17
    # Redundant Move: movq _vr17, %rbx on %rbx    # 
       movq -32(%rbp), %r13                       # movq -32(%rbp), %r13
       movq -48(%rbp), %r15                       # movq -48(%rbp), %r15
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret
    # return                                      # 
       movq %r8, %r12                             # movq _vr13, %r12
    # Redundant Move: movq _vr14, %r13 on %r13    # 
       movq %r13, -32(%rbp)                       # movq %r13, -32(%rbp)
       movq %r15, %r14                            # movq _vr15, %r14
       movq %rcx, %r15                            # movq _vr16, %r15
       movq %r15, -48(%rbp)                       # movq %r15, -48(%rbp)
       movq -64(%rbp), %rbx                       # movq -64(%rbp), _vr17
    # Redundant Move: movq _vr17, %rbx on %rbx    # 
       movq -32(%rbp), %r13                       # movq -32(%rbp), %r13
       movq -48(%rbp), %r15                       # movq -48(%rbp), %r15
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

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

.quad 9
  _str1Chars:	.ascii "fibbing: "
_str1:	.quad _str1Chars
.quad 10
  _str2Chars:	.ascii "Terminal: "
_str2:	.quad _str2Chars
.quad 0
  _str0Chars:	.ascii ""
_str0:	.quad _str0Chars



