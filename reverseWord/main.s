.cpu cortex-a53
.fpu neon-fp-armv8

.data
prompt: .asciz "Enter a word: \n"
inp: .asciz "%s"
out: .asciz "The reverse word is: %s\n"

.text
.align 2
.global main
.type main, %function

main:
	push {fp, lr}
	add fp, sp, #4
	
	@allocate memory to store certain # characters
	mov r0, #100 @allocate memory for 100 bytes
	bl malloc @allocate the 100 bytes
	mov r4, r0 @move the address of the 100 bytes to r4

	@prompt user
	ldr r0, =prompt
	bl printf
	ldr r0, =inp
	mov r1, r4
	bl scanf @scanf(=inp, 100 bytes) 

	@call reverse to reverse the word
	mov r0, r4 @move the word into r0
	bl reverse2
	mov r5, r0 @result moved into r5
	
	@ check to see if it works
	ldr r0, =out
	mov r1, r5
	bl printf @printf(=out, input reversed)
	bl printf

	@return 
	mov r0, #0
	sub fp, sp, #4
	pop {fp, pc}

