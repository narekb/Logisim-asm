.model small
.stack 100H

.386
.data

LIST    DW  "N", 0, 1       ; nand with input values in bit0 and bit1 postions = 1
        DW  "O", 0, 2
        DW  "n", 0
        DW  "X", 3, 4
        DW  "z"             ; end processing     

INTER   DW 10 DUP(?)

.code

PROCESS:
        MOV AX, @DATA
        MOV DS, AX

        MOV SI, [LIST]      ; Address of LIST[0] into SI
        MOV DI, [INTER]     ; Address of INTER[0] into DI
        
        INC SI              
        MOV BX, [SI]        ; Load LIST[0] into BX
        MOV [DI], BX        ; Copy from BX to INTER[0]
        
        INC SI
        MOV BX, [SI]        ; Load LIST[1] into BX
        ADD DI, 2           ; 0 -> 1 
        MOV [DI], BX        ; INTER[1] = BX

        LEA SI, LIST        ; Load back to SI = LIST[0]
        
        
        MOV [DI], 0         ; Initial input, INTER[0] = 0
        MOV [DI+1], 1       ; INTER[1] = 1
        
NEXT:
        MOV CX, [SI]        ; Load current LIST[i] into CX
        
        CMP CX, "N"         ;check for a NAND
        JE CHECK_NAND_INPUT
        CMP CX, "O"
        JE CHECK_OR_INPUT
        CMP CX, "X"
        JE CHECK_XOR_INPUT
        CMP CX, "n"
        JE CHECK_NOT_INPUT
        CMP CX, "z"         ;check for an end signal
        JE EXIT
       
        
CHECK_NAND_INPUT:
        ADD SI, 2
        
        PUSH DI             ; Backup previous INTER index so that output is one in the right place
                            ; ...pop in NAND_OP
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
                            ; Loop to get element of INTER by yndex (received as parameter in LIST)
        PUSH AX             ; Save AX data to stack, pop after all loops
        MOV AX, [SI]        ; Set counter to first parameter
        ADD AX, 3H
        
        CMP AX, 0
        JE skip_loop
        
    inter_loop:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        JG inter_loop
        
    skip_loop:
        
       
        MOV CX, [DI]        ; Move specified element from INTER to CX...
                            ; ...this will be input 1
                            
                            ; Gate inputs should be kept in CX and DX
        
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
        
        ADD SI, 2           ; Move forward one element in LIST
        MOV AX, [SI]        ; Set counter to second parameter
        ADD AX, 3H
        CMP AX, 0
        JE skip_loop2
        
    inter_loop2:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        JG inter_loop2
    skip_loop2:
        
        
        MOV DX, [DI]        ; This will be input 2
        
        POP AX              ; Recover stack data into AX
        
        JMP NAND_BITS
        
        
CHECK_OR_INPUT:
        ADD SI, 2
        
        PUSH DI             ; Backup previous INTER index so that output is one in the right place
                            ; ...pop in OR_OP
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
                            ; Loop to get element of INTER by yndex (received as parameter in LIST)
        PUSH AX             ; Save AX data to stack, pop after all loops
        MOV AX, [SI]        ; Set counter to first parameter
        ADD AX, 3H
        
        CMP AX, 0
        JE skip_loop3
        
    inter_loop3:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        JG inter_loop3
    skip_loop3:
        
       
        MOV CX, [DI]        ; Move specified element from INTER to AX...
                            ; ...this will be input 1
                            
                            ; Gate inputs should be kept in CX and DX
        
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
        
        ADD SI, 2           ; Move forward one element in LIST
        MOV AX, [SI]        ; Set counter to second parameter
        ADD AX, 3H
        CMP AX, 0
        JE skip_loop4
    inter_loop4:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        

        JG inter_loop4
        
    skip_loop4:
        
        MOV DX, [DI]        ; This will be input 2
        
        POP AX              ; Recover stack data into AX
        
        JMP OR_BITS
       
        
CHECK_XOR_INPUT:
        ADD SI, 2
        
        PUSH DI             ; Backup previous INTER index so that output is one in the right place
                            ; ...pop in OR_OP
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
                            ; Loop to get element of INTER by yndex (received as parameter in LIST)
        PUSH AX             ; Save AX data to stack, pop after all loops
        MOV AX, [SI]        ; Set counter to first parameter
        ADD AX, 3H
        
        CMP AX, 0
        JE skip_loop5
        
    inter_loop5:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        JG inter_loop5
        
    skip_loop5: 
        
       
        MOV CX, [DI]        ; Move specified element from INTER to CX...
                            ; ...this will be input 1
                            
                            ; Gate inputs should be kept in CX and DX
        
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
        
        ADD SI, 2           ; Move forward one element in LIST
        MOV AX, [SI]        ; Set counter to second parameter
        ADD AX, 3H
        
        CMP AX, 0
        JE skip_loop6
    inter_loop6:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        JG inter_loop6
    skip_loop6:
        
        MOV DX, [DI]        ; This will be input 2
        
        POP AX              ; Recover stack data into AX
        
        JMP XOR_BITS
        
        
CHECK_NOT_INPUT:
        ADD SI, 2
        
        PUSH DI             ; Backup previous INTER index so that output is one in the right place
                            ; ...pop in OR_OP
        
        MOV DI, [INTER]     ; Reset INTER index (DI) to 0
                            ; Loop to get element of INTER by yndex (received as parameter in LIST)
        PUSH AX             ; Save AX data to stack, pop after all loops
        MOV AX, [SI]        ; Set counter to first parameter
        ADD AX, 3H
        
        CMP AX, 0
        JE skip_loop7
    inter_loop7:
        DEC AX
        ADD DI, 2
        CMP AX, 0
        JG inter_loop7
        
    skip_loop7:
        
       
        MOV CX, [DI]        ; Move specified element from INTER to AX...
                            ; ...this will be input 1
                            
                            ; Gate inputs should be kept in CX and DX
        
        JMP NOT_BITS

        
NAND_BITS:
        AND CX, 00000001B   ; mask off all bits except input bit 0
        AND DX, 00000001B   ; mask off all bits except input bit 1
                            ; now we have the binary value of each bit in BL and CL, in bit 0 location
        AND CX,DX           ; AND these two registers, result in BL
        NOT CX              ; invert bits for the not part of nand
        AND CX, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
        
        PUSH AX             ; Save all the stuff from AX into stack (pop in NAND_OP)
        
        MOV AX, CX          ; copy answer into return value register
        JMP NAND_OP         


NAND_OP:
        POP DI              ; Recover correct index for INTER insertion
                            ; ...pushed during CHECK_NAND_INPUT

        ADD AX, 30H
        ADD DI, 2
        MOV [DI], AX        ;save first interval result in INTER indexed by INDEX
        
        MOV AH, 2           ; code for "write a character"
        MOV DX,[DI]         ; ascii code goes in DL
        INT 21H
        
       
        
        ADD DI, 2
        ADD SI, 2
        POP AX

        JMP NEXT
        
        
OR_BITS:
        AND CX, 00000001B   ; mask off all bits except input bit 0
        AND DX, 00000001B   ; mask off all bits except input bit 1
                            ; now we have the binary value of each bit in BL and CL, in bit 0 location
        OR CX,  DX          ; OR these two registers, result in BL
        AND CX, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
        
        PUSH AX
        MOV AX, CX          ; copy answer into return value register
        JMP OR_OP
        
OR_OP:
        POP DI              ; Recover index for INTER insertion
                            ; ...pushed during CHECK_OR_INPUT

        ADD AX, 30H
        ADD DI, 2
        MOV [DI], AX
        
        MOV AH, 2
        MOV DX, [DI]
        INT 21H
        
        ADD DI, 2
        ADD SI, 2
        POP AX
        
        JMP NEXT
        
        
        
XOR_BITS:
        AND CX, 00000001B   ; mask off all bits except input bit 0
        AND DX, 00000001B   ; mask off all bits except input bit 1
                            ; now we have the binary value of each bit in CX and DX, in bit 0 location
        XOR CX,  DX         ; OR these two registers, result in BL
        AND CX, 00000001B   ; clear all upper bits positions leaving bit 0 either a zero or one 
        
        PUSH AX
        MOV AX, CX          ; copy answer into return value register
        JMP XOR_OP
        
        
XOR_OP:
        POP DI              ; Recover index for INTER insertion
                            ; ...pushed during CHECK_OR_INPUT

        ADD AX, 30H
        ADD DI, 2
        MOV [DI], AX
        
        MOV AH, 2
        MOV DX, [DI]
        INT 21H
        
        ADD DI, 2
        ADD SI, 2
        POP AX
        
        JMP NEXT
        
        
NOT_BITS:
        AND CX, 00000001B
        NOT CX
        
        PUSH AX
        MOV AX, CX
        AND AX, 00000001B
        
        JMP NOT_OP
        

        
NOT_OP:
        POP DI

        ADD AX, 30H
        ADD DI, 2
        MOV [DI], AX
        
        MOV AH, 2
        MOV DX, [DI]
        INT 21H
        
        ADD DI, 2
        ADD SI, 2
        POP AX
        
        JMP NEXT
        
EXIT:
    MOV AH,4CH
    INT 21H
    
    END     PROCESS