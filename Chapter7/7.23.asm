; R5=1 if palindrome 0 otherwise (tested on simulator)
            .ORIG x3000
            LD R0, PTR
            ADD R1, R0, #0
AGAIN       LDR R2, R1, #0
            BRz CONT
            ADD R1, R1, #1
            BRnzp AGAIN
CONT        ADD R1, R1, #-1     ; (a)
LOOP        LDR R3, R0, #0
            LDR R4, R1, #0      ; (b)
            NOT R4, R4
            ADD R4, R4, #1
            ADD R3, R3, R4
            BRnp NO
            ADD R0, R0, #1      ; (c)
            ADD R1, R1, #-1     ; (d)
            NOT R2, R0
            ADD R2, R2, #1
            ADD R2, R1, R2
            BRnz YES
            BRnzp LOOP          ; (e)
YES         AND R5, R5, #0
            ADD R5, R5, #1
            BRnzp DONE
NO          AND R5, R5, #0
DONE        HALT
PTR         .FILL x4000
.END
