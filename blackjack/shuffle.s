.cpu cortex-a53
.fpu neon-fp-armv8

.data
prompt: .asciz "%d\n"
.text
.align 2
.global shuffle
.type shuffle, %function

shuffle:
	push {lr}
	push {fp}
	add fp, sp, #4
	mov r4, r0
	mov r0, #0
	bl time
	bl srand
	mov r5, #0 @r5 counts # of cards
	mov r0, #0
	mov r1, #0
	initarray:
		add r0, r0, #1
		cmp r0, #14
		beq dinitarray
		push {r1}
		b initarray
	dinitarray:
		add r5, r5, #1
		cmp r5, #52
		beq done
		dinitarray_inner:
			bl rand @gen random number
			mov r1, #13
			bl modulo @call modulo.s
			sub r10, fp, #8
			mov r2, #4
	 		mul r2, r0, r2
			sub r10, r10, r2 @position of the card
			ldr r2, [r10]
			cmp r2, #4
			beq dinitarray_inner
			add r2, r2, #1
			str r2, [r10]
			mov r2, r0
			ldr r1, =prompt
			mov r0, r4
			bl fprintf
			b dinitarray
	done:
		sub sp, fp, #4
		pop {fp, pc}
