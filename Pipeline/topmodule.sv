module topmodule ( input clk , rst );
wire [31:0] instruction;
wire MemWriteD, RegWriteD, ALUSrcD, JumpD, BranchD, LuiD, JalrD;
wire [2:0] ImmSrcD;
wire [3:0] ALUControlD;
wire [1:0] ResultSrcD;
wire [6:0] opcode = instruction[6:0];
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];
wire [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW;
wire PCSrcE;
wire [1:0] ResultSrcE;
wire RegWriteM, RegWriteW, RegWriteE;
wire StallF, StallD, FlushD, FlushE;
wire [1:0] ForwardAE, ForwardBE;
wire PCSrcD;
  // Controller instance
  Controller controller_inst (
      .opcode(opcode),
      .funct3(funct3),
      .funct7(funct7),
      .reg_write(RegWriteD),
      .alu_src(ALUSrcD),
      .mem_write(MemWriteD),
      .imm_src(ImmSrcD),
      .alu_op(ALUControlD),
      .result_src(ResultSrcD), 
      .jalr(JalrD),
      .jump(JumpD),
      .branch_eq(BranchEQ_D),
      .branch_ne(BranchNE_D)
  );
  
  // Hazard Unit instance
  HazardUnit hazard_unit_inst (
	  .RegWriteE(RegWriteE),
      .RegWriteM(RegWriteM),
      .RegWriteW(RegWriteW),
      .ResultSrcE(ResultSrcE),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .Rs1E(Rs1E),
      .Rs2E(Rs2E),
      .RdE(RdE),
      .RdM(RdM),
      .RdW(RdW),
      .PCSrcE(PCSrcE),
      .StallF(StallF),
      .StallD(StallD),
      .FlushD(FlushD),
      .FlushE(FlushE),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE)
  );

  // DataPath instance
  datapath datapath_inst (
      .clk(clk),
      .rst(rst),
      .MemWriteD(MemWriteD),
      .RegWriteD(RegWriteD),
      .ALUSrcD(ALUSrcD),
      .JumpD(JumpD),
      .BranchEQ_D(BranchEQ_D),
      .BranchNE_D(BranchNE_D),
      .JalrD(JalrD),
      .StallD(StallD),
      .StallF(StallF),
      .FlushD(FlushD),
      .FlushE(FlushE),
      .ALUControlD(ALUControlD), 
      .ImmSrcD(ImmSrcD), 
      .ResultSrcD(ResultSrcD),
      .ForwardAE(ForwardAE),
      .ForwardBE(ForwardBE),
      .inst_out(instruction),
      .Rs1D(Rs1D),
      .Rs2D(Rs2D),
      .Rs1E(Rs1E),
      .Rs2E(Rs2E),
      .RdE(RdE),
      .RdM(RdM),
      .RdW(RdW),
      .PCSrcE(PCSrcE),
	  .RegWriteE(RegWriteE),
      .RegWriteM(RegWriteM),
      .RegWriteW(RegWriteW),
      .ResultSrcE(ResultSrcE)
  );

endmodule