            .ORIG x3000
            ; .EXTERNAL INIT

            JSR INIT
            LD R0,A
            LD R1,B
X           NOT R2, R0      ; (a)
            ADD R2, R2, #1  ; (b)
            ADD R2,R2,R1
            BRz DONE        ; (c)
            ADD R1,R1,#-1
            ADD R0, R0, #1 ; (d)
            BRnzp X
DONE        ST R1,C
TRAP        x25
A           .BLKW 1
B           .BLKW 1
C           .BLKW 1
            .END



            .ORIG x2FF0
            ; .EXTERNAL A
            ; .EXTERNAL B

            ; init A
INIT        AND R0, R0, #0
            ADD R0, R0, #4
            ST R0, A
            ; init B
            AND R0, R0, #0
            ADD R0, R0, #8
            ST R0, B
            ret
            .END
