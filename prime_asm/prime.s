.cpu cortex-a53
.fpu neon-fp-armv8

.data @define constants
prompt: .asciz "Enter two positive integers: \n"
format: .asciz "%d %d"
result: .asciz "Prime numbers between %d and %d are: "
printerFormat: .asciz "%d "
newLine: .asciz "\n"
.text
.align 2
.global main
.type main, %function

main:
	mov r7, lr
	ldr r0, =prompt
	bl printf
	ldr r0, =format
	mov r1, sp
	mov r2, sp
	add r2, r2, #4
	bl scanf
	ldr r0, =result
	pop {r4, r5}
	mov r1, r4
	mov r2, r5
	bl printf
	loop:
		add r4, r4, #1
		cmp r4, r5
		bge done
		mov r0, r4
		bl checkPrimeNumber
		cmp r0, #1
		beq printer
		b loop
	printer:
		ldr r0, =printerFormat
		mov r1, r4
		bl printf
		b loop
	done:
		ldr r0, =newLine
		bl printf
		mov r0, #0
		mov lr, r7
		bx lr
