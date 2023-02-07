;
; Lab02.asm
;
; Created: 2/7/2023 3:11:50 PM
; Author : stlondon, mpass
;


; Replace with your application code

sbi DDRB,0
sbi DDRB,1
sbi DDRB,2

start:
;0 = 3F
;1 = 06
;2 = 5B
;3 = 4F
;4 = 66
;5 = 6D
;6 = 7D
;7 = 07
;8 = 7F
;9 = 67
ldi R16, 0x67 ; load pattern to display
rcall display
display: 
	; backup used registers on stack
	push R16
	push R17
	in R17, SREG
	push R17
	ldi R17, 8 ; loop --> test all 8 bits
loop:
	rol R16 ; rotate left trough Carry
	BRCS set_ser_in_1 ; branch if Carry is set
	; put code here to set SER to 0
	cbi PORTB,0
	rjmp end
set_ser_in_1:
	; put code here to set SER to 1
	sbi PORTB,0
end:
	; put code here to generate SRCLK pulse
	cbi PORTB,2
	nop
	sbi PORTB,2
	dec R17
	brne loop
	; put code here to generate RCLK pulse
	cbi PORTB,1
	nop
	sbi PORTB,1
	; restore registers from stack
	pop R17
	out SREG, R17
	pop R17
	pop R16
	ret 