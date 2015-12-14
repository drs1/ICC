# File test/wellformed/objects.s

.requ	bump, r3
	 b      main
;; ----------------------------
;; VTables

.align 4

AVT:
	.data 	AM
BVT:
	.data 	BM
CVT:
	.data 	CMain

.align 4
main:
;;; main, set the bump pointer to the beginning of the heap
	 adr    bump, heap      				
	 stu    lr, [sp, #1]    				
	 stu    fp, [sp, #1]    				
	 mov    fp, sp         			  

;;; o = new C          
	 mov    $8, r0   
	 bl     LIBAllocObject   			
	 adr    r1, CVT      

;;; move the vptr into the object
	 str    r1, [r0]               


;;; call the object's main       
	 bl     CMain      


;;;ic_main always returns 0
	 mov    r0, #0                 
	 mov    sp, fp                 
	 ldu    fp, [sp, #1]           
	 swi    #SysHalt

heap:
