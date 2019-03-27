.cpu cortex-a53
.fpu neon-fp-armv8
.data
.text
.align 2

.global modulo
.type modulo, %function

modulo:
    push {fp, lr}     @ push lr, fp (calling function) onto stack, updates sp by -8
    add fp, sp, #4    @ point fp (this function) to lr on stack @ -4

    @ r0 -> first arg, r1 -> second arg
    @ r0 = r0 % r1

    @ e.g, let 10 % 3
    @ r2 = 10/3 = 3
    @ r2 = 3 * 3 = 9
    @ r0 = 10 -9 = 1 for the return value/modulus

    udiv r2, r0, r1   @ r2 = r0 / r1  integer division
    mul r2, r2, r1    @ r2 = r2 * r1
    sub r0, r0, r2    @ r0 = r0 - r2  return value/modulus stored in r0


    sub sp, fp, #4    @ place sp at -8 on stack
    pop {fp, lr}      @ pop fp (calling function), pop lr, set sp at 0 on stack
    bx lr             @ branch back to calling function
