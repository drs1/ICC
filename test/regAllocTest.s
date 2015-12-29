# File test/regAllocTest.s


.globl __ic_main
# ----------------------------
# VTables

.data
.align 8

_RegAllocTest_VT:
	.quad _RegAllocTest_main
.quad 0


.text
_RegAllocTest_main:
	# ----- prologue ------
	pushq %rbp
	movq %rsp, %rbp
	subq $72, %rsp

	# ---- method instructions ------
    # Entry                                       # 
    # Entry                                       # 
    # Exit                                        # 
    # Exit                                        # 
    # TAC_Preamble(List(args),2)                  # 
    # Fake Def of all callee save registers       # 
       movq %r12, %r15                            # movq %r12, _vr1
       movq %r13, %r8                             # movq %r13, _vr2
       movq %r14, %r11                            # movq %r14, _vr3
       movq %r11, -72(%rbp)                       # movq _vr3, -72(%rbp)
       movq %r15, %rcx                            # movq %r15, _vr4
       movq %rbx, %r13                            # movq %rbx, _vr5
       movq 16(%rbp), %rbx                        # movq 16(%rbp), this
       movq 24(%rbp), %rbx                        # movq 24(%rbp), args
    # b = 5                                       # 
       movq $5, %rbx                              # movq $5, b
    # a = 4                                       # 
       movq $4, %r10                              # movq $4, a
    # k = 3                                       # 
       movq $3, %r11                              # movq $3, k
    # j = 2                                       # 
       movq $2, %r14                              # movq $2, j
    # i = 1                                       # 
       movq $1, %r12                              # movq $1, i
       movq %r12, -64(%rbp)                       # movq i, -64(%rbp)
    # t3 = i + j                                  # 
       movq -64(%rbp), %r12                       # movq -64(%rbp), i
    # Redundant Move: movq i, _tt3 on %r12        # 
       addq %r14, %r12                            # addq j, _tt3
    # t2 = t3 + k                                 # 
    # Redundant Move: movq _tt3, _tt2 on %r12     # 
       addq %r11, %r12                            # addq k, _tt2
    # t1 = t2 + a                                 # 
    # Redundant Move: movq _tt2, _tt1 on %r12     # 
       addq %r10, %r12                            # addq a, _tt1
    # t0 = t1 + b                                 # 
    # Redundant Move: movq _tt1, _tt0 on %r12     # 
       addq %rbx, %r12                            # addq b, _tt0
    # ijk = t0                                    # 
       movq %r12, %rbx                            # movq _tt0, ijk
    # Library.printi(ijk)                         # 
       movq %rbx, %rdi                            # movq ijk, %rdi
       call __LIB_printi                          # call __LIB_printi
    # return                                      # 
       movq %r15, %r12                            # movq _vr1, %r12
       movq %r8, %r13                             # movq _vr2, %r13
       movq -72(%rbp), %r11                       # movq -72(%rbp), _vr3
       movq %r11, %r14                            # movq _vr3, %r14
       movq %rcx, %r15                            # movq _vr4, %r15
       movq %r13, %rbx                            # movq _vr5, %rbx
    # Fake Use of all callee save registers       # 
       movq %rbp, %rsp                            # movq %rbp, %rsp
       popq %rbp                                  # popq %rbp
       ret                                        # ret

epilogue_RegAllocTest_main:
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

       movq $8, %rdi                 # o = new RegAllocTest

       call __LIB_allocateObject   
       leaq _RegAllocTest_VT(%rip), %rdi       

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




