# File test/sieve_test.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_Sieve_VT:
	.quad _Sieve_initArray
	.quad _Sieve_sieveAll
	.quad _Sieve_sieve
	.quad _Sieve_printPrimes
	.quad _Sieve_main
.quad 0


.text
_Sieve_initArray:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $280, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(),7)                      # 
    # Fake Def of all callee save registers       # 
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq %r12, %rbx                            # movq %r12, _vr1
       movq %rbx, -64(%rbp)                       # %rbx -> _vr1
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq %r13, %rbx                            # movq %r13, _vr2
       movq %rbx, -72(%rbp)                       # %rbx -> _vr2
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq %r14, %rbx                            # movq %r14, _vr3
       movq %rbx, -80(%rbp)                       # %rbx -> _vr3
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq %r15, %rbx                            # movq %r15, _vr4
       movq %rbx, -88(%rbp)                       # %rbx -> _vr4
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
       movq %rbx, %r15                            # movq %rbx, _vr5
       movq %r15, -96(%rbp)                       # %r15 -> _vr5
       movq 16(%rbp), %r15                        # movq 16(%rbp), this
       movq %r15, 16(%rbp)                        # %r15 -> this
    # i = 0                                       # 
       movq $0, %r15                              # movq $0, i
       movq %r15, -104(%rbp)                      # %r15 -> i
    # L0:                                         # 
L0:                                               # L0:
    # Null check this                             # 
       movq 16(%rbp), %r15                        # this -> %r15
       movq %r15, %rbx                            # movq this, _vr6
       movq %rbx, -112(%rbp)                      # %rbx -> _vr6
       movq -112(%rbp), %rbx                      # _vr6 -> %rbx
       cmpq $0, %rbx                              # cmpq $0, _vr6
       je labelNullPtrError                       # je labelNullPtrError
    # t1 = this.num                               # 
       movq 16(%rbp), %rbx                        # this -> %rbx
       movq %rbx, %r15                            # movq this, _vr7
       movq %r15, -120(%rbp)                      # %r15 -> _vr7
       movq -120(%rbp), %r15                      # _vr7 -> %r15
       movq 8(%r15), %rbx                         # movq 8(_vr7), _tt1
       movq %rbx, -128(%rbp)                      # %rbx -> _tt1
    # Null check t1                               # 
       movq -128(%rbp), %rbx                      # _tt1 -> %rbx
       movq %rbx, %r15                            # movq _tt1, _vr8
       movq %r15, -136(%rbp)                      # %r15 -> _vr8
       movq -136(%rbp), %r15                      # _vr8 -> %r15
       cmpq $0, %r15                              # cmpq $0, _vr8
       je labelNullPtrError                       # je labelNullPtrError
    # t2 = t1.length                              # 
       movq -128(%rbp), %r15                      # _tt1 -> %r15
       movq %r15, %rbx                            # movq _tt1, _vr9
       movq %rbx, -144(%rbp)                      # %rbx -> _vr9
       movq -144(%rbp), %rbx                      # _vr9 -> %rbx
       movq -8(%rbx), %r15                        # movq -8(_vr9), _tt2
       movq %r15, -152(%rbp)                      # %r15 -> _tt2
    # t0 = i < t2                                 # 
       movq -152(%rbp), %r15                      # _tt2 -> %r15
       movq %r15, %rbx                            # movq _tt2, _vr11
       movq %rbx, -160(%rbp)                      # %rbx -> _vr11
       movq -104(%rbp), %rbx                      # i -> %rbx
       movq %rbx, %r15                            # movq i, _vr10
       movq %r15, -168(%rbp)                      # %r15 -> _vr10
       movq -168(%rbp), %r15                      # _vr10 -> %r15
       movq -160(%rbp), %rbx                      # _vr11 -> %rbx
       cmpq %r15, %rbx                            # cmpq _vr10, _vr11
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -176(%rbp)                      # %rax -> %rax
       movq -176(%rbp), %rax                      # %rax -> %rax
       setg %al                                   # setg %al
       movq %rax, -176(%rbp)                      # %rax -> %rax
       movq -176(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rbx                            # movq %rax, _tt0
       movq %rbx, -184(%rbp)                      # %rbx -> _tt0
    # t3 = !t0                                    # 
       movq $1, %rbx                              # movq $1, _tt3
       movq %rbx, -192(%rbp)                      # %rbx -> _tt3
       movq -184(%rbp), %rbx                      # _tt0 -> %rbx
       movq -192(%rbp), %rax                      # _tt3 -> %rax
       subq %rbx, %rax                            # subq _tt0, _tt3
       movq %rax, -192(%rbp)                      # %rax -> _tt3
    # cjump L1:                                   # 
       movq -192(%rbp), %rax                      # _tt3 -> %rax
       movq %rax, %rbx                            # movq _tt3, _vr12
       movq %rbx, -200(%rbp)                      # %rbx -> _vr12
       movq -200(%rbp), %rbx                      # _vr12 -> %rbx
       testq $1, %rbx                             # testq $1, _vr12
       jne   L1                                   # jne   L1
    # Null check this                             # 
       movq 16(%rbp), %rbx                        # this -> %rbx
       movq %rbx, %rax                            # movq this, _vr13
       movq %rax, -208(%rbp)                      # %rax -> _vr13
       movq -208(%rbp), %rax                      # _vr13 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr13
       je labelNullPtrError                       # je labelNullPtrError
    # t4 = this.num                               # 
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rbx                            # movq this, _vr14
       movq %rbx, -216(%rbp)                      # %rbx -> _vr14
       movq -216(%rbp), %rbx                      # _vr14 -> %rbx
       movq 8(%rbx), %rax                         # movq 8(_vr14), _tt4
       movq %rax, -224(%rbp)                      # %rax -> _tt4
    # Null check t4                               # 
       movq -224(%rbp), %rax                      # _tt4 -> %rax
       movq %rax, %rbx                            # movq _tt4, _vr15
       movq %rbx, -232(%rbp)                      # %rbx -> _vr15
       movq -232(%rbp), %rbx                      # _vr15 -> %rbx
       cmpq $0, %rbx                              # cmpq $0, _vr15
       je labelNullPtrError                       # je labelNullPtrError
    # Check if i in bounds t4                     # 
       movq -104(%rbp), %rbx                      # i -> %rbx
       movq %rbx, %rax                            # movq i, _vr16
       movq %rax, -240(%rbp)                      # %rax -> _vr16
       movq -240(%rbp), %rax                      # _vr16 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr16
       jl labelArrayBoundsError                   # jl labelArrayBoundsError
       movq -224(%rbp), %rax                      # _tt4 -> %rax
       movq %rax, %rbx                            # movq _tt4, _vr17
       movq %rbx, -248(%rbp)                      # %rbx -> _vr17
       movq -248(%rbp), %rbx                      # _vr17 -> %rbx
       movq -8(%rbx), %rbx                        # movq -8(_vr17), _vr17
       movq %rbx, -248(%rbp)                      # %rbx -> _vr17
       movq -240(%rbp), %rbx                      # _vr16 -> %rbx
       movq -248(%rbp), %rax                      # _vr17 -> %rax
       cmpq %rbx, %rax                            # cmpq _vr16, _vr17
       jle labelArrayBoundsError                  # jle labelArrayBoundsError
    # t4[i] = i                                   # 
       movq -104(%rbp), %rax                      # i -> %rax
       movq %rax, %rbx                            # movq i, _vr20
       movq %rbx, -256(%rbp)                      # %rbx -> _vr20
       movq -224(%rbp), %rbx                      # _tt4 -> %rbx
       movq %rbx, %rax                            # movq _tt4, _vr18
       movq %rax, -264(%rbp)                      # %rax -> _vr18
       movq -104(%rbp), %rax                      # i -> %rax
       movq %rax, %rbx                            # movq i, _vr19
       movq %rbx, -272(%rbp)                      # %rbx -> _vr19
       movq -264(%rbp), %rbx                      # _vr18 -> %rbx
       movq -272(%rbp), %rax                      # _vr19 -> %rax
       movq -256(%rbp), %r15                      # _vr20 -> %r15
       movq %r15, (%rbx, %rax, 8)                 # movq _vr20, (_vr18, _vr19, 8)
    # t5 = i + 1                                  # 
       movq -104(%rbp), %r15                      # i -> %r15
       movq %r15, %rax                            # movq i, _tt5
       movq %rax, -280(%rbp)                      # %rax -> _tt5
       movq -280(%rbp), %rax                      # _tt5 -> %rax
       addq $1, %rax                              # addq $1, _tt5
       movq %rax, -280(%rbp)                      # %rax -> _tt5
    # i = t5                                      # 
       movq -280(%rbp), %rax                      # _tt5 -> %rax
       movq %rax, %r15                            # movq _tt5, i
       movq %r15, -104(%rbp)                      # %r15 -> i
    # jump L0:                                    # 
       jmp  L0                                    # jmp  L0
    # L1:                                         # 
L1:                                               # L1:
    # return                                      # 
       movq -64(%rbp), %r15                       # _vr1 -> %r15
       movq %r15, %r12                            # movq _vr1, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr2 -> %r12
       movq %r12, %r13                            # movq _vr2, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr3 -> %r13
       movq %r13, %r14                            # movq _vr3, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr4 -> %r14
       movq %r14, %r15                            # movq _vr4, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr5 -> %r15
       movq %r15, %rbx                            # movq _vr5, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_Sieve_initArray:
movq %rbp,%rsp
popq %rbp
ret


_Sieve_sieveAll:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $288, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(),15)                     # 
    # Fake Def of all callee save registers       # 
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq %r12, %rbx                            # movq %r12, _vr21
       movq %rbx, -64(%rbp)                       # %rbx -> _vr21
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq %r13, %rbx                            # movq %r13, _vr22
       movq %rbx, -72(%rbp)                       # %rbx -> _vr22
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq %r14, %rbx                            # movq %r14, _vr23
       movq %rbx, -80(%rbp)                       # %rbx -> _vr23
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq %r15, %rbx                            # movq %r15, _vr24
       movq %rbx, -88(%rbp)                       # %rbx -> _vr24
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
       movq %rbx, %r15                            # movq %rbx, _vr25
       movq %r15, -96(%rbp)                       # %r15 -> _vr25
       movq 16(%rbp), %r15                        # movq 16(%rbp), this
       movq %r15, 16(%rbp)                        # %r15 -> this
    # i = 2                                       # 
       movq $2, %r15                              # movq $2, i
       movq %r15, -104(%rbp)                      # %r15 -> i
    # L2:                                         # 
L2:                                               # L2:
    # Null check this                             # 
       movq 16(%rbp), %r15                        # this -> %r15
       movq %r15, %rbx                            # movq this, _vr26
       movq %rbx, -112(%rbp)                      # %rbx -> _vr26
       movq -112(%rbp), %rbx                      # _vr26 -> %rbx
       cmpq $0, %rbx                              # cmpq $0, _vr26
       je labelNullPtrError                       # je labelNullPtrError
    # t1 = this.num                               # 
       movq 16(%rbp), %rbx                        # this -> %rbx
       movq %rbx, %r15                            # movq this, _vr27
       movq %r15, -120(%rbp)                      # %r15 -> _vr27
       movq -120(%rbp), %r15                      # _vr27 -> %r15
       movq 8(%r15), %rbx                         # movq 8(_vr27), _tt1
       movq %rbx, -128(%rbp)                      # %rbx -> _tt1
    # Null check t1                               # 
       movq -128(%rbp), %rbx                      # _tt1 -> %rbx
       movq %rbx, %r15                            # movq _tt1, _vr28
       movq %r15, -136(%rbp)                      # %r15 -> _vr28
       movq -136(%rbp), %r15                      # _vr28 -> %r15
       cmpq $0, %r15                              # cmpq $0, _vr28
       je labelNullPtrError                       # je labelNullPtrError
    # t2 = t1.length                              # 
       movq -128(%rbp), %r15                      # _tt1 -> %r15
       movq %r15, %rbx                            # movq _tt1, _vr29
       movq %rbx, -144(%rbp)                      # %rbx -> _vr29
       movq -144(%rbp), %rbx                      # _vr29 -> %rbx
       movq -8(%rbx), %r15                        # movq -8(_vr29), _tt2
       movq %r15, -152(%rbp)                      # %r15 -> _tt2
    # t0 = i < t2                                 # 
       movq -152(%rbp), %r15                      # _tt2 -> %r15
       movq %r15, %rbx                            # movq _tt2, _vr31
       movq %rbx, -160(%rbp)                      # %rbx -> _vr31
       movq -104(%rbp), %rbx                      # i -> %rbx
       movq %rbx, %r15                            # movq i, _vr30
       movq %r15, -168(%rbp)                      # %r15 -> _vr30
       movq -168(%rbp), %r15                      # _vr30 -> %r15
       movq -160(%rbp), %rbx                      # _vr31 -> %rbx
       cmpq %r15, %rbx                            # cmpq _vr30, _vr31
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -176(%rbp)                      # %rax -> %rax
       movq -176(%rbp), %rax                      # %rax -> %rax
       setg %al                                   # setg %al
       movq %rax, -176(%rbp)                      # %rax -> %rax
       movq -176(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rbx                            # movq %rax, _tt0
       movq %rbx, -184(%rbp)                      # %rbx -> _tt0
    # t3 = !t0                                    # 
       movq $1, %rbx                              # movq $1, _tt3
       movq %rbx, -192(%rbp)                      # %rbx -> _tt3
       movq -184(%rbp), %rbx                      # _tt0 -> %rbx
       movq -192(%rbp), %rax                      # _tt3 -> %rax
       subq %rbx, %rax                            # subq _tt0, _tt3
       movq %rax, -192(%rbp)                      # %rax -> _tt3
    # cjump L3:                                   # 
       movq -192(%rbp), %rax                      # _tt3 -> %rax
       movq %rax, %rbx                            # movq _tt3, _vr32
       movq %rbx, -200(%rbp)                      # %rbx -> _vr32
       movq -200(%rbp), %rbx                      # _vr32 -> %rbx
       testq $1, %rbx                             # testq $1, _vr32
       jne   L3                                   # jne   L3
    # Null check this                             # 
       movq 16(%rbp), %rbx                        # this -> %rbx
       movq %rbx, %rax                            # movq this, _vr33
       movq %rax, -208(%rbp)                      # %rax -> _vr33
       movq -208(%rbp), %rax                      # _vr33 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr33
       je labelNullPtrError                       # je labelNullPtrError
    # this.sieve(i)                               # 
       movq -104(%rbp), %rax                      # i -> %rax
       pushq %rax                                 # pushq i
       movq 16(%rbp), %rax                        # this -> %rax
       pushq %rax                                 # pushq this
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rbx                            # movq this, _vr34
       movq %rbx, -216(%rbp)                      # %rbx -> _vr34
       movq -216(%rbp), %rbx                      # _vr34 -> %rbx
       movq (%rbx), %rbx                          # movq (_vr34), _vr34
       movq %rbx, -216(%rbp)                      # %rbx -> _vr34
       movq -216(%rbp), %rbx                      # _vr34 -> %rbx
       call *16(%rbx)                             # call *16(_vr34)
       movq %r8, -224(%rbp)                       # %r8 -> %r8
       movq %r9, -232(%rbp)                       # %r9 -> %r9
       movq %r10, -240(%rbp)                      # %r10 -> %r10
       movq %r11, -248(%rbp)                      # %r11 -> %r11
       movq %rax, -176(%rbp)                      # %rax -> %rax
       movq %rcx, -256(%rbp)                      # %rcx -> %rcx
       movq %rdx, -264(%rbp)                      # %rdx -> %rdx
       movq %rsi, -272(%rbp)                      # %rsi -> %rsi
       movq %rdi, -280(%rbp)                      # %rdi -> %rdi
       addq $16, %rsp                             # addq $16, %rsp
    # t4 = i + 1                                  # 
       movq -104(%rbp), %rdi                      # i -> %rdi
       movq %rdi, %rsi                            # movq i, _tt4
       movq %rsi, -288(%rbp)                      # %rsi -> _tt4
       movq -288(%rbp), %rsi                      # _tt4 -> %rsi
       addq $1, %rsi                              # addq $1, _tt4
       movq %rsi, -288(%rbp)                      # %rsi -> _tt4
    # i = t4                                      # 
       movq -288(%rbp), %rsi                      # _tt4 -> %rsi
       movq %rsi, %rdi                            # movq _tt4, i
       movq %rdi, -104(%rbp)                      # %rdi -> i
    # jump L2:                                    # 
       jmp  L2                                    # jmp  L2
    # L3:                                         # 
L3:                                               # L3:
    # return                                      # 
       movq -64(%rbp), %rdi                       # _vr21 -> %rdi
       movq %rdi, %r12                            # movq _vr21, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr22 -> %r12
       movq %r12, %r13                            # movq _vr22, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr23 -> %r13
       movq %r13, %r14                            # movq _vr23, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr24 -> %r14
       movq %r14, %r15                            # movq _vr24, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr25 -> %r15
       movq %r15, %rbx                            # movq _vr25, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_Sieve_sieveAll:
movq %rbp,%rsp
popq %rbp
ret


_Sieve_sieve:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $304, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(n),23)                    # 
    # Fake Def of all callee save registers       # 
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq %r12, %rbx                            # movq %r12, _vr35
       movq %rbx, -64(%rbp)                       # %rbx -> _vr35
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq %r13, %rbx                            # movq %r13, _vr36
       movq %rbx, -72(%rbp)                       # %rbx -> _vr36
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq %r14, %rbx                            # movq %r14, _vr37
       movq %rbx, -80(%rbp)                       # %rbx -> _vr37
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq %r15, %rbx                            # movq %r15, _vr38
       movq %rbx, -88(%rbp)                       # %rbx -> _vr38
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
       movq %rbx, %r15                            # movq %rbx, _vr39
       movq %r15, -96(%rbp)                       # %r15 -> _vr39
       movq 16(%rbp), %r15                        # movq 16(%rbp), this
       movq %r15, 16(%rbp)                        # %r15 -> this
       movq 24(%rbp), %r15                        # movq 24(%rbp), n
       movq %r15, 24(%rbp)                        # %r15 -> n
    # t0 = 2 * n                                  # 
       movq $2, %rax                              # movq $2, %rax
       movq %rax, -104(%rbp)                      # %rax -> %rax
       movq -104(%rbp), %rax                      # %rax -> %rax
       cqto                                       # cqto
       movq %rdx, -112(%rbp)                      # %rdx -> %rdx
       movq 24(%rbp), %rdx                        # n -> %rdx
       movq %rdx, %rax                            # movq n, _vr40
       movq %rax, -120(%rbp)                      # %rax -> _vr40
       movq -120(%rbp), %rax                      # _vr40 -> %rax
       movq %rax, %rdx                            # realloc vr
       movq -104(%rbp), %rax                      # %rax -> %rax
       movq %rdx, %r15                            # realloc vr
       movq -112(%rbp), %rdx                      # %rdx -> %rdx
       imulq %r15                                 # imulq _vr40
       movq %rax, -104(%rbp)                      # %rax -> %rax
       movq %rdx, -112(%rbp)                      # %rdx -> %rdx
       movq -104(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rdx                            # movq %rax, _tt0
       movq %rdx, -128(%rbp)                      # %rdx -> _tt0
    # i = t0                                      # 
       movq -128(%rbp), %rdx                      # _tt0 -> %rdx
       movq %rdx, %rax                            # movq _tt0, i
       movq %rax, -136(%rbp)                      # %rax -> i
    # L4:                                         # 
L4:                                               # L4:
    # Null check this                             # 
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rdx                            # movq this, _vr41
       movq %rdx, -144(%rbp)                      # %rdx -> _vr41
       movq -144(%rbp), %rdx                      # _vr41 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr41
       je labelNullPtrError                       # je labelNullPtrError
    # t2 = this.num                               # 
       movq 16(%rbp), %rdx                        # this -> %rdx
       movq %rdx, %rax                            # movq this, _vr42
       movq %rax, -152(%rbp)                      # %rax -> _vr42
       movq -152(%rbp), %rax                      # _vr42 -> %rax
       movq 8(%rax), %rdx                         # movq 8(_vr42), _tt2
       movq %rdx, -160(%rbp)                      # %rdx -> _tt2
    # Null check t2                               # 
       movq -160(%rbp), %rdx                      # _tt2 -> %rdx
       movq %rdx, %rax                            # movq _tt2, _vr43
       movq %rax, -168(%rbp)                      # %rax -> _vr43
       movq -168(%rbp), %rax                      # _vr43 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr43
       je labelNullPtrError                       # je labelNullPtrError
    # t3 = t2.length                              # 
       movq -160(%rbp), %rax                      # _tt2 -> %rax
       movq %rax, %rdx                            # movq _tt2, _vr44
       movq %rdx, -176(%rbp)                      # %rdx -> _vr44
       movq -176(%rbp), %rdx                      # _vr44 -> %rdx
       movq -8(%rdx), %rax                        # movq -8(_vr44), _tt3
       movq %rax, -184(%rbp)                      # %rax -> _tt3
    # t1 = i < t3                                 # 
       movq -184(%rbp), %rax                      # _tt3 -> %rax
       movq %rax, %rdx                            # movq _tt3, _vr46
       movq %rdx, -192(%rbp)                      # %rdx -> _vr46
       movq -136(%rbp), %rdx                      # i -> %rdx
       movq %rdx, %rax                            # movq i, _vr45
       movq %rax, -200(%rbp)                      # %rax -> _vr45
       movq -200(%rbp), %rax                      # _vr45 -> %rax
       movq -192(%rbp), %rdx                      # _vr46 -> %rdx
       cmpq %rax, %rdx                            # cmpq _vr45, _vr46
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -104(%rbp)                      # %rax -> %rax
       movq -104(%rbp), %rax                      # %rax -> %rax
       setg %al                                   # setg %al
       movq %rax, -104(%rbp)                      # %rax -> %rax
       movq -104(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rdx                            # movq %rax, _tt1
       movq %rdx, -208(%rbp)                      # %rdx -> _tt1
    # t4 = !t1                                    # 
       movq $1, %rdx                              # movq $1, _tt4
       movq %rdx, -216(%rbp)                      # %rdx -> _tt4
       movq -208(%rbp), %rdx                      # _tt1 -> %rdx
       movq -216(%rbp), %rax                      # _tt4 -> %rax
       subq %rdx, %rax                            # subq _tt1, _tt4
       movq %rax, -216(%rbp)                      # %rax -> _tt4
    # cjump L5:                                   # 
       movq -216(%rbp), %rax                      # _tt4 -> %rax
       movq %rax, %rdx                            # movq _tt4, _vr47
       movq %rdx, -224(%rbp)                      # %rdx -> _vr47
       movq -224(%rbp), %rdx                      # _vr47 -> %rdx
       testq $1, %rdx                             # testq $1, _vr47
       jne   L5                                   # jne   L5
    # Null check this                             # 
       movq 16(%rbp), %rdx                        # this -> %rdx
       movq %rdx, %rax                            # movq this, _vr48
       movq %rax, -232(%rbp)                      # %rax -> _vr48
       movq -232(%rbp), %rax                      # _vr48 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr48
       je labelNullPtrError                       # je labelNullPtrError
    # t5 = this.num                               # 
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rdx                            # movq this, _vr49
       movq %rdx, -240(%rbp)                      # %rdx -> _vr49
       movq -240(%rbp), %rdx                      # _vr49 -> %rdx
       movq 8(%rdx), %rax                         # movq 8(_vr49), _tt5
       movq %rax, -248(%rbp)                      # %rax -> _tt5
    # Null check t5                               # 
       movq -248(%rbp), %rax                      # _tt5 -> %rax
       movq %rax, %rdx                            # movq _tt5, _vr50
       movq %rdx, -256(%rbp)                      # %rdx -> _vr50
       movq -256(%rbp), %rdx                      # _vr50 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr50
       je labelNullPtrError                       # je labelNullPtrError
    # Check if i in bounds t5                     # 
       movq -136(%rbp), %rdx                      # i -> %rdx
       movq %rdx, %rax                            # movq i, _vr51
       movq %rax, -264(%rbp)                      # %rax -> _vr51
       movq -264(%rbp), %rax                      # _vr51 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr51
       jl labelArrayBoundsError                   # jl labelArrayBoundsError
       movq -248(%rbp), %rax                      # _tt5 -> %rax
       movq %rax, %rdx                            # movq _tt5, _vr52
       movq %rdx, -272(%rbp)                      # %rdx -> _vr52
       movq -272(%rbp), %rdx                      # _vr52 -> %rdx
       movq -8(%rdx), %rdx                        # movq -8(_vr52), _vr52
       movq %rdx, -272(%rbp)                      # %rdx -> _vr52
       movq -264(%rbp), %rdx                      # _vr51 -> %rdx
       movq -272(%rbp), %rax                      # _vr52 -> %rax
       cmpq %rdx, %rax                            # cmpq _vr51, _vr52
       jle labelArrayBoundsError                  # jle labelArrayBoundsError
    # t5[i] = 0                                   # 
       movq $0, %rax                              # movq $0, _vr55
       movq %rax, -280(%rbp)                      # %rax -> _vr55
       movq -248(%rbp), %rax                      # _tt5 -> %rax
       movq %rax, %rdx                            # movq _tt5, _vr53
       movq %rdx, -288(%rbp)                      # %rdx -> _vr53
       movq -136(%rbp), %rdx                      # i -> %rdx
       movq %rdx, %rax                            # movq i, _vr54
       movq %rax, -296(%rbp)                      # %rax -> _vr54
       movq -288(%rbp), %rax                      # _vr53 -> %rax
       movq -296(%rbp), %rdx                      # _vr54 -> %rdx
       movq -280(%rbp), %r15                      # _vr55 -> %r15
       movq %r15, (%rax, %rdx, 8)                 # movq _vr55, (_vr53, _vr54, 8)
    # t6 = i + n                                  # 
       movq -136(%rbp), %r15                      # i -> %r15
       movq %r15, %rdx                            # movq i, _tt6
       movq %rdx, -304(%rbp)                      # %rdx -> _tt6
       movq 24(%rbp), %rdx                        # n -> %rdx
       movq -304(%rbp), %r15                      # _tt6 -> %r15
       addq %rdx, %r15                            # addq n, _tt6
       movq %r15, -304(%rbp)                      # %r15 -> _tt6
    # i = t6                                      # 
       movq -304(%rbp), %r15                      # _tt6 -> %r15
       movq %r15, %rdx                            # movq _tt6, i
       movq %rdx, -136(%rbp)                      # %rdx -> i
    # jump L4:                                    # 
       jmp  L4                                    # jmp  L4
    # L5:                                         # 
L5:                                               # L5:
    # return                                      # 
       movq -64(%rbp), %rdx                       # _vr35 -> %rdx
       movq %rdx, %r12                            # movq _vr35, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr36 -> %r12
       movq %r12, %r13                            # movq _vr36, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr37 -> %r13
       movq %r13, %r14                            # movq _vr37, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr38 -> %r14
       movq %r14, %r15                            # movq _vr38, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr39 -> %r15
       movq %r15, %rbx                            # movq _vr39, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_Sieve_sieve:
movq %rbp,%rsp
popq %rbp
ret


_Sieve_printPrimes:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $504, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(),31)                     # 
    # Fake Def of all callee save registers       # 
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq %r12, %rbx                            # movq %r12, _vr56
       movq %rbx, -64(%rbp)                       # %rbx -> _vr56
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq %r13, %rbx                            # movq %r13, _vr57
       movq %rbx, -72(%rbp)                       # %rbx -> _vr57
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq %r14, %rbx                            # movq %r14, _vr58
       movq %rbx, -80(%rbp)                       # %rbx -> _vr58
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq %r15, %rbx                            # movq %r15, _vr59
       movq %rbx, -88(%rbp)                       # %rbx -> _vr59
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
       movq %rbx, %r15                            # movq %rbx, _vr60
       movq %r15, -96(%rbp)                       # %r15 -> _vr60
       movq 16(%rbp), %r15                        # movq 16(%rbp), this
       movq %r15, 16(%rbp)                        # %r15 -> this
    # i = 2                                       # 
       movq $2, %r15                              # movq $2, i
       movq %r15, -104(%rbp)                      # %r15 -> i
    # Library.print(Primes less than )            # 
       movq _str0(%rip), %rdi                     # movq _str0(%rip), %rdi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
       movq -112(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_print                           # call __LIB_print
       movq %r8, -120(%rbp)                       # %r8 -> %r8
       movq %r9, -128(%rbp)                       # %r9 -> %r9
       movq %r10, -136(%rbp)                      # %r10 -> %r10
       movq %r11, -144(%rbp)                      # %r11 -> %r11
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq %rcx, -160(%rbp)                      # %rcx -> %rcx
       movq %rdx, -168(%rbp)                      # %rdx -> %rdx
       movq %rsi, -176(%rbp)                      # %rsi -> %rsi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
    # Null check this                             # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rdx                            # movq this, _vr61
       movq %rdx, -184(%rbp)                      # %rdx -> _vr61
       movq -184(%rbp), %rdx                      # _vr61 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr61
       je labelNullPtrError                       # je labelNullPtrError
    # t0 = this.num                               # 
       movq 16(%rbp), %rdx                        # this -> %rdx
       movq %rdx, %rsi                            # movq this, _vr62
       movq %rsi, -192(%rbp)                      # %rsi -> _vr62
       movq -192(%rbp), %rsi                      # _vr62 -> %rsi
       movq 8(%rsi), %rdx                         # movq 8(_vr62), _tt0
       movq %rdx, -200(%rbp)                      # %rdx -> _tt0
    # Null check t0                               # 
       movq -200(%rbp), %rdx                      # _tt0 -> %rdx
       movq %rdx, %rsi                            # movq _tt0, _vr63
       movq %rsi, -208(%rbp)                      # %rsi -> _vr63
       movq -208(%rbp), %rsi                      # _vr63 -> %rsi
       cmpq $0, %rsi                              # cmpq $0, _vr63
       je labelNullPtrError                       # je labelNullPtrError
    # t1 = t0.length                              # 
       movq -200(%rbp), %rsi                      # _tt0 -> %rsi
       movq %rsi, %rdx                            # movq _tt0, _vr64
       movq %rdx, -216(%rbp)                      # %rdx -> _vr64
       movq -216(%rbp), %rdx                      # _vr64 -> %rdx
       movq -8(%rdx), %rsi                        # movq -8(_vr64), _tt1
       movq %rsi, -224(%rbp)                      # %rsi -> _tt1
    # Library.printi(t1)                          # 
       movq -224(%rbp), %rsi                      # _tt1 -> %rsi
       movq %rsi, %rdi                            # movq _tt1, %rdi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
       movq -112(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_printi                          # call __LIB_printi
       movq %r8, -120(%rbp)                       # %r8 -> %r8
       movq %r9, -128(%rbp)                       # %r9 -> %r9
       movq %r10, -136(%rbp)                      # %r10 -> %r10
       movq %r11, -144(%rbp)                      # %r11 -> %r11
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq %rcx, -160(%rbp)                      # %rcx -> %rcx
       movq %rdx, -168(%rbp)                      # %rdx -> %rdx
       movq %rsi, -176(%rbp)                      # %rsi -> %rsi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
    # Library.print(: )                           # 
       movq _str1(%rip), %rdi                     # movq _str1(%rip), %rdi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
       movq -112(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_print                           # call __LIB_print
       movq %r8, -120(%rbp)                       # %r8 -> %r8
       movq %r9, -128(%rbp)                       # %r9 -> %r9
       movq %r10, -136(%rbp)                      # %r10 -> %r10
       movq %r11, -144(%rbp)                      # %r11 -> %r11
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq %rcx, -160(%rbp)                      # %rcx -> %rcx
       movq %rdx, -168(%rbp)                      # %rdx -> %rdx
       movq %rsi, -176(%rbp)                      # %rsi -> %rsi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
    # L6:                                         # 
L6:                                               # L6:
    # Null check this                             # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rdx                            # movq this, _vr65
       movq %rdx, -232(%rbp)                      # %rdx -> _vr65
       movq -232(%rbp), %rdx                      # _vr65 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr65
       je labelNullPtrError                       # je labelNullPtrError
    # t3 = this.num                               # 
       movq 16(%rbp), %rdx                        # this -> %rdx
       movq %rdx, %rsi                            # movq this, _vr66
       movq %rsi, -240(%rbp)                      # %rsi -> _vr66
       movq -240(%rbp), %rsi                      # _vr66 -> %rsi
       movq 8(%rsi), %rdx                         # movq 8(_vr66), _tt3
       movq %rdx, -248(%rbp)                      # %rdx -> _tt3
    # Null check t3                               # 
       movq -248(%rbp), %rdx                      # _tt3 -> %rdx
       movq %rdx, %rsi                            # movq _tt3, _vr67
       movq %rsi, -256(%rbp)                      # %rsi -> _vr67
       movq -256(%rbp), %rsi                      # _vr67 -> %rsi
       cmpq $0, %rsi                              # cmpq $0, _vr67
       je labelNullPtrError                       # je labelNullPtrError
    # t4 = t3.length                              # 
       movq -248(%rbp), %rsi                      # _tt3 -> %rsi
       movq %rsi, %rdx                            # movq _tt3, _vr68
       movq %rdx, -264(%rbp)                      # %rdx -> _vr68
       movq -264(%rbp), %rdx                      # _vr68 -> %rdx
       movq -8(%rdx), %rsi                        # movq -8(_vr68), _tt4
       movq %rsi, -272(%rbp)                      # %rsi -> _tt4
    # t2 = i < t4                                 # 
       movq -272(%rbp), %rsi                      # _tt4 -> %rsi
       movq %rsi, %rdx                            # movq _tt4, _vr70
       movq %rdx, -280(%rbp)                      # %rdx -> _vr70
       movq -104(%rbp), %rdx                      # i -> %rdx
       movq %rdx, %rsi                            # movq i, _vr69
       movq %rsi, -288(%rbp)                      # %rsi -> _vr69
       movq -288(%rbp), %rsi                      # _vr69 -> %rsi
       movq -280(%rbp), %rdx                      # _vr70 -> %rdx
       cmpq %rsi, %rdx                            # cmpq _vr69, _vr70
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq -152(%rbp), %rax                      # %rax -> %rax
       setg %al                                   # setg %al
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq -152(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rdx                            # movq %rax, _tt2
       movq %rdx, -296(%rbp)                      # %rdx -> _tt2
    # t5 = !t2                                    # 
       movq $1, %rdx                              # movq $1, _tt5
       movq %rdx, -304(%rbp)                      # %rdx -> _tt5
       movq -296(%rbp), %rdx                      # _tt2 -> %rdx
       movq -304(%rbp), %rax                      # _tt5 -> %rax
       subq %rdx, %rax                            # subq _tt2, _tt5
       movq %rax, -304(%rbp)                      # %rax -> _tt5
    # cjump L7:                                   # 
       movq -304(%rbp), %rax                      # _tt5 -> %rax
       movq %rax, %rdx                            # movq _tt5, _vr71
       movq %rdx, -312(%rbp)                      # %rdx -> _vr71
       movq -312(%rbp), %rdx                      # _vr71 -> %rdx
       testq $1, %rdx                             # testq $1, _vr71
       jne   L7                                   # jne   L7
    # Null check this                             # 
       movq 16(%rbp), %rdx                        # this -> %rdx
       movq %rdx, %rax                            # movq this, _vr72
       movq %rax, -320(%rbp)                      # %rax -> _vr72
       movq -320(%rbp), %rax                      # _vr72 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr72
       je labelNullPtrError                       # je labelNullPtrError
    # t8 = this.num                               # 
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rdx                            # movq this, _vr73
       movq %rdx, -328(%rbp)                      # %rdx -> _vr73
       movq -328(%rbp), %rdx                      # _vr73 -> %rdx
       movq 8(%rdx), %rax                         # movq 8(_vr73), _tt8
       movq %rax, -336(%rbp)                      # %rax -> _tt8
    # Null check t8                               # 
       movq -336(%rbp), %rax                      # _tt8 -> %rax
       movq %rax, %rdx                            # movq _tt8, _vr74
       movq %rdx, -344(%rbp)                      # %rdx -> _vr74
       movq -344(%rbp), %rdx                      # _vr74 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr74
       je labelNullPtrError                       # je labelNullPtrError
    # Check if i in bounds t8                     # 
       movq -104(%rbp), %rdx                      # i -> %rdx
       movq %rdx, %rax                            # movq i, _vr75
       movq %rax, -352(%rbp)                      # %rax -> _vr75
       movq -352(%rbp), %rax                      # _vr75 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr75
       jl labelArrayBoundsError                   # jl labelArrayBoundsError
       movq -336(%rbp), %rax                      # _tt8 -> %rax
       movq %rax, %rdx                            # movq _tt8, _vr76
       movq %rdx, -360(%rbp)                      # %rdx -> _vr76
       movq -360(%rbp), %rdx                      # _vr76 -> %rdx
       movq -8(%rdx), %rdx                        # movq -8(_vr76), _vr76
       movq %rdx, -360(%rbp)                      # %rdx -> _vr76
       movq -352(%rbp), %rdx                      # _vr75 -> %rdx
       movq -360(%rbp), %rax                      # _vr76 -> %rax
       cmpq %rdx, %rax                            # cmpq _vr75, _vr76
       jle labelArrayBoundsError                  # jle labelArrayBoundsError
    # t7 = t8[i]                                  # 
       movq -336(%rbp), %rax                      # _tt8 -> %rax
       movq %rax, %rdx                            # movq _tt8, _vr77
       movq %rdx, -368(%rbp)                      # %rdx -> _vr77
       movq -104(%rbp), %rdx                      # i -> %rdx
       movq %rdx, %rax                            # movq i, _vr78
       movq %rax, -376(%rbp)                      # %rax -> _vr78
       movq -368(%rbp), %rax                      # _vr77 -> %rax
       movq -376(%rbp), %rdx                      # _vr78 -> %rdx
       movq (%rax, %rdx, 8), %rsi                 # movq (_vr77, _vr78, 8), _tt7
       movq %rsi, -384(%rbp)                      # %rsi -> _tt7
    # t6 = t7 != 0                                # 
       movq $0, %rsi                              # movq $0, _vr80
       movq %rsi, -392(%rbp)                      # %rsi -> _vr80
       movq -384(%rbp), %rsi                      # _tt7 -> %rsi
       movq %rsi, %rdx                            # movq _tt7, _vr79
       movq %rdx, -400(%rbp)                      # %rdx -> _vr79
       movq -400(%rbp), %rdx                      # _vr79 -> %rdx
       movq -392(%rbp), %rsi                      # _vr80 -> %rsi
       cmpq %rdx, %rsi                            # cmpq _vr79, _vr80
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq -152(%rbp), %rax                      # %rax -> %rax
       setne %al                                  # setne %al
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq -152(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rsi                            # movq %rax, _tt6
       movq %rsi, -408(%rbp)                      # %rsi -> _tt6
    # t9 = !t6                                    # 
       movq $1, %rsi                              # movq $1, _tt9
       movq %rsi, -416(%rbp)                      # %rsi -> _tt9
       movq -408(%rbp), %rsi                      # _tt6 -> %rsi
       movq -416(%rbp), %rax                      # _tt9 -> %rax
       subq %rsi, %rax                            # subq _tt6, _tt9
       movq %rax, -416(%rbp)                      # %rax -> _tt9
    # cjump L8:                                   # 
       movq -416(%rbp), %rax                      # _tt9 -> %rax
       movq %rax, %rsi                            # movq _tt9, _vr81
       movq %rsi, -424(%rbp)                      # %rsi -> _vr81
       movq -424(%rbp), %rsi                      # _vr81 -> %rsi
       testq $1, %rsi                             # testq $1, _vr81
       jne   L8                                   # jne   L8
    # Null check this                             # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rax                            # movq this, _vr82
       movq %rax, -432(%rbp)                      # %rax -> _vr82
       movq -432(%rbp), %rax                      # _vr82 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr82
       je labelNullPtrError                       # je labelNullPtrError
    # t11 = this.num                              # 
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rsi                            # movq this, _vr83
       movq %rsi, -440(%rbp)                      # %rsi -> _vr83
       movq -440(%rbp), %rsi                      # _vr83 -> %rsi
       movq 8(%rsi), %rax                         # movq 8(_vr83), _tt11
       movq %rax, -448(%rbp)                      # %rax -> _tt11
    # Null check t11                              # 
       movq -448(%rbp), %rax                      # _tt11 -> %rax
       movq %rax, %rsi                            # movq _tt11, _vr84
       movq %rsi, -456(%rbp)                      # %rsi -> _vr84
       movq -456(%rbp), %rsi                      # _vr84 -> %rsi
       cmpq $0, %rsi                              # cmpq $0, _vr84
       je labelNullPtrError                       # je labelNullPtrError
    # Check if i in bounds t11                    # 
       movq -104(%rbp), %rsi                      # i -> %rsi
       movq %rsi, %rax                            # movq i, _vr85
       movq %rax, -464(%rbp)                      # %rax -> _vr85
       movq -464(%rbp), %rax                      # _vr85 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr85
       jl labelArrayBoundsError                   # jl labelArrayBoundsError
       movq -448(%rbp), %rax                      # _tt11 -> %rax
       movq %rax, %rsi                            # movq _tt11, _vr86
       movq %rsi, -472(%rbp)                      # %rsi -> _vr86
       movq -472(%rbp), %rsi                      # _vr86 -> %rsi
       movq -8(%rsi), %rsi                        # movq -8(_vr86), _vr86
       movq %rsi, -472(%rbp)                      # %rsi -> _vr86
       movq -464(%rbp), %rsi                      # _vr85 -> %rsi
       movq -472(%rbp), %rax                      # _vr86 -> %rax
       cmpq %rsi, %rax                            # cmpq _vr85, _vr86
       jle labelArrayBoundsError                  # jle labelArrayBoundsError
    # t10 = t11[i]                                # 
       movq -448(%rbp), %rax                      # _tt11 -> %rax
       movq %rax, %rsi                            # movq _tt11, _vr87
       movq %rsi, -480(%rbp)                      # %rsi -> _vr87
       movq -104(%rbp), %rsi                      # i -> %rsi
       movq %rsi, %rax                            # movq i, _vr88
       movq %rax, -488(%rbp)                      # %rax -> _vr88
       movq -480(%rbp), %rax                      # _vr87 -> %rax
       movq -488(%rbp), %rsi                      # _vr88 -> %rsi
       movq (%rax, %rsi, 8), %rdx                 # movq (_vr87, _vr88, 8), _tt10
       movq %rdx, -496(%rbp)                      # %rdx -> _tt10
    # Library.printi(t10)                         # 
       movq -496(%rbp), %rdx                      # _tt10 -> %rdx
       movq %rdx, %rdi                            # movq _tt10, %rdi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
       movq -112(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_printi                          # call __LIB_printi
       movq %r8, -120(%rbp)                       # %r8 -> %r8
       movq %r9, -128(%rbp)                       # %r9 -> %r9
       movq %r10, -136(%rbp)                      # %r10 -> %r10
       movq %r11, -144(%rbp)                      # %r11 -> %r11
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq %rcx, -160(%rbp)                      # %rcx -> %rcx
       movq %rdx, -168(%rbp)                      # %rdx -> %rdx
       movq %rsi, -176(%rbp)                      # %rsi -> %rsi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
    # Library.print( )                            # 
       movq _str2(%rip), %rdi                     # movq _str2(%rip), %rdi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
       movq -112(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_print                           # call __LIB_print
       movq %r8, -120(%rbp)                       # %r8 -> %r8
       movq %r9, -128(%rbp)                       # %r9 -> %r9
       movq %r10, -136(%rbp)                      # %r10 -> %r10
       movq %r11, -144(%rbp)                      # %r11 -> %r11
       movq %rax, -152(%rbp)                      # %rax -> %rax
       movq %rcx, -160(%rbp)                      # %rcx -> %rcx
       movq %rdx, -168(%rbp)                      # %rdx -> %rdx
       movq %rsi, -176(%rbp)                      # %rsi -> %rsi
       movq %rdi, -112(%rbp)                      # %rdi -> %rdi
    # L8:                                         # 
L8:                                               # L8:
    # t12 = i + 1                                 # 
       movq -104(%rbp), %rsi                      # i -> %rsi
       movq %rsi, %rdx                            # movq i, _tt12
       movq %rdx, -504(%rbp)                      # %rdx -> _tt12
       movq -504(%rbp), %rdx                      # _tt12 -> %rdx
       addq $1, %rdx                              # addq $1, _tt12
       movq %rdx, -504(%rbp)                      # %rdx -> _tt12
    # i = t12                                     # 
       movq -504(%rbp), %rdx                      # _tt12 -> %rdx
       movq %rdx, %rsi                            # movq _tt12, i
       movq %rsi, -104(%rbp)                      # %rsi -> i
    # jump L6:                                    # 
       jmp  L6                                    # jmp  L6
    # L7:                                         # 
L7:                                               # L7:
    # return                                      # 
       movq -64(%rbp), %rsi                       # _vr56 -> %rsi
       movq %rsi, %r12                            # movq _vr56, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr57 -> %r12
       movq %r12, %r13                            # movq _vr57, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr58 -> %r13
       movq %r13, %r14                            # movq _vr58, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr59 -> %r14
       movq %r14, %r15                            # movq _vr59, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr60 -> %r15
       movq %r15, %rbx                            # movq _vr60, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_Sieve_printPrimes:
movq %rbp,%rsp
popq %rbp
ret


_Sieve_main:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $424, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(args),46)                 # 
    # Fake Def of all callee save registers       # 
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq %r12, %rbx                            # movq %r12, _vr89
       movq %rbx, -64(%rbp)                       # %rbx -> _vr89
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq %r13, %rbx                            # movq %r13, _vr90
       movq %rbx, -72(%rbp)                       # %rbx -> _vr90
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq %r14, %rbx                            # movq %r14, _vr91
       movq %rbx, -80(%rbp)                       # %rbx -> _vr91
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq %r15, %rbx                            # movq %r15, _vr92
       movq %rbx, -88(%rbp)                       # %rbx -> _vr92
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
       movq %rbx, %r15                            # movq %rbx, _vr93
       movq %r15, -96(%rbp)                       # %r15 -> _vr93
       movq 16(%rbp), %r15                        # movq 16(%rbp), this
       movq %r15, 16(%rbp)                        # %r15 -> this
       movq 24(%rbp), %r15                        # movq 24(%rbp), args
       movq %r15, 24(%rbp)                        # %r15 -> args
    # Null check args                             # 
       movq 24(%rbp), %r15                        # args -> %r15
       movq %r15, %rbx                            # movq args, _vr94
       movq %rbx, -104(%rbp)                      # %rbx -> _vr94
       movq -104(%rbp), %rbx                      # _vr94 -> %rbx
       cmpq $0, %rbx                              # cmpq $0, _vr94
       je labelNullPtrError                       # je labelNullPtrError
    # t1 = args.length                            # 
       movq 24(%rbp), %rbx                        # args -> %rbx
       movq %rbx, %r15                            # movq args, _vr95
       movq %r15, -112(%rbp)                      # %r15 -> _vr95
       movq -112(%rbp), %r15                      # _vr95 -> %r15
       movq -8(%r15), %rbx                        # movq -8(_vr95), _tt1
       movq %rbx, -120(%rbp)                      # %rbx -> _tt1
    # t0 = t1 != 1                                # 
       movq $1, %rbx                              # movq $1, _vr97
       movq %rbx, -128(%rbp)                      # %rbx -> _vr97
       movq -120(%rbp), %rbx                      # _tt1 -> %rbx
       movq %rbx, %r15                            # movq _tt1, _vr96
       movq %r15, -136(%rbp)                      # %r15 -> _vr96
       movq -136(%rbp), %r15                      # _vr96 -> %r15
       movq -128(%rbp), %rbx                      # _vr97 -> %rbx
       cmpq %r15, %rbx                            # cmpq _vr96, _vr97
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq -144(%rbp), %rax                      # %rax -> %rax
       setne %al                                  # setne %al
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq -144(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rbx                            # movq %rax, _tt0
       movq %rbx, -152(%rbp)                      # %rbx -> _tt0
    # t2 = !t0                                    # 
       movq $1, %rbx                              # movq $1, _tt2
       movq %rbx, -160(%rbp)                      # %rbx -> _tt2
       movq -152(%rbp), %rbx                      # _tt0 -> %rbx
       movq -160(%rbp), %rax                      # _tt2 -> %rax
       subq %rbx, %rax                            # subq _tt0, _tt2
       movq %rax, -160(%rbp)                      # %rax -> _tt2
    # cjump L9:                                   # 
       movq -160(%rbp), %rax                      # _tt2 -> %rax
       movq %rax, %rbx                            # movq _tt2, _vr98
       movq %rbx, -168(%rbp)                      # %rbx -> _vr98
       movq -168(%rbp), %rbx                      # _vr98 -> %rbx
       testq $1, %rbx                             # testq $1, _vr98
       jne   L9                                   # jne   L9
    # Library.println(Unspecified number.)        # 
       movq _str3(%rip), %rdi                     # movq _str3(%rip), %rdi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -176(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_println                         # call __LIB_println
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
    # return                                      # 
       movq -64(%rbp), %rsi                       # _vr89 -> %rsi
       movq %rsi, %r12                            # movq _vr89, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr90 -> %r12
       movq %r12, %r13                            # movq _vr90, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr91 -> %r13
       movq %r13, %r14                            # movq _vr91, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr92 -> %r14
       movq %r14, %r15                            # movq _vr92, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr93 -> %r15
       movq %r15, %rbx                            # movq _vr93, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret
    # L9:                                         # 
L9:                                               # L9:
    # Library.println()                           # 
       movq _str4(%rip), %rdi                     # movq _str4(%rip), %rdi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -176(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_println                         # call __LIB_println
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
    # Null check args                             # 
       movq 24(%rbp), %rsi                        # args -> %rsi
       movq %rsi, %rdx                            # movq args, _vr99
       movq %rdx, -240(%rbp)                      # %rdx -> _vr99
       movq -240(%rbp), %rdx                      # _vr99 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr99
       je labelNullPtrError                       # je labelNullPtrError
    # Check if 0 in bounds args                   # 
       movq $0, %rdx                              # movq $0, _vr100
       movq %rdx, -248(%rbp)                      # %rdx -> _vr100
       movq -248(%rbp), %rdx                      # _vr100 -> %rdx
       cmpq $0, %rdx                              # cmpq $0, _vr100
       jl labelArrayBoundsError                   # jl labelArrayBoundsError
       movq 24(%rbp), %rdx                        # args -> %rdx
       movq %rdx, %rsi                            # movq args, _vr101
       movq %rsi, -256(%rbp)                      # %rsi -> _vr101
       movq -256(%rbp), %rsi                      # _vr101 -> %rsi
       movq -8(%rsi), %rsi                        # movq -8(_vr101), _vr101
       movq %rsi, -256(%rbp)                      # %rsi -> _vr101
       movq -248(%rbp), %rsi                      # _vr100 -> %rsi
       movq -256(%rbp), %rdx                      # _vr101 -> %rdx
       cmpq %rsi, %rdx                            # cmpq _vr100, _vr101
       jle labelArrayBoundsError                  # jle labelArrayBoundsError
    # t3 = args[0]                                # 
       movq 24(%rbp), %rdx                        # args -> %rdx
       movq %rdx, %rsi                            # movq args, _vr102
       movq %rsi, -264(%rbp)                      # %rsi -> _vr102
       movq $0, %rsi                              # movq $0, _vr103
       movq %rsi, -272(%rbp)                      # %rsi -> _vr103
       movq -264(%rbp), %rsi                      # _vr102 -> %rsi
       movq -272(%rbp), %rdx                      # _vr103 -> %rdx
       movq (%rsi, %rdx, 8), %rcx                 # movq (_vr102, _vr103, 8), _tt3
       movq %rcx, -280(%rbp)                      # %rcx -> _tt3
    # t4 = Library.stoi(t30)                      # 
       movq -280(%rbp), %rcx                      # _tt3 -> %rcx
       movq %rcx, %rdi                            # movq _tt3, %rdi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq $0, %rsi                              # movq $0, %rsi
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq -176(%rbp), %rdi                      # %rdi -> %rdi
       movq -232(%rbp), %rsi                      # %rsi -> %rsi
       call __LIB_stoi                            # call __LIB_stoi
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -144(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rdx                            # movq %rax, _tt4
       movq %rdx, -288(%rbp)                      # %rdx -> _tt4
    # n = t4                                      # 
       movq -288(%rbp), %rdx                      # _tt4 -> %rdx
       movq %rdx, %rax                            # movq _tt4, n
       movq %rax, -296(%rbp)                      # %rax -> n
    # t5 = n <= 0                                 # 
       movq $0, %rax                              # movq $0, _vr105
       movq %rax, -304(%rbp)                      # %rax -> _vr105
       movq -296(%rbp), %rax                      # n -> %rax
       movq %rax, %rdx                            # movq n, _vr104
       movq %rdx, -312(%rbp)                      # %rdx -> _vr104
       movq -312(%rbp), %rdx                      # _vr104 -> %rdx
       movq -304(%rbp), %rax                      # _vr105 -> %rax
       cmpq %rdx, %rax                            # cmpq _vr104, _vr105
       movq $0, %rax                              # movq $0, %rax
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq -144(%rbp), %rax                      # %rax -> %rax
       setge %al                                  # setge %al
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq -144(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rdx                            # movq %rax, _tt5
       movq %rdx, -320(%rbp)                      # %rdx -> _tt5
    # t6 = !t5                                    # 
       movq $1, %rdx                              # movq $1, _tt6
       movq %rdx, -328(%rbp)                      # %rdx -> _tt6
       movq -320(%rbp), %rdx                      # _tt5 -> %rdx
       movq -328(%rbp), %rax                      # _tt6 -> %rax
       subq %rdx, %rax                            # subq _tt5, _tt6
       movq %rax, -328(%rbp)                      # %rax -> _tt6
    # cjump L10:                                  # 
       movq -328(%rbp), %rax                      # _tt6 -> %rax
       movq %rax, %rdx                            # movq _tt6, _vr106
       movq %rdx, -336(%rbp)                      # %rdx -> _vr106
       movq -336(%rbp), %rdx                      # _vr106 -> %rdx
       testq $1, %rdx                             # testq $1, _vr106
       jne   L10                                  # jne   L10
    # Library.println(Invalid array length)       # 
       movq _str5(%rip), %rdi                     # movq _str5(%rip), %rdi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -176(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_println                         # call __LIB_println
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
    # return                                      # 
       movq -64(%rbp), %rsi                       # _vr89 -> %rsi
       movq %rsi, %r12                            # movq _vr89, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr90 -> %r12
       movq %r12, %r13                            # movq _vr90, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr91 -> %r13
       movq %r13, %r14                            # movq _vr91, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr92 -> %r14
       movq %r14, %r15                            # movq _vr92, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr93 -> %r15
       movq %r15, %rbx                            # movq _vr93, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret
    # L10:                                        # 
L10:                                              # L10:
    # Greater than 0 check n                      # 
       movq -296(%rbp), %rbx                      # n -> %rbx
       movq %rbx, %r15                            # movq n, _vr107
       movq %r15, -344(%rbp)                      # %r15 -> _vr107
       movq -344(%rbp), %r15                      # _vr107 -> %r15
       cmpq $0, %r15                              # cmpq $0, _vr107
       jl labelArraySizeError                     # jl labelArraySizeError
    # t7 = Library.allocateArray(n)               # 
       movq -296(%rbp), %r15                      # n -> %r15
       movq %r15, %rdi                            # movq n, %rdi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -176(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_allocateArray                   # call __LIB_allocateArray
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -144(%rbp), %rax                      # %rax -> %rax
       movq %rax, %rsi                            # movq %rax, _tt7
       movq %rsi, -352(%rbp)                      # %rsi -> _tt7
    # Null check this                             # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rax                            # movq this, _vr108
       movq %rax, -360(%rbp)                      # %rax -> _vr108
       movq -360(%rbp), %rax                      # _vr108 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr108
       je labelNullPtrError                       # je labelNullPtrError
    # this.num = t7                               # 
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rsi                            # movq this, _vr109
       movq %rsi, -368(%rbp)                      # %rsi -> _vr109
       movq -352(%rbp), %rsi                      # _tt7 -> %rsi
       movq %rsi, %rax                            # movq _tt7, _vr110
       movq %rax, -376(%rbp)                      # %rax -> _vr110
       movq -368(%rbp), %rax                      # _vr109 -> %rax
       movq -376(%rbp), %rsi                      # _vr110 -> %rsi
       movq %rsi, 8(%rax)                         # movq _vr110, 8(_vr109)
    # Null check this                             # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rax                            # movq this, _vr111
       movq %rax, -384(%rbp)                      # %rax -> _vr111
       movq -384(%rbp), %rax                      # _vr111 -> %rax
       cmpq $0, %rax                              # cmpq $0, _vr111
       je labelNullPtrError                       # je labelNullPtrError
    # this.initArray()                            # 
       movq 16(%rbp), %rax                        # this -> %rax
       pushq %rax                                 # pushq this
       movq 16(%rbp), %rax                        # this -> %rax
       movq %rax, %rsi                            # movq this, _vr112
       movq %rsi, -392(%rbp)                      # %rsi -> _vr112
       movq -392(%rbp), %rsi                      # _vr112 -> %rsi
       movq (%rsi), %rsi                          # movq (_vr112), _vr112
       movq %rsi, -392(%rbp)                      # %rsi -> _vr112
       movq -392(%rbp), %rsi                      # _vr112 -> %rsi
       movq %rsi, %rdi                            # realloc vr
       movq %rdi, %r15                            # realloc vr
       call *0(%r15)                              # call *0(_vr112)
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       addq $8, %rsp                              # addq $8, %rsp
    # Null check this                             # 
       movq 16(%rbp), %rdi                        # this -> %rdi
       movq %rdi, %rsi                            # movq this, _vr113
       movq %rsi, -400(%rbp)                      # %rsi -> _vr113
       movq -400(%rbp), %rsi                      # _vr113 -> %rsi
       cmpq $0, %rsi                              # cmpq $0, _vr113
       je labelNullPtrError                       # je labelNullPtrError
    # this.sieveAll()                             # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       pushq %rsi                                 # pushq this
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rdi                            # movq this, _vr114
       movq %rdi, -408(%rbp)                      # %rdi -> _vr114
       movq -408(%rbp), %rdi                      # _vr114 -> %rdi
       movq (%rdi), %rdi                          # movq (_vr114), _vr114
       movq %rdi, -408(%rbp)                      # %rdi -> _vr114
       movq -408(%rbp), %rdi                      # _vr114 -> %rdi
       movq %rdi, %r15                            # realloc vr
       call *8(%r15)                              # call *8(_vr114)
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       addq $8, %rsp                              # addq $8, %rsp
    # Null check this                             # 
       movq 16(%rbp), %rdi                        # this -> %rdi
       movq %rdi, %rsi                            # movq this, _vr115
       movq %rsi, -416(%rbp)                      # %rsi -> _vr115
       movq -416(%rbp), %rsi                      # _vr115 -> %rsi
       cmpq $0, %rsi                              # cmpq $0, _vr115
       je labelNullPtrError                       # je labelNullPtrError
    # this.printPrimes()                          # 
       movq 16(%rbp), %rsi                        # this -> %rsi
       pushq %rsi                                 # pushq this
       movq 16(%rbp), %rsi                        # this -> %rsi
       movq %rsi, %rdi                            # movq this, _vr116
       movq %rdi, -424(%rbp)                      # %rdi -> _vr116
       movq -424(%rbp), %rdi                      # _vr116 -> %rdi
       movq (%rdi), %rdi                          # movq (_vr116), _vr116
       movq %rdi, -424(%rbp)                      # %rdi -> _vr116
       movq -424(%rbp), %rdi                      # _vr116 -> %rdi
       movq %rdi, %r15                            # realloc vr
       call *24(%r15)                             # call *24(_vr116)
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       addq $8, %rsp                              # addq $8, %rsp
    # Library.println()                           # 
       movq _str4(%rip), %rdi                     # movq _str4(%rip), %rdi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
       movq -176(%rbp), %rdi                      # %rdi -> %rdi
       call __LIB_println                         # call __LIB_println
       movq %r8, -184(%rbp)                       # %r8 -> %r8
       movq %r9, -192(%rbp)                       # %r9 -> %r9
       movq %r10, -200(%rbp)                      # %r10 -> %r10
       movq %r11, -208(%rbp)                      # %r11 -> %r11
       movq %rax, -144(%rbp)                      # %rax -> %rax
       movq %rcx, -216(%rbp)                      # %rcx -> %rcx
       movq %rdx, -224(%rbp)                      # %rdx -> %rdx
       movq %rsi, -232(%rbp)                      # %rsi -> %rsi
       movq %rdi, -176(%rbp)                      # %rdi -> %rdi
    # return                                      # 
       movq -64(%rbp), %rsi                       # _vr89 -> %rsi
       movq %rsi, %r12                            # movq _vr89, %r12
       movq %r12, -24(%rbp)                       # %r12 -> %r12
       movq -72(%rbp), %r12                       # _vr90 -> %r12
       movq %r12, %r13                            # movq _vr90, %r13
       movq %r13, -32(%rbp)                       # %r13 -> %r13
       movq -80(%rbp), %r13                       # _vr91 -> %r13
       movq %r13, %r14                            # movq _vr91, %r14
       movq %r14, -40(%rbp)                       # %r14 -> %r14
       movq -88(%rbp), %r14                       # _vr92 -> %r14
       movq %r14, %r15                            # movq _vr92, %r15
       movq %r15, -48(%rbp)                       # %r15 -> %r15
       movq -96(%rbp), %r15                       # _vr93 -> %r15
       movq %r15, %rbx                            # movq _vr93, %rbx
       movq %rbx, -56(%rbp)                       # %rbx -> %rbx
       movq -24(%rbp), %r12                       # %r12 -> %r12
       movq -32(%rbp), %r13                       # %r13 -> %r13
       movq -40(%rbp), %r14                       # %r14 -> %r14
       movq -48(%rbp), %r15                       # %r15 -> %r15
       movq -56(%rbp), %rbx                       # %rbx -> %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_Sieve_main:
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

       movq $16, %rdi                 # o = new Sieve

       call __LIB_allocateObject   
       leaq _Sieve_VT(%rip), %rdi       

       movq %rdi, (%rax)
       pushq %rax                        # o.main(args) -> push o
       movq (%rax), %rax            
       call *32(%rax)                   # main is at offset 32 in vtable

       addq $16, %rsp                
       movq $0, %rax                     # __ic_main always returns 0

       movq %rbp,%rsp                    # epilogue
       popq %rbp                    
       ret                         



# ----------------------------
# String Constants

.data
.align 8

.quad 1
  _str2Chars:	.ascii " "
_str2:	.quad _str2Chars
.quad 17
  _str0Chars:	.ascii "Primes less than "
_str0:	.quad _str0Chars
.quad 19
  _str3Chars:	.ascii "Unspecified number."
_str3:	.quad _str3Chars
.quad 20
  _str5Chars:	.ascii "Invalid array length"
_str5:	.quad _str5Chars
.quad 0
  _str4Chars:	.ascii ""
_str4:	.quad _str4Chars
.quad 2
  _str1Chars:	.ascii ": "
_str1:	.quad _str1Chars



