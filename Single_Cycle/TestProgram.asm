addi a1, zero, 20
addi s0, zero, 0
slli a1, a1, 2
slt t0, s0, a1
beq t0, zero, 13
addi s1, s0, 4
slt t1, s1, a1
beq t1, zero, 9
lw t2, 0(s0)
lw t3, 0(s1)
slt t4, t3, t2
beq t4, zero, 3
sw t3, 0(s0)
sw t2, 0(s1)
addi s1, s1, 4
jal rd -9
addi s0, s0, 4
jal rd -14
jal rd 0