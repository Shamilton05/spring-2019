.cpu cortex-a53
.fpu neon-fp-armv8

.data
inp: .asciz "%d"

.extern fscanf

.text
.align 2

.global draw
.type draw, %function

draw:
    push {fp, lr}       @ push lr, fp (calling function) onto stack, updates sp by -8
    add fp, sp, #4      @ point fp (this function) to lr on stack @ -4

    @r0 contains filepointer
    @r1 contains array

    push {r1, r0}       @push fptr onto stack, push array address onto stack, updates sp to -16

    @ scan for next randomized number from "deck.dat" file, that will represent the new card drawn from the deck
    ldr r0, [sp]        @ load fptr into arg reg r0
    ldr r1, =inp        @ load string address "%d" into arg reg r1
    sub sp, sp, #4      @ create new memory on stack, so sp updated to -20
    mov r2, sp          @ store address of empty memory into arg reg r2
    bl fscanf           @ fscanf(fptr, "%d", r2 address at -20 on stack)

    @ determine proper storage location within array argument arr for the chosen card
    ldr r9, [sp]        @ load random number stored in sp from fscanf into r9
    add sp, sp, #4      @ move sp back to -16 on stack so sp points to fptr
    mov r3, #4          @ put #4 into r3 for multiple of 4 calculation
    mul r3, r9, r3      @ r3 = random number (1-13) from file * 4
    ldr r10, [sp, #4]   @ load array address at current sp location of -16 on stack into r10
    add r3, r3, r10     @ r3 = (random rank * 4) + address of array

    @ increment card count at the proper card rank location in the array
    ldr r9, [r3]        @ load element at the address into r9
    add r9, r9, #1      @ increment the card count at that location
    str r9, [r3]        @ store card count back into array address location pointed to by r3

    @ increment total card count for the array stored at arr[0]
    ldr r8, [r10]       @ put element arr[0] (total card count in hand) into r8
    add r8, r8, #1      @ r8 = arr[0] (total card count in hand) + 1
    str r8, [r10]       @ put result into arr[0] (total card count in hand)

@ ends function call
    mov r0, #0          @ return 0
    sub sp, fp, #4      @ place sp at -8 on stack
    pop {fp, lr}        @ pop fp (calling function), pop lr, set sp at 0 on stack
    bx lr               @ branch back to calling function
