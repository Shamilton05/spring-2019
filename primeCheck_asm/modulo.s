.cpu cortex-a53
.fpu neon-fp-armv8

.data @define constants
.text
.align 2
.global modulo
.type modulo, %function

modulo:
	push {fp, lr}
	add fp, sp, #4
	loop:
		cmp r0, r1
		blt done
		sub r0, r0, r1
		b loop
	done:
		sub sp, fp, #4
		pop {fp, lr}
		bx lr
