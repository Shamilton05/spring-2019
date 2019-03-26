.cpu cortex-a53
.fpu neon-fp-armv8 
.text 
.align 2 
.global modulo 
.type modulo, %function 
modulo: mov r10, lr 
udiv r2, r0, r1 
mul r2, r2, r1 
sub r0, r0, r2 
mov lr, r10 
bx lr
