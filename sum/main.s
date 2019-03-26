.cpu cortex-a53
.fpu neon-fp-armv8

.data
prompt: .asciz "%d\n"

.equ e, 4
.equ f, 8

.text
.align 2
.global main
.type main, %function

main:
	sub sp, sp, #4
	str lr, [sp]
	sub sp, sp, #4
	str fp, [sp]
	add fp, sp, #4
	mov r0, #1
	mov r1, #2
	mov r2, #3
	mov r3, #4
	sub sp, sp, #4
	mov r4, #5
	str r4, [sp]
	sub sp, sp, #4
	mov r4, #6
	str r4, [sp]	
	bl add
	mov r1, r0
	ldr r0, =prompt
	bl printf
	mov r0, #0
	add sp, sp, #8
	ldr fp, [sp]
	add sp, sp, #4
	ldr lr, [sp]
	add sp, sp, #4
	bx lr
