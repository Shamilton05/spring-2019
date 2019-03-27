@checks if the hand of cards is a winner
@params : address of array
.cpu cortex-a53
.fpu neon-fp-armv8

.data
.text
.align 2
.global checkwin
.type checkwin, %function

checkwin:
	push {lr}
	mov r2, r0 @address of array
	mov r1, #0 @loop counter
	push {r1} @store loop counter on stack
	mov r0, #0 @number of pairs counter
	loop:
		cmp r0, #14
		beq win
		pop {r1}
		cmp r1, #13
		beq notWin
		add r2, r2, #4 @incrememnt array index
		add r1, r1, #1 @incrememnt loop counter
		push {r1}
		ldr r1, [r2]
		cmp r1, #2
		beq addOne
		cmp r1, #4
		beq addTwo
		b loop
	addOne:
		add r0, r0, #1
		b loop
	addTwo:
		add r0, r0, #2
		b loop
	win:
		mov r0, #1
		pop {r1, lr}
		bx lr
	not win:
		mov r0, #0
		pop {r1, lr}
		bx lr
