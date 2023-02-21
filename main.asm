;
; Lab02.asm
;
; Created: 2/7/2023 3:11:50 PM
; Author : stlondon, mpass
;
.include "m328Pdef.inc"
.cseg
.org 0

; 7-segement bit-patterns
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


ldi R16, 0; Initialize counter to zero.

; --------- Main loop body ---------
start:

sbis PINB, BUTTON0
rcall wait_for_release_button0

sbis PINB, BUTTON1
rcall wait_for_release_button1

rcall display

rjmp start ; Return to start. Main loop of program.

; --------- End loop body ---------

wait_for_release_button0:
; Note: Button is Active-Low. So I/O bit will be set when released.
	sbis PINB, BUTTON0
	rjmp wait_for_release_button0
	rcall increment_counter
	ret


wait_for_release_button1:
; Note: Button is Active-Low. So I/O bit will be set when released.
	sbis PINB, BUTTON1
	rjmp wait_for_release_button1
	rcall decrement_counter
	ret

increment_counter:
; Don't allow incrementing past 25.
	cpi R16, 25
	breq end_increment_counter
	inc R16
end_increment_counter:
	ret

decrement_counter:
; Don't allow decrementing below 0.
	cpi R16, 0
	breq end_decrement_counter
	dec R16
end_decrement_counter:
	ret

resolve_digits:
; R19 - digit1
; R17 - digit0

try_00:
	cpi R16, 0
	breq set_00
	rjmp try_01
set_00:
	ldi R19, 0x3F; 0
	ldi R17, 0x3F; 0
	rjmp end_resolve

try_01:
	cpi R16, 1
	breq set_01
	rjmp try_02
set_01:
	ldi R19, 0x3F; 0
	ldi R17, 0x06; 1
	rjmp end_resolve

try_02:
	cpi R16, 2
	breq set_02
	rjmp try_03
set_02:
	ldi R19, 0x3F; 0
	ldi R17, 0x5B; 2
	rjmp end_resolve

try_03:
	cpi R16, 3
	breq set_03
	rjmp try_04
set_03:
	ldi R19, 0x3F; 0
	ldi R17, 0x4F; 3
	rjmp end_resolve

try_04:
	cpi R16, 4
	breq set_04
	rjmp try_05
set_04:
	ldi R19, 0x3F; 0
	ldi R17, 0x66; 4
	rjmp end_resolve

try_05:
	cpi R16, 5
	breq set_05
	rjmp try_06
set_05:
	ldi R19, 0x3F; 0
	ldi R17, 0x6D; 5
	rjmp end_resolve

try_06:
	cpi R16, 6
	breq set_06
	rjmp try_07
set_06:
	ldi R19, 0x3F; 0
	ldi R17, 0x7D; 6
	rjmp end_resolve

try_07:
	cpi R16, 7
	breq set_07
	rjmp try_08
set_07:
	ldi R19, 0x3F; 0
	ldi R17, 0x07; 7
	rjmp end_resolve

try_08:
	cpi R16, 8
	breq set_08
	rjmp try_09
set_08:
	ldi R19, 0x3F; 0
	ldi R17, 0x7F; 8
	rjmp end_resolve

try_09:
	cpi R16, 9
	breq set_09
	rjmp try_10
set_09:
	ldi R19, 0x3F; 0
	ldi R17, 0x6F; 9
	rjmp end_resolve

try_10:
	cpi R16, 10
	breq set_10
	rjmp try_11
set_10:
	ldi R19, 0x06; 1
	ldi R17, 0x3F; 0
	rjmp end_resolve

try_11:
	cpi R16, 11
	breq set_11
	rjmp try_12
set_11:
	ldi R19, 0x06; 1
	ldi R17, 0x06; 1
	rjmp end_resolve

try_12:
	cpi R16, 12
	breq set_12
	rjmp try_13
set_12:
	ldi R19, 0x06; 1
	ldi R17, 0x5B; 2
	rjmp end_resolve

try_13:
	cpi R16, 13
	breq set_13
	rjmp try_14
set_13:
	ldi R19, 0x06; 1
	ldi R17, 0x4F; 3
	rjmp end_resolve

try_14:
	cpi R16, 14
	breq set_14
	rjmp try_15
set_14:
	ldi R19, 0x06; 1
	ldi R17, 0x66; 4
	rjmp end_resolve

try_15:
	cpi R16, 15
	breq set_15
	rjmp try_16
set_15:
	ldi R19, 0x06; 1
	ldi R17, 0x6D; 5
	rjmp end_resolve

try_16:
	cpi R16, 16
	breq set_16
	rjmp try_17
set_16:
	ldi R19, 0x06; 1
	ldi R17, 0x7D; 6
	rjmp end_resolve

try_17:
	cpi R16, 17
	breq set_17
	rjmp try_18
set_17:
	ldi R19, 0x06; 1
	ldi R17, 0x07; 7
	rjmp end_resolve

try_18:
	cpi R16, 18
	breq set_18
	rjmp try_19
set_18:
	ldi R19, 0x06; 1
	ldi R17, 0x7F; 8
	rjmp end_resolve

try_19:
	cpi R16, 19
	breq set_19
	rjmp try_20
set_19:
	ldi R19, 0x06; 1
	ldi R17, 0x6F; 9
	rjmp end_resolve

try_20:
	cpi R16, 20
	breq set_20
	rjmp try_21
set_20:
	ldi R19, 0x5B; 2
	ldi R17, 0x3F; 0
	rjmp end_resolve

try_21:
	cpi R16, 21
	breq set_21
	rjmp try_22
set_21:
	ldi R19, 0x5B; 2
	ldi R17, 0x06; 1
	rjmp end_resolve

try_22:
	cpi R16, 22
	breq set_22
	rjmp try_23
set_22:
	ldi R19, 0x5B; 2
	ldi R17, 0x5B; 2
	rjmp end_resolve

try_23:
	cpi R16, 23
	breq set_23
	rjmp try_24
set_23:
	ldi R19, 0x5B; 2
	ldi R17, 0x4F; 3
	rjmp end_resolve

try_24:
	cpi R16, 24
	breq set_24
	rjmp try_25
set_24:
	ldi R19, 0x5B; 2
	ldi R17, 0x66; 4
	rjmp end_resolve

try_25:
	cpi R16, 25
	breq set_25
	rjmp end_resolve
set_25:
	ldi R19, 0x5B; 2
	ldi R17, 0x6D; 5
	rjmp end_resolve

end_resolve:
	ret


display:
; Input - R19: digit1, R17:digit0 
rcall resolve_digits

	; backup used registers on stack
	push R17
	push R18
	in R18, SREG
	push R18
	push R19
	push R20
	ldi R18, 8 ; loop --> test all 8 bits
	ldi R20, 8


loop_digit1:
	rol R19
	brcs set_ser_in_1_digit1
	cbi PORTB,SERIAL
	rjmp end_digit1
set_ser_in_1_digit1:
	sbi PORTB,SERIAL
end_digit1:
	cbi PORTB,SRCLK
	nop
	sbi PORTB,SRCLK
	dec R20
	brne loop_digit1


loop_digit0:
	rol R17 ; rotate left trough Carry
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
	dec R18
	brne loop_digit0


	; put code here to generate RCLK pulse
	cbi PORTB,RCLK
	nop
	sbi PORTB,RCLK
	nop
	cbi PORTB,RCLK

	; restore registers from stack
	pop R20
	pop R19
	pop R18
	out SREG, R18
	pop R18
	pop R17

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