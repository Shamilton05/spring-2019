@ sort_hcode.s
@ a bubble sort
@ r0 <- &hcode[0]

.cpu cortex-a53
.fpu neon-fp-armv8

.data
.equ LTR_TO_NXT_LTR, 56       @ memory distance from &hcode[i].letter to & hcode[i + 1].letter
.equ LTR_TO_CODE, 4           @ memory distance from &hcode[i].letter to &hcode[i].code[0]
.equ CODE_TO_CODE, 4          @ memory distance from &hcode[i].code[j] to &hcode[i].code[j + 1]
.equ LTR_TO_SIZE, 52          @ memory distance from &hcode[i].letter to &hcode[i].size
.equ CODE_TO_SIZE, 4          @ memory distance from &hcode[i].code[11] to &hcode[i].size

.text
.align 2
.global sort_hcode
.type sort_hcode, %function

sort_hcode:
    push {fp, lr}
    add fp, sp, #4

    mov r7, r0                              @ r7 = &hcode[0]
    mov r1, #0                              @ i = 0;

    outerWhileLoop:                         @ while (i < 28), only go to 1 before the end
        cmp r1, #28                         @ if i > 28 then branch to endFunction
        bge endFunction

        mov r3, #LTR_TO_NXT_LTR             @ r3 = 56, which is the offset from &hcode[i].letter to &hcode[i + 1].letter
        mul r3, r3, r1                      @ r3 = i * 56, which is the offset from &hcode[0].letter to &hcode[i].letter
        add r3, r3, #LTR_TO_SIZE            @ r3 = offset from &hcode[0].letter to &hcode[i].size
        mov r10, r3                         @ r10 = offset from &hcode[0].letter to &hcode[i].size
        ldr r3, [r7, r10]                   @ r3 = hcode[i].size

        add r2, r1, #1                      @ r2 = j = i + 1

        innerWhileLoop:                     @ while (j < 29)
            cmp r2, #29                     @ if j >= 29, then branch to outer while loop
            bge continue1

            mov r8, #LTR_TO_NXT_LTR         @ r8 = 56
            mul r8, r8, r2                  @ r8 = = j * 56 = offset from &hcode[0] to &hcode[j]
            add r8, r8, #LTR_TO_SIZE        @ r8 = offset from &hcode[0].letter to &hcode[j].size
            push {r8}                       @ sp updated, sp = offset from &hcode[0].letter to &hcode[j].size
            ldr r8, [r7, r8]                @ r8 = hcode[j].size

            cmp r3, r8                      @ if hcode[i].size > hcode[j].size then switch the structs
            bgt switchStructs

            add r2, r2, #1                  @ j++
            b innerWhileLoop                @ brances if hcode[i].size >= hcode[j].size

            switchStructs:
                ldr r8, [sp], #4            @ recall r8 from stack is offset from &hcode[0].letter to &hcode[j].size
                mov r3, r10                 @ recall r3 from stack is offset from &hcode[0].letter to &hcode[i].size

                @ switch letters
                sub r8, r8, #LTR_TO_SIZE    @ r8 = offset from &hcode[0].letter to &hcode[j].letter
                sub r3, r3, #LTR_TO_SIZE    @ r3 = offset from &hcode[0].letter to &hcode[i].letter
                @ recall r7 <- &hcode[0]

                ldrb r0, [r7, r3]           @ r0 = hcode[i].letter
                ldrb r9, [r7, r8]           @ r9 = hcode[j].letter
                strb r0, [r7, r8]           @ hcode[i].letter = hcode[j].letter
                strb r9, [r7, r3]           @ hcode[j].letter = hcode[i].letter

                @ switch codes
                add r3, r3, #LTR_TO_CODE    @ r3 = offset from &hcode[0].letter to &hcode[i].code[0]
                add r8, r8, #LTR_TO_CODE    @ r8 = offset from &hcode[0].letter to &hcode[j].code[0]

                ldr r0, [r7, r3]            @ r0 = hcode[i].code[0]
                ldr r9, [r7, r8]            @ r9 = hcode[j].code[0]
                str r0, [r7, r8]            @ hcode[j].code[0] = hcode[i].code[0]
                str r9, [r7, r3]            @ hcode[i].code[0] = hcode[j].code[0]

                mov r6, #1                  @ r6 = loop counter, say n = 1;
                switchCodesLoop:            @ while (n < 12)

                    cmp r6, #12             @ if n >= 12 branch to continue2
                    bge continue2

                    add r3, r3, #CODE_TO_CODE   @ r3 = offset from &hcode[0].letter to &hcode[i].code[n] to &hcode[i].code[n + 1]
                    add r8, r8, #CODE_TO_CODE   @ r8 = offset from &hcode[0].letter to &hcode[j].code[n] to &hcode[j].code[n + 1    ]

                    ldr r0, [r7, r3]        @ r0 = hcode[i].code[0]
                    ldr r9, [r7, r8]        @ r9 = hcode[j].code[0]
                    str r0, [r7, r8]        @ hcode[j].code[0] = hcode[i].code[0]
                    str r9, [r7, r3]        @ hcode[i].code[0] = hcode[j].code[0]

                    @ for debugging
                    ldr r0, [r7, r3]        @ r0 = hcode[i].code[0]
                    ldr r9, [r7, r8]        @ r9 = hcode[j].code[0]

                    add r6, r6, #1          @ ++n;

                    b switchCodesLoop

                continue2:

                @ switch sizes
                add r8, r8, #CODE_TO_SIZE   @ r8 = offset from &hcode[0].code[11] to &hcode[j].size
                add r3, r3, #CODE_TO_SIZE   @ r3 = offset from &hcode[0].code[11] to &hcode[i].size
                ldr r0, [r7, r3]            @ r0 = hcode[i].size
                ldr r9, [r7, r8]            @ r9 = hcode[j].size
                str r0, [r7, r8]            @ hcode[j].size = hcode[i].size
                str r9, [r7, r3]            @ hcode[i].size = hcode[j].size

                add r2, r2, #1              @ j++
                ldr r3, [r7, r10]           @ restore r3 to r3 = hcode[i].size after switching structs
                b innerWhileLoop            @ branch back to continue comparing hcode[i].size to hcode[j + 1].size


            continue1:
            add r1, r1, #1                  @ ++i;
            b outerWhileLoop

endFunction:
        sub sp, fp, #4
        pop {fp, pc}



