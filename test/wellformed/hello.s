# File test/wellformed/hello.s

.requ	bump, r3
	     b	 main
;; ----------------------------
;; VTables

.align 4

HelloVT:
	.data 	HelloMain