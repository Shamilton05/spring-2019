@checks if the hand of cards is empty. returns 1 if empty, 0 if !empty
@params : address of array
.cpu cortex-a53
.fpu neon-fp-armv8

.data
.text
.align 2
.global checkEmptyHand
.type checkEmptyHand, %function

checkEmptyHand:
        push {lr}
        mov r2, r0 @address of array
        mov r1, #0 @loop counter
        push {r1} @store loop counter on stack
        loop:
                add r2, r2, #4 @increment array index to point to arr[1]
                pop {r1}
                add r1, r1, #1 @incrememnt loop counter
                cmp r1, #14
                beq empty
                push {r1}
                ldr r0, [r2]
		mov r1, #2
		push {r2}
                bl modulo
		pop {r2}
		cmp r0, #0
                bne notEmpty @not empty, return 0
		b loop
	empty:
		mov r0, #1 @else is empty, return 1
		pop {lr} @just lr on stack
		bx lr
	notEmpty:
		mov r0, #0
		pop {r1, lr} @r1 and lr on stack
		bx lr
