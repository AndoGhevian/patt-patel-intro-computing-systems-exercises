; opcodes should be UpperCase
                .ORIG x3000
                ; read maximum INPUTLEN characters
                ; ignoring space and tabs until
                ; length is fulfilled or lf read
                LD R1, INPUTLEN
                LD R2, INPUT
READOP          TRAP x20
                ; do not count space, tab
                LD R4, SPACE
                NOT R4, R4
                ADD R4, R4, #1
                ADD R4, R0, R4
                BRz NEXTREAD
                LD R4, TAB
                NOT R4, R4
                ADD R4, R4, #1
                ADD R4, R0, R4
                BRz NEXTREAD
                ; If lf do not adjust input address,
                ; and finish the loop
                TRAP x21
                STR R0, R2, #0
                LD R4, LF
                NOT R4, R4
                ADD R4, R4, #1
                ADD R4, R0, R4
                BRz ENDREADOP
                ; adjust next input address and remaining length,
                ; continue loop If length not exhausted
                ADD R2, R2, #1
                ADD R1, R1, #-1
NEXTREAD        ADD R1, R1, #0
                BRz ENDREADOP
                BRnzp READOP
                ; append nul
ENDREADOP       AND R0, R0, #0
                STR R0, R2, #0

                ; if all available words filled,
                ; print new line
                ADD R1, R1, #0
                BRz PRINTLF
                BRnzp SEARCH
PRINTLF         LD R0, LF
                TRAP x21

; PRINTOP         LD R0, INPUT
;                 TRAP x22

SEARCH          LEA R1, OPS         ; memory location of opcode address
                LDR R5, R1, #0      ; opcode address
                LD R2, INPUT        ; input address

SEARCHLOOP      LDR R3, R5, #0      ; opcode character
                LDR R4, R2, #0      ; input character
                NOT R4, R4
                ADD R4, R4, #1
                ADD R4, R3, R4      ; subtract input-char from op-char
                BRz CHKENDSTR
                ADD R1, R1, #1     ; If chars not equal, point to next op
                LDR R5, R1, #0
                LD R2, INPUT
                BR NEXTLOOP
                ; if chars equal
CHKENDSTR       ADD R3, R3, #0
                BRnp NEXTCHAR       ; If chars equal but not nul, point to next char
                BR ENDSEARCHLOOP    ; break: If chars equal and nul => found
NEXTCHAR        ADD R5, R5, #1
                ADD R2, R2, #1
                BR SEARCHLOOP       ; loop again
NEXTLOOP        ADD R5, R5, #0
                BRz ENDSEARCHLOOP   ; break: If opcode address = x0000 => not found
                BR SEARCHLOOP       ; loop again
                ; R1 contains memory location of opcode address or x0000
ENDSEARCHLOOP   LDR R2, R1, #0
                BRz NOTFOUNDERR     ; if Mem[R1] = x0000, not found
                LEA R2, OPS
                NOT R2, R2
                ADD R2, R2, #1
                ADD R1, R1, R2      ; index of opcode
                LEA R0, BINOPS
BINOPADDRLOOP   ADD R1, R1, #0
                BRz PRINTOP
                ADD R0, R0, #5
                ADD R1, R1, #-1
                BR BINOPADDRLOOP
PRINTOP         TRAP x22
                TRAP x25
NOTFOUNDERR     LD R0, NOTFOUNDMSG
                TRAP x22
                TRAP x25            ; HALT


INPUT           .FILL x4200         ; input storage address
INPUTLEN        .FILL x0010         ; the maximum available words number 50
                                    ; See INPUTSTORAGE

SPACE           .FILL x0020
TAB             .FILL x0009
LF              .FILL x000A

OPS             .FILL x4000         ; 17 assembly opcode addresses
                .FILL x4015
                .FILL x4023
                .FILL x4037
                .FILL x4049
                .FILL x4051
                .FILL x4064
                .FILL x4074
                .FILL x4089
                .FILL x4092
                .FILL x40A5
                .FILL x40B6
                .FILL x40C0
                .FILL x40D1
                .FILL x40E5
                .FILL x40F8
                .FILL x4100
                .FILL x0000         ; address list terminator
NOTFOUNDMSG     .FILL x4300
BINOPS          .STRINGZ "0001"     ; ADD: binary opcodes list corresponding
                                    ; to assembly opcodes list, each 4 word long
                                    ; (LC-3 memory is word addressable)
                .STRINGZ "0101"     ; AND
                .STRINGZ "0000"     ; BR
                .STRINGZ "1100"     ; JMP
                .STRINGZ "0100"     ; JSR
                .STRINGZ "0100"     ; JSRR
                .STRINGZ "0010"     ; LD
                .STRINGZ "1010"     ; LDI
                .STRINGZ "0110"     ; LDR
                .STRINGZ "1110"     ; LEA
                .STRINGZ "1001"     ; NOT
                .STRINGZ "1100"     ; RET
                .STRINGZ "1000"     ; RTI
                .STRINGZ "0011"     ; ST
                .STRINGZ "1011"     ; STI
                .STRINGZ "0111"     ; STR
                .STRINGZ "1111"     ; TRAP

                .END
                .ORIG x4000         ; assembly language opcodes list
                .STRINGZ "ADD"
                .END
                .ORIG x4015
                .STRINGZ "AND"
                .END
                .ORIG x4023
                .STRINGZ "BR"
                .END
                .ORIG x4037
                .STRINGZ "JMP"
                .END
                .ORIG x4049
                .STRINGZ "JSR"
                .END
                .ORIG x4051
                .STRINGZ "JSRR"
                .END
                .ORIG x4064
                .STRINGZ "LD"
                .END
                .ORIG x4074
                .STRINGZ "LDI"
                .END
                .ORIG x4089
                .STRINGZ "LDR"
                .END
                .ORIG x4092
                .STRINGZ "LEA"
                .END
                .ORIG x40A5
                .STRINGZ "NOT"
                .END
                .ORIG x40B6
                .STRINGZ "RET"
                .END
                .ORIG x40C0
                .STRINGZ "RTI"
                .END
                .ORIG x40D1
                .STRINGZ "ST"
                .END
                .ORIG x40E5
                .STRINGZ "STI"
                .END
                .ORIG x40F8
                .STRINGZ "STR"
                .END
                .ORIG x4100
                .STRINGZ "TRAP"
                .END
                ; input storage
                .ORIG x4200
INPUTSTORAGE    .BLKW #51       ; make sure maximum expected
                                ; words number is greater than
                                ; input length in ASCII characters
                .END
                .ORIG x4300
                ; not found error message
                .STRINGZ "Invalid Assembly Opcode\n"
                .END
