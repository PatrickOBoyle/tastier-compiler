	AREA	TastierProject, CODE, READONLY

    IMPORT  TastierDiv
	IMPORT	TastierMod
	IMPORT	TastierReadInt
	IMPORT	TastierPrintInt
	IMPORT	TastierPrintIntLf
	IMPORT	TastierPrintTrue
	IMPORT	TastierPrintTrueLf
	IMPORT	TastierPrintFalse
    IMPORT	TastierPrintFalseLf
    IMPORT  TastierPrintString
    
; Entry point called from C runtime __main
	EXPORT	main

; Preserve 8-byte stack alignment for external routines
	PRESERVE8

; Register names
BP  RN 10	; pointer to stack base
TOP RN 11	; pointer to top of stack

main
; Initialization
	LDR		R4, =globals
	LDR 	BP, =stack		; address of stack base
	LDR 	TOP, =stack+16	; address of top of stack frame
	B		Main
; Procedure Subtract
SubtractBody
    LDR     R2, =6
    LDR     R5, [R4, R2, LSL #2] ; i
    LDR     R6, =1
    SUB     R5, R5, R6
    LDR     R2, =6
    STR     R5, [R4, R2, LSL #2] ; i
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from Subtract
Subtract
    LDR     R0, =2          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       SubtractBody
; Procedure Add
AddBody
    LDR     R2, =6
    LDR     R5, [R4, R2, LSL #2] ; i
    LDR     R6, =0
    CMP     R5, R6
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L1              ; jump on condition false
    MOV     R2, BP          ; load current base pointer
    LDR     R2, [R2,#8]
    ADD     R2, R2, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; sum
    LDR     R2, =6
    LDR     R6, [R4, R2, LSL #2] ; i
    ADD     R5, R5, R6
    MOV     R2, BP          ; load current base pointer
    LDR     R2, [R2,#8]
    ADD     R2, R2, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; sum
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Subtract
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Add
    B       L2
L1
L2
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from Add
Add
    LDR     R0, =2          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       AddBody
; Procedure SumUp
SumUpBody
    LDR     R2, =6
    LDR     R5, [R4, R2, LSL #2] ; i
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; j
    LDR     R5, =1
    LDR     R2, =3
    STR     R5, [R4, R2, LSL #2] ; array
    LDR     R5, =2
    LDR     R2, =4
    STR     R5, [R4, R2, LSL #2] ; array
    LDR     R5, =3
    LDR     R2, =5
    STR     R5, [R4, R2, LSL #2] ; array
    LDR     R5, =4
    LDR     R2, =6
    STR     R5, [R4, R2, LSL #2] ; array
    LDR     R5, =5
    LDR     R2, =7
    STR     R5, [R4, R2, LSL #2] ; array
    LDR     R2, =3
    LDR     R0, [R4, R2, LSL #2] ; array
    LDR     R2, =3
    STR     R0, [R4, R2, LSL #2] ; k
    LDR     R5, =0
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; sum
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Add
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L3
    DCB     "The sum of the values from 1 to ", 0
    ALIGN
L3
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; j
    MOV     R0, R5
    BL      TastierPrintInt
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L4
    DCB     " is ", 0
    ALIGN
L4
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; sum
    MOV     R0, R5
    BL      TastierPrintIntLf
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from SumUp
SumUp
    LDR     R0, =1          ; current lexic level
    LDR     R1, =3          ; number of local variables
    BL      enter           ; build new stack frame
    B       SumUpBody
;Name: j, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 0 , Next Address: 0
;Name: sum, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 1 , Next Address: 0
;Name: p, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: False, Adr: 2 , Next Address: 0
;Name: Subtract, Type: undef, Kind: proc, Sub-Category: Scalar, Level: local, Init: False, Adr: 0 , Next Address: 0
;Name: Add, Type: undef, Kind: proc, Sub-Category: Scalar, Level: local, Init: False, Adr: 0 , Next Address: 0
; Procedure cyka
cykaBody
    ADD     R2, BP, #16
    LDR     R1, =-5
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; tester
    LDR     R6, =1
    ADD     R5, R5, R6
    ADD     R2, BP, #16
    LDR     R1, =-5
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; tester
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from cyka
cyka
    LDR     R0, =1          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       cykaBody
;Name: tester, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: -5 , Next Address: 0
;Name: testerq, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: False, Adr: -6 , Next Address: 0
MainBody
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L5
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L5
    BL      TastierReadInt
    LDR     R2, =6
    STR     R0, [R4, R2, LSL #2] ; i
    LDR     R5, =0
    LDR     R2, =1
    STR     R5, [R4, R2, LSL #2] ; z
L6
    LDR     R2, =1
    LDR     R5, [R4, R2, LSL #2] ; z
    LDR     R6, =5
    CMP     R5, R6
    MOVLT   R5, #1
    MOVGE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L0              ; jump on condition false
    LDR     R2, =1
    LDR     R5, [R4, R2, LSL #2] ; z
    LDR     R6, =1
    ADD     R5, R5, R6
    LDR     R2, =1
    STR     R5, [R4, R2, LSL #2] ; z
    LDR     R2, =1
    LDR     R5, [R4, R2, LSL #2] ; z
    LDR     R2, =2
    STR     R5, [R4, R2, LSL #2] ; w
    B       L6
L0
    LDR     R5, =1
    LDR     R6, =2
    CMP     R5, R6
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L7              ; jump on condition false
    LDR     R5, =5
    B       L8
L7
    LDR     R2, =0
    STR     R5, [R4, R2, LSL #2] ; k
    LDR     R5, =15
L8
    LDR     R2, =0
    STR     R5, [R4, R2, LSL #2] ; k
    LDR     R5, =10
    LDR     R2, =4
    STR     R5, [R4, R2, LSL #2] ; testVal
    ADD     TOP, TOP, #8      ; create space for parameters
    LDR     R2, =4
    ADD     R2, R4, R2, LSL #2
    STR     R2, [TOP, #-4]      ; add to stack
    LDR     R2, =4
    STR     R2, [TOP, #-8]      ; add to stack
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       cyka
    LDR     R5, =0
    LDR     R2, =5
    STR     R5, [R4, R2, LSL #2] ; result
    LDR     R2, =4
    LDR     R5, [R4, R2, LSL #2] ; testVal
    LDR     R6, =1
    CMP     R6, R5
    MOVEQ   R6, #1
    MOVNE   R6, #0
    MOVS    R6, R6          ; reset Z flag in CPSR
    BEQ     L10              ; jump on condition false
    LDR     R5, =10
    LDR     R6, =1
    SUB     R5, R5, R6
    LDR     R2, =5
    STR     R5, [R4, R2, LSL #2] ; result
    B       L9
L10
    LDR     R6, =5
    CMP     R6, R5
    MOVEQ   R6, #1
    MOVNE   R6, #0
    MOVS    R6, R6          ; reset Z flag in CPSR
    BEQ     L11              ; jump on condition false
    LDR     R5, =10
    LDR     R6, =5
    SUB     R5, R5, R6
    LDR     R2, =5
    STR     R5, [R4, R2, LSL #2] ; result
    B       L9
L11
    LDR     R5, =0
    LDR     R2, =5
    STR     R5, [R4, R2, LSL #2] ; result
L9
L12
    LDR     R2, =6
    LDR     R5, [R4, R2, LSL #2] ; i
    LDR     R6, =0
    CMP     R5, R6
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L13              ; jump on condition false
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       SumUp
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L14
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L14
    BL      TastierReadInt
    LDR     R2, =6
    STR     R0, [R4, R2, LSL #2] ; i
    B       L12
L13
StopTest
    B       StopTest
Main
    LDR     R0, =1          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       MainBody
;Name: k, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 0 , Next Address: 0
;Name: z, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 1 , Next Address: 0
;Name: w, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 2 , Next Address: 0
;Name: array, Type: integer, Kind: var, Sub-Category: Array, Level: global, Init: True, Adr: 3 , Next Address: 5
;Name: testVal, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 4 , Next Address: 0
;Name: result, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 5 , Next Address: 0
;Name: i, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 6 , Next Address: 0
;Name: SumUp, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, Adr: 0 , Next Address: 0
;Name: cyka, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, Adr: 0 , Next Address: 0
;Name: main, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, Adr: 0 , Next Address: 0

; Subroutine enter
; Construct stack frame for procedure
; Input: R0 - lexic level (LL)
;		 R1 - number of local variables
; Output: new stack frame

enter
	STR		R0, [TOP,#4]			; set lexic level
	STR		BP, [TOP,#12]			; and dynamic link
	; if called procedure is at the same lexic level as
	; calling procedure then its static link is a copy of
	; the calling procedure's static link, otherwise called
 	; procedure's static link is a copy of the static link 
	; found LL delta levels down the static link chain
    LDR		R2, [BP,#4]				; check if called LL (R0) and
	SUBS	R0, R2					; calling LL (R2) are the same
	BGT		enter1
	LDR		R0, [BP,#8]				; store calling procedure's static
	STR		R0, [TOP,#8]			; link in called procedure's frame
	B		enter2
enter1
	MOV		R3, BP					; load current base pointer
	SUBS	R0, R0, #1				; and step down static link chain
    BEQ     enter2-4                ; until LL delta has been reduced
	LDR		R3, [R3,#8]				; to zero
	B		enter1+4				;
	STR		R3, [TOP,#8]			; store computed static link
enter2
	MOV		BP, TOP					; reset base and top registers to
	ADD		TOP, TOP, #16			; point to new stack frame adding
	ADD		TOP, TOP, R1, LSL #2	; four bytes per local variable
	BX		LR						; return
	
	AREA	Memory, DATA, READWRITE
globals     SPACE 4096
stack      	SPACE 16384

	END