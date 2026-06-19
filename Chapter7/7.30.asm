; circular stack x3FFF -> 3FFB
            .ORIG x3000
            AND R2, R2, #0
            AND R1, R1, #0
            ADD R1, R1, #8
PUSHNUMBERS BRz ENDPRG
            ADD R2, R2, #1
            ADD R0, R2, #0
            JSR PUSH
            ADD R1, R1, #-1
            BRnzp PUSHNUMBERS
ENDPRG      HALT

; non volatile register R1 (program saved register)
; volatile R0, R5, R6
PUSH        ST  R1, SAVER
            LD  R1, NEGFULL
            ADD R1, R6, R1
            BRp SKIP        ; (a)
            LD  R6, BASE
SKIP        ADD R6, R6, #-1
            LD  R1, MINUS5
            ADD R1, R5, R1
            BRz END
            ADD R5, R5, #1  ; (b)
END         STR R0, R6, #0  ; (c)
            LD  R1, SAVER   ; (d)
            RET
NEGFULL     .FILL xC005     ; x-3FFB
MINUS5      .FILL xFFFB     ; #-5
BASE        .FILL x4000
SAVER       .BLKW #1
.END
