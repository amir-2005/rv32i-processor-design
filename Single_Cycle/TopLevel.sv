module TopLevel (
    input clk, rst
);

wire [31:0] instruction;
wire reg_write, alu_src, mem_write;
wire [2:0] imm_src;
wire [3:0] alu_op;
wire [1:0] result_src, sel_pc_next;
wire zero;

wire [6:0] opcode = instruction[6:0];
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];

Datapath datapath (
    .clk(clk),
    .rst(rst),
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_write(mem_write),
    .imm_src(imm_src),
    .alu_op(alu_op),
    .result_src(result_src),
    .sel_pc_next(sel_pc_next),
    .zero(zero),
    .inst_out(instruction)
);

Controller controller (
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .zero(zero),                   
    .reg_write(reg_write),
    .alu_src(alu_src),
    .mem_write(mem_write),
    .imm_src(imm_src),
    .alu_op(alu_op),
    .result_src(result_src),
    .sel_pc_next(sel_pc_next)
);

endmodule