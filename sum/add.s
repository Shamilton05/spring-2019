.cpu cortex-a53
.fpu neon-fp-armv8

.data
.equ e, 8
.equ f, 4

.text
.align 2
.global add
.type add, %function

add:
	push {lr}
	
	add r4, r0, r1
	add r4, r4, r2
	add r4, r4, r3
	ldr r0, [sp, #e]
	add r4, r4, r0
	ldr r0, [sp, #f]
	add r4, r4, r0
	mov r0, r4
	ldr lr, [sp]
	add sp, sp, #4
	bx lr
