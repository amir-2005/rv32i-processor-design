module Controller (
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input zero,                    
    output reg reg_write,
    output reg alu_src,
    output reg mem_write,
    output reg [2:0] imm_src,
    output reg [3:0] alu_op,
    output reg [1:0] result_src,
    output reg [1:0] sel_pc_next
);

localparam [6:0]
    R_TYPE = 7'b0110011,
    I_TYPE_ALU = 7'b0010011,
    I_TYPE_LOAD = 7'b0000011,
    I_TYPE_JALR = 7'b1100111,
    S_TYPE = 7'b0100011,
    B_TYPE = 7'b1100011,
    J_TYPE = 7'b1101111,
    U_TYPE = 7'b0110111;

localparam [2:0] 
    IMM_I = 3'b000,
    IMM_S = 3'b001, 
    IMM_B = 3'b010,
    IMM_U = 3'b011,
    IMM_J = 3'b100;

localparam [3:0]
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b0001,
    ALU_AND  = 4'b0010,
    ALU_OR   = 4'b0011,
    ALU_XOR  = 4'b0100,
    ALU_SLT  = 4'b0101,
    ALU_SLTU = 4'b0110,
    ALU_SLL  = 4'b0111,
    ALU_SRL  = 4'b1000,
    ALU_SRA  = 4'b1001;
    ALU_INA  = 4'b1010;
    ALU_INB  = 4'b1011;

localparam [1:0]
    PC_PLUS4 = 2'b00,
    PC_JUMP = 2'b01,
    PC_JALR = 2'b10;

localparam [1:0]
    RESULT_MEM = 2'b00,
    RESULT_ALU = 2'b01,
    RESULT_PC4 = 2'b10,
    RESULT_IMM = 2'b11;

wire branch_taken;
assign branch_taken = (opcode == B_TYPE) && ((funct3 == 3'b000 && zero) || (funct3 == 3'b001 && !zero));

always @(*) begin
    reg_write = 1'b0;
    alu_src = 1'b0;
    mem_write = 1'b0;
    imm_src = IMM_I;
    alu_op = ALU_ADD;
    result_src = RESULT_ALU;
    sel_pc_next = PC_PLUS4;

    case (opcode)

        R_TYPE: begin
            reg_write = 1'b1;
            alu_src = 1'b0;
            mem_write = 1'b0;
            result_src = RESULT_ALU;
            sel_pc_next = PC_PLUS4;
            
            case (funct3)
                3'b000: alu_op = (funct7 == 7'b0100000) ? ALU_SUB : ALU_ADD;
                3'b111: alu_op = ALU_AND;
                3'b110: alu_op = ALU_OR;
                3'b010: alu_op = ALU_SLT;
            endcase
        end

        I_TYPE_ALU: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_write = 1'b0;
            imm_src = IMM_I;
            result_src = RESULT_ALU;
            sel_pc_next = PC_PLUS4;
            
            case (funct3)
                3'b000: alu_op = ALU_ADD;  
                3'b100: alu_op = ALU_XOR;  
                3'b110: alu_op = ALU_OR;  
                3'b010: alu_op = ALU_SLT;
                3'b001: alu_op = ALU_SLL;   // Extra !
            endcase
        end

        I_TYPE_LOAD: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_write = 1'b0;
            imm_src = IMM_I;
            alu_op = ALU_ADD;
            result_src = RESULT_MEM;
            sel_pc_next = PC_PLUS4;
        end

        S_TYPE: begin
            reg_write = 1'b0;
            alu_src = 1'b1;
            mem_write = 1'b1;
            imm_src = IMM_S;
            alu_op = ALU_ADD;
            result_src = RESULT_ALU;
            sel_pc_next = PC_PLUS4;
        end

        B_TYPE: begin
            reg_write = 1'b0;
            alu_src = 1'b0;
            mem_write = 1'b0;
            imm_src = IMM_B;
            alu_op = ALU_SUB;
            result_src = RESULT_ALU;
            
            if (branch_taken) begin
                sel_pc_next = PC_JUMP;
            end 
        end

        J_TYPE: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_write = 1'b0;
            imm_src = IMM_J;
            alu_op = ALU_ADD;
            result_src = RESULT_PC4;
            sel_pc_next = PC_JUMP;
        end

        I_TYPE_JALR: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_write = 1'b0;
            imm_src = IMM_I;
            alu_op = ALU_ADD;
            result_src = RESULT_PC4;
            sel_pc_next = PC_JALR;
        end

        U_TYPE: begin
            reg_write = 1'b1;
            alu_src = 1'b1;
            mem_write = 1'b0;
            imm_src = IMM_U;
            result_src = RESULT_IMM;
            sel_pc_next = PC_PLUS4;
        end

    endcase
end

endmodule