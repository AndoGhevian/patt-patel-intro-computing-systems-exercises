        .ORIG x3000
ONE     LD R0, A
        ADD R1, R1, R0  ; R1 is not initialized to 0,
TWO     LD R0, B        ; so it will give logical error
        ADD R1, R1, R0  ; if there is a garbae inside R1
THREE   LD R0, C        ; before program execution
        ADD R1, R1, R0
        ST R1, SUM
        TRAP x25
A       .FILL x0001
B       .FILL x0002
C       .FILL x0003
D       .FILL x0004 ; Here should be SUM, otherwise assembler
        .END        ; will give error when trying to find its
                    ; corresponding address in symbol table
