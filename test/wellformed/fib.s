;;;  File test/wellformed/fib.s

	 .requ	bump, r3
	 b      main
;; ----------------------------
;; VTables


FibonacciVT:
	.data 	FibonacciMain, FibonacciFib,0





FibonacciMain:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #23

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(args),2)                ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr1, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr1
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr2, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr2
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr3, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr3
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr4, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr4
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr5, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr5
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr6, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr6
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr7, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr7
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
       ldr    r9, [fp, #3]                        ;;;ldr    args, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> args
    ;;; n = 10                                    ;;;
       mov    r9, #10                             ;;;mov    n, #10
       str r9, [fp, #-17 ]                        ;;;r9 -> n
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr8, this
       str r10, [fp, #-18 ]                       ;;;r10 -> _vr8
       ldr r10, [fp, #-18 ]                       ;;;_vr8 -> r10
       cmp    r10, #0                             ;;;cmp    _vr8, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t0 = this.fib(n)                          ;;;
       ldr r10, [fp, #-17 ]                       ;;;n -> r10
       stu    r10, [sp, #-1]                      ;;;stu    n, [sp, #-1]
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       stu    r10, [sp, #-1]                      ;;;stu    this, [sp, #-1]
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov     r1, r10                            ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #1]                        ;;;ldr    r1, [r1, #1]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
       add    sp, sp, #2                          ;;;add    sp, sp, #2
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt0, r0
       str r2, [fp, #-21 ]                        ;;;r2 -> _tt0
    ;;; r = t0                                    ;;;
       ldr r2, [fp, #-21 ]                        ;;;_tt0 -> r2
       mov    r0, r2                              ;;;mov    r, _tt0
       str r0, [fp, #-22 ]                        ;;;r0 -> r
    ;;; Library.printi(r)                         ;;;
       ldr r0, [fp, #-22 ]                        ;;;r -> r0
       mov	r2, r0                                 ;;;realloc vr
       mov    r0, r2                              ;;;mov    r0, r
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       bl LIBPrinti                               ;;;bl LIBPrinti
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
    ;;; t1 =                                      ;;;
       adr      r2, str0                          ;;;adr      _tt1, str0
       str r2, [fp, #-23 ]                        ;;;r2 -> _tt1
    ;;; Library.println(t1)                       ;;;
       ldr r2, [fp, #-23 ]                        ;;;_tt1 -> r2
       mov    r0, r2                              ;;;mov    r0, _tt1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       bl LIBPrintln                              ;;;bl LIBPrintln
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
    ;;; return                                    ;;;
       ldr r2, [fp, #-10 ]                        ;;;_vr1 -> r2
       mov    r4, r2                              ;;;mov    r4, _vr1
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr2 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr2
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr3 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr3
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr4 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr4
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr5 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr5
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr6 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr6
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr7 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr7
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
    ;;; Fake Use of all callee save registers     ;;;
       mov    sp, fp                              ;;;mov    sp, fp
       ldu    fp, [sp, #1]                        ;;;ldu    fp, [sp, #1]
       ldu    pc, [sp, #1]                        ;;;ldu    pc, [sp, #1]

FibonacciFib:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #33

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(n),12)                  ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr10, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr10
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr11, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr11
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr12, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr12
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr13, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr13
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr14, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr14
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr15, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr15
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr16, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr16
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
       ldr    r9, [fp, #3]                        ;;;ldr    n, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> n
    ;;; t0 = n < 2                                ;;;
       mov      r9,#2                             ;;;mov      _vr18,#2
       str r9, [fp, #-17 ]                        ;;;r9 -> _vr18
       ldr r9, [fp, #3 ]                          ;;;n -> r9
       mov    r10, r9                             ;;;mov    _vr17, n
       str r10, [fp, #-18 ]                       ;;;r10 -> _vr17
       ldr r10, [fp, #-18 ]                       ;;;_vr17 -> r10
       ldr r9, [fp, #-17 ]                        ;;;_vr18 -> r9
       cmp    r10, r9                             ;;;cmp    _vr17, _vr18
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r9, r0                              ;;;mov    _tt0, r0
       str r9, [fp, #-20 ]                        ;;;r9 -> _tt0
    ;;; t1 = !t0                                  ;;;
       mov    r9, #1                              ;;;mov    _tt1, #1
       str r9, [fp, #-21 ]                        ;;;r9 -> _tt1
       ldr r9, [fp, #-21 ]                        ;;;_tt1 -> r9
       ldr r0, [fp, #-20 ]                        ;;;_tt0 -> r0
       eor    r9, r9, r0                          ;;;eor    _tt1, _tt1, _tt0
       str r9, [fp, #-21 ]                        ;;;r9 -> _tt1
    ;;; cjump L0:                                 ;;;
       ldr r0, [fp, #-21 ]                        ;;;_tt1 -> r0
       mov    r9, r0                              ;;;mov    _vr19, _tt1
       str r9, [fp, #-22 ]                        ;;;r9 -> _vr19
       ldr r9, [fp, #-21 ]                        ;;;_tt1 -> r9
       tst    r9, #1                              ;;;tst    _tt1, #1
       bne    L0                                  ;;;bne    L0
    ;;; return n                                  ;;;
       ldr r9, [fp, #3 ]                          ;;;n -> r9
       mov    r0, r9                              ;;;mov    r0, n
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-10 ]                        ;;;_vr10 -> r0
       mov    r4, r0                              ;;;mov    r4, _vr10
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr11 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr11
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr12 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr12
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr13 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr13
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr14 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr14
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr15 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr15
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr16 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr16
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
    ;;; Fake Use of all callee save registers     ;;;
       mov    sp, fp                              ;;;mov    sp, fp
       ldu    fp, [sp, #1]                        ;;;ldu    fp, [sp, #1]
       ldu    pc, [sp, #1]                        ;;;ldu    pc, [sp, #1]
    ;;; L0:                                       ;;;
L0:                                               ;;;L0:
    ;;; t3 = n - 1                                ;;;
       ldr r0, [fp, #3 ]                          ;;;n -> r0
       mov    r10, r0                             ;;;mov    _vr20, n
       str r10, [fp, #-23 ]                       ;;;r10 -> _vr20
       ldr r10, [fp, #-23 ]                       ;;;_vr20 -> r10
       sub    r0, r10, #1                         ;;;sub    _tt3, _vr20, #1
       str r0, [fp, #-24 ]                        ;;;r0 -> _tt3
    ;;; Null check this                           ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr21, this
       str r10, [fp, #-25 ]                       ;;;r10 -> _vr21
       ldr r10, [fp, #-25 ]                       ;;;_vr21 -> r10
       cmp    r10, #0                             ;;;cmp    _vr21, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t4 = this.fib(t3)                         ;;;
       ldr r10, [fp, #-24 ]                       ;;;_tt3 -> r10
       stu    r10, [sp, #-1]                      ;;;stu    _tt3, [sp, #-1]
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       stu    r10, [sp, #-1]                      ;;;stu    this, [sp, #-1]
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov     r1, r10                            ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #1]                        ;;;ldr    r1, [r1, #1]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-26 ]                        ;;;r2 -> r2
       add    sp, sp, #2                          ;;;add    sp, sp, #2
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt4, r0
       str r2, [fp, #-27 ]                        ;;;r2 -> _tt4
    ;;; t5 = n - 2                                ;;;
       ldr r2, [fp, #3 ]                          ;;;n -> r2
       mov    r0, r2                              ;;;mov    _vr23, n
       str r0, [fp, #-28 ]                        ;;;r0 -> _vr23
       ldr r0, [fp, #-28 ]                        ;;;_vr23 -> r0
       sub    r2, r0, #2                          ;;;sub    _tt5, _vr23, #2
       str r2, [fp, #-29 ]                        ;;;r2 -> _tt5
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr24, this
       str r0, [fp, #-30 ]                        ;;;r0 -> _vr24
       ldr r0, [fp, #-30 ]                        ;;;_vr24 -> r0
       cmp    r0, #0                              ;;;cmp    _vr24, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t6 = this.fib(t5)                         ;;;
       ldr r0, [fp, #-29 ]                        ;;;_tt5 -> r0
       stu    r0, [sp, #-1]                       ;;;stu    _tt5, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       stu    r0, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov     r1, r0                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #1]                        ;;;ldr    r1, [r1, #1]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-26 ]                        ;;;r2 -> r2
       add    sp, sp, #2                          ;;;add    sp, sp, #2
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt6, r0
       str r2, [fp, #-31 ]                        ;;;r2 -> _tt6
    ;;; t2 = t4 + t6                              ;;;
       ldr r2, [fp, #-27 ]                        ;;;_tt4 -> r2
       mov    r0, r2                              ;;;mov    _vr26, _tt4
       str r0, [fp, #-32 ]                        ;;;r0 -> _vr26
       ldr r0, [fp, #-32 ]                        ;;;_vr26 -> r0
       ldr r2, [fp, #-31 ]                        ;;;_tt6 -> r2
       add    r10, r0, r2                         ;;;add    _tt2, _vr26, _tt6
       str r10, [fp, #-33 ]                       ;;;r10 -> _tt2
    ;;; return t2                                 ;;;
       ldr r10, [fp, #-33 ]                       ;;;_tt2 -> r10
       mov    r0, r10                             ;;;mov    r0, _tt2
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-10 ]                        ;;;_vr10 -> r0
       mov    r4, r0                              ;;;mov    r4, _vr10
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr11 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr11
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr12 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr12
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr13 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr13
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr14 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr14
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr15 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr15
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr16 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr16
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
    ;;; Fake Use of all callee save registers     ;;;
       mov    sp, fp                              ;;;mov    sp, fp
       ldu    fp, [sp, #1]                        ;;;ldu    fp, [sp, #1]
       ldu    pc, [sp, #1]                        ;;;ldu    pc, [sp, #1]
    ;;; return                                    ;;;
       ldr r0, [fp, #-10 ]                        ;;;_vr10 -> r0
       mov    r4, r0                              ;;;mov    r4, _vr10
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr11 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr11
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr12 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr12
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr13 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr13
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr14 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr14
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr15 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr15
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr16 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr16
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
    ;;; Fake Use of all callee save registers     ;;;
       mov    sp, fp                              ;;;mov    sp, fp
       ldu    fp, [sp, #1]                        ;;;ldu    fp, [sp, #1]
       ldu    pc, [sp, #1]                        ;;;ldu    pc, [sp, #1]

;; ----------------------------
;; Error handling.  Jump to these procedures when a run-time check fails.

strNullPtrError: 
	 .string 	"Null pointer violation."

strArrayBoundsError: 
	.string 	 "Array bounds violation."

strArraySizeError: 
		.string 	 "Array size violation."

strdivByZeroError:   
	  .string "Divide by 0 violation."

labelNullPtrError:
	 adr    r0, strNullPtrError
	 bl     LIBPrintln
	 mov    r0, #1
	 swi    #SysHalt


labelArrayBoundsError:
	 adr    r0, strArrayBoundsError
	 bl     LIBPrintln
	 mov    r0, #1
	 swi    #SysHalt


labelArraySizeError:
	 adr    r0, strArraySizeError
	 bl     LIBPrintln
	 mov    r0, #1
	 swi    #SysHalt


labelDivByZeroError:
	 adr    r0, strdivByZeroError
	 bl     LIBPrintln
	 mov    r0, #1
	 swi    #SysHalt




main:
;;; main, set the bump pointer to the beginning of the heap
	 adr    bump, heap      				
	 stu    lr, [sp, #-1]    				
	 stu    fp, [sp, #-1]    				
	 mov    fp, sp         			  

;;; o = new Fibonacci          
	 mov    r0,  #1   
	 bl     LIBAllocateObject   			
	 adr    r1, FibonacciVT      

;;; move the vptr into the object
	 str    r1, [r0]               


;;; call the object's main       
	 stu    r0, [sp, #-1]  
	 stu    r0, [sp, #-1]  
	 bl     FibonacciMain      


;;;ic_main always returns 0
	 mov    r0, #0                 
	 mov    sp, fp                 
	 ldu    fp, [sp, #1]           
	 swi    #SysHalt

;;; ----------------------------
;;; String Constants


str0:	.string ""



;;; ------------------------------
;;; Library Calls


LIBAllocateObject:
;;; object size gets passed in r0
	stu     lr, [sp, #-1]
	mov     r1, bump
	add     bump, r0, bump
	mov     r0, r1
	ldu     pc, [sp, #1]



LIBAllocateArray:
	stu	   lr, [sp, #-1]
	str     r0, [bump]
	mov	   r1, bump
	add	   bump, r0, bump
	mov	   r0, r1
	ldu	   pc, [sp, #1]



LIBPrintln:
;;; address of the string is in r0
	 stu	lr, [sp, #-1]
	 mov	r1, r0


printlnLoop:	
	 ldrs   r0, [r1]
	 beq    printlnDone
	 swi    #SysPutChar
	 add    r1, r1, #1
	 b      printlnLoop


printlnDone:
	 mov	   r0, #10
	 swi	   #SysPutChar
	 ldu	   pc, [sp, #1]
	 

LIBPrint:
	stu	lr, [sp, #-1]
	mov	r1, r0
printLoop:
	ldrs    r0, [r1]
	beq	   printDone
	swi	   #SysPutChar
	add	   r1, r1, #1
	b	     printLoop
printDone:
	ldu	   pc, [sp, #1]
LIBPrinti:
	stu	   lr, [sp, #-1]
	swi	   #SysPutNum
	ldu	   pc, [sp, #1]



LIBPrintb:
	stu	   lr, [sp, #-1]
	cmp	   r0, #1
	beq	   true



false:	mov	r0, #'F
	swi 	  #SysPutChar
	mov	  r0, #'a
	swi 	  #SysPutChar
	mov	  r0, #'l
	swi 	  #SysPutChar
	mov	  r0, #'s
	swi 	  #SysPutChar
	mov	  r0, #'e
	swi 	  #SysPutChar
	ldu	  pc, [sp, #1]
true:	mov    r0, #'T
	swi 	  #SysPutChar
	mov	  r0, #'r
	swi 	  #SysPutChar
	mov	  r0, #'u
	swi 	  #SysPutChar
	mov	  r0, #'e
	swi 	  #SysPutChar
	ldu	  pc, [sp, #1]
LIBExit:
	swi	  #SysHalt
heap:
