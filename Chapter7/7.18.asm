; should compare same length strings
; in memory ending with x0000 and if equal
; fill R5 <- 1
.ORIG x3000
LD R1, FIRST
LD R2, SECOND
AND R0, R0, #0
LOOP LDR R3, R1, #0 ; (a)
LDR R4, R2, #0
BRz NEXT
ADD R1, R1, #1
ADD R2, R2, #1
NOT R3, R3 ; (b)
ADD R3, R3, #1 ; (c)
ADD R3, R3, R4
BRz LOOP
AND R5, R5, #0
BRnzp DONE
NEXT AND R5, R5, #0
ADD R5, R5, #1
DONE TRAP x25
FIRST .FILL x4000
SECOND .FILL x4100
.END
; as I use here .END and .ORIG
; are used to specify memory
; layout in the object file
; and in final executable image.
; here it result in a program
; decoupled in to sections: data, program
; x4000 and x4100 are containing strings
.ORIG x4000
.STRINGZ "Hello World"
.END
.ORIG x4100
.STRINGZ "Hello Wordd"
.END
