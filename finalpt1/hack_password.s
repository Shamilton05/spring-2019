.cpu cortex-a53
.fpu neon-fp-armv8

.data

format: .asciz "%s\n"
array: .skip 4 * 4

.text
.align 2
.global hack_password
.type hack_password, %function

hack_password:
	push {fp, lr}
	add fp, sp, #4

	mov r4, #48 @r4 is password[0]
	mov r5, #48 @r5 is password[1]
	mov r6, #48 @r6 is password[2]

	
	mov r9, #0 @r9 is null pointer
	ldr r10, =array
	mov r7, r10 @r7 has front of array
	strb r4, [r10], #1
	strb r5, [r10], #1
	strb r6, [r10], #1
	strb r9, [r10]
	mov r10, r7 @r10 back to front

	@ find correct char for password[0] - password[2]
	@ push null pointer (0), r6, r5, r4 onto the stack
	@ move sp into r1 and format into r0
	@ call printf

	@first loop to check if password[0] (r4) is a number
	@ push null pointer (0), r6, r5, r4 onto the stack
	@ move sp into r0
	@ call check_password
	@ cmp r0, 100
	@ bge passw2loop1
	@ increment r4 by one
	@ cmp r4, 58
	@ beq passw1loop2

	passw1loop1:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r4, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #100
		bge passw2break1
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r4, r4, #1
		cmp r4, #58
		beq passw1break2
		b passw1loop1
	@it's not a number, so check uppercase letters
	passw1break2:
		mov r4, #65
	passw1loop2:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r4, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #100
		bge passw2break1
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r4, r4, #1
		cmp r4, #91
		beq passw1break3
		b passw1loop2
	@it's not uppercase letter, so check lowercase letters
	passw1break3:
		mov r4, #97
	passw1loop3:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r4, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #100
		bge passw2break1
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r4, r4, #1
		cmp r4, #123
		beq done
		b passw1loop1

	@now check passw[1]
	passw2break1:
		add r10, r10, #1 @pointing passw[1]
	passw2loop1:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r5, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #110
		bge passw3break1
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r5, r5, #1
		cmp r5, #58
		beq passw2break2
		b passw2loop1
	passw2break2:
		mov r5, #65
	passw2loop2:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r5, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #110
		bge passw3break1
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r5, r5, #1
		cmp r5, #91
		beq passw2break3
		b passw2loop2
	passw2break3:
		mov r5, #97
	passw2loop3:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r5, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #110
		bge passw3break1
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r5, r5, #1
		cmp r5, #123
		beq done
		b passw2loop3

	@now check passw[2]
	passw3break1:
		add r10, r10, #1
	passw3loop1:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r6, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #111
		bge done
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r6, r6, #1
		cmp r6, #58
		beq passw3break2
		b passw3loop1
	passw3break2:
		mov r6, #65
	passw3loop2:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r6, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #111
		bge done
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r6, r6, #1
		cmp r6, #91
		beq passw3break3
		b passw3loop2
	passw3break3:
		mov r6, #97
	passw3loop3:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		strb r6, [r10]
		mov r0, r7
		bl check_password
		cmp r0, #111
		bge done
		pop {r4}
		pop {r5}
		pop {r6}
		pop {r9}
		add r6, r6, #1
		cmp r6, #123
		beq done
		b passw3loop3

	done:
		push {r9}
		push {r6}
		push {r5}
		push {r4}
		mov r1, r7
		ldr r0, =format
		bl printf
		sub sp, fp, #4    @ place sp at -8 on stack
		pop {fp, lr}      @ pop fp (calling function), pop lr, set sp at 0 on stack
		bx lr @ branch back to calling function
