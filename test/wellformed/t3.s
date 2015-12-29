;;;  File test/wellformed/t3.s

	 .requ	bump, r3
	 b      main
;; ----------------------------
;; VTables


AVT:
	.data 	AMain





AMain:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #27

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
       ldr    r9, [fp, #-3]                       ;;;ldr    args, [fp, #-3]
       str r9, [fp, #3 ]                          ;;;r9 -> args
    ;;; n = 2                                     ;;;
       mov    r9, #2                              ;;;mov    n, #2
       str r9, [fp, #-17 ]                        ;;;r9 -> n
    ;;; t0 = n < 0                                ;;;
       mov      r9,#0                             ;;;mov      _vr9,#0
       str r9, [fp, #-18 ]                        ;;;r9 -> _vr9
       ldr r9, [fp, #-17 ]                        ;;;n -> r9
       mov    r10, r9                             ;;;mov    _vr8, n
       str r10, [fp, #-19 ]                       ;;;r10 -> _vr8
       ldr r10, [fp, #-19 ]                       ;;;_vr8 -> r10
       ldr r9, [fp, #-18 ]                        ;;;_vr9 -> r9
       cmp    r10, r9                             ;;;cmp    _vr8, _vr9
       mov    r0, #0                              ;;;mov    r0, #0
       str r0, [fp, #-20 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-20 ]                        ;;;r0 -> r0
       movlt    r0, #1                            ;;;movlt    r0, #1
       str r0, [fp, #-20 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-20 ]                        ;;;r0 -> r0
       mov    r9, r0                              ;;;mov    _tt0, r0
       str r9, [fp, #-21 ]                        ;;;r9 -> _tt0
    ;;; t1 = !t0                                  ;;;
       mov    r9, #1                              ;;;mov    _tt1, #1
       str r9, [fp, #-22 ]                        ;;;r9 -> _tt1
       ldr r9, [fp, #-22 ]                        ;;;_tt1 -> r9
       ldr r0, [fp, #-21 ]                        ;;;_tt0 -> r0
       eor    r9, r9, r0                          ;;;eor    _tt1, _tt1, _tt0
       str r9, [fp, #-22 ]                        ;;;r9 -> _tt1
    ;;; cjump L0:                                 ;;;
       ldr r0, [fp, #-22 ]                        ;;;_tt1 -> r0
       mov    r9, r0                              ;;;mov    _vr10, _tt1
       str r9, [fp, #-23 ]                        ;;;r9 -> _vr10
       ldr r9, [fp, #-22 ]                        ;;;_tt1 -> r9
       tst    r9, #1                              ;;;tst    _tt1, #1
       bne    L0                                  ;;;bne    L0
    ;;; t2 = yes                                  ;;;
       adr      r9, str0                          ;;;adr      _tt2, str0
       str r9, [fp, #-24 ]                        ;;;r9 -> _tt2
    ;;; Library.println(t2)                       ;;;
       ldr r9, [fp, #-24 ]                        ;;;_tt2 -> r9
       mov    r0, r9                              ;;;mov    r0, _tt2
       str r0, [fp, #-20 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-20 ]                        ;;;r0 -> r0
       bl LIBPrintln                              ;;;bl LIBPrintln
       str r0, [fp, #-20 ]                        ;;;r0 -> r0
       str r1, [fp, #-25 ]                        ;;;r1 -> r1
       str r2, [fp, #-26 ]                        ;;;r2 -> r2
    ;;; jump L1:                                  ;;;
       b    L1                                    ;;;b    L1
    ;;; L0:                                       ;;;
L0:                                               ;;;L0:
    ;;; t3 = no                                   ;;;
       adr      r2, str1                          ;;;adr      _tt3, str1
       str r2, [fp, #-27 ]                        ;;;r2 -> _tt3
    ;;; Library.println(t3)                       ;;;
       ldr r2, [fp, #-27 ]                        ;;;_tt3 -> r2
       mov    r0, r2                              ;;;mov    r0, _tt3
       str r0, [fp, #-20 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-20 ]                        ;;;r0 -> r0
       bl LIBPrintln                              ;;;bl LIBPrintln
       str r0, [fp, #-20 ]                        ;;;r0 -> r0
       str r1, [fp, #-25 ]                        ;;;r1 -> r1
       str r2, [fp, #-26 ]                        ;;;r2 -> r2
    ;;; L1:                                       ;;;
L1:                                               ;;;L1:
    ;;; return                                    ;;;
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
	 stu    lr, [sp, #1]    				
	 stu    fp, [sp, #1]    				
	 mov    fp, sp         			  

;;; o = new A          
	 mov    r0,  #1   
	 bl     LIBAllocateObject   			
	 adr    r1, AVT      

;;; move the vptr into the object
	 str    r1, [r0]               


;;; call the object's main       
	 bl     AMain      


;;;ic_main always returns 0
	 mov    r0, #0                 
	 mov    sp, fp                 
	 ldu    fp, [sp, #1]           
	 swi    #SysHalt

;;; ----------------------------
;;; String Constants


str1:	.string "no"
str0:	.string "yes"



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
