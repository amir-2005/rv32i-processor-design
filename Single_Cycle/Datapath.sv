module Datapath (
    input clk, rst,
    input reg_write, alu_src, mem_write,
    input [2:0] imm_src, 
    input [3:0] alu_op,
    input [1:0] result_src, sel_pc_next,
    output zero, 
    output[31:0] inst_out
);

wire[31:0] pc_next, pc_current, pc_plus_4, inst;
wire[31:0] immediate, reg1, reg2, alu_2nd, alu_out;
wire[31:0] mem_out, reg_write_data, pc_plus_imm;
wire[31:0] four = 32'd4;
wire[31:0] GND = 0;
wire[31:0] pc_imm_addr = {alu_out[31:1] , 1'b0};

PC pc(clk, rst, pc_next, pc_current);
InstMem inst_mem(pc_current, inst);
RegFile reg_file(clk, rst, inst[19:15], inst[24:20], inst[11:7], reg_write_data, reg_write, reg1, reg2);
ImmExt imm_ext(inst, imm_src, immediate);
Mux2to1 mux1(reg2, immediate, alu_src, alu_2nd);
ALU alu(reg1, alu_2nd, alu_op, alu_out, zero);
DataMem data_mem(clk, mem_write, alu_out, reg2, mem_out);
Mux4to1 mux2(mem_out, alu_out, pc_plus_4, immediate, result_src, reg_write_data);
Adder adder1(immediate, pc_current, pc_plus_imm);
Adder adder2(pc_current, four, pc_plus_4);
Mux4to1 mux3(pc_plus_4, pc_plus_imm, pc_imm_addr, GND, sel_pc_next, pc_next);

assign inst_out = inst;

endmodule