@assembler directive
.cpu cortex-a53
.fpu neon-fp-armv8

.data @define constants
prompt : .asciiz "Which fibonacci number would you like to know?"
.extern printf
.extern scanf

.text
.align 2
.global main
.type main, %function

main:
  mov r7, lr
  mov r5, #0
  mov r6, #1
  ldr r0, =prompt
  bl printf
  bl scanf
  mov r0, r4 @nth term
  loop:
    sub r4, r4, #2
    cmp r4, #0
    blt done
    adds r5, r5, r6
    adds r6, r5, r6
    bl loop
  done:
    TST r4, #1
    BNE odd
    mov r0, r5 @even so store r5 as return value
    mov lr, r4
    bx lr @return
  odd: @odd so store r4 as return value
    mov r0, r4
    mov lr, r4
    bx lr @return
