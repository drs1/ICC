;;;  File test/qsort_test.s

	 .requ	bump, r3
	 b      main
;; ----------------------------
;; VTables


QuicksortVT:
	.data 	QuicksortPartition, QuicksortQuicksort, QuicksortInitArray, QuicksortPrintArray, QuicksortMain,0


QuicksortPartition:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #109

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(low, high),5)           ;;;
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
       ldr    r9, [fp, #3]                        ;;;ldr    low, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> low
       ldr    r9, [fp, #4]                        ;;;ldr    high, [fp, #4]
       str r9, [fp, #4 ]                          ;;;r9 -> high
    ;;; j = high                                  ;;;
       ldr r9, [fp, #4 ]                          ;;;high -> r9
       mov    r10, r9                             ;;;mov    j, high
       str r10, [fp, #-17 ]                       ;;;r10 -> j
    ;;; i = low                                   ;;;
       ldr r10, [fp, #3 ]                         ;;;low -> r10
       mov    r9, r10                             ;;;mov    i, low
       str r9, [fp, #-18 ]                        ;;;r9 -> i
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr8, this
       str r10, [fp, #-19 ]                       ;;;r10 -> _vr8
       ldr r10, [fp, #-19 ]                       ;;;_vr8 -> r10
       cmp    r10, #0                             ;;;cmp    _vr8, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t1 = this.a                               ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r9, r10                             ;;;mov    _vr9, this
       str r9, [fp, #-20 ]                        ;;;r9 -> _vr9
       ldr r9, [fp, #-20 ]                        ;;;_vr9 -> r9
       ldr    r10, [r9, #1]                       ;;;ldr    _tt1, [_vr9, #1]
       str r10, [fp, #-21 ]                       ;;;r10 -> _tt1
    ;;; Null check t1                             ;;;
       ldr r10, [fp, #-21 ]                       ;;;_tt1 -> r10
       mov    r9, r10                             ;;;mov    _vr10, _tt1
       str r9, [fp, #-22 ]                        ;;;r9 -> _vr10
       ldr r9, [fp, #-22 ]                        ;;;_vr10 -> r9
       cmp    r9, #0                              ;;;cmp    _vr10, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if low in bounds t1                 ;;;
       ldr r9, [fp, #3 ]                          ;;;low -> r9
       mov    r10, r9                             ;;;mov    _vr11, low
       str r10, [fp, #-23 ]                       ;;;r10 -> _vr11
       ldr r10, [fp, #-23 ]                       ;;;_vr11 -> r10
       cmp    r10, #0                             ;;;cmp    _vr11, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-21 ]                       ;;;_tt1 -> r10
       mov    r9, r10                             ;;;mov    _vr12, _tt1
       str r9, [fp, #-24 ]                        ;;;r9 -> _vr12
    ;;; t0 = t1[low]                              ;;;
       ldr r9, [fp, #-21 ]                        ;;;_tt1 -> r9
       mov    r10, r9                             ;;;mov    _vr13, _tt1
       str r10, [fp, #-25 ]                       ;;;r10 -> _vr13
       ldr r10, [fp, #3 ]                         ;;;low -> r10
       mov    r9, r10                             ;;;mov    _vr14, low
       str r9, [fp, #-26 ]                        ;;;r9 -> _vr14
       ldr r9, [fp, #-25 ]                        ;;;_vr13 -> r9
       ldr r10, [fp, #-26 ]                       ;;;_vr14 -> r10
       ldr    r8, [r9, r10]                       ;;;ldr    _tt0, [_vr13, _vr14]
       str r8, [fp, #-27 ]                        ;;;r8 -> _tt0
    ;;; pivot = t0                                ;;;
       ldr r8, [fp, #-27 ]                        ;;;_tt0 -> r8
       mov    r10, r8                             ;;;mov    pivot, _tt0
       str r10, [fp, #-28 ]                       ;;;r10 -> pivot
    ;;; L0:                                       ;;;
L0:                                               ;;;L0:
    ;;; t2 = !"true"                              ;;;
       mov    r10, #1                             ;;;mov    _tt2, #1
       str r10, [fp, #-29 ]                       ;;;r10 -> _tt2
       ldr r10, [fp, #-29 ]                       ;;;_tt2 -> r10
       eor    r10, r10, #1                        ;;;eor    _tt2, _tt2, #1
       str r10, [fp, #-29 ]                       ;;;r10 -> _tt2
    ;;; cjump L1:                                 ;;;
       ldr r10, [fp, #-29 ]                       ;;;_tt2 -> r10
       mov    r8, r10                             ;;;mov    _vr15, _tt2
       str r8, [fp, #-30 ]                        ;;;r8 -> _vr15
       ldr r8, [fp, #-29 ]                        ;;;_tt2 -> r8
       tst    r8, #1                              ;;;tst    _tt2, #1
       bne    L1                                  ;;;bne    L1
    ;;; L2:                                       ;;;
L2:                                               ;;;L2:
    ;;; Null check this                           ;;;
       ldr r8, [fp, #2 ]                          ;;;this -> r8
       mov    r10, r8                             ;;;mov    _vr16, this
       str r10, [fp, #-31 ]                       ;;;r10 -> _vr16
       ldr r10, [fp, #-31 ]                       ;;;_vr16 -> r10
       cmp    r10, #0                             ;;;cmp    _vr16, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t5 = this.a                               ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r8, r10                             ;;;mov    _vr17, this
       str r8, [fp, #-32 ]                        ;;;r8 -> _vr17
       ldr r8, [fp, #-32 ]                        ;;;_vr17 -> r8
       ldr    r10, [r8, #1]                       ;;;ldr    _tt5, [_vr17, #1]
       str r10, [fp, #-33 ]                       ;;;r10 -> _tt5
    ;;; Null check t5                             ;;;
       ldr r10, [fp, #-33 ]                       ;;;_tt5 -> r10
       mov    r8, r10                             ;;;mov    _vr18, _tt5
       str r8, [fp, #-34 ]                        ;;;r8 -> _vr18
       ldr r8, [fp, #-34 ]                        ;;;_vr18 -> r8
       cmp    r8, #0                              ;;;cmp    _vr18, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t5                   ;;;
       ldr r8, [fp, #-18 ]                        ;;;i -> r8
       mov    r10, r8                             ;;;mov    _vr19, i
       str r10, [fp, #-35 ]                       ;;;r10 -> _vr19
       ldr r10, [fp, #-35 ]                       ;;;_vr19 -> r10
       cmp    r10, #0                             ;;;cmp    _vr19, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-33 ]                       ;;;_tt5 -> r10
       mov    r8, r10                             ;;;mov    _vr20, _tt5
       str r8, [fp, #-36 ]                        ;;;r8 -> _vr20
    ;;; t4 = t5[i]                                ;;;
       ldr r8, [fp, #-33 ]                        ;;;_tt5 -> r8
       mov    r10, r8                             ;;;mov    _vr21, _tt5
       str r10, [fp, #-37 ]                       ;;;r10 -> _vr21
       ldr r10, [fp, #-18 ]                       ;;;i -> r10
       mov    r8, r10                             ;;;mov    _vr22, i
       str r8, [fp, #-38 ]                        ;;;r8 -> _vr22
       ldr r8, [fp, #-37 ]                        ;;;_vr21 -> r8
       ldr r10, [fp, #-38 ]                       ;;;_vr22 -> r10
       ldr    r9, [r8, r10]                       ;;;ldr    _tt4, [_vr21, _vr22]
       str r9, [fp, #-39 ]                        ;;;r9 -> _tt4
    ;;; t3 = t4 < pivot                           ;;;
       ldr r9, [fp, #-28 ]                        ;;;pivot -> r9
       mov    r10, r9                             ;;;mov    _vr24, pivot
       str r10, [fp, #-40 ]                       ;;;r10 -> _vr24
       ldr r10, [fp, #-39 ]                       ;;;_tt4 -> r10
       mov    r9, r10                             ;;;mov    _vr23, _tt4
       str r9, [fp, #-41 ]                        ;;;r9 -> _vr23
       ldr r9, [fp, #-41 ]                        ;;;_vr23 -> r9
       ldr r10, [fp, #-40 ]                       ;;;_vr24 -> r10
       cmp    r9, r10                             ;;;cmp    _vr23, _vr24
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt3, r0
       str r10, [fp, #-43 ]                       ;;;r10 -> _tt3
    ;;; t6 = !t3                                  ;;;
       mov    r10, #1                             ;;;mov    _tt6, #1
       str r10, [fp, #-44 ]                       ;;;r10 -> _tt6
       ldr r10, [fp, #-44 ]                       ;;;_tt6 -> r10
       ldr r0, [fp, #-43 ]                        ;;;_tt3 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt6, _tt6, _tt3
       str r10, [fp, #-44 ]                       ;;;r10 -> _tt6
    ;;; cjump L3:                                 ;;;
       ldr r0, [fp, #-44 ]                        ;;;_tt6 -> r0
       mov    r10, r0                             ;;;mov    _vr25, _tt6
       str r10, [fp, #-45 ]                       ;;;r10 -> _vr25
       ldr r10, [fp, #-44 ]                       ;;;_tt6 -> r10
       tst    r10, #1                             ;;;tst    _tt6, #1
       bne    L3                                  ;;;bne    L3
    ;;; t7 = i + 1                                ;;;
       ldr r10, [fp, #-18 ]                       ;;;i -> r10
       mov    r0, r10                             ;;;mov    _vr26, i
       str r0, [fp, #-46 ]                        ;;;r0 -> _vr26
       ldr r0, [fp, #-46 ]                        ;;;_vr26 -> r0
       add    r10, r0, #1                         ;;;add    _tt7, _vr26, #1
       str r10, [fp, #-47 ]                       ;;;r10 -> _tt7
    ;;; i = t7                                    ;;;
       ldr r10, [fp, #-47 ]                       ;;;_tt7 -> r10
       mov    r0, r10                             ;;;mov    i, _tt7
       str r0, [fp, #-18 ]                        ;;;r0 -> i
    ;;; jump L2:                                  ;;;
       b    L2                                    ;;;b    L2
    ;;; L3:                                       ;;;
L3:                                               ;;;L3:
    ;;; L4:                                       ;;;
L4:                                               ;;;L4:
    ;;; Null check this                           ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr27, this
       str r10, [fp, #-48 ]                       ;;;r10 -> _vr27
       ldr r10, [fp, #-48 ]                       ;;;_vr27 -> r10
       cmp    r10, #0                             ;;;cmp    _vr27, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t10 = this.a                              ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr28, this
       str r0, [fp, #-49 ]                        ;;;r0 -> _vr28
       ldr r0, [fp, #-49 ]                        ;;;_vr28 -> r0
       ldr    r10, [r0, #1]                       ;;;ldr    _tt10, [_vr28, #1]
       str r10, [fp, #-50 ]                       ;;;r10 -> _tt10
    ;;; Null check t10                            ;;;
       ldr r10, [fp, #-50 ]                       ;;;_tt10 -> r10
       mov    r0, r10                             ;;;mov    _vr29, _tt10
       str r0, [fp, #-51 ]                        ;;;r0 -> _vr29
       ldr r0, [fp, #-51 ]                        ;;;_vr29 -> r0
       cmp    r0, #0                              ;;;cmp    _vr29, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t10                  ;;;
       ldr r0, [fp, #-17 ]                        ;;;j -> r0
       mov    r10, r0                             ;;;mov    _vr30, j
       str r10, [fp, #-52 ]                       ;;;r10 -> _vr30
       ldr r10, [fp, #-52 ]                       ;;;_vr30 -> r10
       cmp    r10, #0                             ;;;cmp    _vr30, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-50 ]                       ;;;_tt10 -> r10
       mov    r0, r10                             ;;;mov    _vr31, _tt10
       str r0, [fp, #-53 ]                        ;;;r0 -> _vr31
    ;;; t9 = t10[j]                               ;;;
       ldr r0, [fp, #-50 ]                        ;;;_tt10 -> r0
       mov    r10, r0                             ;;;mov    _vr32, _tt10
       str r10, [fp, #-54 ]                       ;;;r10 -> _vr32
       ldr r10, [fp, #-17 ]                       ;;;j -> r10
       mov    r0, r10                             ;;;mov    _vr33, j
       str r0, [fp, #-55 ]                        ;;;r0 -> _vr33
       ldr r0, [fp, #-54 ]                        ;;;_vr32 -> r0
       ldr r10, [fp, #-55 ]                       ;;;_vr33 -> r10
       ldr    r9, [r0, r10]                       ;;;ldr    _tt9, [_vr32, _vr33]
       str r9, [fp, #-56 ]                        ;;;r9 -> _tt9
    ;;; t8 = t9 > pivot                           ;;;
       ldr r9, [fp, #-28 ]                        ;;;pivot -> r9
       mov    r10, r9                             ;;;mov    _vr35, pivot
       str r10, [fp, #-57 ]                       ;;;r10 -> _vr35
       ldr r10, [fp, #-56 ]                       ;;;_tt9 -> r10
       mov    r9, r10                             ;;;mov    _vr34, _tt9
       str r9, [fp, #-58 ]                        ;;;r9 -> _vr34
       ldr r9, [fp, #-58 ]                        ;;;_vr34 -> r9
       ldr r10, [fp, #-57 ]                       ;;;_vr35 -> r10
       cmp    r9, r10                             ;;;cmp    _vr34, _vr35
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
       movgt    r0, #1                            ;;;movgt    r0, #1
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt8, r0
       str r10, [fp, #-59 ]                       ;;;r10 -> _tt8
    ;;; t11 = !t8                                 ;;;
       mov    r10, #1                             ;;;mov    _tt11, #1
       str r10, [fp, #-60 ]                       ;;;r10 -> _tt11
       ldr r10, [fp, #-60 ]                       ;;;_tt11 -> r10
       ldr r0, [fp, #-59 ]                        ;;;_tt8 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt11, _tt11, _tt8
       str r10, [fp, #-60 ]                       ;;;r10 -> _tt11
    ;;; cjump L5:                                 ;;;
       ldr r0, [fp, #-60 ]                        ;;;_tt11 -> r0
       mov    r10, r0                             ;;;mov    _vr36, _tt11
       str r10, [fp, #-61 ]                       ;;;r10 -> _vr36
       ldr r10, [fp, #-60 ]                       ;;;_tt11 -> r10
       tst    r10, #1                             ;;;tst    _tt11, #1
       bne    L5                                  ;;;bne    L5
    ;;; t12 = j - 1                               ;;;
       ldr r10, [fp, #-17 ]                       ;;;j -> r10
       mov    r0, r10                             ;;;mov    _vr37, j
       str r0, [fp, #-62 ]                        ;;;r0 -> _vr37
       ldr r0, [fp, #-62 ]                        ;;;_vr37 -> r0
       sub    r10, r0, #1                         ;;;sub    _tt12, _vr37, #1
       str r10, [fp, #-63 ]                       ;;;r10 -> _tt12
    ;;; j = t12                                   ;;;
       ldr r10, [fp, #-63 ]                       ;;;_tt12 -> r10
       mov    r0, r10                             ;;;mov    j, _tt12
       str r0, [fp, #-17 ]                        ;;;r0 -> j
    ;;; jump L4:                                  ;;;
       b    L4                                    ;;;b    L4
    ;;; L5:                                       ;;;
L5:                                               ;;;L5:
    ;;; t13 = i >= j                              ;;;
       ldr r0, [fp, #-17 ]                        ;;;j -> r0
       mov    r10, r0                             ;;;mov    _vr39, j
       str r10, [fp, #-64 ]                       ;;;r10 -> _vr39
       ldr r10, [fp, #-18 ]                       ;;;i -> r10
       mov    r0, r10                             ;;;mov    _vr38, i
       str r0, [fp, #-65 ]                        ;;;r0 -> _vr38
       ldr r0, [fp, #-65 ]                        ;;;_vr38 -> r0
       ldr r10, [fp, #-64 ]                       ;;;_vr39 -> r10
       cmp    r0, r10                             ;;;cmp    _vr38, _vr39
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
       movge    r0, #1                            ;;;movge    r0, #1
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt13, r0
       str r10, [fp, #-66 ]                       ;;;r10 -> _tt13
    ;;; t14 = !t13                                ;;;
       mov    r10, #1                             ;;;mov    _tt14, #1
       str r10, [fp, #-67 ]                       ;;;r10 -> _tt14
       ldr r10, [fp, #-67 ]                       ;;;_tt14 -> r10
       ldr r0, [fp, #-66 ]                        ;;;_tt13 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt14, _tt14, _tt13
       str r10, [fp, #-67 ]                       ;;;r10 -> _tt14
    ;;; cjump L6:                                 ;;;
       ldr r0, [fp, #-67 ]                        ;;;_tt14 -> r0
       mov    r10, r0                             ;;;mov    _vr40, _tt14
       str r10, [fp, #-68 ]                       ;;;r10 -> _vr40
       ldr r10, [fp, #-67 ]                       ;;;_tt14 -> r10
       tst    r10, #1                             ;;;tst    _tt14, #1
       bne    L6                                  ;;;bne    L6
    ;;; jump L1:                                  ;;;
       b    L1                                    ;;;b    L1
    ;;; L6:                                       ;;;
L6:                                               ;;;L6:
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr41, this
       str r0, [fp, #-69 ]                        ;;;r0 -> _vr41
       ldr r0, [fp, #-69 ]                        ;;;_vr41 -> r0
       cmp    r0, #0                              ;;;cmp    _vr41, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t16 = this.a                              ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr42, this
       str r10, [fp, #-70 ]                       ;;;r10 -> _vr42
       ldr r10, [fp, #-70 ]                       ;;;_vr42 -> r10
       ldr    r0, [r10, #1]                       ;;;ldr    _tt16, [_vr42, #1]
       str r0, [fp, #-71 ]                        ;;;r0 -> _tt16
    ;;; Null check t16                            ;;;
       ldr r0, [fp, #-71 ]                        ;;;_tt16 -> r0
       mov    r10, r0                             ;;;mov    _vr43, _tt16
       str r10, [fp, #-72 ]                       ;;;r10 -> _vr43
       ldr r10, [fp, #-72 ]                       ;;;_vr43 -> r10
       cmp    r10, #0                             ;;;cmp    _vr43, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t16                  ;;;
       ldr r10, [fp, #-18 ]                       ;;;i -> r10
       mov    r0, r10                             ;;;mov    _vr44, i
       str r0, [fp, #-73 ]                        ;;;r0 -> _vr44
       ldr r0, [fp, #-73 ]                        ;;;_vr44 -> r0
       cmp    r0, #0                              ;;;cmp    _vr44, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-71 ]                        ;;;_tt16 -> r0
       mov    r10, r0                             ;;;mov    _vr45, _tt16
       str r10, [fp, #-74 ]                       ;;;r10 -> _vr45
    ;;; t15 = t16[i]                              ;;;
       ldr r10, [fp, #-71 ]                       ;;;_tt16 -> r10
       mov    r0, r10                             ;;;mov    _vr46, _tt16
       str r0, [fp, #-75 ]                        ;;;r0 -> _vr46
       ldr r0, [fp, #-18 ]                        ;;;i -> r0
       mov    r10, r0                             ;;;mov    _vr47, i
       str r10, [fp, #-76 ]                       ;;;r10 -> _vr47
       ldr r10, [fp, #-75 ]                       ;;;_vr46 -> r10
       ldr r0, [fp, #-76 ]                        ;;;_vr47 -> r0
       ldr    r9, [r10, r0]                       ;;;ldr    _tt15, [_vr46, _vr47]
       str r9, [fp, #-77 ]                        ;;;r9 -> _tt15
    ;;; tmp = t15                                 ;;;
       ldr r9, [fp, #-77 ]                        ;;;_tt15 -> r9
       mov    r0, r9                              ;;;mov    tmp, _tt15
       str r0, [fp, #-78 ]                        ;;;r0 -> tmp
    ;;; Null check this                           ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r9, r0                              ;;;mov    _vr48, this
       str r9, [fp, #-79 ]                        ;;;r9 -> _vr48
       ldr r9, [fp, #-79 ]                        ;;;_vr48 -> r9
       cmp    r9, #0                              ;;;cmp    _vr48, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t18 = this.a                              ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r0, r9                              ;;;mov    _vr49, this
       str r0, [fp, #-80 ]                        ;;;r0 -> _vr49
       ldr r0, [fp, #-80 ]                        ;;;_vr49 -> r0
       ldr    r9, [r0, #1]                        ;;;ldr    _tt18, [_vr49, #1]
       str r9, [fp, #-81 ]                        ;;;r9 -> _tt18
    ;;; Null check t18                            ;;;
       ldr r9, [fp, #-81 ]                        ;;;_tt18 -> r9
       mov    r0, r9                              ;;;mov    _vr50, _tt18
       str r0, [fp, #-82 ]                        ;;;r0 -> _vr50
       ldr r0, [fp, #-82 ]                        ;;;_vr50 -> r0
       cmp    r0, #0                              ;;;cmp    _vr50, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t18                  ;;;
       ldr r0, [fp, #-17 ]                        ;;;j -> r0
       mov    r9, r0                              ;;;mov    _vr51, j
       str r9, [fp, #-83 ]                        ;;;r9 -> _vr51
       ldr r9, [fp, #-83 ]                        ;;;_vr51 -> r9
       cmp    r9, #0                              ;;;cmp    _vr51, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #-81 ]                        ;;;_tt18 -> r9
       mov    r0, r9                              ;;;mov    _vr52, _tt18
       str r0, [fp, #-84 ]                        ;;;r0 -> _vr52
    ;;; t17 = t18[j]                              ;;;
       ldr r0, [fp, #-81 ]                        ;;;_tt18 -> r0
       mov    r9, r0                              ;;;mov    _vr53, _tt18
       str r9, [fp, #-85 ]                        ;;;r9 -> _vr53
       ldr r9, [fp, #-17 ]                        ;;;j -> r9
       mov    r0, r9                              ;;;mov    _vr54, j
       str r0, [fp, #-86 ]                        ;;;r0 -> _vr54
       ldr r0, [fp, #-85 ]                        ;;;_vr53 -> r0
       ldr r9, [fp, #-86 ]                        ;;;_vr54 -> r9
       ldr    r10, [r0, r9]                       ;;;ldr    _tt17, [_vr53, _vr54]
       str r10, [fp, #-87 ]                       ;;;r10 -> _tt17
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r9, r10                             ;;;mov    _vr55, this
       str r9, [fp, #-88 ]                        ;;;r9 -> _vr55
       ldr r9, [fp, #-88 ]                        ;;;_vr55 -> r9
       cmp    r9, #0                              ;;;cmp    _vr55, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t19 = this.a                              ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr56, this
       str r10, [fp, #-89 ]                       ;;;r10 -> _vr56
       ldr r10, [fp, #-89 ]                       ;;;_vr56 -> r10
       ldr    r9, [r10, #1]                       ;;;ldr    _tt19, [_vr56, #1]
       str r9, [fp, #-90 ]                        ;;;r9 -> _tt19
    ;;; Null check t19                            ;;;
       ldr r9, [fp, #-90 ]                        ;;;_tt19 -> r9
       mov    r10, r9                             ;;;mov    _vr57, _tt19
       str r10, [fp, #-91 ]                       ;;;r10 -> _vr57
       ldr r10, [fp, #-91 ]                       ;;;_vr57 -> r10
       cmp    r10, #0                             ;;;cmp    _vr57, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t19                  ;;;
       ldr r10, [fp, #-18 ]                       ;;;i -> r10
       mov    r9, r10                             ;;;mov    _vr58, i
       str r9, [fp, #-92 ]                        ;;;r9 -> _vr58
       ldr r9, [fp, #-92 ]                        ;;;_vr58 -> r9
       cmp    r9, #0                              ;;;cmp    _vr58, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #-90 ]                        ;;;_tt19 -> r9
       mov    r10, r9                             ;;;mov    _vr59, _tt19
       str r10, [fp, #-93 ]                       ;;;r10 -> _vr59
    ;;; t19[i] = t17                              ;;;
       ldr r10, [fp, #-90 ]                       ;;;_tt19 -> r10
       mov    r9, r10                             ;;;mov    _vr61, _tt19
       str r9, [fp, #-94 ]                        ;;;r9 -> _vr61
       ldr r9, [fp, #-18 ]                        ;;;i -> r9
       mov    r10, r9                             ;;;mov    _vr60, i
       str r10, [fp, #-95 ]                       ;;;r10 -> _vr60
       ldr r10, [fp, #-87 ]                       ;;;_tt17 -> r10
       mov    r9, r10                             ;;;mov    _vr62, _tt17
       str r9, [fp, #-96 ]                        ;;;r9 -> _vr62
       ldr r9, [fp, #-96 ]                        ;;;_vr62 -> r9
       ldr r10, [fp, #-94 ]                       ;;;_vr61 -> r10
       ldr r0, [fp, #-95 ]                        ;;;_vr60 -> r0
       str    r9, [r10, r0]                       ;;;str    _vr62, [_vr61, _vr60]
    ;;; Null check this                           ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr63, this
       str r10, [fp, #-97 ]                       ;;;r10 -> _vr63
       ldr r10, [fp, #-97 ]                       ;;;_vr63 -> r10
       cmp    r10, #0                             ;;;cmp    _vr63, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t20 = this.a                              ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr64, this
       str r0, [fp, #-98 ]                        ;;;r0 -> _vr64
       ldr r0, [fp, #-98 ]                        ;;;_vr64 -> r0
       ldr    r10, [r0, #1]                       ;;;ldr    _tt20, [_vr64, #1]
       str r10, [fp, #-99 ]                       ;;;r10 -> _tt20
    ;;; Null check t20                            ;;;
       ldr r10, [fp, #-99 ]                       ;;;_tt20 -> r10
       mov    r0, r10                             ;;;mov    _vr65, _tt20
       str r0, [fp, #-100 ]                       ;;;r0 -> _vr65
       ldr r0, [fp, #-100 ]                       ;;;_vr65 -> r0
       cmp    r0, #0                              ;;;cmp    _vr65, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t20                  ;;;
       ldr r0, [fp, #-17 ]                        ;;;j -> r0
       mov    r10, r0                             ;;;mov    _vr66, j
       str r10, [fp, #-101 ]                      ;;;r10 -> _vr66
       ldr r10, [fp, #-101 ]                      ;;;_vr66 -> r10
       cmp    r10, #0                             ;;;cmp    _vr66, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-99 ]                       ;;;_tt20 -> r10
       mov    r0, r10                             ;;;mov    _vr67, _tt20
       str r0, [fp, #-102 ]                       ;;;r0 -> _vr67
    ;;; t20[j] = tmp                              ;;;
       ldr r0, [fp, #-99 ]                        ;;;_tt20 -> r0
       mov    r10, r0                             ;;;mov    _vr69, _tt20
       str r10, [fp, #-103 ]                      ;;;r10 -> _vr69
       ldr r10, [fp, #-17 ]                       ;;;j -> r10
       mov    r0, r10                             ;;;mov    _vr68, j
       str r0, [fp, #-104 ]                       ;;;r0 -> _vr68
       ldr r0, [fp, #-78 ]                        ;;;tmp -> r0
       mov    r10, r0                             ;;;mov    _vr70, tmp
       str r10, [fp, #-105 ]                      ;;;r10 -> _vr70
       ldr r10, [fp, #-105 ]                      ;;;_vr70 -> r10
       ldr r0, [fp, #-103 ]                       ;;;_vr69 -> r0
       ldr r9, [fp, #-104 ]                       ;;;_vr68 -> r9
       str    r10, [r0, r9]                       ;;;str    _vr70, [_vr69, _vr68]
    ;;; t21 = i + 1                               ;;;
       ldr r9, [fp, #-18 ]                        ;;;i -> r9
       mov    r0, r9                              ;;;mov    _vr71, i
       str r0, [fp, #-106 ]                       ;;;r0 -> _vr71
       ldr r0, [fp, #-106 ]                       ;;;_vr71 -> r0
       add    r9, r0, #1                          ;;;add    _tt21, _vr71, #1
       str r9, [fp, #-107 ]                       ;;;r9 -> _tt21
    ;;; i = t21                                   ;;;
       ldr r9, [fp, #-107 ]                       ;;;_tt21 -> r9
       mov    r0, r9                              ;;;mov    i, _tt21
       str r0, [fp, #-18 ]                        ;;;r0 -> i
    ;;; t22 = j - 1                               ;;;
       ldr r0, [fp, #-17 ]                        ;;;j -> r0
       mov    r9, r0                              ;;;mov    _vr72, j
       str r9, [fp, #-108 ]                       ;;;r9 -> _vr72
       ldr r9, [fp, #-108 ]                       ;;;_vr72 -> r9
       sub    r0, r9, #1                          ;;;sub    _tt22, _vr72, #1
       str r0, [fp, #-109 ]                       ;;;r0 -> _tt22
    ;;; j = t22                                   ;;;
       ldr r0, [fp, #-109 ]                       ;;;_tt22 -> r0
       mov    r9, r0                              ;;;mov    j, _tt22
       str r9, [fp, #-17 ]                        ;;;r9 -> j
    ;;; jump L0:                                  ;;;
       b    L0                                    ;;;b    L0
    ;;; L1:                                       ;;;
L1:                                               ;;;L1:
    ;;; return j                                  ;;;
       ldr r9, [fp, #-17 ]                        ;;;j -> r9
       mov    r0, r9                              ;;;mov    r0, j
       str r0, [fp, #-42 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-10 ]                        ;;;_vr1 -> r0
       mov    r4, r0                              ;;;mov    r4, _vr1
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
       ldr r0, [fp, #-42 ]                        ;;;r0 -> r0
    ;;; Fake Use of all callee save registers     ;;;
       mov    sp, fp                              ;;;mov    sp, fp
       ldu    fp, [sp, #1]                        ;;;ldu    fp, [sp, #1]
       ldu    pc, [sp, #1]                        ;;;ldu    pc, [sp, #1]
    ;;; return                                    ;;;
       ldr r0, [fp, #-10 ]                        ;;;_vr1 -> r0
       mov    r4, r0                              ;;;mov    r4, _vr1
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

QuicksortQuicksort:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #33

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(low, high),27)          ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr73, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr73
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr74, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr74
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr75, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr75
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr76, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr76
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr77, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr77
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr78, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr78
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr79, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr79
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
       ldr    r9, [fp, #3]                        ;;;ldr    low, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> low
       ldr    r9, [fp, #4]                        ;;;ldr    high, [fp, #4]
       str r9, [fp, #4 ]                          ;;;r9 -> high
    ;;; t0 = low < high                           ;;;
       ldr r9, [fp, #4 ]                          ;;;high -> r9
       mov    r10, r9                             ;;;mov    _vr81, high
       str r10, [fp, #-17 ]                       ;;;r10 -> _vr81
       ldr r10, [fp, #3 ]                         ;;;low -> r10
       mov    r9, r10                             ;;;mov    _vr80, low
       str r9, [fp, #-18 ]                        ;;;r9 -> _vr80
       ldr r9, [fp, #-18 ]                        ;;;_vr80 -> r9
       ldr r10, [fp, #-17 ]                       ;;;_vr81 -> r10
       cmp    r9, r10                             ;;;cmp    _vr80, _vr81
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt0, r0
       str r10, [fp, #-20 ]                       ;;;r10 -> _tt0
    ;;; t1 = !t0                                  ;;;
       mov    r10, #1                             ;;;mov    _tt1, #1
       str r10, [fp, #-21 ]                       ;;;r10 -> _tt1
       ldr r10, [fp, #-21 ]                       ;;;_tt1 -> r10
       ldr r0, [fp, #-20 ]                        ;;;_tt0 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt1, _tt1, _tt0
       str r10, [fp, #-21 ]                       ;;;r10 -> _tt1
    ;;; cjump L7:                                 ;;;
       ldr r0, [fp, #-21 ]                        ;;;_tt1 -> r0
       mov    r10, r0                             ;;;mov    _vr82, _tt1
       str r10, [fp, #-22 ]                       ;;;r10 -> _vr82
       ldr r10, [fp, #-21 ]                       ;;;_tt1 -> r10
       tst    r10, #1                             ;;;tst    _tt1, #1
       bne    L7                                  ;;;bne    L7
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr83, this
       str r0, [fp, #-23 ]                        ;;;r0 -> _vr83
       ldr r0, [fp, #-23 ]                        ;;;_vr83 -> r0
       cmp    r0, #0                              ;;;cmp    _vr83, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t2 = this.partition(lowhigh)              ;;;
       ldr r0, [fp, #4 ]                          ;;;high -> r0
       mov    r10, r0                             ;;;mov    _vr84, high
       str r10, [fp, #-24 ]                       ;;;r10 -> _vr84
       ldr r10, [fp, #-24 ]                       ;;;_vr84 -> r10
       stu    r10, [sp, #-1]                      ;;;stu    _vr84, [sp, #-1]
       ldr r10, [fp, #3 ]                         ;;;low -> r10
       mov    r0, r10                             ;;;mov    _vr84, low
       str r0, [fp, #-24 ]                        ;;;r0 -> _vr84
       ldr r0, [fp, #-24 ]                        ;;;_vr84 -> r0
       stu    r0, [sp, #-1]                       ;;;stu    _vr84, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       stu    r0, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov     r1, r0                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #0]                        ;;;ldr    r1, [r1, #0]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-25 ]                        ;;;r2 -> r2
       add    sp, sp, #3                          ;;;add    sp, sp, #3
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt2, r0
       str r2, [fp, #-26 ]                        ;;;r2 -> _tt2
    ;;; mid = t2                                  ;;;
       ldr r2, [fp, #-26 ]                        ;;;_tt2 -> r2
       mov    r0, r2                              ;;;mov    mid, _tt2
       str r0, [fp, #-27 ]                        ;;;r0 -> mid
    ;;; Null check this                           ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r2, r0                              ;;;mov    _vr86, this
       str r2, [fp, #-28 ]                        ;;;r2 -> _vr86
       ldr r2, [fp, #-28 ]                        ;;;_vr86 -> r2
       cmp    r2, #0                              ;;;cmp    _vr86, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.quicksort(lowmid)                    ;;;
       ldr r2, [fp, #-27 ]                        ;;;mid -> r2
       mov    r0, r2                              ;;;mov    _vr87, mid
       str r0, [fp, #-29 ]                        ;;;r0 -> _vr87
       ldr r0, [fp, #-29 ]                        ;;;_vr87 -> r0
       stu    r0, [sp, #-1]                       ;;;stu    _vr87, [sp, #-1]
       ldr r0, [fp, #3 ]                          ;;;low -> r0
       mov    r2, r0                              ;;;mov    _vr87, low
       str r2, [fp, #-29 ]                        ;;;r2 -> _vr87
       ldr r2, [fp, #-29 ]                        ;;;_vr87 -> r2
       stu    r2, [sp, #-1]                       ;;;stu    _vr87, [sp, #-1]
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       stu    r2, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov     r1, r2                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #1]                        ;;;ldr    r1, [r1, #1]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-25 ]                        ;;;r2 -> r2
       add    sp, sp, #3                          ;;;add    sp, sp, #3
    ;;; t3 = mid + 1                              ;;;
       ldr r2, [fp, #-27 ]                        ;;;mid -> r2
       mov    r0, r2                              ;;;mov    _vr89, mid
       str r0, [fp, #-30 ]                        ;;;r0 -> _vr89
       ldr r0, [fp, #-30 ]                        ;;;_vr89 -> r0
       add    r2, r0, #1                          ;;;add    _tt3, _vr89, #1
       str r2, [fp, #-31 ]                        ;;;r2 -> _tt3
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr90, this
       str r0, [fp, #-32 ]                        ;;;r0 -> _vr90
       ldr r0, [fp, #-32 ]                        ;;;_vr90 -> r0
       cmp    r0, #0                              ;;;cmp    _vr90, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.quicksort(t3high)                    ;;;
       ldr r0, [fp, #4 ]                          ;;;high -> r0
       mov    r2, r0                              ;;;mov    _vr91, high
       str r2, [fp, #-33 ]                        ;;;r2 -> _vr91
       ldr r2, [fp, #-33 ]                        ;;;_vr91 -> r2
       stu    r2, [sp, #-1]                       ;;;stu    _vr91, [sp, #-1]
       ldr r2, [fp, #-31 ]                        ;;;_tt3 -> r2
       mov    r0, r2                              ;;;mov    _vr91, _tt3
       str r0, [fp, #-33 ]                        ;;;r0 -> _vr91
       ldr r0, [fp, #-33 ]                        ;;;_vr91 -> r0
       stu    r0, [sp, #-1]                       ;;;stu    _vr91, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       stu    r0, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov     r1, r0                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #1]                        ;;;ldr    r1, [r1, #1]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-25 ]                        ;;;r2 -> r2
       add    sp, sp, #3                          ;;;add    sp, sp, #3
    ;;; L7:                                       ;;;
L7:                                               ;;;L7:
    ;;; return                                    ;;;
       ldr r2, [fp, #-10 ]                        ;;;_vr73 -> r2
       mov    r4, r2                              ;;;mov    r4, _vr73
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr74 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr74
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr75 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr75
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr76 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr76
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr77 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr77
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr78 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr78
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr79 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr79
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

QuicksortInitArray:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #50

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(),35)                   ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr93, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr93
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr94, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr94
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr95, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr95
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr96, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr96
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr97, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr97
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr98, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr98
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr99, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr99
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
    ;;; i = 0                                     ;;;
       mov    r9, #0                              ;;;mov    i, #0
       str r9, [fp, #-17 ]                        ;;;r9 -> i
    ;;; L8:                                       ;;;
L8:                                               ;;;L8:
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr100, this
       str r10, [fp, #-18 ]                       ;;;r10 -> _vr100
       ldr r10, [fp, #-18 ]                       ;;;_vr100 -> r10
       cmp    r10, #0                             ;;;cmp    _vr100, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t1 = this.a                               ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r9, r10                             ;;;mov    _vr101, this
       str r9, [fp, #-19 ]                        ;;;r9 -> _vr101
       ldr r9, [fp, #-19 ]                        ;;;_vr101 -> r9
       ldr    r10, [r9, #1]                       ;;;ldr    _tt1, [_vr101, #1]
       str r10, [fp, #-20 ]                       ;;;r10 -> _tt1
    ;;; Null check t1                             ;;;
       ldr r10, [fp, #-20 ]                       ;;;_tt1 -> r10
       mov    r9, r10                             ;;;mov    _vr102, _tt1
       str r9, [fp, #-21 ]                        ;;;r9 -> _vr102
       ldr r9, [fp, #-21 ]                        ;;;_vr102 -> r9
       cmp    r9, #0                              ;;;cmp    _vr102, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t2 = t1.length                            ;;;
       ldr r9, [fp, #-20 ]                        ;;;_tt1 -> r9
       mov    r10, r9                             ;;;mov    _vr103, _tt1
       str r10, [fp, #-22 ]                       ;;;r10 -> _vr103
       ldr r10, [fp, #-22 ]                       ;;;_vr103 -> r10
       ldr    r9, [r10, #-1]                      ;;;ldr    _tt2, [_vr103, #-1]
       str r9, [fp, #-23 ]                        ;;;r9 -> _tt2
    ;;; t0 = i < t2                               ;;;
       ldr r9, [fp, #-23 ]                        ;;;_tt2 -> r9
       mov    r10, r9                             ;;;mov    _vr105, _tt2
       str r10, [fp, #-24 ]                       ;;;r10 -> _vr105
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r9, r10                             ;;;mov    _vr104, i
       str r9, [fp, #-25 ]                        ;;;r9 -> _vr104
       ldr r9, [fp, #-25 ]                        ;;;_vr104 -> r9
       ldr r10, [fp, #-24 ]                       ;;;_vr105 -> r10
       cmp    r9, r10                             ;;;cmp    _vr104, _vr105
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt0, r0
       str r10, [fp, #-27 ]                       ;;;r10 -> _tt0
    ;;; t3 = !t0                                  ;;;
       mov    r10, #1                             ;;;mov    _tt3, #1
       str r10, [fp, #-28 ]                       ;;;r10 -> _tt3
       ldr r10, [fp, #-28 ]                       ;;;_tt3 -> r10
       ldr r0, [fp, #-27 ]                        ;;;_tt0 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt3, _tt3, _tt0
       str r10, [fp, #-28 ]                       ;;;r10 -> _tt3
    ;;; cjump L9:                                 ;;;
       ldr r0, [fp, #-28 ]                        ;;;_tt3 -> r0
       mov    r10, r0                             ;;;mov    _vr106, _tt3
       str r10, [fp, #-29 ]                       ;;;r10 -> _vr106
       ldr r10, [fp, #-28 ]                       ;;;_tt3 -> r10
       tst    r10, #1                             ;;;tst    _tt3, #1
       bne    L9                                  ;;;bne    L9
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr107, this
       str r0, [fp, #-30 ]                        ;;;r0 -> _vr107
       ldr r0, [fp, #-30 ]                        ;;;_vr107 -> r0
       cmp    r0, #0                              ;;;cmp    _vr107, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t5 = this.a                               ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr108, this
       str r10, [fp, #-31 ]                       ;;;r10 -> _vr108
       ldr r10, [fp, #-31 ]                       ;;;_vr108 -> r10
       ldr    r0, [r10, #1]                       ;;;ldr    _tt5, [_vr108, #1]
       str r0, [fp, #-32 ]                        ;;;r0 -> _tt5
    ;;; Null check t5                             ;;;
       ldr r0, [fp, #-32 ]                        ;;;_tt5 -> r0
       mov    r10, r0                             ;;;mov    _vr109, _tt5
       str r10, [fp, #-33 ]                       ;;;r10 -> _vr109
       ldr r10, [fp, #-33 ]                       ;;;_vr109 -> r10
       cmp    r10, #0                             ;;;cmp    _vr109, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t6 = t5.length                            ;;;
       ldr r10, [fp, #-32 ]                       ;;;_tt5 -> r10
       mov    r0, r10                             ;;;mov    _vr110, _tt5
       str r0, [fp, #-34 ]                        ;;;r0 -> _vr110
       ldr r0, [fp, #-34 ]                        ;;;_vr110 -> r0
       ldr    r10, [r0, #-1]                      ;;;ldr    _tt6, [_vr110, #-1]
       str r10, [fp, #-35 ]                       ;;;r10 -> _tt6
    ;;; t4 = t6 * 2                               ;;;
       ldr r10, [fp, #-35 ]                       ;;;_tt6 -> r10
       mov    r0, r10                             ;;;mov    _vr111, _tt6
       str r0, [fp, #-36 ]                        ;;;r0 -> _vr111
       ldr r0, [fp, #-36 ]                        ;;;_vr111 -> r0
       mul    r10, r0, #2                         ;;;mul    _tt4, _vr111, #2
       str r10, [fp, #-37 ]                       ;;;r10 -> _tt4
    ;;; t7 = Library.random(t4)                   ;;;
       ldr r10, [fp, #-37 ]                       ;;;_tt4 -> r10
       mov    r0, r10                             ;;;mov    r0, _tt4
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       bl LIBRandom                               ;;;bl LIBRandom
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       str r2, [fp, #-38 ]                        ;;;r2 -> r2
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt7, r0
       str r2, [fp, #-39 ]                        ;;;r2 -> _tt7
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr112, this
       str r0, [fp, #-40 ]                        ;;;r0 -> _vr112
       ldr r0, [fp, #-40 ]                        ;;;_vr112 -> r0
       cmp    r0, #0                              ;;;cmp    _vr112, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t8 = this.a                               ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r2, r0                              ;;;mov    _vr113, this
       str r2, [fp, #-41 ]                        ;;;r2 -> _vr113
       ldr r2, [fp, #-41 ]                        ;;;_vr113 -> r2
       ldr    r0, [r2, #1]                        ;;;ldr    _tt8, [_vr113, #1]
       str r0, [fp, #-42 ]                        ;;;r0 -> _tt8
    ;;; Null check t8                             ;;;
       ldr r0, [fp, #-42 ]                        ;;;_tt8 -> r0
       mov    r2, r0                              ;;;mov    _vr114, _tt8
       str r2, [fp, #-43 ]                        ;;;r2 -> _vr114
       ldr r2, [fp, #-43 ]                        ;;;_vr114 -> r2
       cmp    r2, #0                              ;;;cmp    _vr114, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t8                   ;;;
       ldr r2, [fp, #-17 ]                        ;;;i -> r2
       mov    r0, r2                              ;;;mov    _vr115, i
       str r0, [fp, #-44 ]                        ;;;r0 -> _vr115
       ldr r0, [fp, #-44 ]                        ;;;_vr115 -> r0
       cmp    r0, #0                              ;;;cmp    _vr115, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-42 ]                        ;;;_tt8 -> r0
       mov    r2, r0                              ;;;mov    _vr116, _tt8
       str r2, [fp, #-45 ]                        ;;;r2 -> _vr116
    ;;; t8[i] = t7                                ;;;
       ldr r2, [fp, #-42 ]                        ;;;_tt8 -> r2
       mov    r0, r2                              ;;;mov    _vr118, _tt8
       str r0, [fp, #-46 ]                        ;;;r0 -> _vr118
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r2, r0                              ;;;mov    _vr117, i
       str r2, [fp, #-47 ]                        ;;;r2 -> _vr117
       ldr r2, [fp, #-39 ]                        ;;;_tt7 -> r2
       mov    r0, r2                              ;;;mov    _vr119, _tt7
       str r0, [fp, #-48 ]                        ;;;r0 -> _vr119
       ldr r0, [fp, #-48 ]                        ;;;_vr119 -> r0
       ldr r2, [fp, #-46 ]                        ;;;_vr118 -> r2
       ldr r10, [fp, #-47 ]                       ;;;_vr117 -> r10
       str    r0, [r2, r10]                       ;;;str    _vr119, [_vr118, _vr117]
    ;;; t9 = i + 1                                ;;;
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r2, r10                             ;;;mov    _vr120, i
       str r2, [fp, #-49 ]                        ;;;r2 -> _vr120
       ldr r2, [fp, #-49 ]                        ;;;_vr120 -> r2
       add    r10, r2, #1                         ;;;add    _tt9, _vr120, #1
       str r10, [fp, #-50 ]                       ;;;r10 -> _tt9
    ;;; i = t9                                    ;;;
       ldr r10, [fp, #-50 ]                       ;;;_tt9 -> r10
       mov    r2, r10                             ;;;mov    i, _tt9
       str r2, [fp, #-17 ]                        ;;;r2 -> i
    ;;; jump L8:                                  ;;;
       b    L8                                    ;;;b    L8
    ;;; L9:                                       ;;;
L9:                                               ;;;L9:
    ;;; return                                    ;;;
       ldr r2, [fp, #-10 ]                        ;;;_vr93 -> r2
       mov    r4, r2                              ;;;mov    r4, _vr93
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr94 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr94
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr95 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr95
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr96 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr96
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr97 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr97
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr98 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr98
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr99 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr99
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

QuicksortPrintArray:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #44

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(),43)                   ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr121, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr121
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr122, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr122
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr123, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr123
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr124, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr124
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr125, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr125
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr126, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr126
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr127, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr127
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
    ;;; i = 0                                     ;;;
       mov    r9, #0                              ;;;mov    i, #0
       str r9, [fp, #-17 ]                        ;;;r9 -> i
    ;;; t0 = Array elements:                      ;;;
       adr      r9, str0                          ;;;adr      _tt0, str0
       str r9, [fp, #-18 ]                        ;;;r9 -> _tt0
    ;;; Library.print(t0)                         ;;;
       ldr r9, [fp, #-18 ]                        ;;;_tt0 -> r9
       mov    r0, r9                              ;;;mov    r0, _tt0
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       bl LIBPrint                                ;;;bl LIBPrint
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
    ;;; L10:                                      ;;;
L10:                                              ;;;L10:
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr128, this
       str r0, [fp, #-21 ]                        ;;;r0 -> _vr128
       ldr r0, [fp, #-21 ]                        ;;;_vr128 -> r0
       cmp    r0, #0                              ;;;cmp    _vr128, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t2 = this.a                               ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r2, r0                              ;;;mov    _vr129, this
       str r2, [fp, #-22 ]                        ;;;r2 -> _vr129
       ldr r2, [fp, #-22 ]                        ;;;_vr129 -> r2
       ldr    r0, [r2, #1]                        ;;;ldr    _tt2, [_vr129, #1]
       str r0, [fp, #-23 ]                        ;;;r0 -> _tt2
    ;;; Null check t2                             ;;;
       ldr r0, [fp, #-23 ]                        ;;;_tt2 -> r0
       mov    r2, r0                              ;;;mov    _vr130, _tt2
       str r2, [fp, #-24 ]                        ;;;r2 -> _vr130
       ldr r2, [fp, #-24 ]                        ;;;_vr130 -> r2
       cmp    r2, #0                              ;;;cmp    _vr130, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t3 = t2.length                            ;;;
       ldr r2, [fp, #-23 ]                        ;;;_tt2 -> r2
       mov    r0, r2                              ;;;mov    _vr131, _tt2
       str r0, [fp, #-25 ]                        ;;;r0 -> _vr131
       ldr r0, [fp, #-25 ]                        ;;;_vr131 -> r0
       ldr    r2, [r0, #-1]                       ;;;ldr    _tt3, [_vr131, #-1]
       str r2, [fp, #-26 ]                        ;;;r2 -> _tt3
    ;;; t1 = i < t3                               ;;;
       ldr r2, [fp, #-26 ]                        ;;;_tt3 -> r2
       mov    r0, r2                              ;;;mov    _vr133, _tt3
       str r0, [fp, #-27 ]                        ;;;r0 -> _vr133
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r2, r0                              ;;;mov    _vr132, i
       str r2, [fp, #-28 ]                        ;;;r2 -> _vr132
       ldr r2, [fp, #-28 ]                        ;;;_vr132 -> r2
       ldr r0, [fp, #-27 ]                        ;;;_vr133 -> r0
       cmp    r2, r0                              ;;;cmp    _vr132, _vr133
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt1, r0
       str r2, [fp, #-29 ]                        ;;;r2 -> _tt1
    ;;; t4 = !t1                                  ;;;
       mov    r2, #1                              ;;;mov    _tt4, #1
       str r2, [fp, #-30 ]                        ;;;r2 -> _tt4
       ldr r2, [fp, #-30 ]                        ;;;_tt4 -> r2
       ldr r0, [fp, #-29 ]                        ;;;_tt1 -> r0
       eor    r2, r2, r0                          ;;;eor    _tt4, _tt4, _tt1
       str r2, [fp, #-30 ]                        ;;;r2 -> _tt4
    ;;; cjump L11:                                ;;;
       ldr r0, [fp, #-30 ]                        ;;;_tt4 -> r0
       mov    r2, r0                              ;;;mov    _vr134, _tt4
       str r2, [fp, #-31 ]                        ;;;r2 -> _vr134
       ldr r2, [fp, #-30 ]                        ;;;_tt4 -> r2
       tst    r2, #1                              ;;;tst    _tt4, #1
       bne    L11                                 ;;;bne    L11
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr135, this
       str r0, [fp, #-32 ]                        ;;;r0 -> _vr135
       ldr r0, [fp, #-32 ]                        ;;;_vr135 -> r0
       cmp    r0, #0                              ;;;cmp    _vr135, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t6 = this.a                               ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r2, r0                              ;;;mov    _vr136, this
       str r2, [fp, #-33 ]                        ;;;r2 -> _vr136
       ldr r2, [fp, #-33 ]                        ;;;_vr136 -> r2
       ldr    r0, [r2, #1]                        ;;;ldr    _tt6, [_vr136, #1]
       str r0, [fp, #-34 ]                        ;;;r0 -> _tt6
    ;;; Null check t6                             ;;;
       ldr r0, [fp, #-34 ]                        ;;;_tt6 -> r0
       mov    r2, r0                              ;;;mov    _vr137, _tt6
       str r2, [fp, #-35 ]                        ;;;r2 -> _vr137
       ldr r2, [fp, #-35 ]                        ;;;_vr137 -> r2
       cmp    r2, #0                              ;;;cmp    _vr137, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t6                   ;;;
       ldr r2, [fp, #-17 ]                        ;;;i -> r2
       mov    r0, r2                              ;;;mov    _vr138, i
       str r0, [fp, #-36 ]                        ;;;r0 -> _vr138
       ldr r0, [fp, #-36 ]                        ;;;_vr138 -> r0
       cmp    r0, #0                              ;;;cmp    _vr138, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-34 ]                        ;;;_tt6 -> r0
       mov    r2, r0                              ;;;mov    _vr139, _tt6
       str r2, [fp, #-37 ]                        ;;;r2 -> _vr139
    ;;; t5 = t6[i]                                ;;;
       ldr r2, [fp, #-34 ]                        ;;;_tt6 -> r2
       mov    r0, r2                              ;;;mov    _vr140, _tt6
       str r0, [fp, #-38 ]                        ;;;r0 -> _vr140
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r2, r0                              ;;;mov    _vr141, i
       str r2, [fp, #-39 ]                        ;;;r2 -> _vr141
       ldr r2, [fp, #-38 ]                        ;;;_vr140 -> r2
       ldr r0, [fp, #-39 ]                        ;;;_vr141 -> r0
       ldr    r9, [r2, r0]                        ;;;ldr    _tt5, [_vr140, _vr141]
       str r9, [fp, #-40 ]                        ;;;r9 -> _tt5
    ;;; Library.printi(t5)                        ;;;
       ldr r9, [fp, #-40 ]                        ;;;_tt5 -> r9
       mov    r0, r9                              ;;;mov    r0, _tt5
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       bl LIBPrinti                               ;;;bl LIBPrinti
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
    ;;; t7 =                                      ;;;
       adr      r2, str1                          ;;;adr      _tt7, str1
       str r2, [fp, #-41 ]                        ;;;r2 -> _tt7
    ;;; Library.print(t7)                         ;;;
       ldr r2, [fp, #-41 ]                        ;;;_tt7 -> r2
       mov    r0, r2                              ;;;mov    r0, _tt7
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       bl LIBPrint                                ;;;bl LIBPrint
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
    ;;; t8 = i + 1                                ;;;
       ldr r2, [fp, #-17 ]                        ;;;i -> r2
       mov    r0, r2                              ;;;mov    _vr142, i
       str r0, [fp, #-42 ]                        ;;;r0 -> _vr142
       ldr r0, [fp, #-42 ]                        ;;;_vr142 -> r0
       add    r2, r0, #1                          ;;;add    _tt8, _vr142, #1
       str r2, [fp, #-43 ]                        ;;;r2 -> _tt8
    ;;; i = t8                                    ;;;
       ldr r2, [fp, #-43 ]                        ;;;_tt8 -> r2
       mov    r0, r2                              ;;;mov    i, _tt8
       str r0, [fp, #-17 ]                        ;;;r0 -> i
    ;;; jump L10:                                 ;;;
       b    L10                                   ;;;b    L10
    ;;; L11:                                      ;;;
L11:                                              ;;;L11:
    ;;; t9 = \n                                   ;;;
       adr      r0, str2                          ;;;adr      _tt9, str2
       str r0, [fp, #-44 ]                        ;;;r0 -> _tt9
    ;;; Library.print(t9)                         ;;;
       ldr r0, [fp, #-44 ]                        ;;;_tt9 -> r0
       mov	r2, r0                                 ;;;realloc vr
       mov    r0, r2                              ;;;mov    r0, _tt9
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-19 ]                        ;;;r0 -> r0
       bl LIBPrint                                ;;;bl LIBPrint
       str r0, [fp, #-19 ]                        ;;;r0 -> r0
       str r2, [fp, #-20 ]                        ;;;r2 -> r2
    ;;; return                                    ;;;
       ldr r2, [fp, #-10 ]                        ;;;_vr121 -> r2
       mov    r4, r2                              ;;;mov    r4, _vr121
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr122 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr122
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr123 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr123
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr124 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr124
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr125 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr125
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr126 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr126
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr127 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr127
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

QuicksortMain:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #30

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(args),55)               ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr143, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr143
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr144, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr144
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr145, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr145
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr146, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr146
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr147, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr147
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr148, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr148
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr149, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr149
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
       ldr    r9, [fp, #3]                        ;;;ldr    args, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> args
    ;;; n = 10                                    ;;;
       mov    r9, #10                             ;;;mov    n, #10
       str r9, [fp, #-17 ]                        ;;;r9 -> n
    ;;; Greater than 0 check n                    ;;;
    ;;; stub                                      ;;;
    ;;; t0 = Library.allocateArray(n)             ;;;
       ldr r9, [fp, #-17 ]                        ;;;n -> r9
       mov    r0, r9                              ;;;mov    r0, n
       str r0, [fp, #-18 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-18 ]                        ;;;r0 -> r0
       bl LIBAllocateArray                        ;;;bl LIBAllocateArray
       str r0, [fp, #-18 ]                        ;;;r0 -> r0
       str r2, [fp, #-19 ]                        ;;;r2 -> r2
       ldr r0, [fp, #-18 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt0, r0
       str r2, [fp, #-20 ]                        ;;;r2 -> _tt0
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr150, this
       str r0, [fp, #-21 ]                        ;;;r0 -> _vr150
       ldr r0, [fp, #-21 ]                        ;;;_vr150 -> r0
       cmp    r0, #0                              ;;;cmp    _vr150, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.a = t0                               ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r2, r0                              ;;;mov    _vr151, this
       str r2, [fp, #-22 ]                        ;;;r2 -> _vr151
       ldr r2, [fp, #-20 ]                        ;;;_tt0 -> r2
       mov    r0, r2                              ;;;mov    _vr152, _tt0
       str r0, [fp, #-23 ]                        ;;;r0 -> _vr152
       ldr r0, [fp, #-23 ]                        ;;;_vr152 -> r0
       ldr r2, [fp, #-22 ]                        ;;;_vr151 -> r2
       str    r0, [r2, #1]                        ;;;str    _vr152, [_vr151, #1]
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr153, this
       str r0, [fp, #-24 ]                        ;;;r0 -> _vr153
       ldr r0, [fp, #-24 ]                        ;;;_vr153 -> r0
       cmp    r0, #0                              ;;;cmp    _vr153, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.initArray()                          ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       stu    r0, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov     r1, r0                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #2]                        ;;;ldr    r1, [r1, #2]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-18 ]                        ;;;r0 -> r0
       str r2, [fp, #-19 ]                        ;;;r2 -> r2
       add    sp, sp, #1                          ;;;add    sp, sp, #1
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr156, this
       str r0, [fp, #-25 ]                        ;;;r0 -> _vr156
       ldr r0, [fp, #-25 ]                        ;;;_vr156 -> r0
       cmp    r0, #0                              ;;;cmp    _vr156, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.printArray()                         ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       stu    r0, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov     r1, r0                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #3]                        ;;;ldr    r1, [r1, #3]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-18 ]                        ;;;r0 -> r0
       str r2, [fp, #-19 ]                        ;;;r2 -> r2
       add    sp, sp, #1                          ;;;add    sp, sp, #1
    ;;; t1 = n - 1                                ;;;
       ldr r2, [fp, #-17 ]                        ;;;n -> r2
       mov    r0, r2                              ;;;mov    _vr159, n
       str r0, [fp, #-26 ]                        ;;;r0 -> _vr159
       ldr r0, [fp, #-26 ]                        ;;;_vr159 -> r0
       sub    r2, r0, #1                          ;;;sub    _tt1, _vr159, #1
       str r2, [fp, #-27 ]                        ;;;r2 -> _tt1
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr160, this
       str r0, [fp, #-28 ]                        ;;;r0 -> _vr160
       ldr r0, [fp, #-28 ]                        ;;;_vr160 -> r0
       cmp    r0, #0                              ;;;cmp    _vr160, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.quicksort(0t1)                       ;;;
       ldr r0, [fp, #-27 ]                        ;;;_tt1 -> r0
       mov    r2, r0                              ;;;mov    _vr161, _tt1
       str r2, [fp, #-29 ]                        ;;;r2 -> _vr161
       ldr r2, [fp, #-29 ]                        ;;;_vr161 -> r2
       stu    r2, [sp, #-1]                       ;;;stu    _vr161, [sp, #-1]
       mov      r2,#0                             ;;;mov      _vr161,#0
       str r2, [fp, #-29 ]                        ;;;r2 -> _vr161
       ldr r2, [fp, #-29 ]                        ;;;_vr161 -> r2
       stu    r2, [sp, #-1]                       ;;;stu    _vr161, [sp, #-1]
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       stu    r2, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov     r1, r2                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #1]                        ;;;ldr    r1, [r1, #1]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-18 ]                        ;;;r0 -> r0
       str r2, [fp, #-19 ]                        ;;;r2 -> r2
       add    sp, sp, #3                          ;;;add    sp, sp, #3
    ;;; Null check this                           ;;;
       ldr r2, [fp, #2 ]                          ;;;this -> r2
       mov    r0, r2                              ;;;mov    _vr163, this
       str r0, [fp, #-30 ]                        ;;;r0 -> _vr163
       ldr r0, [fp, #-30 ]                        ;;;_vr163 -> r0
       cmp    r0, #0                              ;;;cmp    _vr163, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; this.printArray()                         ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       stu    r0, [sp, #-1]                       ;;;stu    this, [sp, #-1]
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov     r1, r0                             ;;;mov     r1, this
       add    lr, pc, #4                          ;;;add    lr, pc, #4
       ldr    r1, [r1]                            ;;;ldr    r1, [r1]
       ldr    r1, [r1, #3]                        ;;;ldr    r1, [r1, #3]
       mov    pc, r1                              ;;;mov    pc, r1
       str r0, [fp, #-18 ]                        ;;;r0 -> r0
       str r2, [fp, #-19 ]                        ;;;r2 -> r2
       add    sp, sp, #1                          ;;;add    sp, sp, #1
    ;;; return                                    ;;;
       ldr r2, [fp, #-10 ]                        ;;;_vr143 -> r2
       mov    r4, r2                              ;;;mov    r4, _vr143
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr144 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr144
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr145 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr145
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr146 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr146
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr147 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr147
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr148 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr148
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr149 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr149
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

;;; o = new Quicksort          
	 mov    r0,  #2   
	 bl     LIBAllocateObject   			
	 adr    r1, QuicksortVT      

;;; move the vptr into the object
	 str    r1, [r0]               


;;; call the object's main       
	 stu    r0, [sp, #-1]  
	 stu    r0, [sp, #-1]  
	 bl     QuicksortMain      


;;;ic_main always returns 0
	 mov    r0, #0                 
	 mov    sp, fp                 
	 ldu    fp, [sp, #1]           
	 swi    #SysHalt

;;; ----------------------------
;;; String Constants


str1:	.string " "
str2:	.string "\n"
str0:	.string "Array elements: "



;;; ------------------------------
;;; Library Calls


LIBAllocateObject:
;;; object size gets passed in r0
	stu     lr, [sp, #-1]
	mov     r1, bump
	add     bump, r0, bump
	mov     r0, r1
	ldu     pc, [sp, #1]


LIBRandom:
		stu	lr, [sp, #-1]	
		mov	r1, r0
randLoop:
		swis	#SysEntropy
;;; make sure it's not negative
		blt	randLoop
		cmp	r1, r0
	 blt	randLoop
	 ldu	pc, [sp, #1]


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
