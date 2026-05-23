                .ORIG x3000
                ; read maximum INPUTLEN characters
                ; ignoring space and tabs until
                ; length is fulfilled or lf read
                LD R1, INPUTLEN
                LD R2, INPUT
READOP          TRAP x20
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
                TRAP x21
                STR R0, R2, #0
                LD R4, LF
                NOT R4, R4
                ADD R4, R4, #1
                ADD R4, R0, R4
                BRz ENDREADOP
                ; adjust next input address and remaining length
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
                BRz NEWLINE
                BRnzp PRINTOP
NEWLINE         LD R0, LF
                TRAP x21
                ; ________________________________
                ; replace this code with opcode
                ; comparison loop
                ; work in progress....
                ; _______________________________
PRINTOP         LD R0, INPUT
                TRAP x22
                ; program here
INPUT           .FILL x4200         ; input storage address
INPUTLEN        .FILL x0002         ; the maximum available words number 50
SPACE           .FILL x0020
TAB             .FILL x0009
LF              .FILL x000A
OPS             .FILL x4000         ; 17 assembly opcode addresses
                .FILL x4010
                .FILL x4020
                .FILL x4030
                .FILL x4040
                .FILL x4050
                .FILL x4060
                .FILL x4070
                .FILL x4080
                .FILL x4090
                .FILL x40A0
                .FILL x40B0
                .FILL x40C0
                .FILL x40D0
                .FILL x40E0
                .FILL x40F0
                .FILL x4100
BINOPS          .STRINGZ "0001"     ; ADD: binary opcodes list corresponding
                                    ; to assembly opcodes list
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
                .ORIG x4010
                .STRINGZ "AND"
                .END
                .ORIG x4020
                .STRINGZ "BR"
                .END
                .ORIG x4030
                .STRINGZ "JMP"
                .END
                .ORIG x4040
                .STRINGZ "JSR"
                .END
                .ORIG x4050
                .STRINGZ "JSRR"
                .END
                .ORIG x4060
                .STRINGZ "LD"
                .END
                .ORIG x4070
                .STRINGZ "LDI"
                .END
                .ORIG x4080
                .STRINGZ "LDR"
                .END
                .ORIG x4090
                .STRINGZ "LEA"
                .END
                .ORIG x40A0
                .STRINGZ "NOT"
                .END
                .ORIG x40B0
                .STRINGZ "RET"
                .END
                .ORIG x40C0
                .STRINGZ "RTI"
                .END
                .ORIG x40D0
                .STRINGZ "ST"
                .END
                .ORIG x40E0
                .STRINGZ "STI"
                .END
                .ORIG x40F0
                .STRINGZ "STR"
                .END
                .ORIG x4100
                .STRINGZ "TRAP"
                .END
                ; input storage
                .ORIG x4200
                .BLKW #51       ; make sure maximum expected
                                ; words number is greater than
                                ; input length in ASCII characters
                .END