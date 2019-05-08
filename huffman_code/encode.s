@ encode.s
@ Method will encode the message contained in the char array message[10000]
@ and place the message into the char array encoded_message[60000].
@
@ r0 <- contains &message[0] array address
@ r1 <- contains &hcode[0] array of structs address containing the hcode

.cpu cortex-a53
.fpu neon-fp-armv8

.data

.equ LTR_TO_NXT_LTR, 56       @ memory distance from &hcode[i].letter to & hcode[i + 1].letter
.equ LTR_TO_CODE, 4           @ memory distance from &hcode[i].letter to &hcode[i].code[0]
.equ CODE_TO_CODE, 4          @ memory distance from &hcode[i].code[j] to &hcode[i].code[j + 1]
.equ LTR_TO_SIZE, 52          @ memory distance from &hcode[i].letter to &hcode[i].size
.equ MEMORY, 4                @ memory distance in array, in this case, from &message[i] to &message[i + 1]
.equ BITS_IN_INT, 32          @ each int is 32 bits
.equ BYTE, 1                  @ a single byte
.equ MAX_LOWER_CASE, 122      @ integer value for 'z'
.equ MIN_LOWER_CASE, 97       @ integer value for 'a'
.equ MAX_UPPER_CASE, 90       @ integer value for 'Z'
.equ MIN_UPPER_CASE, 65       @ integer value for 'A'

checkOutput: .asciz "%u\n"    @ USED FOR DEBUGGING

.text
.align 2

.global encode
.type encode, %function

encode:
    push {fp, lr}
    add fp, sp, #4
    @ use the stack to store strlen(message) (@sp + 12), &hcode[current].letter (@sp+8), &hcode[current].code[0] (@sp +4), &hcode[current].size (@sp)
    sub sp, sp, #16

    @ r0 -> &message[0]
    @ r1 -> &hcode[0]

    mov r4, r0    @ put &message[0] into r4
    mov r5, r1    @ put &hcode[0] into r5
    mov r6, #0    @ c_data compressed data
    mov r7, #32   @ counter to add to 32 bits for a number
    mov r10, #0   @ i loop index

    mov r0, r4    @ put &message[0] into arg reg r0 to get length of the message
    bl strlen     @ r0 <- return value will contain message length

    str r0, [sp, #12]     @ string length pushed onto stack

    outerWhileLoop:
        ldr r0, [sp, #12]        @ loads in strlen into arg reg r0

        cmp r10, r0              @ i < strlen(message)
        beq endFunction

        @ char c = message[i].letter
        mov r0, #BYTE
        mul r0, r10, r0          @ r0 = i * 1 for offset from &message[i] to &message[i + 1]
        ldrb r1, [r4, r0]        @ ***********c = r1 = message[i] **************

        @ ***Based on current char in message, get index for hcode array <- hcodeIndex***

        @**for upper case A-Z**
        @ if c >= 65 && c <= 90, c is an uppercase char A - Z
        @ if the char c < 65, not an alpha so branch to alpha
        @ chars less than 65 are '.' <- 46, '?' <- 63, ' ' <- 32, '!' <- 33, ',' <- 44
        cmp r1, #MIN_UPPER_CASE
        blt notAlpha

        @ if char c <= 90, then relative to the above step, char c is upper case so change to lowercase and branch to encoding
        cmp r1, #MAX_UPPER_CASE
        addle r1, r1, #32             @ replace uppercase letter with equivalent lowercase letter
        suble r2, r1, #MIN_LOWER_CASE @ hcodeIndex = r2 = c - a, for the hcode array
        ble encoding


        @ **for lower case a-z**
        @ if c >= 97 && c <= 122 , c is a lowercase char a-z
        cmp r1, #MIN_LOWER_CASE      @ relative to the above steps, if char c < 97 then its not a char
        blt notAlpha

        cmp r1, #MAX_LOWER_CASE      @ relative to the above steps, if char c <= 122 then its lowercase
        suble r2, r1, #MIN_LOWER_CASE @ hcodeIndex = r2 = c - a, for the hcode array
        ble encoding

        cmp r1, #MAX_LOWER_CASE      @ relative to the above steps, if char c > 122 then its not alpha
        bgt notAlpha

        notAlpha:
            cmp r1, #46          @ '.' <- #46
            bne notAlpha1        @ if c != '.' then branch to the next possible char

            mov r2, #26          @ else, c == '.' or '!' or '?' then branch to encoding and use index #26 for hcode array
            b encoding

        notAlpha1:
            cmp r1, #33          @ '!' <- #33
            bne notAlpha2        @ if c != '!' then branch to next possible char

            mov r2, #26          @ else, c == '.' or '!' or '?' then branch to encoding and use index #26 for hcode array
            b encoding

        notAlpha2:
            cmp r1, #63          @ '?' <- #63
            bne notAlpha3        @ if c != '?' then branch to next possible char

            mov r2, #26          @ else, c == '.' or '!' or '?' so branch to encoding and use index #26 for hcode array
            b encoding

        notAlpha3:
            cmp r1, #32          @ ' ' <- #32
            bne notAlpha4        @ if c != ' ' then branch to next possible char

            mov r2, #27          @ else c == ' ' so branch to encoding and use index #27 for hcode array
            b encoding

        notAlpha4:
            cmp r1, #44          @ ',' <- #44
            bne continue         @ if c != ',' then branch to continue statement

            mov r2, #28          @ else c == ',' so branch to encoding and use index #28 for hcode array
            b encoding

        continue:

        add r10, r10, #1         @ ++i; r10 <- i index for message[i]

        encoding:
            @ get &hcode[hcodeIndex].letter, &hcode[hcodeIndex].code[0], &hcode[hcodeIndex].size
            mov r0, #LTR_TO_NXT_LTR   @ r0 <- offset from &hcode[i].letter to &hcode[i + 1].letter
            mul r0, r2, r0            @ r0 = hcodeIndex * 56, offset from &hcode[0].letter to &hcode[i].letter
            add r8, r5, r0            @ r8 = &hcode[hcodeIndex].letter
            str r8, [sp, #8]          @ sp + 8 contains &hcode[hcodeIndex].letter        *******
            mov r9, r8                @ r9 = &hcode[i].letter, copy address from r8 to r9
            add r8, r8, #LTR_TO_SIZE  @ r8 = &hcode[hcodeIndex].size
            str r8, [sp]              @ sp contains &hcode[hcodeIndex].size  *********
            add r9, r9, #LTR_TO_CODE  @ r9 = &hcode[i].code[0]
            str r9, [sp, #4]          @ sp + 4 contains &hcode[hcodeIndex].code[0]      *********

            ldr r1, [sp]              @ r1 = &hcode[i].size, recall r5 <- &hcode[0] which is same as &hcode[0].letter
            ldr r1, [r1]              @ r1 = hcode[i].size

            cmp r1, r7           @ if(hcode[i].size <= counter)
            blle skip2            @ go to skip2: --meaning the 32 bit number/packet is not yet completed

            @***Send data***       @ else send data
            @ r3 <- huffman code represented as a # shifted (counter - hcode[i].size) bits left
            cmp r3, #0             @ if the last huffman code ORR with c_data represents char ' ', then set counter to 28, else set counter to 32
            @ this allows the proper space between int packets to be in the front of the next packet represented as the first 4 zeroes
            movne r7, #BITS_IN_INT @ reset 32-bits in total counter to 32 bits total
            moveq r7, #28
            @ send data code     ???? need to add lines of code here to send data ??????


            @ FOR DEBUGGING
            str r0, [sp, #-4]!
            str r1, [sp, #-4]!

            mov r1, r6            @ r1 = number/packet as an int
            ldr r0, =checkOutput
            bl printf

            ldr r1, [sp], #4
            ldr r0, [sp], #4
            @ END DEBUGGING

            mov r6, #0           @ c_data = 0, reset compressed data to 00...00 that is 32 0 bits

            skip2:

            @ hcode[index].code (consists of 0 and 1s)
            mov r3, #0           @ unsigned int, uint temp = 0;
            mov r0, #0           @ int j = 0;   loop counter

        @***Get huffman code and store it in r3 as a single integer***
        @ e.g., a 1001 <- so 'a' would be stored in r3 as integer 9 which is 1001 in binary
            innerWhileLoop:
                cmp r0, r1           @ if j < hcode[index].size, r0 <- j, r1 <- hcode[index].size
                bge combineHuffCompressedData    @ finished examining huffman code for current char

                @***collect hcode[index].code[j]*** as a single integer
                @ set temp = temp | hcode[i].code[j] << j

                ldr r8, [sp, #4]         @ r8 = &hcode[hcodeIndex].code[0]
                mov r9, #MEMORY          @ r9 = 4
                mul r9, r0, r9           @ r9 = j * 4 for offset from &hcode[i].code[0] to &hcode[i].code[j]
                add r8, r8, r9           @ r8 = &hcode[i].code[j]

                ldr r8, [r8]             @ r8 = hcode[i].code[j] which is going to be number 1 or 0, using code array like storing single binary digits

                @ since r8 = int of either 1 or 0 so either 00...01 or 00...00, for 32 bits in total

                mov r3, r3, LSL #1   @ (temp << 1) left shift temp by 1 spot to make room for the next bit from hcode[hcodeIndex].code[j]
                ORR r3, r3, r8       @ temp | ( hcode[hcodeIndex].code[j] << j ), ***essentially recreating the code as a single number for that char
                add r0, r0, #1       @ ++j;

                b innerWhileLoop     @ continue the process until the number is recreated from the code, like going from binary to a single number

        @***Combine huffman code with c_data <- compressed data***
        @ essentially take the binary code above and shift it as far left as possible according to the remaining bit counter
        @ this will create a new integer representation of a set of huffman codes combined into 1 integer
        combineHuffCompressedData:

            ldr r8, [sp]         @ r8 = &hcode[hcodeIndex].size
            ldr r8, [r8]         @ r8 = hcode[hcodeIndex].size
            mov r9, r8           @ copy hcode[hcodeIndex].size into r9

            @ subtract size of huffman code from total bit length, store answer into r8, recall r7 <- total bit counter
            sub r8, r7, r8       @ r8 = (counter - hcode[index].size)
            @ left shift the integer by the remaining bits left in counter
            mov r3, r3, LSL r8   @ temp << (counter - hcode[index].size)
            @ combine those bits with the compressed data to transmit so far
            ORR r6, r6, r3       @ c_data = c_data | temp;
            @ reduce the total number of bits remaining originally from 32 bits from the counter
            sub r7, r7, r9       @ counter = counter - hcode[index].size;

        add r10, r10, #1         @ ++i;
        b outerWhileLoop

endFunction:
    @ send last data packet
    @ send data code     ???? need to add lines of code here to send data ??????

    @ FOR DEBUGGING
    mov r1, r6            @ r1 = number/packet as an int
    ldr r0, =checkOutput
    bl printf
    @ END DEBUGGING

    add sp, sp, #16
    sub sp, fp, #4
    pop {fp, pc}
