; Procedure Subtract
SubtractBody
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; i
    LDR     R6, =1
    SUB     R5, R5, R6
    LDR     R2, =0
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
    LDR     R2, =0
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
    LDR     R2, =0
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
    LDR     R2, =0
    LDR     R5, [R4, R2, LSL #2] ; i
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; j
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
; Procedure AddParams
AddParamsBody
    ADD     R2, BP, #16
    LDR     R1, =-5
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; x
    ADD     R2, BP, #16
    LDR     R1, =-6
    ADD     R2, R2, R1, LSL #2
    LDR     R6, [R2]        ; y
    ADD     R5, R5, R6
    ADD     R2, BP, #16
    LDR     R1, =-5
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; x
    MOV     TOP, BP         ; reset top of stack
    LDR     BP, [TOP,#12]   ; and stack base pointers
    LDR     PC, [TOP]       ; return from AddParams
AddParams
    LDR     R0, =1          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       AddParamsBody
;Name: x, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: -5 , Next Address: 0
;Name: y, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: False, Adr: -6 , Next Address: 0
MainBody
    LDR     R5, =100
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; ONEHUNDRED
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L5
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L5
    BL      TastierReadInt
    LDR     R2, =0
    STR     R0, [R4, R2, LSL #2] ; i
    MOVS    R5, #1          ; true
    LDR     R2, =0
    STR     R5, [R4, R2, LSL #2] ; TRUE
    LDR     R5, =0
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; z
L6
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; z
    LDR     R6, =5
    CMP     R5, R6
    MOVLT   R5, #1
    MOVGE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L0              ; jump on condition false
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; z
    LDR     R6, =1
    ADD     R5, R5, R6
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; z
    ADD     R2, BP, #16
    LDR     R1, =0
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; z
    ADD     R2, BP, #16
    LDR     R1, =1
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; w
    B       L6
L0
    LDR     R5, =1
    ADD     R2, BP, #16
    LDR     R1, =5
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; array
    LDR     R5, =2
    ADD     R2, BP, #16
    LDR     R1, =6
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; array
    LDR     R5, =3
    ADD     R2, BP, #16
    LDR     R1, =7
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; array
    LDR     R5, =4
    ADD     R2, BP, #16
    LDR     R1, =8
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; array
    LDR     R5, =5
    ADD     R2, BP, #16
    LDR     R1, =9
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; array
    ADD     R2, BP, #16
    LDR     R1, =5
    ADD     R2, R2, R1, LSL #2
    LDR     R0, [R2]        ; array
    ADD     R2, BP, #16
    LDR     R1, =5
    ADD     R2, R2, R1, LSL #2
    STR     R0, [R2]        ; k
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
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; k
    LDR     R5, =15
L8
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; k
    LDR     R5, =10
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; testVal
    LDR     R5, =5
    ADD     R2, BP, #16
    LDR     R1, =2
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; k
    ADD     TOP, TOP, #8      ; create space for parameters
    LDR     R2, =3
    ADD     R2, R4, R2, LSL #2
    STR     R2, [TOP, #-4]      ; add to stack
    LDR     R2, =2
    ADD     R2, R4, R2, LSL #2
    STR     R2, [TOP, #-8]      ; add to stack
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       AddParams
    LDR     R5, =0
    ADD     R2, BP, #16
    LDR     R1, =4
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; result
    ADD     R2, BP, #16
    LDR     R1, =3
    ADD     R2, R2, R1, LSL #2
    LDR     R5, [R2]        ; testVal
    LDR     R6, =1
    CMP     R6, R5
    MOVEQ   R6, #1
    MOVNE   R6, #0
    MOVS    R6, R6          ; reset Z flag in CPSR
    BEQ     L10              ; jump on condition false
    LDR     R5, =10
    LDR     R6, =1
    SUB     R5, R5, R6
    ADD     R2, BP, #16
    LDR     R1, =4
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; result
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
    ADD     R2, BP, #16
    LDR     R1, =4
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; result
    B       L9
L11
    LDR     R5, =0
    ADD     R2, BP, #16
    LDR     R1, =4
    ADD     R2, R2, R1, LSL #2
    STR     R5, [R2]        ; result
L9
L12
    LDR     R2, =0
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
    LDR     R2, =0
    STR     R0, [R4, R2, LSL #2] ; i
    B       L12
L13
StopTest
    B       StopTest
Main
    LDR     R0, =1          ; current lexic level
    LDR     R1, =6          ; number of local variables
    BL      enter           ; build new stack frame
    B       MainBody
;Name: ONEHUNDRED, Type: integer, Kind: constant, Sub-Category: Scalar, Level: local, Init: True, Adr: 0 , Next Address: 0
;Name: z, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 0 , Next Address: 0
;Name: w, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 1 , Next Address: 0
;Name: k, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 2 , Next Address: 0
;Name: testVal, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 3 , Next Address: 0
;Name: result, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, Adr: 4 , Next Address: 0
;Name: array, Type: integer, Kind: var, Sub-Category: Array, Level: local, Init: True, Adr: 5 , Next Address: 5
;Name: TRUE, Type: boolean, Kind: constant, Sub-Category: Scalar, Level: global, Init: True, Adr: 0 , Next Address: 0
;Name: i, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, Adr: 0 , Next Address: 0
;Name: SumUp, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, Adr: 0 , Next Address: 0
;Name: AddParams, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, Adr: 0 , Next Address: 0
;Name: main, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, Adr: 0 , Next Address: 0
