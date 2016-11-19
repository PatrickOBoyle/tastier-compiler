; Procedure Subtract
SubtractBody
    LDR     R0, =4
    LDR     R5, [R4, R0, LSL #2] ; i
    LDR     R6, =1
    SUB     R5, R5, R6
    LDR     R0, =4
    STR     R5, [R4, R0, LSL #2] ; i
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
    LDR     R0, =4
    LDR     R5, [R4, R0, LSL #2] ; i
    LDR     R6, =0
    CMP     R5, R6
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L1              ; jump on condition false
    MOV     R0, BP          ; load current base pointer
    LDR     R0, [R0,#8]
    ADD     R0, R0, #16
    LDR     R1, =1
    LDR     R5, [R0, R1, LSL #2] ; sum
    LDR     R0, =4
    LDR     R6, [R4, R0, LSL #2] ; i
    ADD     R5, R5, R6
    MOV     R0, BP          ; load current base pointer
    LDR     R0, [R0,#8]
    ADD     R0, R0, #16
    LDR     R1, =1
    STR     R5, [R0, R1, LSL #2] ; sum
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
    LDR     R5, =1
    LDR     R6, =2
    CMP     R5, R6
    MOVLT   R5, #1
    MOVGE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L3              ; jump on condition false
    LDR     R5, =5
    B       L4
L3
    STR     R5, [BP,#16]    ; j
    LDR     R5, =15
L4
    STR     R5, [BP,#16]    ; j
    LDR     R0, =4
    LDR     R5, [R4, R0, LSL #2] ; i
    STR     R5, [BP,#16]    ; j
    LDR     R5, =1
    STR     R5, [R4]        ; array
    LDR     R5, =2
    LDR     R0, =1
    STR     R5, [R4, R0, LSL #2] ; array
    LDR     R5, =3
    LDR     R0, =2
    STR     R5, [R4, R0, LSL #2] ; array
    LDR     R5, =4
    LDR     R0, =3
    STR     R5, [R4, R0, LSL #2] ; array
    LDR     R5, =5
    LDR     R0, =4
    STR     R5, [R4, R0, LSL #2] ; array
    LDR     R0, [R4]        ; array
    LDR     R0, =4
    STR     R0, [R4, R0, LSL #2] ; k
    LDR     R5, =0
    ADD     R0, BP, #16
    LDR     R1, =1
    STR     R5, [R0, R1, LSL #2] ; sum
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       Add
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L5
    DCB     "The sum of the values from 1 to ", 0
    ALIGN
L5
    LDR     R5, [BP,#16]    ; j
    MOV     R0, R5
    BL      TastierPrintInt
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L6
    DCB     " is ", 0
    ALIGN
L6
    ADD     R0, BP, #16
    LDR     R1, =1
    LDR     R5, [R0, R1, LSL #2] ; sum
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
;Name: j, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, , Next Address: 0
;Name: sum, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: True, , Next Address: 0
;Name: p, Type: integer, Kind: var, Sub-Category: Scalar, Level: local, Init: False, , Next Address: 0
;Name: Subtract, Type: undef, Kind: proc, Sub-Category: Scalar, Level: local, Init: False, , Next Address: 0
;Name: Add, Type: undef, Kind: proc, Sub-Category: Scalar, Level: local, Init: False, , Next Address: 0
MainBody
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L7
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L7
    BL      TastierReadInt
    LDR     R0, =4
    STR     R0, [R4, R0, LSL #2] ; i
L8
    LDR     R0, =4
    LDR     R5, [R4, R0, LSL #2] ; i
    LDR     R6, =0
    CMP     R5, R6
    MOVGT   R5, #1
    MOVLE   R5, #0
    MOVS    R5, R5          ; reset Z flag in CPSR
    BEQ     L9              ; jump on condition false
    ADD     R0, PC, #4      ; store return address
    STR     R0, [TOP]       ; in new stack frame
    B       SumUp
    ADD     R0, PC, #4      ; string address
    BL      TastierPrintString
    B       L10
    DCB     "Enter value for i (or 0 to stop): ", 0
    ALIGN
L10
    BL      TastierReadInt
    LDR     R0, =4
    STR     R0, [R4, R0, LSL #2] ; i
    B       L8
L9
StopTest
    B       StopTest
Main
    LDR     R0, =1          ; current lexic level
    LDR     R1, =0          ; number of local variables
    BL      enter           ; build new stack frame
    B       MainBody
;Name: array, Type: integer, Kind: var, Sub-Category: Array, Level: global, Init: True, , Next Address: 5
;Name: k, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, , Next Address: 0
;Name: z, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: False, , Next Address: 0
;Name: w, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: False, , Next Address: 0
;Name: i, Type: integer, Kind: var, Sub-Category: Scalar, Level: global, Init: True, , Next Address: 0
;Name: SumUp, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, , Next Address: 0
;Name: main, Type: undef, Kind: proc, Sub-Category: Scalar, Level: global, Init: False, , Next Address: 0
