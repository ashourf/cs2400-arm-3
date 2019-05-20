		;		ARM Programming Assignment #3: 32 bit IEEE 754 single-precision multiplier
		;
		;		Write a 32-bit floating point multiplier. The numbers will be represented
		;		in the single-precision IEEE 754 floating-point standard. The result should
		;		also be in IEEE 754 binary32. Assume you only have normalized numbers, i.e.
		;		the exponent is never 0b00000000.
		;		Write the result in the provided "fill" word.
		
		;		Your code here
		
floats	DCD		0xa0bcff0d, 0x13c0adea
result	FILL		8
need		DCD		0x10000 ; for 32 bit mul
masks	DCD		0x0000ffff , 0xffff0000 ; for 32 bit mul
		
		;load	floats address into memory
		ADR		r0 , floats
		;load	numbers
		LDR		r1, [r0]
		LDR		r2, [r0,#4]
		;extract	exponents
		MOV		r3, r1, lsl #8
		MOV		r4, r2, lsl #8
		MOV		r3, r3, lsr #8
		MOV		r4, r4, lsr #8
		;store	floating points on stack for later
		STR		r1, [sp, #4] ; 0xa0bcff0d
		STR		r2, [sp, #8] ;0x13c0adea
		;store	fractions for later on stack
		STR		r3, [sp, #16]
		STR		r4, [sp, #20]
		MOV		r1, #0 ; return register to default state before mul subroutine
		MOV		r2, #0 ; return register to default state before mul subroutine
mul32
		
		
		ADR		r0, masks ;get masks
		LDR		r1, [r0], #4 ; load mask 0x0000ffff
		LDR		r2, [r0] ; load mask 0xffff0000
		AND		r5, r3, r1 ; get bottom half of multipicand
		AND		r3, r3, r2 ; get top half of multipicand
		AND		r6, r4, r1 ; get bottom half of multiplier
		AND		r4, r4, r2 ; get top half of multiplier
		MOV		r1, r3, lsr #16  ; put top half of multipcand in the right place
		MOV		r2, r4 , lsr #16   ; put top half of multipiler in right place
		MOV		r3, r5
		MOV		r4, r6
		MOV		r5, #0
		MOV		r6, #0
		
		
		
		
main
		MOV		r7 , r1 ; move top multipler into generic register
		MOV		r8, r2 ; move top multicand into generic register
mul1
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r9, r9,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul1
		
		MOV		r7 , r4 ;move bottom multiplier into generic register
		MOV		r8, r1 ; move top multicand into generic register
mul2
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r5, r5,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul2
		
		MOV		r7 , r2 ; move bottom multiplicand into generic register
		MOV		r8, r3 ;top multipler into generic register
mul3
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r6, r6,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul3
		
		MOV		r7 , r4 ; move bottom multipcand into generic register
		MOV		r8, r3 ; move top multicand into generic register
mul4
		TST		r7, #1 ; check least siginfcant bit of  generic multiplier
		ADDNE	r11, r11,r8 ; if 1 add multpicand to result
		ADDCS	r10,r10, #1 ; add if carry
		MOV		r8, r8 , lsl #1 ;bit shift multpicand left by 1 bit
		MOV		r7, r7, lsr #1 ;bit shift multiper right by 1 bit
		CMP		r7, #0 ; stop at N
		BNE		mul4
product
		ADR		r7, need
		LDR		r7, [r7]
		
		
		ADDS		r5, r5, r6
		MOV		r12, r5, lsl #16
		MOV		r5, r5, lsr #16
		ADDCS	r9,  r9, r7
		ADDS		r11, r11, r12
		ADC		r9, r9 , r5
		MOV		r0, r11  ; mov results to easier to track registers
		MOV		r1, r9 ; mov results to easier to track registers
		
		;load	original numbers from the stack
		LDR		r3, [sp, #4]
		LDR		r4, [sp, #8]
		;isolate	exponents
		MOV		r5, r3, lsr #23
		MOV		r6, r4, lsr #23
		;add		exponents
		ADD		r5,r5, r6
		;subtract	bias
		SUB		r5, r5, #127
		
		
		
		
		
		
		
		
		
		
		
