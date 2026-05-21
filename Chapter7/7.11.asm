; because of the fact that numbers
; input as 2 digit hex or dec, it means
; with max pow of 16 (10 is smaller) it
; is possible to represent it in 16 bits, so
; will simply count value of input based on base
; and print through binary representation
; ________________________________________________
            .ORIG x3000
            ; R1 <- 2 (digits to read)
            AND R1, R1, #0
            ADD R1, R1, #2
            ; R2 <- 0 (2's complement number)
            AND R2, R2, #0
            ; R3 (base identifier -> 0=#, 1=x,X)
            AND R3, R3, #0
            ; R0 <- input base specifier
            TRAP x20
            TRAP x21
; identify base with R3 0=#, 1=x/X
; ________________________________________________
            ; R4 <- R0 - Mem[HASH]
            LD R4, HASH
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRz ISHASH

            ; R4 <- R0 - Mem[XLOW]
            LD R4, XLOW
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRz ISX

            ; R4 <- R0 - Mem[X]
            LD R4, X
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRz ISX
            BR NOPREF ; End program with invalid prefix message

ISX         ADD R3, R3, #1
            BR ASCIITOBIN

ISHASH      ADD R3, R3, #0
; calculate 2's complement value based on
; input digits.
; __________________________________________
            ; Test R1 = 0 digits count
ASCIITOBIN  ADD R1, R1, #0
            BRz PRINTBIN
            ; check digits range based on
            ; base prefix and exit read loop
            ; if invalid digit encountered.
            ; for appropriate digit range
            ; replace digit with its 2's complement
            TRAP x20
            TRAP x21
            ADD R3, R3, #0
            BRz DECDIGCHK
            ; R4 <- R0 - 'f'
LHEXDIGCHK  LD R4, DIGFLOW
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRp PRINTBIN
            ; R4 <- R0 - 'a'
            LD R4, DIGALOW
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRn HHEXDIGCHK
            ADD R4, R4, #10
            BR ENDDIGCHK
            ; R4 <- R0 - 'F'
HHEXDIGCHK  LD R4, DIGF
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRp PRINTBIN
            ; R4 <- R0 - 'A'
            LD R4, DIGA
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRn DHEXDIGCHK
            ADD R4, R4, #10
            BR ENDDIGCHK
            ; R4 <- R0 - '9'
DHEXDIGCHK  LD R4, DIG9
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRp PRINTBIN
            ; R4 <- R0 - '0'
            LD R4, DIG0
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRn PRINTBIN
            BR ENDDIGCHK
            ; R4 <- R0 - '9'
DECDIGCHK   LD R4, DIG9
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRp PRINTBIN
            ; R4 <- R0 - '0'
            LD R4, DIG0
            NOT R4, R4
            ADD R4, R4, #1
            ADD R4, R0, R4
            BRn PRINTBIN
            ; converted digit 2's complement
            ; here R4 already contain it
ENDDIGCHK   ADD R0, R4, #0
            ; R5 <- 0 (temp sum)
            AND R5, R5, #0
            ; R4 <- init base (10 or 16)
MULPOW      AND R4, R4, #0
            ADD R3, R3, #0
            BRz DECPOW
HEXPOW      ADD R4, R4, #15
            BR  MULPOWLOOP
DECPOW      ADD R4, R4, #9
MULPOWLOOP  ADD R4, R4, #0
            BRn ENDMUL
            ADD R5, R5, R2
            ADD R4, R4, #-1
            BR MULPOWLOOP
ENDMUL      ADD R2, R5, R0 ; add next digit
            ADD R1, R1, #-1
            BR ASCIITOBIN
PRINTBIN    LD R0, LF
            TRAP x21
            LD R1, DIG0
            ; R4 <- 15
            AND R4, R4, #0
            ADD R4, R4, #15
PRINTLOOP   ADD R4, R4, #0
            BRn ENDPRINT
            ADD R2, R2, #0
            BRn PRINT1
PRINT0      ADD R0, R1, #0
            TRAP x21
            BR  PRINTITER
PRINT1      ADD R0, R1, #1
            TRAP x21
PRINTITER   ADD R4, R4, #-1
            ADD R2, R2, R2
            BR  PRINTLOOP
ENDPRINT    TRAP x25
NOPREF      LEA R0, ERRPREFIX
            TRAP x22
            TRAP x25
HASH        .FILL x0023
LF          .FILL x000A
XLOW        .FILL x0078
X           .FILL x0058
DIG0        .FILL x0030
DIG9        .FILL x0039
DIGA        .FILL x0041
DIGF        .FILL x0046
DIGALOW     .FILL x0061
DIGFLOW     .FILL x0066
ERRPREFIX   .STRINGZ "Required to provide valid prefix: dec # or hex x, X\n"
.END
