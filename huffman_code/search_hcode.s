@ search_hcode.s
@ This function compares the current_int with the huffman codes in the hcode[] array and returns the index
@ location if found, otherwise returns 29 for not found.
@
@ r0 <- &hcode[0].letter
@ r1 <- current_int
@ r2 <- numBitsAdded, the number of bits being examined so far
@
@ Returns 29 if the current_int doesn't match any huffman codes in the hcode[] array
@ Otherwise returns index of the huffman code containing the decoded letter

.cpu cortex-a53
.fpu neon-fp-armv8

.data

.equ MAX_LT_SHIFT, 31         @ the maximum number of times the first bit can be shifted to the left is 31 times to get to the 32nd bit position
.equ LTR_TO_SIZE, 52          @ memory distance from &hcode[i].letter to &hcode[i].size
.equ LTR_TO_CODE, 4           @ memory distance from &hcode[i].letter to &hcode[i].code[0]
.equ LTR_TO_NXT_LTR, 56       @ memory distance from &hcode[i].letter to & hcode[i + 1].letter

.text
.align 2
.global search_hcode
.type search_hcode, %function

search_hcode:
    push {fp, lr}
    add fp, sp, #4
    push {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10}         @ store all register values onto the stack

    @ r0 <- &hcode[0].letter
    @ r1 <- current_int
    @ r2 <- numBitsAdded, the number of bits being examined so far


    mov r8, r1                     @ r8 = current_int
    mov r7, r0                     @ r1 = &hcode[0].letter
    str r2, [sp, #-4]!             @ sp = numBitsAdded

    mov r4, #0                     @ i = 0;
    outerWhileLoop:

        cmp r4, #29                @ if i = hcode index = 29
        moveq r0, r4               @ return 29 meaning not an equivalent char found in hcode[]
        beq endFunction            @ go to endFunction

        mov r5, #LTR_TO_NXT_LTR    @ r5 = 56
        mul r6, r4, r5             @ r6 = offset from &hcode[0].letter to &hcode[i].letter
        mov r1, r6                 @ r1 = offset from &hcode[0].letter to &hcode[i].letter
        add r1, r7, r1             @ r1 = &hcode[i].letter
        add r5, r6, #LTR_TO_SIZE   @ r5 = offset from &hcode[0].letter to &hcode[i].size
        add r6, r6, #LTR_TO_CODE   @ r6 = offset from &hcode[0].letter to &hcode[i].code

        ldr r2, [r7,r5]            @ r2 = hcode[i].size

        ldr r5, [sp]               @ r5 = numBitsAdded
        cmp r2, r5                 @ only examine hcode[i] struct if numBitsAdded == hcode[i].size
        addne r4, r4, #1           @ otherwise ++i
        bne outerWhileLoop         @ and examine next struct

        ldr r3, [r7, r6]           @ r3 = hcode[i].code[0]

        mov r5, r1                 @ r5 = &hcode[i].letter


        mov r1, #0                 @ j = 0;
        mov r9, #MAX_LT_SHIFT      @ r9 = maximum number of bits that the first bit can be shifted to the left = 31

        mov r10, #0                @ r10 = 0;

        @ loop creates an int containing only the .code portion bits of hcode[i] being looked at, with the codes in the front of the packet
        @ e.g. for 'a' with huffman code 1001, the result in r10 would be 1001 0000 0000 0000 0000 0000 0000 0000
        innerWhileLoop:            @ while (j < hcode[i].size)
            cmp r1, r2             @ if j >= hcode[i].size
            bge checkBits          @ go to end function

            mov r0, #4             @ r0 = 4
            mul r0, r1, r0         @ r0 = j * 4 = offset for &hcode[i].code[0] to &hcode[i].code[j]
            add r0, r0, #4         @ need to add 4 here to get to the .code section
            ldr r0, [r5, r0]       @ r0 = hcode[i].code[j]

            mov r0, r0, LSL r9     @ left shift value stored at hcode[i].code[j] according to bitPosition
            ORR r10, r10,  r0      @ combine with r10, which started at 0 (32 zeroes) to create an int containing the hcode[i].code[0 to j] bits in the right positions
            sub r9, r9, #1         @ --bitPosition;
            add r1, r1,#1          @ ++i;

            b innerWhileLoop

        checkBits:
            @ recall r8 contains current_int being checked
            eor r1, r10, r8      @ exclusive-or huffmanCode (bits to far left in 32 bit packet) with current_int, if same bits 0, if different bits 1
            cmp r1, #0
            addne r4, r4, #1     @ ++i;   for checking next hcode
            bne outerWhileLoop   @ branch back up to outerWhileLoop to check next hcode

            moveq r0, r4         @ if r1 is 1, return hcode index
            beq endFunction

endFunction:
        add sp, sp, #4
        pop {r1, r2, r3, r4, r5, r6, r7, r8, r9, r10}            @ restore all register values
        sub sp, fp, #4
        pop {fp, pc}
