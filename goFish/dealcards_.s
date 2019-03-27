.cpu cortex-a53
.fpu neon-fp-armv8

.data

.extern fscanf

.text
.align 2
.global dealcards
.type dealcards, %function

dealcards:
    push {fp, lr}          @ push lr, fp (calling function) onto stack, updates sp by -8
    add fp, sp, #4         @ point fp (this function) to lr on stack @ -4

    @ r0 = filepointer
    @ r1 = address of first element of current player array
    @ current player means either for player or for CPU, whichever is indicated by the ""actual"" array argument
    @ for function call

    mov r4, r0             @ put fptr into r4
    mov r5, r1             @ put address of first element of current player array into r5
    ldr r6, [r5]           @ put integer in address of first element of current player array thus r6
                           @ has number of cards in current players hands
    mov r2, #5             @ put 5 into r2
    sub r6, r2, r6         @ r6 -> numCardsNeeded = numCards - 5 to calculate number of cards needed

    mov r7, #0             @ i = 0

    @ adds more cards to the current players hand until player has at least 5 cards in their hand
    whileLoop:
        cmp r7, r6         @ i < numCardsNeeded, where numCards Needed will be between 0 - 5 cards
        beq endFunction    @ branch to end of function

        @ draw another card and add it to the proper rank location in current player hand
        mov r0, r4         @ put fptr into arg reg r0
        mov r1, r5         @ put address of first array element of current player into arg reg r1
        bl draw            @ draw a card and place into proper array location of current player

        add r7, r7, #1     @ ++i;
        b whileLoop        @ branch to while loop

endFunction:
    sub sp, fp, #4         @ place sp at -8 on stack
    pop {fp, lr}           @ pop fp (calling function), pop lr, set sp at 0 on stack
    bx lr                  @ branch back to calling function
