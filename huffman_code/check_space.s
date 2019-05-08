@ check_space.s
@ verifies whether or not there is a space as the first char of an integer packet
@ r0 <- 32 bit encoded unsigned int packed
@ Returns 0 if ' ' is not the first char in the packet
@ Returns 2 if ' ' is the first char in the packet

.cpu cortex-a53
.fpu neon-fp-armv8

.data
.text
.align 2
.global check_space
.type check_space, %function

check_space:
    push {fp, lr}
    add fp, sp, #4

    @ visual representations of count_spaces
    @ count_spaces(int )
    @ r0 <- 32-int unsigned

    AND r1, r0, #0xF0000000    @ extract the first 4 digits of the integer by AND with 1111 0..0 <-28 zeroes
    cmp r1, #0                 @ if r1 is 0 then the first 4 digits are all zero in the integer which means there is a space
    bne endFunction            @ return 0 if not a space

    mov r0, #2                 @ else if r1 is zero there is a space, so return 2
    sub sp, fp, #4
    pop {fp, pc}

endFunction:
        mov r0, #0              @ return 0 if there is not a space as the first char
        sub sp, fp, #4
        pop {fp, pc}

