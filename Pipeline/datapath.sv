module datapath(
	input clk, rst, MemWriteD, RegWriteD, ALUSrcD, JumpD, BranchNE_D, BranchEQ_D, JalrD, StallD, StallF,
	FlushD, FlushE, input [3:0] ALUControlD, input [2:0] ImmSrcD,
	input [1:0] ResultSrcD, ForwardAE, ForwardBE,
	output [31:0] inst_out, output wire [4:0] Rs1D,Rs2D,Rs1E,Rs2E,RdE,RdM,RdW,
	output wire PCSrcE, RegWriteM, RegWriteE, RegWriteW, output wire [1:0] ResultSrcE
);
	
	wire [31:0] InstrD, PCD; 
    wire [31:0] SrcBE;
    wire [31:0] PCF,PCF_next;
	assign inst_out = InstrD;
    wire [31:0] WriteDataE, PCTargetE;
    wire [31:0] PCPlus4F;
    wire [31:0] InstrF;
    wire JalrE, MemWriteE, JumpE, BranchNE_E, BranchEQ_E, ALUSrcE;
    wire [31:0] RD1D,RD2D;
    wire [31:0] ResultW;
    wire [4:0] RdD;
    assign Rs1D = InstrD [19:15];
    assign Rs2D = InstrD [24:20];
    assign RdD  = InstrD [11:7];
    wire [3:0] ALUControlE;
    wire [31:0] RD1E, RD2E, PCE, PCPlus4E;
    wire [31:0] ALUResultM,SrcAE; 
    wire [31:0] ALUResultE;
    wire [31:0] ReadDataM, PCPlus4M;
    wire MemWriteM;
    wire [1:0] ResultSrcM;
    wire [31:0] WriteDataM;
    wire [31:0] ALUResultW, ReadDataW, PCPlus4W;
    wire  MemWriteW;
    wire [1:0] ResultSrcW;
    wire [31:0] PCPlus4D;
    wire [31:0] ImmExtD, ImmExtE, ImmExtM, ImmExtW;
    wire [31:0] PCJumpAddress;
    wire AcceptBranch;
	wire [31:0] four = 32'd4;
	wire [31:0] GND = 32'b0;
	wire zero;

	Mux2to1 Jalr_mux(
        .in1(PCTargetE),
        .in2(ALUResultE),
        .sel(JalrE),
        .out(PCJumpAddress)
    );

	Mux2to1 muxPC(
        .in1(PCPlus4F),
        .in2(PCJumpAddress),
        .sel(PCSrcE),
        .out(PCF_next)
    );
	
    PC registerPC(
        .clk(clk),
        .rst(rst),
        .pause(StallF),
        .next(PCF_next),
        .current(PCF)
    );	

    InstMem instrMem(
        .addr(PCF),
        .out(InstrF)
    );
	
    Adder adderPC(
        .in1(PCF),
        .in2(four),
        .out(PCPlus4F)
    );	

    FetchRegister fetch_register(
        .clk(clk),
        .pause(StallD),
        .rst(rst),
		.clear(FlushD),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F),
        .InstrD(InstrD),        
        .PCD(PCD),       
        .PCPlus4D(PCPlus4D)   
    );
	
    RegFile registerFile(
        .clk(clk),
        .rst(rst),
        .rdreg1(Rs1D),
        .rdreg2(Rs2D),
        .wreg(RdW),
        .wdata(ResultW),
        .we(RegWriteW),
        .rdata1(RD1D),
        .rdata2(RD2D)
    );
	
	ImmExt extend(
        .instruction(InstrD),
        .imm_src(ImmSrcD),
        .imm_out(ImmExtD)
    );
	
    DecodeRegister decode_register (
        
        .clk(clk),
        .rst(rst),
		.clear(FlushE),
        .JalrD(JalrD), 
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD), 
        .BranchEQ_D(BranchEQ_D),
		.BranchNE_D(BranchNE_D),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .PCD(PCD),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),

        //output wires
        .JalrE(JalrE),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchEQ_E(BranchEQ_E),
        .BranchNE_E(BranchNE_E),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E)
    );
	
    Mux4to1 Forwarding_A (
        .in1(RD1E),
        .in2(ResultW),
        .in3(ALUResultM),
        .in4(GND),
        .sel(ForwardAE), 
        .out(SrcAE)
    );

    Mux4to1 Forwarding_B (
        .in1(RD2E),	
        .in2(ResultW),
        .in3(ALUResultM),
        .in4(GND),
        .sel(ForwardBE), 
        .out(WriteDataE)
    );
	

	
	Mux2to1 SrcB_selector(
        .in1(WriteDataE),
        .in2(ImmExtE),
        .sel(ALUSrcE),
        .out(SrcBE)
    );
	
    Adder adderPCTarget(
        .in1(PCE),
        .in2(ImmExtE),
        .out(PCTargetE)
    );
	
    ALU alu(
        .src1(SrcAE),
        .src2(SrcBE),
        .alu_control(ALUControlE),
        .alu_result(ALUResultE),
        .zero(zero)
    );
	
    assign AcceptBranch = (BranchEQ_E && zero) || (BranchNE_E && !zero);
    assign PCSrcE = JumpE ||  AcceptBranch; 
	
    ExecutionRegister alu_execution (
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .ImmExtE(ImmExtE),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .ImmExtM(ImmExtM)
    );
	
    DataMem dataMemory(
        .clk(clk),
        .we(MemWriteM),
        .addr(ALUResultM),
        .wdata(WriteDataM),
        .rdata(ReadDataM)
    );
	
    DataMemoryRegister dataMemory_register (
        .clk(clk),
        .rst(rst),
        .ALUResultM(ALUResultM),
        .ReadDataM(ReadDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .ImmExtM(ImmExtM),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .RdW(RdW),
        .PCPlus4W(PCPlus4W),
        .ImmExtW(ImmExtW),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW)
    );
	
    Mux4to1 muxResult (
        .in1(ReadDataW),
        .in2(ALUResultW),
        .in3(PCPlus4W),
        .in4(ImmExtW),
        .sel(ResultSrcW), 
        .out(ResultW)
    );
	
endmodule