;;;  File test/matrix_mult_test.s

	 .requ	bump, r3
	 b      main
;; ----------------------------
;; VTables


MatrixMultVT:
	.data 	MatrixMultMultiply, MatrixMultInitMatrix, MatrixMultPrintMatrix, MatrixMultMain,0





MatrixMultMultiply:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #150

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(),5)                    ;;;
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
    ;;; i = 0                                     ;;;
       mov    r9, #0                              ;;;mov    i, #0
       str r9, [fp, #-17 ]                        ;;;r9 -> i
    ;;; L0:                                       ;;;
L0:                                               ;;;L0:
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr8, this
       str r10, [fp, #-18 ]                       ;;;r10 -> _vr8
       ldr r10, [fp, #-18 ]                       ;;;_vr8 -> r10
       cmp    r10, #0                             ;;;cmp    _vr8, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t1 = this.a                               ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r9, r10                             ;;;mov    _vr9, this
       str r9, [fp, #-19 ]                        ;;;r9 -> _vr9
       ldr r9, [fp, #-19 ]                        ;;;_vr9 -> r9
       ldr    r10, [r9, #3]                       ;;;ldr    _tt1, [_vr9, #3]
       str r10, [fp, #-20 ]                       ;;;r10 -> _tt1
    ;;; Null check t1                             ;;;
       ldr r10, [fp, #-20 ]                       ;;;_tt1 -> r10
       mov    r9, r10                             ;;;mov    _vr10, _tt1
       str r9, [fp, #-21 ]                        ;;;r9 -> _vr10
       ldr r9, [fp, #-21 ]                        ;;;_vr10 -> r9
       cmp    r9, #0                              ;;;cmp    _vr10, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t2 = t1.length                            ;;;
       ldr r9, [fp, #-20 ]                        ;;;_tt1 -> r9
       mov    r10, r9                             ;;;mov    _vr11, _tt1
       str r10, [fp, #-22 ]                       ;;;r10 -> _vr11
       ldr r10, [fp, #-22 ]                       ;;;_vr11 -> r10
       ldr    r9, [r10, #-1]                      ;;;ldr    _tt2, [_vr11, #-1]
       str r9, [fp, #-23 ]                        ;;;r9 -> _tt2
    ;;; t0 = i < t2                               ;;;
       ldr r9, [fp, #-23 ]                        ;;;_tt2 -> r9
       mov    r10, r9                             ;;;mov    _vr13, _tt2
       str r10, [fp, #-24 ]                       ;;;r10 -> _vr13
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r9, r10                             ;;;mov    _vr12, i
       str r9, [fp, #-25 ]                        ;;;r9 -> _vr12
       ldr r9, [fp, #-25 ]                        ;;;_vr12 -> r9
       ldr r10, [fp, #-24 ]                       ;;;_vr13 -> r10
       cmp    r9, r10                             ;;;cmp    _vr12, _vr13
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
    ;;; cjump L1:                                 ;;;
       ldr r0, [fp, #-28 ]                        ;;;_tt3 -> r0
       mov    r10, r0                             ;;;mov    _vr14, _tt3
       str r10, [fp, #-29 ]                       ;;;r10 -> _vr14
       ldr r10, [fp, #-28 ]                       ;;;_tt3 -> r10
       tst    r10, #1                             ;;;tst    _tt3, #1
       bne    L1                                  ;;;bne    L1
    ;;; j = 0                                     ;;;
       mov    r10, #0                             ;;;mov    j, #0
       str r10, [fp, #-30 ]                       ;;;r10 -> j
    ;;; L2:                                       ;;;
L2:                                               ;;;L2:
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr15, this
       str r0, [fp, #-31 ]                        ;;;r0 -> _vr15
       ldr r0, [fp, #-31 ]                        ;;;_vr15 -> r0
       cmp    r0, #0                              ;;;cmp    _vr15, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t6 = this.c                               ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr16, this
       str r10, [fp, #-32 ]                       ;;;r10 -> _vr16
       ldr r10, [fp, #-32 ]                       ;;;_vr16 -> r10
       ldr    r0, [r10, #1]                       ;;;ldr    _tt6, [_vr16, #1]
       str r0, [fp, #-33 ]                        ;;;r0 -> _tt6
    ;;; Null check t6                             ;;;
       ldr r0, [fp, #-33 ]                        ;;;_tt6 -> r0
       mov    r10, r0                             ;;;mov    _vr17, _tt6
       str r10, [fp, #-34 ]                       ;;;r10 -> _vr17
       ldr r10, [fp, #-34 ]                       ;;;_vr17 -> r10
       cmp    r10, #0                             ;;;cmp    _vr17, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t6                   ;;;
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r0, r10                             ;;;mov    _vr18, i
       str r0, [fp, #-35 ]                        ;;;r0 -> _vr18
       ldr r0, [fp, #-35 ]                        ;;;_vr18 -> r0
       cmp    r0, #0                              ;;;cmp    _vr18, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-33 ]                        ;;;_tt6 -> r0
       mov    r10, r0                             ;;;mov    _vr19, _tt6
       str r10, [fp, #-36 ]                       ;;;r10 -> _vr19
    ;;; t5 = t6[i]                                ;;;
       ldr r10, [fp, #-33 ]                       ;;;_tt6 -> r10
       mov    r0, r10                             ;;;mov    _vr20, _tt6
       str r0, [fp, #-37 ]                        ;;;r0 -> _vr20
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r10, r0                             ;;;mov    _vr21, i
       str r10, [fp, #-38 ]                       ;;;r10 -> _vr21
       ldr r10, [fp, #-37 ]                       ;;;_vr20 -> r10
       ldr r0, [fp, #-38 ]                        ;;;_vr21 -> r0
       ldr    r9, [r10, r0]                       ;;;ldr    _tt5, [_vr20, _vr21]
       str r9, [fp, #-39 ]                        ;;;r9 -> _tt5
    ;;; Null check t5                             ;;;
       ldr r9, [fp, #-39 ]                        ;;;_tt5 -> r9
       mov    r0, r9                              ;;;mov    _vr22, _tt5
       str r0, [fp, #-40 ]                        ;;;r0 -> _vr22
       ldr r0, [fp, #-40 ]                        ;;;_vr22 -> r0
       cmp    r0, #0                              ;;;cmp    _vr22, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t7 = t5.length                            ;;;
       ldr r0, [fp, #-39 ]                        ;;;_tt5 -> r0
       mov    r9, r0                              ;;;mov    _vr23, _tt5
       str r9, [fp, #-41 ]                        ;;;r9 -> _vr23
       ldr r9, [fp, #-41 ]                        ;;;_vr23 -> r9
       ldr    r0, [r9, #-1]                       ;;;ldr    _tt7, [_vr23, #-1]
       str r0, [fp, #-42 ]                        ;;;r0 -> _tt7
    ;;; t4 = j < t7                               ;;;
       ldr r0, [fp, #-42 ]                        ;;;_tt7 -> r0
       mov    r9, r0                              ;;;mov    _vr25, _tt7
       str r9, [fp, #-43 ]                        ;;;r9 -> _vr25
       ldr r9, [fp, #-30 ]                        ;;;j -> r9
       mov    r0, r9                              ;;;mov    _vr24, j
       str r0, [fp, #-44 ]                        ;;;r0 -> _vr24
       ldr r0, [fp, #-44 ]                        ;;;_vr24 -> r0
       ldr r9, [fp, #-43 ]                        ;;;_vr25 -> r9
       cmp    r0, r9                              ;;;cmp    _vr24, _vr25
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       mov    r9, r0                              ;;;mov    _tt4, r0
       str r9, [fp, #-45 ]                        ;;;r9 -> _tt4
    ;;; t8 = !t4                                  ;;;
       mov    r9, #1                              ;;;mov    _tt8, #1
       str r9, [fp, #-46 ]                        ;;;r9 -> _tt8
       ldr r9, [fp, #-46 ]                        ;;;_tt8 -> r9
       ldr r0, [fp, #-45 ]                        ;;;_tt4 -> r0
       eor    r9, r9, r0                          ;;;eor    _tt8, _tt8, _tt4
       str r9, [fp, #-46 ]                        ;;;r9 -> _tt8
    ;;; cjump L3:                                 ;;;
       ldr r0, [fp, #-46 ]                        ;;;_tt8 -> r0
       mov    r9, r0                              ;;;mov    _vr26, _tt8
       str r9, [fp, #-47 ]                        ;;;r9 -> _vr26
       ldr r9, [fp, #-46 ]                        ;;;_tt8 -> r9
       tst    r9, #1                              ;;;tst    _tt8, #1
       bne    L3                                  ;;;bne    L3
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r0, r9                              ;;;mov    _vr27, this
       str r0, [fp, #-48 ]                        ;;;r0 -> _vr27
       ldr r0, [fp, #-48 ]                        ;;;_vr27 -> r0
       cmp    r0, #0                              ;;;cmp    _vr27, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t10 = this.c                              ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r9, r0                              ;;;mov    _vr28, this
       str r9, [fp, #-49 ]                        ;;;r9 -> _vr28
       ldr r9, [fp, #-49 ]                        ;;;_vr28 -> r9
       ldr    r0, [r9, #1]                        ;;;ldr    _tt10, [_vr28, #1]
       str r0, [fp, #-50 ]                        ;;;r0 -> _tt10
    ;;; Null check t10                            ;;;
       ldr r0, [fp, #-50 ]                        ;;;_tt10 -> r0
       mov    r9, r0                              ;;;mov    _vr29, _tt10
       str r9, [fp, #-51 ]                        ;;;r9 -> _vr29
       ldr r9, [fp, #-51 ]                        ;;;_vr29 -> r9
       cmp    r9, #0                              ;;;cmp    _vr29, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t10                  ;;;
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r0, r9                              ;;;mov    _vr30, i
       str r0, [fp, #-52 ]                        ;;;r0 -> _vr30
       ldr r0, [fp, #-52 ]                        ;;;_vr30 -> r0
       cmp    r0, #0                              ;;;cmp    _vr30, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-50 ]                        ;;;_tt10 -> r0
       mov    r9, r0                              ;;;mov    _vr31, _tt10
       str r9, [fp, #-53 ]                        ;;;r9 -> _vr31
    ;;; t9 = t10[i]                               ;;;
       ldr r9, [fp, #-50 ]                        ;;;_tt10 -> r9
       mov    r0, r9                              ;;;mov    _vr32, _tt10
       str r0, [fp, #-54 ]                        ;;;r0 -> _vr32
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r9, r0                              ;;;mov    _vr33, i
       str r9, [fp, #-55 ]                        ;;;r9 -> _vr33
       ldr r9, [fp, #-54 ]                        ;;;_vr32 -> r9
       ldr r0, [fp, #-55 ]                        ;;;_vr33 -> r0
       ldr    r10, [r9, r0]                       ;;;ldr    _tt9, [_vr32, _vr33]
       str r10, [fp, #-56 ]                       ;;;r10 -> _tt9
    ;;; Null check t9                             ;;;
       ldr r10, [fp, #-56 ]                       ;;;_tt9 -> r10
       mov    r0, r10                             ;;;mov    _vr34, _tt9
       str r0, [fp, #-57 ]                        ;;;r0 -> _vr34
       ldr r0, [fp, #-57 ]                        ;;;_vr34 -> r0
       cmp    r0, #0                              ;;;cmp    _vr34, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t9                   ;;;
       ldr r0, [fp, #-30 ]                        ;;;j -> r0
       mov    r10, r0                             ;;;mov    _vr35, j
       str r10, [fp, #-58 ]                       ;;;r10 -> _vr35
       ldr r10, [fp, #-58 ]                       ;;;_vr35 -> r10
       cmp    r10, #0                             ;;;cmp    _vr35, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-56 ]                       ;;;_tt9 -> r10
       mov    r0, r10                             ;;;mov    _vr36, _tt9
       str r0, [fp, #-59 ]                        ;;;r0 -> _vr36
    ;;; t9[j] = 0                                 ;;;
       ldr r0, [fp, #-56 ]                        ;;;_tt9 -> r0
       mov    r10, r0                             ;;;mov    _vr38, _tt9
       str r10, [fp, #-60 ]                       ;;;r10 -> _vr38
       ldr r10, [fp, #-30 ]                       ;;;j -> r10
       mov    r0, r10                             ;;;mov    _vr37, j
       str r0, [fp, #-61 ]                        ;;;r0 -> _vr37
       mov      r0,#0                             ;;;mov      _vr39,#0
       str r0, [fp, #-62 ]                        ;;;r0 -> _vr39
       ldr r0, [fp, #-62 ]                        ;;;_vr39 -> r0
       ldr r10, [fp, #-60 ]                       ;;;_vr38 -> r10
       ldr r9, [fp, #-61 ]                        ;;;_vr37 -> r9
       str    r0, [r10, r9]                       ;;;str    _vr39, [_vr38, _vr37]
    ;;; k = 0                                     ;;;
       mov    r9, #0                              ;;;mov    k, #0
       str r9, [fp, #-63 ]                        ;;;r9 -> k
    ;;; L4:                                       ;;;
L4:                                               ;;;L4:
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr40, this
       str r10, [fp, #-64 ]                       ;;;r10 -> _vr40
       ldr r10, [fp, #-64 ]                       ;;;_vr40 -> r10
       cmp    r10, #0                             ;;;cmp    _vr40, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t13 = this.a                              ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r9, r10                             ;;;mov    _vr41, this
       str r9, [fp, #-65 ]                        ;;;r9 -> _vr41
       ldr r9, [fp, #-65 ]                        ;;;_vr41 -> r9
       ldr    r10, [r9, #3]                       ;;;ldr    _tt13, [_vr41, #3]
       str r10, [fp, #-66 ]                       ;;;r10 -> _tt13
    ;;; Null check t13                            ;;;
       ldr r10, [fp, #-66 ]                       ;;;_tt13 -> r10
       mov    r9, r10                             ;;;mov    _vr42, _tt13
       str r9, [fp, #-67 ]                        ;;;r9 -> _vr42
       ldr r9, [fp, #-67 ]                        ;;;_vr42 -> r9
       cmp    r9, #0                              ;;;cmp    _vr42, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t13                  ;;;
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r10, r9                             ;;;mov    _vr43, i
       str r10, [fp, #-68 ]                       ;;;r10 -> _vr43
       ldr r10, [fp, #-68 ]                       ;;;_vr43 -> r10
       cmp    r10, #0                             ;;;cmp    _vr43, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-66 ]                       ;;;_tt13 -> r10
       mov    r9, r10                             ;;;mov    _vr44, _tt13
       str r9, [fp, #-69 ]                        ;;;r9 -> _vr44
    ;;; t12 = t13[i]                              ;;;
       ldr r9, [fp, #-66 ]                        ;;;_tt13 -> r9
       mov    r10, r9                             ;;;mov    _vr45, _tt13
       str r10, [fp, #-70 ]                       ;;;r10 -> _vr45
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r9, r10                             ;;;mov    _vr46, i
       str r9, [fp, #-71 ]                        ;;;r9 -> _vr46
       ldr r9, [fp, #-70 ]                        ;;;_vr45 -> r9
       ldr r10, [fp, #-71 ]                       ;;;_vr46 -> r10
       ldr    r0, [r9, r10]                       ;;;ldr    _tt12, [_vr45, _vr46]
       str r0, [fp, #-72 ]                        ;;;r0 -> _tt12
    ;;; Null check t12                            ;;;
       ldr r0, [fp, #-72 ]                        ;;;_tt12 -> r0
       mov    r10, r0                             ;;;mov    _vr47, _tt12
       str r10, [fp, #-73 ]                       ;;;r10 -> _vr47
       ldr r10, [fp, #-73 ]                       ;;;_vr47 -> r10
       cmp    r10, #0                             ;;;cmp    _vr47, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t14 = t12.length                          ;;;
       ldr r10, [fp, #-72 ]                       ;;;_tt12 -> r10
       mov    r0, r10                             ;;;mov    _vr48, _tt12
       str r0, [fp, #-74 ]                        ;;;r0 -> _vr48
       ldr r0, [fp, #-74 ]                        ;;;_vr48 -> r0
       ldr    r10, [r0, #-1]                      ;;;ldr    _tt14, [_vr48, #-1]
       str r10, [fp, #-75 ]                       ;;;r10 -> _tt14
    ;;; t11 = k < t14                             ;;;
       ldr r10, [fp, #-75 ]                       ;;;_tt14 -> r10
       mov    r0, r10                             ;;;mov    _vr50, _tt14
       str r0, [fp, #-76 ]                        ;;;r0 -> _vr50
       ldr r0, [fp, #-63 ]                        ;;;k -> r0
       mov    r10, r0                             ;;;mov    _vr49, k
       str r10, [fp, #-77 ]                       ;;;r10 -> _vr49
       ldr r10, [fp, #-77 ]                       ;;;_vr49 -> r10
       ldr r0, [fp, #-76 ]                        ;;;_vr50 -> r0
       cmp    r10, r0                             ;;;cmp    _vr49, _vr50
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-26 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-26 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt11, r0
       str r10, [fp, #-78 ]                       ;;;r10 -> _tt11
    ;;; t15 = !t11                                ;;;
       mov    r10, #1                             ;;;mov    _tt15, #1
       str r10, [fp, #-79 ]                       ;;;r10 -> _tt15
       ldr r10, [fp, #-79 ]                       ;;;_tt15 -> r10
       ldr r0, [fp, #-78 ]                        ;;;_tt11 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt15, _tt15, _tt11
       str r10, [fp, #-79 ]                       ;;;r10 -> _tt15
    ;;; cjump L5:                                 ;;;
       ldr r0, [fp, #-79 ]                        ;;;_tt15 -> r0
       mov    r10, r0                             ;;;mov    _vr51, _tt15
       str r10, [fp, #-80 ]                       ;;;r10 -> _vr51
       ldr r10, [fp, #-79 ]                       ;;;_tt15 -> r10
       tst    r10, #1                             ;;;tst    _tt15, #1
       bne    L5                                  ;;;bne    L5
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr52, this
       str r0, [fp, #-81 ]                        ;;;r0 -> _vr52
       ldr r0, [fp, #-81 ]                        ;;;_vr52 -> r0
       cmp    r0, #0                              ;;;cmp    _vr52, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t19 = this.c                              ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr53, this
       str r10, [fp, #-82 ]                       ;;;r10 -> _vr53
       ldr r10, [fp, #-82 ]                       ;;;_vr53 -> r10
       ldr    r0, [r10, #1]                       ;;;ldr    _tt19, [_vr53, #1]
       str r0, [fp, #-83 ]                        ;;;r0 -> _tt19
    ;;; Null check t19                            ;;;
       ldr r0, [fp, #-83 ]                        ;;;_tt19 -> r0
       mov    r10, r0                             ;;;mov    _vr54, _tt19
       str r10, [fp, #-84 ]                       ;;;r10 -> _vr54
       ldr r10, [fp, #-84 ]                       ;;;_vr54 -> r10
       cmp    r10, #0                             ;;;cmp    _vr54, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t19                  ;;;
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r0, r10                             ;;;mov    _vr55, i
       str r0, [fp, #-85 ]                        ;;;r0 -> _vr55
       ldr r0, [fp, #-85 ]                        ;;;_vr55 -> r0
       cmp    r0, #0                              ;;;cmp    _vr55, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-83 ]                        ;;;_tt19 -> r0
       mov    r10, r0                             ;;;mov    _vr56, _tt19
       str r10, [fp, #-86 ]                       ;;;r10 -> _vr56
    ;;; t18 = t19[i]                              ;;;
       ldr r10, [fp, #-83 ]                       ;;;_tt19 -> r10
       mov    r0, r10                             ;;;mov    _vr57, _tt19
       str r0, [fp, #-87 ]                        ;;;r0 -> _vr57
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r10, r0                             ;;;mov    _vr58, i
       str r10, [fp, #-88 ]                       ;;;r10 -> _vr58
       ldr r10, [fp, #-87 ]                       ;;;_vr57 -> r10
       ldr r0, [fp, #-88 ]                        ;;;_vr58 -> r0
       ldr    r9, [r10, r0]                       ;;;ldr    _tt18, [_vr57, _vr58]
       str r9, [fp, #-89 ]                        ;;;r9 -> _tt18
    ;;; Null check t18                            ;;;
       ldr r9, [fp, #-89 ]                        ;;;_tt18 -> r9
       mov    r0, r9                              ;;;mov    _vr59, _tt18
       str r0, [fp, #-90 ]                        ;;;r0 -> _vr59
       ldr r0, [fp, #-90 ]                        ;;;_vr59 -> r0
       cmp    r0, #0                              ;;;cmp    _vr59, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t18                  ;;;
       ldr r0, [fp, #-30 ]                        ;;;j -> r0
       mov    r9, r0                              ;;;mov    _vr60, j
       str r9, [fp, #-91 ]                        ;;;r9 -> _vr60
       ldr r9, [fp, #-91 ]                        ;;;_vr60 -> r9
       cmp    r9, #0                              ;;;cmp    _vr60, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #-89 ]                        ;;;_tt18 -> r9
       mov    r0, r9                              ;;;mov    _vr61, _tt18
       str r0, [fp, #-92 ]                        ;;;r0 -> _vr61
    ;;; t17 = t18[j]                              ;;;
       ldr r0, [fp, #-89 ]                        ;;;_tt18 -> r0
       mov    r9, r0                              ;;;mov    _vr62, _tt18
       str r9, [fp, #-93 ]                        ;;;r9 -> _vr62
       ldr r9, [fp, #-30 ]                        ;;;j -> r9
       mov    r0, r9                              ;;;mov    _vr63, j
       str r0, [fp, #-94 ]                        ;;;r0 -> _vr63
       ldr r0, [fp, #-93 ]                        ;;;_vr62 -> r0
       ldr r9, [fp, #-94 ]                        ;;;_vr63 -> r9
       ldr    r10, [r0, r9]                       ;;;ldr    _tt17, [_vr62, _vr63]
       str r10, [fp, #-95 ]                       ;;;r10 -> _tt17
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r9, r10                             ;;;mov    _vr64, this
       str r9, [fp, #-96 ]                        ;;;r9 -> _vr64
       ldr r9, [fp, #-96 ]                        ;;;_vr64 -> r9
       cmp    r9, #0                              ;;;cmp    _vr64, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t23 = this.a                              ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r10, r9                             ;;;mov    _vr65, this
       str r10, [fp, #-97 ]                       ;;;r10 -> _vr65
       ldr r10, [fp, #-97 ]                       ;;;_vr65 -> r10
       ldr    r9, [r10, #3]                       ;;;ldr    _tt23, [_vr65, #3]
       str r9, [fp, #-98 ]                        ;;;r9 -> _tt23
    ;;; Null check t23                            ;;;
       ldr r9, [fp, #-98 ]                        ;;;_tt23 -> r9
       mov    r10, r9                             ;;;mov    _vr66, _tt23
       str r10, [fp, #-99 ]                       ;;;r10 -> _vr66
       ldr r10, [fp, #-99 ]                       ;;;_vr66 -> r10
       cmp    r10, #0                             ;;;cmp    _vr66, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t23                  ;;;
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r9, r10                             ;;;mov    _vr67, i
       str r9, [fp, #-100 ]                       ;;;r9 -> _vr67
       ldr r9, [fp, #-100 ]                       ;;;_vr67 -> r9
       cmp    r9, #0                              ;;;cmp    _vr67, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #-98 ]                        ;;;_tt23 -> r9
       mov    r10, r9                             ;;;mov    _vr68, _tt23
       str r10, [fp, #-101 ]                      ;;;r10 -> _vr68
    ;;; t22 = t23[i]                              ;;;
       ldr r10, [fp, #-98 ]                       ;;;_tt23 -> r10
       mov    r9, r10                             ;;;mov    _vr69, _tt23
       str r9, [fp, #-102 ]                       ;;;r9 -> _vr69
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r10, r9                             ;;;mov    _vr70, i
       str r10, [fp, #-103 ]                      ;;;r10 -> _vr70
       ldr r10, [fp, #-102 ]                      ;;;_vr69 -> r10
       ldr r9, [fp, #-103 ]                       ;;;_vr70 -> r9
       ldr    r0, [r10, r9]                       ;;;ldr    _tt22, [_vr69, _vr70]
       str r0, [fp, #-104 ]                       ;;;r0 -> _tt22
    ;;; Null check t22                            ;;;
       ldr r0, [fp, #-104 ]                       ;;;_tt22 -> r0
       mov    r9, r0                              ;;;mov    _vr71, _tt22
       str r9, [fp, #-105 ]                       ;;;r9 -> _vr71
       ldr r9, [fp, #-105 ]                       ;;;_vr71 -> r9
       cmp    r9, #0                              ;;;cmp    _vr71, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if k in bounds t22                  ;;;
       ldr r9, [fp, #-63 ]                        ;;;k -> r9
       mov    r0, r9                              ;;;mov    _vr72, k
       str r0, [fp, #-106 ]                       ;;;r0 -> _vr72
       ldr r0, [fp, #-106 ]                       ;;;_vr72 -> r0
       cmp    r0, #0                              ;;;cmp    _vr72, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-104 ]                       ;;;_tt22 -> r0
       mov    r9, r0                              ;;;mov    _vr73, _tt22
       str r9, [fp, #-107 ]                       ;;;r9 -> _vr73
    ;;; t21 = t22[k]                              ;;;
       ldr r9, [fp, #-104 ]                       ;;;_tt22 -> r9
       mov    r0, r9                              ;;;mov    _vr74, _tt22
       str r0, [fp, #-108 ]                       ;;;r0 -> _vr74
       ldr r0, [fp, #-63 ]                        ;;;k -> r0
       mov    r9, r0                              ;;;mov    _vr75, k
       str r9, [fp, #-109 ]                       ;;;r9 -> _vr75
       ldr r9, [fp, #-108 ]                       ;;;_vr74 -> r9
       ldr r0, [fp, #-109 ]                       ;;;_vr75 -> r0
       ldr    r10, [r9, r0]                       ;;;ldr    _tt21, [_vr74, _vr75]
       str r10, [fp, #-110 ]                      ;;;r10 -> _tt21
    ;;; Null check this                           ;;;
       ldr r10, [fp, #2 ]                         ;;;this -> r10
       mov    r0, r10                             ;;;mov    _vr76, this
       str r0, [fp, #-111 ]                       ;;;r0 -> _vr76
       ldr r0, [fp, #-111 ]                       ;;;_vr76 -> r0
       cmp    r0, #0                              ;;;cmp    _vr76, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t26 = this.b                              ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r10, r0                             ;;;mov    _vr77, this
       str r10, [fp, #-112 ]                      ;;;r10 -> _vr77
       ldr r10, [fp, #-112 ]                      ;;;_vr77 -> r10
       ldr    r0, [r10, #2]                       ;;;ldr    _tt26, [_vr77, #2]
       str r0, [fp, #-113 ]                       ;;;r0 -> _tt26
    ;;; Null check t26                            ;;;
       ldr r0, [fp, #-113 ]                       ;;;_tt26 -> r0
       mov    r10, r0                             ;;;mov    _vr78, _tt26
       str r10, [fp, #-114 ]                      ;;;r10 -> _vr78
       ldr r10, [fp, #-114 ]                      ;;;_vr78 -> r10
       cmp    r10, #0                             ;;;cmp    _vr78, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if k in bounds t26                  ;;;
       ldr r10, [fp, #-63 ]                       ;;;k -> r10
       mov    r0, r10                             ;;;mov    _vr79, k
       str r0, [fp, #-115 ]                       ;;;r0 -> _vr79
       ldr r0, [fp, #-115 ]                       ;;;_vr79 -> r0
       cmp    r0, #0                              ;;;cmp    _vr79, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-113 ]                       ;;;_tt26 -> r0
       mov    r10, r0                             ;;;mov    _vr80, _tt26
       str r10, [fp, #-116 ]                      ;;;r10 -> _vr80
    ;;; t25 = t26[k]                              ;;;
       ldr r10, [fp, #-113 ]                      ;;;_tt26 -> r10
       mov    r0, r10                             ;;;mov    _vr81, _tt26
       str r0, [fp, #-117 ]                       ;;;r0 -> _vr81
       ldr r0, [fp, #-63 ]                        ;;;k -> r0
       mov    r10, r0                             ;;;mov    _vr82, k
       str r10, [fp, #-118 ]                      ;;;r10 -> _vr82
       ldr r10, [fp, #-117 ]                      ;;;_vr81 -> r10
       ldr r0, [fp, #-118 ]                       ;;;_vr82 -> r0
       ldr    r9, [r10, r0]                       ;;;ldr    _tt25, [_vr81, _vr82]
       str r9, [fp, #-119 ]                       ;;;r9 -> _tt25
    ;;; Null check t25                            ;;;
       ldr r9, [fp, #-119 ]                       ;;;_tt25 -> r9
       mov    r0, r9                              ;;;mov    _vr83, _tt25
       str r0, [fp, #-120 ]                       ;;;r0 -> _vr83
       ldr r0, [fp, #-120 ]                       ;;;_vr83 -> r0
       cmp    r0, #0                              ;;;cmp    _vr83, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t25                  ;;;
       ldr r0, [fp, #-30 ]                        ;;;j -> r0
       mov    r9, r0                              ;;;mov    _vr84, j
       str r9, [fp, #-121 ]                       ;;;r9 -> _vr84
       ldr r9, [fp, #-121 ]                       ;;;_vr84 -> r9
       cmp    r9, #0                              ;;;cmp    _vr84, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #-119 ]                       ;;;_tt25 -> r9
       mov    r0, r9                              ;;;mov    _vr85, _tt25
       str r0, [fp, #-122 ]                       ;;;r0 -> _vr85
    ;;; t24 = t25[j]                              ;;;
       ldr r0, [fp, #-119 ]                       ;;;_tt25 -> r0
       mov    r9, r0                              ;;;mov    _vr86, _tt25
       str r9, [fp, #-123 ]                       ;;;r9 -> _vr86
       ldr r9, [fp, #-30 ]                        ;;;j -> r9
       mov    r0, r9                              ;;;mov    _vr87, j
       str r0, [fp, #-124 ]                       ;;;r0 -> _vr87
       ldr r0, [fp, #-123 ]                       ;;;_vr86 -> r0
       ldr r9, [fp, #-124 ]                       ;;;_vr87 -> r9
       ldr    r10, [r0, r9]                       ;;;ldr    _tt24, [_vr86, _vr87]
       str r10, [fp, #-125 ]                      ;;;r10 -> _tt24
    ;;; t20 = t21 * t24                           ;;;
       ldr r10, [fp, #-110 ]                      ;;;_tt21 -> r10
       mov    r9, r10                             ;;;mov    _vr88, _tt21
       str r9, [fp, #-126 ]                       ;;;r9 -> _vr88
       ldr r9, [fp, #-126 ]                       ;;;_vr88 -> r9
       ldr r10, [fp, #-125 ]                      ;;;_tt24 -> r10
       mul    r0, r9, r10                         ;;;mul    _tt20, _vr88, _tt24
       str r0, [fp, #-127 ]                       ;;;r0 -> _tt20
    ;;; t16 = t17 + t20                           ;;;
       ldr r0, [fp, #-95 ]                        ;;;_tt17 -> r0
       mov    r10, r0                             ;;;mov    _vr89, _tt17
       str r10, [fp, #-128 ]                      ;;;r10 -> _vr89
       ldr r10, [fp, #-128 ]                      ;;;_vr89 -> r10
       ldr r0, [fp, #-127 ]                       ;;;_tt20 -> r0
       add    r9, r10, r0                         ;;;add    _tt16, _vr89, _tt20
       str r9, [fp, #-129 ]                       ;;;r9 -> _tt16
    ;;; Null check this                           ;;;
       ldr r9, [fp, #2 ]                          ;;;this -> r9
       mov    r0, r9                              ;;;mov    _vr90, this
       str r0, [fp, #-130 ]                       ;;;r0 -> _vr90
       ldr r0, [fp, #-130 ]                       ;;;_vr90 -> r0
       cmp    r0, #0                              ;;;cmp    _vr90, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t28 = this.c                              ;;;
       ldr r0, [fp, #2 ]                          ;;;this -> r0
       mov    r9, r0                              ;;;mov    _vr91, this
       str r9, [fp, #-131 ]                       ;;;r9 -> _vr91
       ldr r9, [fp, #-131 ]                       ;;;_vr91 -> r9
       ldr    r0, [r9, #1]                        ;;;ldr    _tt28, [_vr91, #1]
       str r0, [fp, #-132 ]                       ;;;r0 -> _tt28
    ;;; Null check t28                            ;;;
       ldr r0, [fp, #-132 ]                       ;;;_tt28 -> r0
       mov    r9, r0                              ;;;mov    _vr92, _tt28
       str r9, [fp, #-133 ]                       ;;;r9 -> _vr92
       ldr r9, [fp, #-133 ]                       ;;;_vr92 -> r9
       cmp    r9, #0                              ;;;cmp    _vr92, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds t28                  ;;;
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r0, r9                              ;;;mov    _vr93, i
       str r0, [fp, #-134 ]                       ;;;r0 -> _vr93
       ldr r0, [fp, #-134 ]                       ;;;_vr93 -> r0
       cmp    r0, #0                              ;;;cmp    _vr93, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r0, [fp, #-132 ]                       ;;;_tt28 -> r0
       mov    r9, r0                              ;;;mov    _vr94, _tt28
       str r9, [fp, #-135 ]                       ;;;r9 -> _vr94
    ;;; t27 = t28[i]                              ;;;
       ldr r9, [fp, #-132 ]                       ;;;_tt28 -> r9
       mov    r0, r9                              ;;;mov    _vr95, _tt28
       str r0, [fp, #-136 ]                       ;;;r0 -> _vr95
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r9, r0                              ;;;mov    _vr96, i
       str r9, [fp, #-137 ]                       ;;;r9 -> _vr96
       ldr r9, [fp, #-136 ]                       ;;;_vr95 -> r9
       ldr r0, [fp, #-137 ]                       ;;;_vr96 -> r0
       ldr    r10, [r9, r0]                       ;;;ldr    _tt27, [_vr95, _vr96]
       str r10, [fp, #-138 ]                      ;;;r10 -> _tt27
    ;;; Null check t27                            ;;;
       ldr r10, [fp, #-138 ]                      ;;;_tt27 -> r10
       mov    r0, r10                             ;;;mov    _vr97, _tt27
       str r0, [fp, #-139 ]                       ;;;r0 -> _vr97
       ldr r0, [fp, #-139 ]                       ;;;_vr97 -> r0
       cmp    r0, #0                              ;;;cmp    _vr97, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t27                  ;;;
       ldr r0, [fp, #-30 ]                        ;;;j -> r0
       mov    r10, r0                             ;;;mov    _vr98, j
       str r10, [fp, #-140 ]                      ;;;r10 -> _vr98
       ldr r10, [fp, #-140 ]                      ;;;_vr98 -> r10
       cmp    r10, #0                             ;;;cmp    _vr98, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-138 ]                      ;;;_tt27 -> r10
       mov    r0, r10                             ;;;mov    _vr99, _tt27
       str r0, [fp, #-141 ]                       ;;;r0 -> _vr99
    ;;; t27[j] = t16                              ;;;
       ldr r0, [fp, #-138 ]                       ;;;_tt27 -> r0
       mov    r10, r0                             ;;;mov    _vr101, _tt27
       str r10, [fp, #-142 ]                      ;;;r10 -> _vr101
       ldr r10, [fp, #-30 ]                       ;;;j -> r10
       mov    r0, r10                             ;;;mov    _vr100, j
       str r0, [fp, #-143 ]                       ;;;r0 -> _vr100
       ldr r0, [fp, #-129 ]                       ;;;_tt16 -> r0
       mov    r10, r0                             ;;;mov    _vr102, _tt16
       str r10, [fp, #-144 ]                      ;;;r10 -> _vr102
       ldr r10, [fp, #-144 ]                      ;;;_vr102 -> r10
       ldr r0, [fp, #-142 ]                       ;;;_vr101 -> r0
       ldr r9, [fp, #-143 ]                       ;;;_vr100 -> r9
       str    r10, [r0, r9]                       ;;;str    _vr102, [_vr101, _vr100]
    ;;; t29 = k + 1                               ;;;
       ldr r9, [fp, #-63 ]                        ;;;k -> r9
       mov    r0, r9                              ;;;mov    _vr103, k
       str r0, [fp, #-145 ]                       ;;;r0 -> _vr103
       ldr r0, [fp, #-145 ]                       ;;;_vr103 -> r0
       add    r9, r0, #1                          ;;;add    _tt29, _vr103, #1
       str r9, [fp, #-146 ]                       ;;;r9 -> _tt29
    ;;; k = t29                                   ;;;
       ldr r9, [fp, #-146 ]                       ;;;_tt29 -> r9
       mov    r0, r9                              ;;;mov    k, _tt29
       str r0, [fp, #-63 ]                        ;;;r0 -> k
    ;;; jump L4:                                  ;;;
       b    L4                                    ;;;b    L4
    ;;; L5:                                       ;;;
L5:                                               ;;;L5:
    ;;; t30 = j + 1                               ;;;
       ldr r0, [fp, #-30 ]                        ;;;j -> r0
       mov    r9, r0                              ;;;mov    _vr104, j
       str r9, [fp, #-147 ]                       ;;;r9 -> _vr104
       ldr r9, [fp, #-147 ]                       ;;;_vr104 -> r9
       add    r0, r9, #1                          ;;;add    _tt30, _vr104, #1
       str r0, [fp, #-148 ]                       ;;;r0 -> _tt30
    ;;; j = t30                                   ;;;
       ldr r0, [fp, #-148 ]                       ;;;_tt30 -> r0
       mov    r9, r0                              ;;;mov    j, _tt30
       str r9, [fp, #-30 ]                        ;;;r9 -> j
    ;;; jump L2:                                  ;;;
       b    L2                                    ;;;b    L2
    ;;; L3:                                       ;;;
L3:                                               ;;;L3:
    ;;; t31 = i + 1                               ;;;
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r0, r9                              ;;;mov    _vr105, i
       str r0, [fp, #-149 ]                       ;;;r0 -> _vr105
       ldr r0, [fp, #-149 ]                       ;;;_vr105 -> r0
       add    r9, r0, #1                          ;;;add    _tt31, _vr105, #1
       str r9, [fp, #-150 ]                       ;;;r9 -> _tt31
    ;;; i = t31                                   ;;;
       ldr r9, [fp, #-150 ]                       ;;;_tt31 -> r9
       mov    r0, r9                              ;;;mov    i, _tt31
       str r0, [fp, #-17 ]                        ;;;r0 -> i
    ;;; jump L0:                                  ;;;
       b    L0                                    ;;;b    L0
    ;;; L1:                                       ;;;
L1:                                               ;;;L1:
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

MatrixMultInitMatrix:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #64

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(m),23)                  ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr106, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr106
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr107, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr107
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr108, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr108
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr109, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr109
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr110, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr110
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr111, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr111
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr112, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr112
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
       ldr    r9, [fp, #3]                        ;;;ldr    m, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> m
    ;;; i = 0                                     ;;;
       mov    r9, #0                              ;;;mov    i, #0
       str r9, [fp, #-17 ]                        ;;;r9 -> i
    ;;; L6:                                       ;;;
L6:                                               ;;;L6:
    ;;; Null check m                              ;;;
       ldr r9, [fp, #3 ]                          ;;;m -> r9
       mov    r10, r9                             ;;;mov    _vr113, m
       str r10, [fp, #-18 ]                       ;;;r10 -> _vr113
       ldr r10, [fp, #-18 ]                       ;;;_vr113 -> r10
       cmp    r10, #0                             ;;;cmp    _vr113, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t1 = m.length                             ;;;
       ldr r10, [fp, #3 ]                         ;;;m -> r10
       mov    r9, r10                             ;;;mov    _vr114, m
       str r9, [fp, #-19 ]                        ;;;r9 -> _vr114
       ldr r9, [fp, #-19 ]                        ;;;_vr114 -> r9
       ldr    r10, [r9, #-1]                      ;;;ldr    _tt1, [_vr114, #-1]
       str r10, [fp, #-20 ]                       ;;;r10 -> _tt1
    ;;; t0 = i < t1                               ;;;
       ldr r10, [fp, #-20 ]                       ;;;_tt1 -> r10
       mov    r9, r10                             ;;;mov    _vr116, _tt1
       str r9, [fp, #-21 ]                        ;;;r9 -> _vr116
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r10, r9                             ;;;mov    _vr115, i
       str r10, [fp, #-22 ]                       ;;;r10 -> _vr115
       ldr r10, [fp, #-22 ]                       ;;;_vr115 -> r10
       ldr r9, [fp, #-21 ]                        ;;;_vr116 -> r9
       cmp    r10, r9                             ;;;cmp    _vr115, _vr116
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       mov    r9, r0                              ;;;mov    _tt0, r0
       str r9, [fp, #-24 ]                        ;;;r9 -> _tt0
    ;;; t2 = !t0                                  ;;;
       mov    r9, #1                              ;;;mov    _tt2, #1
       str r9, [fp, #-25 ]                        ;;;r9 -> _tt2
       ldr r9, [fp, #-25 ]                        ;;;_tt2 -> r9
       ldr r0, [fp, #-24 ]                        ;;;_tt0 -> r0
       eor    r9, r9, r0                          ;;;eor    _tt2, _tt2, _tt0
       str r9, [fp, #-25 ]                        ;;;r9 -> _tt2
    ;;; cjump L7:                                 ;;;
       ldr r0, [fp, #-25 ]                        ;;;_tt2 -> r0
       mov    r9, r0                              ;;;mov    _vr117, _tt2
       str r9, [fp, #-26 ]                        ;;;r9 -> _vr117
       ldr r9, [fp, #-25 ]                        ;;;_tt2 -> r9
       tst    r9, #1                              ;;;tst    _tt2, #1
       bne    L7                                  ;;;bne    L7
    ;;; j = 0                                     ;;;
       mov    r9, #0                              ;;;mov    j, #0
       str r9, [fp, #-27 ]                        ;;;r9 -> j
    ;;; L8:                                       ;;;
L8:                                               ;;;L8:
    ;;; Null check m                              ;;;
       ldr r9, [fp, #3 ]                          ;;;m -> r9
       mov    r0, r9                              ;;;mov    _vr118, m
       str r0, [fp, #-28 ]                        ;;;r0 -> _vr118
       ldr r0, [fp, #-28 ]                        ;;;_vr118 -> r0
       cmp    r0, #0                              ;;;cmp    _vr118, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds m                    ;;;
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r9, r0                              ;;;mov    _vr119, i
       str r9, [fp, #-29 ]                        ;;;r9 -> _vr119
       ldr r9, [fp, #-29 ]                        ;;;_vr119 -> r9
       cmp    r9, #0                              ;;;cmp    _vr119, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #3 ]                          ;;;m -> r9
       mov    r0, r9                              ;;;mov    _vr120, m
       str r0, [fp, #-30 ]                        ;;;r0 -> _vr120
    ;;; t4 = m[i]                                 ;;;
       ldr r0, [fp, #3 ]                          ;;;m -> r0
       mov    r9, r0                              ;;;mov    _vr121, m
       str r9, [fp, #-31 ]                        ;;;r9 -> _vr121
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r0, r9                              ;;;mov    _vr122, i
       str r0, [fp, #-32 ]                        ;;;r0 -> _vr122
       ldr r0, [fp, #-31 ]                        ;;;_vr121 -> r0
       ldr r9, [fp, #-32 ]                        ;;;_vr122 -> r9
       ldr    r10, [r0, r9]                       ;;;ldr    _tt4, [_vr121, _vr122]
       str r10, [fp, #-33 ]                       ;;;r10 -> _tt4
    ;;; Null check t4                             ;;;
       ldr r10, [fp, #-33 ]                       ;;;_tt4 -> r10
       mov    r9, r10                             ;;;mov    _vr123, _tt4
       str r9, [fp, #-34 ]                        ;;;r9 -> _vr123
       ldr r9, [fp, #-34 ]                        ;;;_vr123 -> r9
       cmp    r9, #0                              ;;;cmp    _vr123, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t5 = t4.length                            ;;;
       ldr r9, [fp, #-33 ]                        ;;;_tt4 -> r9
       mov    r10, r9                             ;;;mov    _vr124, _tt4
       str r10, [fp, #-35 ]                       ;;;r10 -> _vr124
       ldr r10, [fp, #-35 ]                       ;;;_vr124 -> r10
       ldr    r9, [r10, #-1]                      ;;;ldr    _tt5, [_vr124, #-1]
       str r9, [fp, #-36 ]                        ;;;r9 -> _tt5
    ;;; t3 = j < t5                               ;;;
       ldr r9, [fp, #-36 ]                        ;;;_tt5 -> r9
       mov    r10, r9                             ;;;mov    _vr126, _tt5
       str r10, [fp, #-37 ]                       ;;;r10 -> _vr126
       ldr r10, [fp, #-27 ]                       ;;;j -> r10
       mov    r9, r10                             ;;;mov    _vr125, j
       str r9, [fp, #-38 ]                        ;;;r9 -> _vr125
       ldr r9, [fp, #-38 ]                        ;;;_vr125 -> r9
       ldr r10, [fp, #-37 ]                       ;;;_vr126 -> r10
       cmp    r9, r10                             ;;;cmp    _vr125, _vr126
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt3, r0
       str r10, [fp, #-39 ]                       ;;;r10 -> _tt3
    ;;; t6 = !t3                                  ;;;
       mov    r10, #1                             ;;;mov    _tt6, #1
       str r10, [fp, #-40 ]                       ;;;r10 -> _tt6
       ldr r10, [fp, #-40 ]                       ;;;_tt6 -> r10
       ldr r0, [fp, #-39 ]                        ;;;_tt3 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt6, _tt6, _tt3
       str r10, [fp, #-40 ]                       ;;;r10 -> _tt6
    ;;; cjump L9:                                 ;;;
       ldr r0, [fp, #-40 ]                        ;;;_tt6 -> r0
       mov    r10, r0                             ;;;mov    _vr127, _tt6
       str r10, [fp, #-41 ]                       ;;;r10 -> _vr127
       ldr r10, [fp, #-40 ]                       ;;;_tt6 -> r10
       tst    r10, #1                             ;;;tst    _tt6, #1
       bne    L9                                  ;;;bne    L9
    ;;; Null check m                              ;;;
       ldr r10, [fp, #3 ]                         ;;;m -> r10
       mov    r0, r10                             ;;;mov    _vr128, m
       str r0, [fp, #-42 ]                        ;;;r0 -> _vr128
       ldr r0, [fp, #-42 ]                        ;;;_vr128 -> r0
       cmp    r0, #0                              ;;;cmp    _vr128, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t8 = m.length                             ;;;
       ldr r0, [fp, #3 ]                          ;;;m -> r0
       mov    r10, r0                             ;;;mov    _vr129, m
       str r10, [fp, #-43 ]                       ;;;r10 -> _vr129
       ldr r10, [fp, #-43 ]                       ;;;_vr129 -> r10
       ldr    r0, [r10, #-1]                      ;;;ldr    _tt8, [_vr129, #-1]
       str r0, [fp, #-44 ]                        ;;;r0 -> _tt8
    ;;; t7 = t8 * 2                               ;;;
       ldr r0, [fp, #-44 ]                        ;;;_tt8 -> r0
       mov    r10, r0                             ;;;mov    _vr130, _tt8
       str r10, [fp, #-45 ]                       ;;;r10 -> _vr130
       ldr r10, [fp, #-45 ]                       ;;;_vr130 -> r10
       mul    r0, r10, #2                         ;;;mul    _tt7, _vr130, #2
       str r0, [fp, #-46 ]                        ;;;r0 -> _tt7
    ;;; t9 = Library.random(t7)                   ;;;
       ldr r0, [fp, #-46 ]                        ;;;_tt7 -> r0
       mov	r10, r0                                ;;;realloc vr
       mov    r0, r10                             ;;;mov    r0, _tt7
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       bl LIBRandom                               ;;;bl LIBRandom
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       str r2, [fp, #-47 ]                        ;;;r2 -> r2
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       mov    r2, r0                              ;;;mov    _tt9, r0
       str r2, [fp, #-48 ]                        ;;;r2 -> _tt9
    ;;; Null check m                              ;;;
       ldr r2, [fp, #3 ]                          ;;;m -> r2
       mov    r0, r2                              ;;;mov    _vr131, m
       str r0, [fp, #-49 ]                        ;;;r0 -> _vr131
       ldr r0, [fp, #-49 ]                        ;;;_vr131 -> r0
       cmp    r0, #0                              ;;;cmp    _vr131, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds m                    ;;;
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r2, r0                              ;;;mov    _vr132, i
       str r2, [fp, #-50 ]                        ;;;r2 -> _vr132
       ldr r2, [fp, #-50 ]                        ;;;_vr132 -> r2
       cmp    r2, #0                              ;;;cmp    _vr132, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r2, [fp, #3 ]                          ;;;m -> r2
       mov    r0, r2                              ;;;mov    _vr133, m
       str r0, [fp, #-51 ]                        ;;;r0 -> _vr133
    ;;; t10 = m[i]                                ;;;
       ldr r0, [fp, #3 ]                          ;;;m -> r0
       mov    r2, r0                              ;;;mov    _vr134, m
       str r2, [fp, #-52 ]                        ;;;r2 -> _vr134
       ldr r2, [fp, #-17 ]                        ;;;i -> r2
       mov    r0, r2                              ;;;mov    _vr135, i
       str r0, [fp, #-53 ]                        ;;;r0 -> _vr135
       ldr r0, [fp, #-52 ]                        ;;;_vr134 -> r0
       ldr r2, [fp, #-53 ]                        ;;;_vr135 -> r2
       ldr    r10, [r0, r2]                       ;;;ldr    _tt10, [_vr134, _vr135]
       str r10, [fp, #-54 ]                       ;;;r10 -> _tt10
    ;;; Null check t10                            ;;;
       ldr r10, [fp, #-54 ]                       ;;;_tt10 -> r10
       mov    r2, r10                             ;;;mov    _vr136, _tt10
       str r2, [fp, #-55 ]                        ;;;r2 -> _vr136
       ldr r2, [fp, #-55 ]                        ;;;_vr136 -> r2
       cmp    r2, #0                              ;;;cmp    _vr136, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t10                  ;;;
       ldr r2, [fp, #-27 ]                        ;;;j -> r2
       mov    r10, r2                             ;;;mov    _vr137, j
       str r10, [fp, #-56 ]                       ;;;r10 -> _vr137
       ldr r10, [fp, #-56 ]                       ;;;_vr137 -> r10
       cmp    r10, #0                             ;;;cmp    _vr137, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #-54 ]                       ;;;_tt10 -> r10
       mov    r2, r10                             ;;;mov    _vr138, _tt10
       str r2, [fp, #-57 ]                        ;;;r2 -> _vr138
    ;;; t10[j] = t9                               ;;;
       ldr r2, [fp, #-54 ]                        ;;;_tt10 -> r2
       mov    r10, r2                             ;;;mov    _vr140, _tt10
       str r10, [fp, #-58 ]                       ;;;r10 -> _vr140
       ldr r10, [fp, #-27 ]                       ;;;j -> r10
       mov    r2, r10                             ;;;mov    _vr139, j
       str r2, [fp, #-59 ]                        ;;;r2 -> _vr139
       ldr r2, [fp, #-48 ]                        ;;;_tt9 -> r2
       mov    r10, r2                             ;;;mov    _vr141, _tt9
       str r10, [fp, #-60 ]                       ;;;r10 -> _vr141
       ldr r10, [fp, #-60 ]                       ;;;_vr141 -> r10
       ldr r2, [fp, #-58 ]                        ;;;_vr140 -> r2
       ldr r0, [fp, #-59 ]                        ;;;_vr139 -> r0
       str    r10, [r2, r0]                       ;;;str    _vr141, [_vr140, _vr139]
    ;;; t11 = j + 1                               ;;;
       ldr r0, [fp, #-27 ]                        ;;;j -> r0
       mov    r2, r0                              ;;;mov    _vr142, j
       str r2, [fp, #-61 ]                        ;;;r2 -> _vr142
       ldr r2, [fp, #-61 ]                        ;;;_vr142 -> r2
       add    r0, r2, #1                          ;;;add    _tt11, _vr142, #1
       str r0, [fp, #-62 ]                        ;;;r0 -> _tt11
    ;;; j = t11                                   ;;;
       ldr r0, [fp, #-62 ]                        ;;;_tt11 -> r0
       mov    r2, r0                              ;;;mov    j, _tt11
       str r2, [fp, #-27 ]                        ;;;r2 -> j
    ;;; jump L8:                                  ;;;
       b    L8                                    ;;;b    L8
    ;;; L9:                                       ;;;
L9:                                               ;;;L9:
    ;;; t12 = i + 1                               ;;;
       ldr r2, [fp, #-17 ]                        ;;;i -> r2
       mov    r0, r2                              ;;;mov    _vr143, i
       str r0, [fp, #-63 ]                        ;;;r0 -> _vr143
       ldr r0, [fp, #-63 ]                        ;;;_vr143 -> r0
       add    r2, r0, #1                          ;;;add    _tt12, _vr143, #1
       str r2, [fp, #-64 ]                        ;;;r2 -> _tt12
    ;;; i = t12                                   ;;;
       ldr r2, [fp, #-64 ]                        ;;;_tt12 -> r2
       mov    r0, r2                              ;;;mov    i, _tt12
       str r0, [fp, #-17 ]                        ;;;r0 -> i
    ;;; jump L6:                                  ;;;
       b    L6                                    ;;;b    L6
    ;;; L7:                                       ;;;
L7:                                               ;;;L7:
    ;;; return                                    ;;;
       ldr r0, [fp, #-10 ]                        ;;;_vr106 -> r0
       mov    r4, r0                              ;;;mov    r4, _vr106
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr107 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr107
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr108 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr108
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6, [fp, #-13 ]                        ;;;_vr109 -> r6
       mov    r7, r6                              ;;;mov    r7, _vr109
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       ldr r7, [fp, #-14 ]                        ;;;_vr110 -> r7
       mov    r8, r7                              ;;;mov    r8, _vr110
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       ldr r8, [fp, #-15 ]                        ;;;_vr111 -> r8
       mov    r9, r8                              ;;;mov    r9, _vr111
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       ldr r9, [fp, #-16 ]                        ;;;_vr112 -> r9
       mov    r10, r9                             ;;;mov    r10, _vr112
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

MatrixMultPrintMatrix:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #61

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(m),36)                  ;;;
    ;;; Fake Def of all callee save registers     ;;;
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       str r7, [fp, #-6 ]                         ;;;r7 -> r7
       str r8, [fp, #-7 ]                         ;;;r8 -> r8
       str r9, [fp, #-8 ]                         ;;;r9 -> r9
       str r10, [fp, #-9 ]                        ;;;r10 -> r10
       ldr r4, [fp, #-3 ]                         ;;;r4 -> r4
       mov    r10, r4                             ;;;mov    _vr144, r4
       str r10, [fp, #-10 ]                       ;;;r10 -> _vr144
       ldr r5, [fp, #-4 ]                         ;;;r5 -> r5
       mov    r10, r5                             ;;;mov    _vr145, r5
       str r10, [fp, #-11 ]                       ;;;r10 -> _vr145
       ldr r6, [fp, #-5 ]                         ;;;r6 -> r6
       mov    r10, r6                             ;;;mov    _vr146, r6
       str r10, [fp, #-12 ]                       ;;;r10 -> _vr146
       ldr r7, [fp, #-6 ]                         ;;;r7 -> r7
       mov    r10, r7                             ;;;mov    _vr147, r7
       str r10, [fp, #-13 ]                       ;;;r10 -> _vr147
       ldr r8, [fp, #-7 ]                         ;;;r8 -> r8
       mov    r10, r8                             ;;;mov    _vr148, r8
       str r10, [fp, #-14 ]                       ;;;r10 -> _vr148
       ldr r9, [fp, #-8 ]                         ;;;r9 -> r9
       mov    r10, r9                             ;;;mov    _vr149, r9
       str r10, [fp, #-15 ]                       ;;;r10 -> _vr149
       ldr r10, [fp, #-9 ]                        ;;;r10 -> r10
       mov    r9, r10                             ;;;mov    _vr150, r10
       str r9, [fp, #-16 ]                        ;;;r9 -> _vr150
       ldr    r9, [fp, #2]                        ;;;ldr    this, [fp, #2]
       str r9, [fp, #2 ]                          ;;;r9 -> this
       ldr    r9, [fp, #3]                        ;;;ldr    m, [fp, #3]
       str r9, [fp, #3 ]                          ;;;r9 -> m
    ;;; i = 0                                     ;;;
       mov    r9, #0                              ;;;mov    i, #0
       str r9, [fp, #-17 ]                        ;;;r9 -> i
    ;;; L10:                                      ;;;
L10:                                              ;;;L10:
    ;;; Null check m                              ;;;
       ldr r9, [fp, #3 ]                          ;;;m -> r9
       mov    r10, r9                             ;;;mov    _vr151, m
       str r10, [fp, #-18 ]                       ;;;r10 -> _vr151
       ldr r10, [fp, #-18 ]                       ;;;_vr151 -> r10
       cmp    r10, #0                             ;;;cmp    _vr151, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t1 = m.length                             ;;;
       ldr r10, [fp, #3 ]                         ;;;m -> r10
       mov    r9, r10                             ;;;mov    _vr152, m
       str r9, [fp, #-19 ]                        ;;;r9 -> _vr152
       ldr r9, [fp, #-19 ]                        ;;;_vr152 -> r9
       ldr    r10, [r9, #-1]                      ;;;ldr    _tt1, [_vr152, #-1]
       str r10, [fp, #-20 ]                       ;;;r10 -> _tt1
    ;;; t0 = i < t1                               ;;;
       ldr r10, [fp, #-20 ]                       ;;;_tt1 -> r10
       mov    r9, r10                             ;;;mov    _vr154, _tt1
       str r9, [fp, #-21 ]                        ;;;r9 -> _vr154
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r10, r9                             ;;;mov    _vr153, i
       str r10, [fp, #-22 ]                       ;;;r10 -> _vr153
       ldr r10, [fp, #-22 ]                       ;;;_vr153 -> r10
       ldr r9, [fp, #-21 ]                        ;;;_vr154 -> r9
       cmp    r10, r9                             ;;;cmp    _vr153, _vr154
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       mov    r9, r0                              ;;;mov    _tt0, r0
       str r9, [fp, #-24 ]                        ;;;r9 -> _tt0
    ;;; t2 = !t0                                  ;;;
       mov    r9, #1                              ;;;mov    _tt2, #1
       str r9, [fp, #-25 ]                        ;;;r9 -> _tt2
       ldr r9, [fp, #-25 ]                        ;;;_tt2 -> r9
       ldr r0, [fp, #-24 ]                        ;;;_tt0 -> r0
       eor    r9, r9, r0                          ;;;eor    _tt2, _tt2, _tt0
       str r9, [fp, #-25 ]                        ;;;r9 -> _tt2
    ;;; cjump L11:                                ;;;
       ldr r0, [fp, #-25 ]                        ;;;_tt2 -> r0
       mov    r9, r0                              ;;;mov    _vr155, _tt2
       str r9, [fp, #-26 ]                        ;;;r9 -> _vr155
       ldr r9, [fp, #-25 ]                        ;;;_tt2 -> r9
       tst    r9, #1                              ;;;tst    _tt2, #1
       bne    L11                                 ;;;bne    L11
    ;;; j = 0                                     ;;;
       mov    r9, #0                              ;;;mov    j, #0
       str r9, [fp, #-27 ]                        ;;;r9 -> j
    ;;; L12:                                      ;;;
L12:                                              ;;;L12:
    ;;; Null check m                              ;;;
       ldr r9, [fp, #3 ]                          ;;;m -> r9
       mov    r0, r9                              ;;;mov    _vr156, m
       str r0, [fp, #-28 ]                        ;;;r0 -> _vr156
       ldr r0, [fp, #-28 ]                        ;;;_vr156 -> r0
       cmp    r0, #0                              ;;;cmp    _vr156, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds m                    ;;;
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r9, r0                              ;;;mov    _vr157, i
       str r9, [fp, #-29 ]                        ;;;r9 -> _vr157
       ldr r9, [fp, #-29 ]                        ;;;_vr157 -> r9
       cmp    r9, #0                              ;;;cmp    _vr157, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #3 ]                          ;;;m -> r9
       mov    r0, r9                              ;;;mov    _vr158, m
       str r0, [fp, #-30 ]                        ;;;r0 -> _vr158
    ;;; t4 = m[i]                                 ;;;
       ldr r0, [fp, #3 ]                          ;;;m -> r0
       mov    r9, r0                              ;;;mov    _vr159, m
       str r9, [fp, #-31 ]                        ;;;r9 -> _vr159
       ldr r9, [fp, #-17 ]                        ;;;i -> r9
       mov    r0, r9                              ;;;mov    _vr160, i
       str r0, [fp, #-32 ]                        ;;;r0 -> _vr160
       ldr r0, [fp, #-31 ]                        ;;;_vr159 -> r0
       ldr r9, [fp, #-32 ]                        ;;;_vr160 -> r9
       ldr    r10, [r0, r9]                       ;;;ldr    _tt4, [_vr159, _vr160]
       str r10, [fp, #-33 ]                       ;;;r10 -> _tt4
    ;;; Null check t4                             ;;;
       ldr r10, [fp, #-33 ]                       ;;;_tt4 -> r10
       mov    r9, r10                             ;;;mov    _vr161, _tt4
       str r9, [fp, #-34 ]                        ;;;r9 -> _vr161
       ldr r9, [fp, #-34 ]                        ;;;_vr161 -> r9
       cmp    r9, #0                              ;;;cmp    _vr161, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t5 = t4.length                            ;;;
       ldr r9, [fp, #-33 ]                        ;;;_tt4 -> r9
       mov    r10, r9                             ;;;mov    _vr162, _tt4
       str r10, [fp, #-35 ]                       ;;;r10 -> _vr162
       ldr r10, [fp, #-35 ]                       ;;;_vr162 -> r10
       ldr    r9, [r10, #-1]                      ;;;ldr    _tt5, [_vr162, #-1]
       str r9, [fp, #-36 ]                        ;;;r9 -> _tt5
    ;;; t3 = j < t5                               ;;;
       ldr r9, [fp, #-36 ]                        ;;;_tt5 -> r9
       mov    r10, r9                             ;;;mov    _vr164, _tt5
       str r10, [fp, #-37 ]                       ;;;r10 -> _vr164
       ldr r10, [fp, #-27 ]                       ;;;j -> r10
       mov    r9, r10                             ;;;mov    _vr163, j
       str r9, [fp, #-38 ]                        ;;;r9 -> _vr163
       ldr r9, [fp, #-38 ]                        ;;;_vr163 -> r9
       ldr r10, [fp, #-37 ]                       ;;;_vr164 -> r10
       cmp    r9, r10                             ;;;cmp    _vr163, _vr164
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       mov    r10, r0                             ;;;mov    _tt3, r0
       str r10, [fp, #-39 ]                       ;;;r10 -> _tt3
    ;;; t6 = !t3                                  ;;;
       mov    r10, #1                             ;;;mov    _tt6, #1
       str r10, [fp, #-40 ]                       ;;;r10 -> _tt6
       ldr r10, [fp, #-40 ]                       ;;;_tt6 -> r10
       ldr r0, [fp, #-39 ]                        ;;;_tt3 -> r0
       eor    r10, r10, r0                        ;;;eor    _tt6, _tt6, _tt3
       str r10, [fp, #-40 ]                       ;;;r10 -> _tt6
    ;;; cjump L13:                                ;;;
       ldr r0, [fp, #-40 ]                        ;;;_tt6 -> r0
       mov    r10, r0                             ;;;mov    _vr165, _tt6
       str r10, [fp, #-41 ]                       ;;;r10 -> _vr165
       ldr r10, [fp, #-40 ]                       ;;;_tt6 -> r10
       tst    r10, #1                             ;;;tst    _tt6, #1
       bne    L13                                 ;;;bne    L13
    ;;; Null check m                              ;;;
       ldr r10, [fp, #3 ]                         ;;;m -> r10
       mov    r0, r10                             ;;;mov    _vr166, m
       str r0, [fp, #-42 ]                        ;;;r0 -> _vr166
       ldr r0, [fp, #-42 ]                        ;;;_vr166 -> r0
       cmp    r0, #0                              ;;;cmp    _vr166, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if i in bounds m                    ;;;
       ldr r0, [fp, #-17 ]                        ;;;i -> r0
       mov    r10, r0                             ;;;mov    _vr167, i
       str r10, [fp, #-43 ]                       ;;;r10 -> _vr167
       ldr r10, [fp, #-43 ]                       ;;;_vr167 -> r10
       cmp    r10, #0                             ;;;cmp    _vr167, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r10, [fp, #3 ]                         ;;;m -> r10
       mov    r0, r10                             ;;;mov    _vr168, m
       str r0, [fp, #-44 ]                        ;;;r0 -> _vr168
    ;;; t8 = m[i]                                 ;;;
       ldr r0, [fp, #3 ]                          ;;;m -> r0
       mov    r10, r0                             ;;;mov    _vr169, m
       str r10, [fp, #-45 ]                       ;;;r10 -> _vr169
       ldr r10, [fp, #-17 ]                       ;;;i -> r10
       mov    r0, r10                             ;;;mov    _vr170, i
       str r0, [fp, #-46 ]                        ;;;r0 -> _vr170
       ldr r0, [fp, #-45 ]                        ;;;_vr169 -> r0
       ldr r10, [fp, #-46 ]                       ;;;_vr170 -> r10
       ldr    r9, [r0, r10]                       ;;;ldr    _tt8, [_vr169, _vr170]
       str r9, [fp, #-47 ]                        ;;;r9 -> _tt8
    ;;; Null check t8                             ;;;
       ldr r9, [fp, #-47 ]                        ;;;_tt8 -> r9
       mov    r10, r9                             ;;;mov    _vr171, _tt8
       str r10, [fp, #-48 ]                       ;;;r10 -> _vr171
       ldr r10, [fp, #-48 ]                       ;;;_vr171 -> r10
       cmp    r10, #0                             ;;;cmp    _vr171, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; Check if j in bounds t8                   ;;;
       ldr r10, [fp, #-27 ]                       ;;;j -> r10
       mov    r9, r10                             ;;;mov    _vr172, j
       str r9, [fp, #-49 ]                        ;;;r9 -> _vr172
       ldr r9, [fp, #-49 ]                        ;;;_vr172 -> r9
       cmp    r9, #0                              ;;;cmp    _vr172, #0
       blt    labelArrayBoundsError               ;;;blt    labelArrayBoundsError
       ldr r9, [fp, #-47 ]                        ;;;_tt8 -> r9
       mov    r10, r9                             ;;;mov    _vr173, _tt8
       str r10, [fp, #-50 ]                       ;;;r10 -> _vr173
    ;;; t7 = t8[j]                                ;;;
       ldr r10, [fp, #-47 ]                       ;;;_tt8 -> r10
       mov    r9, r10                             ;;;mov    _vr174, _tt8
       str r9, [fp, #-51 ]                        ;;;r9 -> _vr174
       ldr r9, [fp, #-27 ]                        ;;;j -> r9
       mov    r10, r9                             ;;;mov    _vr175, j
       str r10, [fp, #-52 ]                       ;;;r10 -> _vr175
       ldr r10, [fp, #-51 ]                       ;;;_vr174 -> r10
       ldr r9, [fp, #-52 ]                        ;;;_vr175 -> r9
       ldr    r0, [r10, r9]                       ;;;ldr    _tt7, [_vr174, _vr175]
       str r0, [fp, #-53 ]                        ;;;r0 -> _tt7
    ;;; Library.printi(t7)                        ;;;
       ldr r0, [fp, #-53 ]                        ;;;_tt7 -> r0
       mov	r9, r0                                 ;;;realloc vr
       mov    r0, r9                              ;;;mov    r0, _tt7
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       bl LIBPrinti                               ;;;bl LIBPrinti
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       str r2, [fp, #-54 ]                        ;;;r2 -> r2
    ;;; t9 =                                      ;;;
       adr      r2, str0                          ;;;adr      _tt9, str0
       str r2, [fp, #-55 ]                        ;;;r2 -> _tt9
    ;;; Library.print(t9)                         ;;;
       ldr r2, [fp, #-55 ]                        ;;;_tt9 -> r2
       mov    r0, r2                              ;;;mov    r0, _tt9
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       bl LIBPrint                                ;;;bl LIBPrint
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       str r2, [fp, #-54 ]                        ;;;r2 -> r2
    ;;; t10 = j + 1                               ;;;
       ldr r2, [fp, #-27 ]                        ;;;j -> r2
       mov    r0, r2                              ;;;mov    _vr176, j
       str r0, [fp, #-56 ]                        ;;;r0 -> _vr176
       ldr r0, [fp, #-56 ]                        ;;;_vr176 -> r0
       add    r2, r0, #1                          ;;;add    _tt10, _vr176, #1
       str r2, [fp, #-57 ]                        ;;;r2 -> _tt10
    ;;; j = t10                                   ;;;
       ldr r2, [fp, #-57 ]                        ;;;_tt10 -> r2
       mov    r0, r2                              ;;;mov    j, _tt10
       str r0, [fp, #-27 ]                        ;;;r0 -> j
    ;;; jump L12:                                 ;;;
       b    L12                                   ;;;b    L12
    ;;; L13:                                      ;;;
L13:                                              ;;;L13:
    ;;; t11 = \n                                  ;;;
       adr      r0, str1                          ;;;adr      _tt11, str1
       str r0, [fp, #-58 ]                        ;;;r0 -> _tt11
    ;;; Library.print(t11)                        ;;;
       ldr r0, [fp, #-58 ]                        ;;;_tt11 -> r0
       mov	r2, r0                                 ;;;realloc vr
       mov    r0, r2                              ;;;mov    r0, _tt11
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       bl LIBPrint                                ;;;bl LIBPrint
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       str r2, [fp, #-54 ]                        ;;;r2 -> r2
    ;;; t12 = i + 1                               ;;;
       ldr r2, [fp, #-17 ]                        ;;;i -> r2
       mov    r0, r2                              ;;;mov    _vr177, i
       str r0, [fp, #-59 ]                        ;;;r0 -> _vr177
       ldr r0, [fp, #-59 ]                        ;;;_vr177 -> r0
       add    r2, r0, #1                          ;;;add    _tt12, _vr177, #1
       str r2, [fp, #-60 ]                        ;;;r2 -> _tt12
    ;;; i = t12                                   ;;;
       ldr r2, [fp, #-60 ]                        ;;;_tt12 -> r2
       mov    r0, r2                              ;;;mov    i, _tt12
       str r0, [fp, #-17 ]                        ;;;r0 -> i
    ;;; jump L10:                                 ;;;
       b    L10                                   ;;;b    L10
    ;;; L11:                                      ;;;
L11:                                              ;;;L11:
    ;;; t13 = \n                                  ;;;
       adr      r0, str1                          ;;;adr      _tt13, str1
       str r0, [fp, #-61 ]                        ;;;r0 -> _tt13
    ;;; Library.print(t13)                        ;;;
       ldr r0, [fp, #-61 ]                        ;;;_tt13 -> r0
       mov	r2, r0                                 ;;;realloc vr
       mov    r0, r2                              ;;;mov    r0, _tt13
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-23 ]                        ;;;r0 -> r0
       bl LIBPrint                                ;;;bl LIBPrint
       str r0, [fp, #-23 ]                        ;;;r0 -> r0
       str r2, [fp, #-54 ]                        ;;;r2 -> r2
    ;;; return                                    ;;;
       ldr r2, [fp, #-10 ]                        ;;;_vr144 -> r2
       mov    r4, r2                              ;;;mov    r4, _vr144
       str r4, [fp, #-3 ]                         ;;;r4 -> r4
       ldr r4, [fp, #-11 ]                        ;;;_vr145 -> r4
       mov    r5, r4                              ;;;mov    r5, _vr145
       str r5, [fp, #-4 ]                         ;;;r5 -> r5
       ldr r5, [fp, #-12 ]                        ;;;_vr146 -> r5
       mov    r6, r5                              ;;;mov    r6, _vr146
       str r6, [fp, #-5 ]                         ;;;r6 -> r6
       ldr r6,