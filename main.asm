;
; Lab02.asm
;
; Created: 2/7/2023 3:11:50 PM
; Author : stlondon, mpass
;
.include "m328Pdef.inc"
.cseg
.org 0

.equ SERIAL=0	; SERIAL is PB0 (Pin 8)
.equ RCLK=1		; RCLK is PB1 (Pin 9)
.equ SRCLK=2	; SRCLK is PB2 (Pin 10)
.equ BUTTON0=3		; BUT0 is PB3 (Pin 11)
.equ BUTTON1=4		; BUT1 is PB4 (Pin 12)

; Data-direction register setup
sbi DDRB,SERIAL ; Set SERIAL (PB0/Pin 8) as output
sbi DDRB,RCLK	; Set RCLK (PB1/Pin 9) as output
sbi DDRB,SRCLK	; Set SRCLCK (PB2/Pin 10) as output
cbi DDRB,BUTTON0	; Set BUT0 (PB3/Pin 11) as input
cbi DDRB,BUTTON1	; Set BUT1 (PB4/Pin 12) as input

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
;9 = 6F
;- = 40


; digit1 (MSD)
; 1 displayed if not pressed. 2 displayed if pressed
ldi R18, 0x5B
SBIC PINB,BUTTON1
ldi R18, 0x06

; digit0 (LSD)
; 3 displayed if not pressed. 4 displayed if pressed.
ldi R16, 0x66 ; load pattern to display
SBIC PINB,BUTTON0
ldi R16, 0x4F


rcall display

rjmp start ; Return to start. Main loop of program.

display: 
	; backup used registers on stack
	push R16
	push R17
	in R17, SREG
	push R17
	push R18
	push R19
	ldi R17, 8 ; loop --> test all 8 bits
	ldi R19, 8


loop_digit1:
	rol R18
	brcs set_ser_in_1_digit1
	cbi PORTB,SERIAL
	rjmp end_digit1
set_ser_in_1_digit1:
	sbi PORTB,SERIAL
end_digit1:
	cbi PORTB,SRCLK
	nop
	sbi PORTB,SRCLK
	dec R19
	brne loop_digit1


loop_digit0:
	rol R16 ; rotate left trough Carry
	brcs set_ser_in_1_digit0 ; branch if Carry is set
	; put code here to set SER to 0
	cbi PORTB,SERIAL
	rjmp end_digit0
set_ser_in_1_digit0:
	; put code here to set SER to 1
	sbi PORTB,SERIAL
end_digit0:
	; put code here to generate SRCLK pulse
	cbi PORTB,SRCLK
	nop
	sbi PORTB,SRCLK
	dec R17
	brne loop_digit0


	; put code here to generate RCLK pulse
	cbi PORTB,RCLK
	nop
	sbi PORTB,RCLK
	nop
	cbi PORTB,RCLK

	; restore registers from stack
	pop R19
	pop R18
	pop R17
	out SREG, R17
	pop R17
	pop R16

	ret


	 
/*
.equ count = 0xFFFF			; assign a 16-bit value to symbol "count"

delay_long:
	ldi r30, low(count)	;1  	; r31:r30  <-- load a 16-bit value into counter register for outer loop
	ldi r31, high(count);1
d1:
	ldi   r29, 0xFF	;1	    	; r29 <-- load a 8-bit value into counter register for inner loop
d2:
	nop	;1							; no operation
	dec   r29  ;1          		; r29 <-- r29 - 1
	brne  d2	;1							; branch to d2 if result is not "0"
	sbiw r31:r30, 1		;2			; r31:r30 <-- r31:r30 - 1
	brne d1		;1							; branch to d1 if result is not "0"
	ret		;4									; return

*/


.exit