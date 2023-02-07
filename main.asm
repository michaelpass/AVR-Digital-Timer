;
; Lab02.asm
;
; Created: 2/7/2023 3:11:50 PM
; Author : stlondon, mpass
;


; Replace with your application code
start:
ldi R16, 0x70 ; load pattern to display
rcall display
display: 
; backup used registers on stack
push R16
push R17
in R17, SREG
push R17
ldi R17, 8 ; loop --> test all 8 bits
