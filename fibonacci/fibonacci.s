@assembler directive
.cpu cortex-a53
.fpu neon-fp-armv8

.data @define constants
words: .asciz "The %d fibonacci number encountered overflow\n"
.extern printf


.text
.align 2
.global main
.type main, %function

main:
  push {fp, lr}
  add fp, sp, #4
  mov r5, #0
  mov r6, #1
  mov r4, #1 @counter
  loop:
    add r4, r4, #1
    adds r7, r5, r6
    bvs done
    mov r5, r6
    mov r6, r7
    b loop
  done:
    mov r1, r4
    ldr r0, =words
    bl printf
    
    mov r0, #0
    sub sp, fp, #4
    pop {fp, lr}
    bx lr
