.cpu cortex-a53
.fpu neon-fp-armv8

.data
inp1: .asciz "Pick a card: "
inp2: .asciz "%d"
out1: .asciz "Go Fish\n"

.text
.align 2
.global askcards_man
.type askcards_man, %function

askcards_man:
    push {fp, lr}          @ push lr, fp (calling function) onto stack, updates sp by -8
    add fp, sp, #4         @ point fp (this function) to lr on stack @ -4

    @r0contains file pointer
    @r1 contains playerArray
    @r2 contains CPUarray

    mov r4, r0             @ place address of fptr in r4
    mov r5, r1             @ place address of playerArray into r5
    mov r6, r2             @ place address of CPUarray into r6

    @ Ask player to pick a card
    ldr r0, =inp1          @ load address of "Pick a card: " string into arg reg r0
    bl printf              @ display string

    @ scan player input into memory
    ldr r0, =inp2          @ place address of format string "%d" into arg reg r0
    sub sp, sp, #4         @ create memory slot for scanned item
    mov r1, sp             @ move address of memory spot into arg reg r1
    bl scanf               @ scan integer into memory

    @ check to see if CPU has any cards of the type, if not Go Fish for player, if yes,
    @ card count removed from CPU and added to player
    ldr r7, [sp] @card selected   @ put integer scanned into memory at sp, into r7
    mov r3, #4             @ put #4 into r3 for multiple of 4 calculation
    mul r3, r3, r7         @ r3 = integer scanned into memory * 4 (to create multiple of 4)
    add r3, r3, r6         @ r3 = (integer * 4) + CPUarray address
    ldr r0, [r3]           @ put integer stored at the r3 address into r2
    mov r1, #2
    bl modulo
    ldr r2, [r3]
    cmp r0, #0             @ check to see if the CPU has any cards stored at the r3 address memory
    beq gofish             @ if not, then Go Fish

    @ occurs if no Go Fish, hence CPU has cards in that memory location, remove cards from CPU, add
    @ to player card count for that rank
    sub r1, r2, #1             @ put 0 into r1       ******** change sub if only taking 1 card from that location
    str r1, [r3]           @ store 0 into that CPU memory address to remove all cards
    mov r3, #4             @ put #4 into r3 for multiple of 4 calculation
    mul r3, r3, r7         @ r3 = integer scanned into memory * 4
    add r3, r3, #1         @ r3 = (integer * 4) + playerArray address, accesses proper location

    @ subtract total cards taken from cpu
    ldr r8, [r6]           @ put element cpu[0] (cpu total cards in hand) into r8
    sub r8, r8, #1         @ r8 = cpu[0] (cpu cards in hand) - all cards from card rank storage location
    str r8, [r6]           @ put result back into cpu[0] (cpu total cards in hand)

    @ update the count for that particular card rank in player deck with total number of cards (every card) taken from cpu for that rank
    ldr r8, [r3]           @ put element player[card rank storage location] into r8
    add r8, r8, #1         @ r8 = player[card rank storage location] + number of cards taken from cpu
    str r8, [r3]           @ put result back into player[card rank storage location]

    @ update total card count for player hand
    ldr r8, [r5]           @ put element player[0] into r8
    add r8, r8, #1         @ increase r8 = player[0] + cards taken from cpu
    str r8, [r5]           @ put result back into player[0]

    @ check to see if player has 4 cards of the same rank, if yes, player wins return -> 1, if no return -> 0, then CPU turn
    ldr r8, [r3]           @ put integer stored in r3 into r8
    cmp r8, #4             @ compare to 4 total for GoFishTest, if player or CPU gets 4 in a row, game is won BRANCH TO CHECKWIN HERE
    blt gameNotOver        @ player loses because branch if not equal

    b playerWon            @ go to playerWon, set return to 1

@ player asked for a card that the CPU doesn't have, so player must choose next card on deck and
@ add to his card count for that specific rank
gofish:
    @ tells user to Go Fish which draws a card from the deck to add to theirs
    ldr r0, =out1          @ loads "Go Fish\n" into arg reg0
    bl printf              @ display string

    @ draw a card from the deck and increase card count for that rank by 1
    mov r0, r4             @ put address of fptr into arg reg r0
    mov r1, r5             @ put address of playerArray into arg reg r1
    bl draw                @ draw a random card and increase card count at proper location into playerArray

    mov r9, #1             @ put 1 into r9 so r9 is acting as loop counter i here
    b   whileLoop


@ checks to see if player has 4 cards of any rank for a win
whileLoop:
    cmp r9, #14            @ i < 14
    beq gameNotOver        @ game not over yet for player, so return 0 for player

    @ put element playerArray[i] into r3
    mov r3, #4             @ put #4 into r3 for multiple of 4 calculation
    mul r3, r3, r9         @ r3 = i * 4
    add r3, r3, r5         @ r3 = (i * 4) + &playerArray[0] -> essentially goes to next array location
    ldr r8, [r3]           @ examine integer at the array location

    @ check to see if player has 4 cards of that rank                  ????? is r3 address &player[i] or element player[i]  ???????
    cmp r8, #4             @ compare r3 with #4 to see if player has 4 cards of any rank
    bge playerWon          @ go to playerWon

    add r9, r9, #1         @ ++i;
    b whileLoop            @ loop back

    @ player hasn't won yet
gameNotOver:
    mov r0, #0             @ return value = 0
    b   endFunction

playerWon:
    mov r0, #1             @ return value = 1
    b   endFunction

endFunction:
    sub sp, fp, #4         @ place sp at -8 on stack
    pop {fp, lr}           @ pop fp (calling function), pop lr, set sp at 0 on stack
    bx lr                  @ branch back to calling function
