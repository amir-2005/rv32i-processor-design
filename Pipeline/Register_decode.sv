module DecodeRegister (
    input clk,
    input rst,
	input clear,
    input JalrD,
    input RegWriteD,
    input [1:0] ResultSrcD,
    input MemWriteD,
    input JumpD,
    input BranchEQ_D,
	input BranchNE_D,
    input [3:0] ALUControlD,
    input ALUSrcD,
    input [31:0] RD1D,
    input [31:0] RD2D,
    input [31:0] PCD,
    input [4:0] Rs1D,
    input [4:0] Rs2D,
    input [4:0] RdD,
    input [31:0] ImmExtD,
    input [31:0] PCPlus4D,

    output reg JalrE,
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchEQ_E,
    output reg BranchNE_E,
    output reg [3:0] ALUControlE,
    output reg ALUSrcE,
    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] PCE,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCPlus4E
);
    initial begin 
        JalrE = 0;
        RegWriteE = 0;
        ResultSrcE = 0;
        MemWriteE = 0;
        JumpE = 0;
        BranchEQ_E = 0;
		BranchNE_E = 0;
        ALUControlE = 0;
        ALUSrcE = 0;
        RD1E = 0;
        RD2E = 0;
        PCE = 0;
        Rs1E = 0;
        Rs2E = 0;
        RdE = 0;
        ImmExtE = 0;
        PCPlus4E = 0;
    end
    always @(posedge clk, posedge rst) begin
        if (rst || clear) begin
            JalrE        <= 1'b0;
            RegWriteE    <= 1'b0;
            ResultSrcE   <= 2'b0;
            MemWriteE    <= 1'b0;
            JumpE        <= 1'b0;
            BranchEQ_E   <= 1'b0;
            BranchNE_E   <= 1'b0;
            ALUControlE  <= 4'b0;
            ALUSrcE      <= 1'b0;
            RD1E         <= 32'b0;
            RD2E         <= 32'b0;
            PCE          <= 32'b0;
            Rs1E         <= 5'b0;
            Rs2E         <= 5'b0;
            RdE          <= 5'b0;
            ImmExtE      <= 32'b0;
            PCPlus4E     <= 32'b0;
        end 
		else begin
            JalrE        <= JalrD;
            RegWriteE    <= RegWriteD;
            ResultSrcE   <= ResultSrcD;
            MemWriteE    <= MemWriteD;
            JumpE        <= JumpD;
            BranchEQ_E   <= BranchEQ_D;
            BranchNE_E   <= BranchNE_D;
            ALUControlE  <= ALUControlD;
            ALUSrcE      <= ALUSrcD;
            RD1E         <= RD1D;
            RD2E         <= RD2D;
            PCE          <= PCD;
            Rs1E         <= Rs1D;
            Rs2E         <= Rs2D;
            RdE          <= RdD;
            ImmExtE      <= ImmExtD;
            PCPlus4E     <= PCPlus4D;

        end
    end

endmodule
