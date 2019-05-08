@ decoder.s
@ This function receives a single 32-bit huffman code based encoded integer packet,
@ decodes the integer as the intended message and stores the decoded message into
@ a d_message[10000] char array.

.cpu cortex-a53
.fpu neon-fp-armv8
.data

.equ LTR_TO_NXT_LTR, 56       @ memory distance from &hcode[i].letter to & hcode[i + 1].letter

.extern count_spaces
.extern search_hcode

.text
.align 2
.global decoder
.type decoder, %function

decoder:
    push {fp, lr}
    add fp, sp, #4

    @ package recieved 32 bit integer, filled with info
    @ extract one bit at a time, check bit string against huffcode

    @ decoder(encoded packet gotten off port, &hcode[0] <-sorted by huffman code length version, &c_char, &d_message[0])
    @ r0 => encoded int
    @ r1 => &hcode[0] array of 29 structs
    @ r2 => &current_char <- contains array index for d_message[index], uses "int &current_char" so that the function can change the value of the int
    @ r3 => char array of 10000 chars, &d_message[0] <- decoded message

    mov r4, r0            @ r4 = encodedInt, encoded int packet
    mov r5, r1            @ r5 = &hcode[0]
    mov r6, r2            @ r6 = &current_char <- address that contains array index for d_message[index]
    mov r7, r3            @ r7 = &d_message[0]
    mov r8, #0            @ r8 = 0, current_int
    mov r9, #0            @ r9 = 0, are the number of bits that have been added to current_int, numBitsAdded
    mov r3, #0            @ r3 = 0, sum of all matching code sizes initialized to 0

    mov r0, #23
    str r0, [sp, #-4]!    @ initialize previousChar to not letter and store into stack memory

    mov r10, #32          @ r10 = numBitsToExamine = 32 bits

    mov r0, r4            @ r0 = encodedInt
    bl check_space        @ verifies whether or not there is a space as the first char in the integer packet
    @ r0 <- returns 0 if first char is not ' ', 2 if ' ' is the first char

    @ let r10 be "numBitsToExamine"
    cmp r0, #0            @ if first char is not ' ',
    beq whileLoop

    @ don't forget to store the space into d_message!!!!!!!!
    cmp r0, #2            @ if first char is ' ', r10 = numBitsToExamine = 28 bits
    moveq r4, r4, LSL #4  @ shift digits over by 4
    ldreq r1, [r6]        @ get index value in &current_char and store into r1
    addeq r1, r1, #1      @ ++index;
    streq r1, [r6]        @ store index back into &current_char


    whileLoop:
    @ convert int array => unsigned int
        cmp r10, #0
        beq endFunction            @ if r10 < 0 <- no more bits to examine, go to endFunction

        mov r0, #1                 @ r0 = 1
        sub r2, r10, #1
        mov r0, r0, LSL r2         @ shift #1 to the same position as the bit to be examined in the integer packet
        AND r0, r0, r4             @ r0 = encoded integer packet with just the bit being examined with the rest of the bits as zeroes

        cmp r3, #0
        movne r0, r0, LSL r3       @ r0 = current_int with all bits shifted to the left

        @ combine with previous encodedInt bits that have been examined to create a string of bits in the front of an int packet <- current_int,
        @ where remaining bits towards right are zeroes.  e.g., encodedInt is 1000 10110 1010 00 101111111110 00000, which represents the chars
        @ "the q"  <- "the quick brown fox jumps over the lazy dog. Apple, beauty, chair."
        @ r8 contains the current set of bits being examined from encodedInt, which is updated to include an additional bit if no huffman match found

        ORR r8, r8, r0             @ updates r8, current_int to include the next bit in encodedInt to be examined
        add r9, r9, #1             @ ++numBitsAdded

        str r9, [sp, #-4]!         @ call to search_hcode changes r9, numBitsAdded so need to store r9 temporarily onto the stack

        mov r2, r9                 @ r2 = numBitsAdded
        mov r0, r5                 @ r0 = &hcode[i]
        mov r1, r8                 @ r1 = current_int = set of bits being examined from encodedInt
        bl search_hcode            @ search_hcode(&hcode[i], current_int)
        @ r0 <- returns hcode index where huffman code is found or 29 if char not found in huffman code index


        ldr r9, [sp], #4          @ restore r9, numBitsAdded

        cmp r0, #29               @ branch to not char if there is not an equivalent char represented as a huffman code in the hcode[] array
        movlt r1, r9              @ copy numBitsAdded to r3 so r3 essentially contains the size of the last matching code
        addlt r3, r3, r1          @ r3 = sum of all matching code sizes
        bge not_found

        ldr r1, [r6]              @ get index value for d_message which is stored in &current_char and store into r1

        mov r2, #LTR_TO_NXT_LTR   @ r2 = 56
        mul r2, r2, r0            @ r2 = 56 * hcodeIndex, previous code thought search_hcode returns hcodeIndex into r0, this would create offset *****
        ldrb r2, [r5, r2]         @ r2 = hcode[i].letter, recall r5 is &hcode[0]

        ldrb r0, [sp]             @ r0 = previousChar

        cmp r2, #32               @ if current char is ' '
        bne skip1                 @ then examine previous char, otherwise go to skip1

        cmp r0, #32               @ if previous char is also ' ', then decrement d_message[]
        bne skip1                 @ otherwise go to skip1

        cmp r2, r0                @ compare current char and previous char, if both are char ' '
        subeq r1, r1, #1          @ then decrement d_message[] index
        streq r1, [r6]            @ store the decremented index back into &current_char
        beq   endFunction         @ go to end of function, since the end of the int packet has been reached

        skip1:

        cmp r2, #32               @ if current char is ' '
        bne skip2

        cmp r10, #2               @ if number of bits remaining to examine is 2 or less and current char is ' '<- #32
        ble endFunction           @ the int packet has been completed, so go to end function

        skip2:
        strb r2, [sp]             @ r2 = hcode[i].letter

        strb r2, [r7, r1]         @ d_message[index] = hcode[i].letter


        add r1, r1, #1            @ ++index;
        str r1, [r6]              @ store index back into &current_char

        sub r10, r10, #1          @ --numBitsToExamine;

        mov r8, #0                @ restore r8, current_int to 0
        mov r9, #0                @ reset numBitsAdded to 0
        b whileLoop

        not_found:
        sub r10, r10, #1          @ --numBitsToExamine;
        b whileLoop


endFunction:
    sub sp, fp, #4
    pop {fp, pc}
