@ read_message.s
@ Method reads the message from the file and stores each character into
@ the array declared as message[10000] in main.c
@
@ r0 <- fptr for the message to be sent
@ r1 <- message array address &message[0]
@ Returns the number of chars in the message

.cpu cortex-a53
.fpu neon-fp-armv8

.data
inp: .asciz "%c"
.extern feof
.equ BYTE, 1
.equ NULL, 0

.text
.align 2
.global read_message
.type read_message, %function

read_message:
    push {fp, lr}
    add fp, sp, #4
    sub sp, sp, #4          @ makes space for memory

    @ r0 contains fptr, and r1 contains the address of the message
    @ refer to the visual representation in the video
    @ while(!feof(fp)) {
    @   fscanf(fp, "%c", &c);
    @   message[i]= c;
    @   i++;
    @} //the above code will be translated below

    mov r4, r0              @ saves the file pointer
    mov r5, r1              @ &message[0]
    mov r10, #0             @ i = 0

    whileLoop:
        mov r0, r4          @ put fptr into arg reg r0
        ldr r1, =inp        @ put "%c" into arg reg r1
        mov r2, sp          @ put memory into arg reg r2
        bl fscanf           @ c will be stored into sp memory
        ldrb r0, [sp]       @ put c into r0  <- fscanf(fp, "%c", &c)


        mov r0, r4          @ put fptr into arg reg r0
        bl feof             @ r0 <- if end of file returns 1 (true), else returns 0 (false)

        cmp r0, #1          @ feof will return true, 1 if end of file reached
        beq endFunction

        ldrb r0, [sp]       @ r0 was changed due to bl feof so reload char back into r0

        mov r1, #BYTE       @ put 1 into r1
        mul r1, r1, r10     @ r1 = i * 1

        cmp r0, #32
        movlt r0, #32

        strb r0, [r5, r1]   @ put char stored into r0 into message[i] array

        cmp r0, #31
        add r10, r10, #1    @ i++

        b whileLoop

    endFunction:
        mov r0, r10         @ return the number of chars in the message
        add sp, sp, #4
        sub sp, fp, #4
        pop {fp, pc}
