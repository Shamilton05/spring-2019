.cpu cortex-a53
.fpu neon-fp-armv8

.data @define constants
.text
.align 2
.global checkPrimeNumber
.type checkPrimeNumber, %function

checkPrimeNumber:
  push {fp, lr}
  add fp, sp, #4
  cmp r0, #2
  ble return1
  push {r0}
  mov r1, #2
  bl modulo
  cmp r0, #0
  beq return0
  mov r2, #2
  pop {r0}
  push {r0}
  udiv r2, r0, r2
  mov r1, #3
  loop:
	cmp r1, r2
	bge return1
	bl modulo
	cmp r0, #0
	beq return0
	add r1, r1, #2
	pop {r0}
	push {r0}
	b loop
  return0:
	mov r0, #0
	sub sp, fp, #4
	pop {fp, lr}
	bx lr
  return1:
	mov r0, #1
	sub sp, fp, #4
	pop {fp, lr}
	bx lr
