.ORIG x3000
; result
AND R1, R1, #0

; bit mask
AND R2, R2, #0
ADD R2, R2, #1

; loop counter
AND R3, R3, #0
ADD R3, R3, #15
ADD R3, R3, #1
; bit calculation loop
LOOP BRz DONE
AND R4, R0, R2
BRz DONOTHING
ADD R1, R1, #1
DONOTHING ADD R1, R1, #0
; Shift Left bit mask
ADD R2, R2, R2
ADD R3, R3, #-1
BRnzp LOOP

DONE TRAP x25
.END
