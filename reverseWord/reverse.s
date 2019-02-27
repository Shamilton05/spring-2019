.cpu cortex-a53
.fpu neon-fp-armv8

.data
prompt: .asciz "debug: %s"
prompt1: .asciz "%c"

.text
.align 2
.global reverse
.type reverse, %function

reverse:
	push {fp, lr} @push lr on stack, then fp on stack
	add fp, sp, #4

	@the input string should be in r0
	mov r6, r0 @move the word into r6
	bl strlen @length of the string returned into r0
	mov r7, r0 @move the length of the word into r7

	@clear the buffer
	ldr r0, =prompt1
	sub r1, sp, #4
	bl scanf

	mov r0, #100 @100 bytes for malloc to allocate
	bl malloc
	mov r8, r0 @r8 will contain the memory allocated by malloc

	@loop to reverse word
	
	mov r3, #-1 @r3 = -1 (counter)
	loop:
		add r3, r3, #1 @r3++
		cmp r3, r7 @if equal then done	
		beq done
	
		add r2, r6, r3 @r2 contains the address of the current char 
		ldrb r9, [r2] @grab character from original word, put in r9
		add r2, r8, r7
	
		sub r2, r8, r3 @r2 starts at the bottom of the new string
		sub r2, r2, #1 @and works its way to the first index
		strb r9, [r2] @inserting the characters 
	
		b loop

	done:
		@add null character to the end of the string
		add r2, r6, r3
		ldrb r9, [r2]
		add r2, r8, r3
		strb r9, [r2]

		mov r0, r8

		sub fp, sp, #4
		pop {fp, pc} @pop fp onto fp, lr onto pc

