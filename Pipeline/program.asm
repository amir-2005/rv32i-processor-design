addi t0, zero, 0
addi t1, zero, 36
lw t2, 0(t0)
beq t0, t1, 7
addi t0, t0, 4
lw t3, 0(t0)
slt t4, t3, t2
beq t4, zero, 2
add t2, zero, t3
jal rd -6
sw t2, 8(t1)
jalr rd zero 11