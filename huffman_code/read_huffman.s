@ read_huffman.s
@ Method stores the huffman code generated into an hcode array of structs.
@ The hcode array is used for encoding and decoding regular text.
@
@ r0 <- fptr
@ r1 <- hcode array containing symbols, binary code encoding, and length of code encoding

.cpu cortex-a53
.fpu neon-fp-armv8

.equ LTR_TO_NXT_LTR, 56       @ memory distance from &hcode[i].letter to & hcode[i + 1].letter
.equ LTR_TO_CODE, 4           @ memory distance from &hcode[i].letter to &hcode[i].code[0]
.equ CODE_TO_CODE, 4          @ memory distance from &hcode[i].code[j] to &hcode[i].code[j + 1]
.equ LTR_TO_SIZE, 52          @ memory distance from &hcode[i].letter to &hcode[i].size

inp: .asciz "%c"

.text
.align 2
.global read_huffman
.type read_huffman, %function

read_huffman:
    push {fp, lr}        @ push the calling function frame pointer and the link register onto the stack
    add fp, sp, #4

    sub sp, sp, #4
    @r0 contains the file pointer, r1 contains the address to the huffcode

    mov r6, r0            @ fptr
    mov r4, #0            @ i = 0
    mov r7, r1            @ &hcode[0].letter
    mov r9, r1            @ &hcode[0].letter

whileLoop:                @ for (i = 0; i < 29; i++). r7 has hcode array address of 29 struct elements to store info in
    cmp r4, #29
    bge endFunction       @ branch to end function once finished with populating data for the 29 structs in the array of structs

    mov r5, #0            @ size = 0, size counts how many chars on the line, how many 0's and 1's, and as a counter variable -- so three purposes

    @ e.g., a 1001 <- where a is in char position 1, 1001 starts in char position 3, and there's a '\n' at the end of the line

    @ beginning of the do-while loop, used to scan each line
    doWhileLoop:
        @ scan each char into memory, lets call it char c
        mov r0, r6               @ move fptr into arg reg r0
        ldr r1, =inp             @ move "%c" into arg reg r1
        mov r2, sp               @ move memory, sp into arg reg r2
        bl fscanf                @ scan char and place into sp, memory

        @ if c == '\n' end do-while loop
        ldrb r0, [sp]
        cmp r0, #10
        beq endDoWhileLoop

        add r5, r5, #1           @ ++ size; because a char has been scanned

        @ if (size == 1) {hcode[i].letter = c;  // store character into memory}
        @ get to proper hcode[i]
        mov r1, #LTR_TO_NXT_LTR  @ LTR_TO_NXT_LTR is the offset from hcode[i].letter to hcode[i+1].letter

        mul r1, r1, r4           @ r1 = i * 56, to create offset from &hcode[0].letter to &hcode[i].letter, r4 <- i

        @ else-if (size != 1)  <- go to huffmanCode because its the huffman code being scanned
        cmp r5, #1
        bne huffmanCode

        @ ****store the character into hcode[i].letter****
        @ store the character into that location which is equivalent to hcode[i].letter
        strb r0, [r7, r1]     @ r7 is &hcode[0].letter, r1 is offset from &hcode[0].letter to &hcode[i].letter

        add r9, r7, r1        @ put in r9 &hcode[i].letter

        b doWhileLoop

    huffmanCode:              @ ****store the huffman code in hcode[i].code[0] to hcode[i].code[size]****
        @ code is a member array of the struct element in the hcode array
        @ size is the number of chars on the line so bitCharPosition = size - 3, allows for storage into hcode[i].code[j] array starting at index j = 0
        @ c - '0' gives either a 1 or a 0 as output
        @ else-if (size >= 3) {hcode[i].code[size - 3] = c - '0'}

        cmp r5, #3             @ if size < 3 go to endDoWhileLoop, skip 2nd space since # bits also starts at 3
        blt doWhileLoop

        @ recall r9 <- &hcode[i].letter, LTR_TO_CODE is the offset from &hcode[i].letter to &hcode[i].code[0]
        add r1, r9, #LTR_TO_CODE        @ r1 = &hcode[i].code[0]
        sub r2, r5, #3         @ r2 = size - 3 = j
        mov r3, #CODE_TO_CODE  @ r3 = offset from hcode[i].code[j] to hcode[i].code[j+1]
        mul r2, r2, r3         @ multiply j * 4 and store into r2 to create an offset from &hcode[i].code[0] to &hcode[i].code[whatever r2 is]
        add r2, r2, r1         @ add offset to r1 to go from &hcode[i].code[0] to &hcode[i].code[j]
        @ r0 <- contains char c stored into memory
        sub r0, r0, #'0'       @ gives either integer 1 if char c = '1' or integer 0 if char c = '0'
        str r0, [r2]           @ store char c as int into hcode[i].code[size - 3]

        b doWhileLoop


    endDoWhileLoop:           @ used to scan next line for next struct in the array of structs

    @ ****store the size in hcode[i].size****
    @ recall r9 <- &hcode[i].letter
    add r1, r9, #LTR_TO_SIZE    @ r1 = & hcode[i].size where LTR_TO_SIZE is offset from &hcode[i].letter to &hcode[i].size

    sub r2, r5, #2        @ r2 = size - 2
    str r2, [r1]          @ store size - 2 which is length of huffman code bits into hcode[i].size

    add r4,r4,#1          @ ++i;
    b whileLoop           @ branch back to while loop, to scan next line to populate next struct

endFunction:
    add sp, sp, #4
    sub sp, fp, #4
    pop {fp, pc}
