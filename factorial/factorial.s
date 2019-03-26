.cpu cortex-a53
.fpu neon-fp-armv8

.data @define constants
format: .asciz "%d"
prompt: .asciz "Enter desired factorial\n"
over: .asciz "Overflow encountered\n"
result: .asciz "%d factorial is %d\n"
.extern printf


.text
.align 2
.global main
.type main, %function

main:
  push {fp, lr}
  add fp, sp, #4
  ldr r0, =prompt
  bl printf
  ldr r0, =format
  mov r1, sp
  bl scanf
  ldr r7, [sp]
  ldr r6, [sp]
  loop:
	sub r7, r7, #1
	cmp r7, #0
	beq printFib
	umull r4, r5, r6, r7
	cmp r5, #0
	bne overflow
	mov r6, r4
	b loop
  printFib:
	ldr r0, =result
	ldr r1, [sp]
	mov r2, r6
	bl printf
	mov r0, #0
	sub sp, fp, #4
	pop {fp, lr}
	bx lr
  overflow:
	ldr r0, =over
	bl printf
	mov r0, #0
	sub sp, fp, #4
	pop {fp, lr}
	bx lr
