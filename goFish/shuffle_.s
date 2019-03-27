.cpu cortex-a53
.fpu neon-fp-armv8
.data
prompt: .asciz "%d\n"
.text
.align 2
.global shuffle
.type shuffle, %function
shuffle:
    sub sp, sp, #4
    str lr, [sp]
    sub sp, sp, #4
    str fp, [sp]
    add fp, sp, #4
    mov r4, r0 @store fp into r4

    mov r0, #0
    bl time
    bl srand
    bl rand

    mov r5, #0 @r5 counts number of cards

    initarray: @initializing array; move sp down [loop count] number of bits
        add r5, r5, #1
        cmp r5, #14 @locks loop count to 13
        beq dinitarray1
        sub sp, sp, #4
        mov r1, #0
        str r1, [sp]
        b initarray
    dinitarray1:
        mov r5, #0
    dinitarray:
        add r5, r5, #1
        cmp r5, #53
        beq done
        fail:
            bl rand
            mov r1, #13
            bl modulo
            add r0, r0, #1
            mov r9, r0

            sub r10, fp, #8
            mov r2, #4
            sub r0, r0, #1
            mul r2, r0, r2
            sub r10, r10, r2
            ldr r2, [r10]
            cmp r2, #4
            beq fail
            add r2, r2, #1
            str r2, [r10]
            mov r2, r9
            mov r0, r4
            ldr r1, =prompt
            bl fprintf
            b dinitarray
    done:
    mov r0, r4
    bl fclose

    add sp, sp, #48 @undoes initarray
    add sp, sp, #4
    ldr fp, [sp]
    add sp, sp, #4
    ldr lr, [sp]
    bx lr
