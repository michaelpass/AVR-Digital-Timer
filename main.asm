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
cbi DDRB,3

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
ldi R16, 0x3F ; load pattern to display
SBIC PINB,3
ldi R16, 0x66
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


.equ count = 0x6B33			; assign a 16-bit value to symbol "count"

delay_long:
	ldi r30, low(count)	;1  	; r31:r30  <-- load a 16-bit value into counter register for outer loop
	ldi r31, high(count);1
d1:
	ldi   r29, 0x4E	;1	    	; r29 <-- load a 8-bit value into counter register for inner loop
d2:
	nop	;1							; no operation
	dec   r29  ;1          		; r29 <-- r29 - 1
	brne  d2	;1							; branch to d2 if result is not "0"
	sbiw r31:r30, 1		;2			; r31:r30 <-- r31:r30 - 1
	brne d1		;1							; branch to d1 if result is not "0"
	ret		;4									; return


.exit