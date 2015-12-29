;;;  File test/batman.s

	 .requ	bump, r3
	 b      main
;; ----------------------------
;; VTables


AVT:
	.data 	,0

BVT:
	.data 	,0

CVT:
	.data 	,0

BatmanVT:
	.data 	BatmanMain,0





BatmanMain:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #18

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(args),8)                ;;;
    ;;; Fake Def of all callee save registers     ;;;
       mov    r2, r4                              ;;;mov    _vr1, r4
       str r2, [fp, #-17 ]                        ;;;str _vr1, [fp, #-17 ]
       mov    r2, r5                              ;;;mov    _vr2, r5
       str r2, [fp, #-15 ]                        ;;;str _vr2, [fp, #-15 ]
    ;;; Redundant Move: mov    _vr3, r6 on r6     ;;;
       str r6, [fp, #-12 ]                        ;;;str _vr3, [fp, #-12 ]
       mov    r2, r7                              ;;;mov    _vr4, r7
       str r2, [fp, #-18 ]                        ;;;str _vr4, [fp, #-18 ]
       mov    r2, r8                              ;;;mov    _vr5, r8
       str r2, [fp, #-13 ]                        ;;;str _vr5, [fp, #-13 ]
       mov    r2, r9                              ;;;mov    _vr6, r9
       str r2, [fp, #-16 ]                        ;;;str _vr6, [fp, #-16 ]
       mov    r2, r10                             ;;;mov    _vr7, r10
       str r2, [fp, #-14 ]                        ;;;str _vr7, [fp, #-14 ]
       ldr    r6, [fp, #2]                        ;;;ldr    this, [fp, #2]
       ldr    r6, [fp, #3]                        ;;;ldr    args, [fp, #3]
    ;;; i = 1                                     ;;;
       mov    r2, #1                              ;;;mov    i, #1
       str r2, [fp, #-10 ]                        ;;;str i, [fp, #-10 ]
    ;;; L0:                                       ;;;
L0:                                               ;;;L0:
    ;;; t0 = i <= 14                              ;;;
       mov      r6,#14                            ;;;mov      _vr9,#14
       ldr r2, [fp, #-10 ]                        ;;;ldr i, [fp, #-10 ]
    ;;; Redundant Move: mov    _vr8, i on r2      ;;;
       str r2, [fp, #-11 ]                        ;;;str _vr8, [fp, #-11 ]
       ldr r2, [fp, #-11 ]                        ;;;ldr _vr8, [fp, #-11 ]
       cmp    r2, r6                              ;;;cmp    _vr8, _vr9
       mov    r0, #0                              ;;;mov    r0, #0
       movle    r0, #1                            ;;;movle    r0, #1
       mov    r2, r0                              ;;;mov    _tt0, r0
    ;;; t1 = !t0                                  ;;;
       mov    r6, #1                              ;;;mov    _tt1, #1
       eor    r6, r6, r2                          ;;;eor    _tt1, _tt1, _tt0
    ;;; cjump L1:                                 ;;;
       mov    r2, r6                              ;;;mov    _vr10, _tt1
       tst    r6, #1                              ;;;tst    _tt1, #1
       bne    L1                                  ;;;bne    L1
    ;;; t2 = na                                   ;;;
       adr      r6, str0                          ;;;adr      _tt2, str0
    ;;; Library.println(t2)                       ;;;
       mov    r0, r6                              ;;;mov    r0, _tt2
       bl LIBPrintln                              ;;;bl LIBPrintln
    ;;; t3 = i + 1                                ;;;
       ldr r2, [fp, #-10 ]                        ;;;ldr i, [fp, #-10 ]
       mov    r6, r2                              ;;;mov    _vr11, i
       add    r6, r6, #1                          ;;;add    _tt3, _vr11, #1
    ;;; i = t3                                    ;;;
       mov    r2, r6                              ;;;mov    i, _tt3
       str r2, [fp, #-10 ]                        ;;;str i, [fp, #-10 ]
    ;;; t4 = i == 14                              ;;;
       mov      r6,#14                            ;;;mov      _vr13,#14
       ldr r2, [fp, #-10 ]                        ;;;ldr i, [fp, #-10 ]
    ;;; Redundant Move: mov    _vr12, i on r2     ;;;
       cmp    r2, r6                              ;;;cmp    _vr12, _vr13
       mov    r0, #0                              ;;;mov    r0, #0
       moveq    r0, #1                            ;;;moveq    r0, #1
       mov    r2, r0                              ;;;mov    _tt4, r0
    ;;; t5 = !t4                                  ;;;
       mov    r6, #1                              ;;;mov    _tt5, #1
       eor    r6, r6, r2                          ;;;eor    _tt5, _tt5, _tt4
    ;;; cjump L2:                                 ;;;
       mov    r2, r6                              ;;;mov    _vr14, _tt5
       tst    r6, #1                              ;;;tst    _tt5, #1
       bne    L2                                  ;;;bne    L2
    ;;; t6 = BATMANNNNN                           ;;;
       adr      r6, str1                          ;;;adr      _tt6, str1
    ;;; Library.println(t6)                       ;;;
       mov    r0, r6                              ;;;mov    r0, _tt6
       bl LIBPrintln                              ;;;bl LIBPrintln
    ;;; jump L1:                                  ;;;
       b    L1                                    ;;;b    L1
    ;;; jump L3:                                  ;;;
       b    L3                                    ;;;b    L3
    ;;; L2:                                       ;;;
L2:                                               ;;;L2:
    ;;; jump L0:                                  ;;;
       b    L0                                    ;;;b    L0
    ;;; L3:                                       ;;;
L3:                                               ;;;L3:
    ;;; jump L0:                                  ;;;
       b    L0                                    ;;;b    L0
    ;;; L1:                                       ;;;
L1:                                               ;;;L1:
    ;;; return                                    ;;;
       ldr r2, [fp, #-17 ]                        ;;;ldr _vr1, [fp, #-17 ]
       mov    r4, r2                              ;;;mov    r4, _vr1
       ldr r2, [fp, #-15 ]                        ;;;ldr _vr2, [fp, #-15 ]
       mov    r5, r2                              ;;;mov    r5, _vr2
       ldr r6, [fp, #-12 ]                        ;;;ldr _vr3, [fp, #-12 ]
    ;;; Redundant Move: mov    r6, _vr3 on r6     ;;;
       ldr r2, [fp, #-18 ]                        ;;;ldr _vr4, [fp, #-18 ]
       mov    r7, r2                              ;;;mov    r7, _vr4
       ldr r2, [fp, #-13 ]                        ;;;ldr _vr5, [fp, #-13 ]
       mov    r8, r2                              ;;;mov    r8, _vr5
       ldr r2, [fp, #-16 ]                        ;;;ldr _vr6, [fp, #-16 ]
       mov    r9, r2                              ;;;mov    r9, _vr6
       ldr r2, [fp, #-14 ]                        ;;;ldr _vr7, [fp, #-14 ]
       mov    r10, r2                             ;;;mov    r10, _vr7
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

;;; o = new Batman          
	 mov    r0,  #1   
	 bl     LIBAllocateObject   			
	 adr    r1, BatmanVT      

;;; move the vptr into the object
	 str    r1, [r0]               


;;; call the object's main       
	 stu    r0, [sp, #-1]  
	 stu    r0, [sp, #-1]  
	 bl     BatmanMain      


;;;ic_main always returns 0
	 mov    r0, #0                 
	 mov    sp, fp                 
	 ldu    fp, [sp, #1]           
	 swi    #SysHalt

;;; ----------------------------
;;; String Constants


str0:	.string "na"
str1:	.string "BATMANNNNN"



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
