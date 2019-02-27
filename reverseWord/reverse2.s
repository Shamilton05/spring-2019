.data
prompt1: .asciz "%c"

.text
.align 2
.global reverse2
.type reverse2, %function

reverse2:
	push {fp, lr}
	add fp, sp, #4

	mov r6, r0 @move the word into r6
	bl strlen
	mov r7, r0 @length of word in r7

	@clear buffer
	ldr r0, =prompt1
	sub r1, sp, #4
	bl scanf
	
	mov r0, #100
	bl malloc
	mov r8, r0

	mov r3, #-1
	loop:
		add r3, r3, #1 @r3++
		cmp r3, r7
		beq done1
	
		add r2, r6, r3 @r2 contains the address of the current char
		push {r2}

		b loop

	done1:
	mov r3, #-1
	mov r10, r8 @r10 has the address of the reversed word
	loop2:
		add r3, r3, #1
		cmp r3, r7
		beq done

		pop {r9} @r9 contains the address of the current char
		ldrb r11, [r9]
		strb r11, [r8]
		add r8, r8, #1 @move r8 down the array by 1
		b loop2
@r8 is pointing below the last char
	done:
		add r9, r6, r7 @r11 points to the null char
		ldrb r11, [r9]
		strb r11, [r8]
	
		mov r0, r10
		sub fp, sp, #4
		pop {fp, pc}
		
