# RISC-V RV32I assembler to machine code converter from string input
reg = {
    'zero': 0, 'ra': 1, 'sp': 2, 'gp': 3, 'tp': 4, 's0':8, 's1':9, 'a0':10, 'a1':11,
    't0': 5, 't1': 6, 't2': 7, 't3': 28, 't4': 29, 't5': 30, 't6': 31
}

# --- convenience: your example uses 'rd' as a token; map it to 'ra' to avoid KeyError.
# If you prefer a different behavior, change/remove this.
reg['rd'] = reg['ra']  # map 'rd' -> x1 (ra)

# Your assembly instructions as a string
asm_code = """
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
"""

# Parse the instructions into a list of tuples
instructions = []
for line in asm_code.strip().splitlines():
    line = line.split('#')[0].strip()  # remove comments
    if not line:
        continue
    parts = line.replace(',', '').split()
    op = parts[0]

    if op == 'lui':
        instructions.append((op, parts[1], int(parts[2], 0)))
    elif op in ['addi', 'slli']:
        instructions.append((op, parts[1], parts[2], int(parts[3], 0)))
    elif op in ['add', 'slt']:
        instructions.append((op, parts[1], parts[2], parts[3]))
    elif op in ['lw', 'sw']:
        if '(' in parts[2]:  # lw/sw offset(base)
            imm, rs1 = parts[2].replace(')', '').split('(')
            instructions.append((op, parts[1], int(imm, 0), rs1))
        else:
            instructions.append((op, parts[1], int(parts[2], 0), parts[3]))
    elif op in ['beq', 'bne']:
        instructions.append((op, parts[1], parts[2], int(parts[3], 0)))
    elif op == 'jal':
        # jal rd, offset  -- offset given in 'instruction counts' like your beq usage
        instructions.append((op, parts[1], int(parts[2], 0)))
    else:
        raise ValueError("Unknown instruction in parse: " + op)

# Encoder function
def encode(instr):
    op = instr[0]
    if op == 'lui':
        rd = reg[instr[1]]
        imm = instr[2] & 0xfffff
        return (imm << 12) | (rd << 7) | 0b0110111
    elif op == 'addi':
        rd = reg[instr[1]]
        rs1 = reg[instr[2]]
        imm = instr[3] & 0xfff
        return (imm << 20) | (rs1 << 15) | (0b000 << 12) | (rd << 7) | 0b0010011
    elif op == 'slli':
        rd = reg[instr[1]]
        rs1 = reg[instr[2]]
        shamt = instr[3] & 0x1f
        return (0b0000000 << 25) | (shamt << 20) | (rs1 << 15) | (0b001 << 12) | (rd << 7) | 0b0010011
    elif op == 'slt':
        rd = reg[instr[1]]
        rs1 = reg[instr[2]]
        rs2 = reg[instr[3]]
        return (0b0000000 << 25) | (rs2 << 20) | (rs1 << 15) | (0b010 << 12) | (rd << 7) | 0b0110011
    elif op == 'add':
        rd = reg[instr[1]]
        rs1 = reg[instr[2]]
        rs2 = reg[instr[3]]
        return (0b0000000 << 25) | (rs2 << 20) | (rs1 << 15) | (0b000 << 12) | (rd << 7) | 0b0110011
    elif op == 'lw':
        rd = reg[instr[1]]
        imm = instr[2] & 0xfff
        rs1 = reg[instr[3]]
        return (imm << 20) | (rs1 << 15) | (0b010 << 12) | (rd << 7) | 0b0000011
    elif op == 'sw':
        rs2 = reg[instr[1]]
        imm = instr[2] & 0xfff
        rs1 = reg[instr[3]]
        imm_11_5 = (imm >> 5) & 0x7f
        imm_4_0 = imm & 0x1f
        return (imm_11_5 << 25) | (rs2 << 20) | (rs1 << 15) | (0b010 << 12) | (imm_4_0 << 7) | 0b0100011
    elif op in ['beq', 'bne']:
        rs1 = reg[instr[1]]
        rs2 = reg[instr[2]]
        offset = instr[3] * 4  # offset in bytes (consistent with your example)
        # create B-type immediate fields from offset
        imm12 = (offset >> 12) & 1
        imm10_5 = (offset >> 5) & 0x3f
        imm4_1 = (offset >> 1) & 0xf
        imm11 = (offset >> 11) & 1
        opcode = 0b1100011
        funct3 = 0b000 if op == 'beq' else 0b001
        return (imm12 << 31) | (imm11 << 7) | (imm10_5 << 25) | (imm4_1 << 8) | (rs2 << 20) | (rs1 << 15) | (funct3 << 12) | opcode
    elif op == 'jal':
        rd = reg[instr[1]]
        # interpret the assembly immediate like your beq: argument is number of instructions -> *4 bytes
        offset = instr[2] * 4  # offset in bytes, can be negative
        # J-type immediate is 21 bits (imm[20|10:1|11|19:12]) and the encoded value is imm << 1
        # We need two's complement representation for negative offsets: mask to 21 bits
        imm21 = offset & ((1 << 21) - 1)  # keep lower 21 bits
        imm20 = (imm21 >> 20) & 0x1
        imm10_1 = (imm21 >> 1) & 0x3ff
        imm11 = (imm21 >> 11) & 0x1
        imm19_12 = (imm21 >> 12) & 0xff
        opcode = 0b1101111
        return (imm20 << 31) | (imm10_1 << 21) | (imm11 << 20) | (imm19_12 << 12) | (rd << 7) | opcode
    else:
        raise ValueError("Unknown instruction: " + op)

# Generate machine code
machine_code = [encode(inst) for inst in instructions]

# Print in binary with addresses
for addr, code in enumerate(machine_code):
    print(f"{code:032b}")
