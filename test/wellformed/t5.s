;;;  File test/wellformed/t5.s

	 .requ	bump, r3
	 b      main
;; ----------------------------
;; VTables


AVT:
	.data 	, 0

BVT:
	.data 	BMain, 0





BMain:
	stu    lr, [sp, #-1]
	stu    fp, [sp, #-1]
	mov    fp, sp
	sub    sp, sp, #28

	;;; ---- method instructions ------
    ;;; Entry                                     ;;;
    ;;; Entry                                     ;;;
    ;;; Exit                                      ;;;
    ;;; Exit                                      ;;;
    ;;; TAC_Preamble(List(args),6)                ;;;
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
    ;;; t0 = new A()                              ;;;
       mov    r0, #1                              ;;;mov    r0, #1
       str r0, [fp, #-17 ]                        ;;;r0 -> r0
       bl     LIBAllocateObject                   ;;;bl     LIBAllocateObject
       ldr r0, [fp, #-17 ]                        ;;;r0 -> r0
       mov    r9, r0                              ;;;mov    _tt0, r0
       str r9, [fp, #-18 ]                        ;;;r9 -> _tt0
       adr    r9, AVT                             ;;;adr    _vr8, AVT
       str r9, [fp, #-19 ]                        ;;;r9 -> _vr8
       ldr r9, [fp, #-19 ]                        ;;;_vr8 -> r9
       ldr r0, [fp, #-18 ]                        ;;;_tt0 -> r0
       ldr    r9, [r0]                            ;;;ldr    _vr8, [_tt0]
    ;;; oa = t0                                   ;;;
       ldr r0, [fp, #-18 ]                        ;;;_tt0 -> r0
       mov    r9, r0                              ;;;mov    oa, _tt0
       str r9, [fp, #-20 ]                        ;;;r9 -> oa
    ;;; Null check oa                             ;;;
       ldr r9, [fp, #-20 ]                        ;;;oa -> r9
       mov    r0, r9                              ;;;mov    _vr9, oa
       str r0, [fp, #-21 ]                        ;;;r0 -> _vr9
       ldr r0, [fp, #-21 ]                        ;;;_vr9 -> r0
       cmp    r0, #0                              ;;;cmp    _vr9, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; oa.a = 2                                  ;;;
       ldr r0, [fp, #-20 ]                        ;;;oa -> r0
       mov    r9, r0                              ;;;mov    _vr10, oa
       str r9, [fp, #-22 ]                        ;;;r9 -> _vr10
       mov      r9,#2                             ;;;mov      _vr11,#2
       str r9, [fp, #-23 ]                        ;;;r9 -> _vr11
       ldr r9, [fp, #-23 ]                        ;;;_vr11 -> r9
       ldr r0, [fp, #-22 ]                        ;;;_vr10 -> r0
       str    r9, [r0, #1]                        ;;;str    _vr11, [_vr10, #1]
    ;;; Null check oa                             ;;;
       ldr r0, [fp, #-20 ]                        ;;;oa -> r0
       mov    r9, r0                              ;;;mov    _vr12, oa
       str r9, [fp, #-24 ]                        ;;;r9 -> _vr12
       ldr r9, [fp, #-24 ]                        ;;;_vr12 -> r9
       cmp    r9, #0                              ;;;cmp    _vr12, #0
       beq labelNullPtrError                      ;;;beq labelNullPtrError
    ;;; t1 = oa.a                                 ;;;
       ldr r9, [fp, #-20 ]                        ;;;oa -> r9
       mov    r0, r9                              ;;;mov    _vr13, oa
       str r0, [fp, #-25 ]                        ;;;r0 -> _vr13
       ldr r0, [fp, #-25 ]                        ;;;_vr13 -> r0
       ldr    r9, [r0, #1]                        ;;;ldr    _tt1, [_vr13, #1]
       str r9, [fp, #-26 ]                        ;;;r9 -> _tt1
    ;;; Library.printi(t1)                        ;;;
       ldr r9, [fp, #-26 ]                        ;;;_tt1 -> r9
       mov    r0, r9                              ;;;mov    r0, _tt1
       str r0, [fp, #-17 ]                        ;;;r0 -> r0
       ldr r0, [fp, #-17 ]                        ;;;r0 -> r0
       bl LIBPrinti                               ;;;bl LIBPrinti
       str r0, [fp, #-17 ]                        ;;;r0 -> r0
       str r1, [fp, #-27 ]                        ;;;r1 -> r1
       str r2, [fp, #-28 ]                        ;;;r2 -> r2
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

;;; o = new B          
	 mov    r0,  #1   
	 bl     LIBAllocateObject   			
	 adr    r1, BVT      

;;; move the vptr into the object
	 str    r1, [r0]               


;;; call the object's main       
	 bl     BMain      


;;;ic_main always returns 0
	 mov    r0, #0                 
	 mov    sp, fp                 
	 ldu    fp, [sp, #1]           
	 swi    #SysHalt

;;; ----------------------------
;;; String Constants





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
