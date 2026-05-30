module ExecutionRegister (
    input wire clk,
    input wire rst,
    input wire RegWriteE,
    input wire [1:0] ResultSrcE,
    input wire MemWriteE,
    input wire [31:0] ALUResultE,
    input wire [31:0] WriteDataE,
    input wire [4:0] RdE,
    input wire [31:0] PCPlus4E,
	input wire [31:0] ImmExtE,
    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM,
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [4:0] RdM,
    output reg [31:0] PCPlus4M,
    output reg [31:0] ImmExtM
);
    initial begin
        RegWriteM = 0;
        ResultSrcM = 0;
        MemWriteM = 0;
        ALUResultM = 0;
        WriteDataM = 0;
        RdM = 0;
        PCPlus4M = 0;
		ImmExtM = 0;
    end
    always @(posedge clk,  posedge rst) begin
        if (rst) begin
            RegWriteM   <= 1'b0;
            ResultSrcM  <= 2'b0;
            MemWriteM   <= 1'b0;
            ALUResultM  <= 32'b0;
            WriteDataM  <= 32'b0;
            RdM         <= 5'b0;
            PCPlus4M    <= 32'b0;
			ImmExtM 	<= 32'b0;
        end else begin
            RegWriteM   <= RegWriteE;
            ResultSrcM  <= ResultSrcE;
            MemWriteM   <= MemWriteE;
            ALUResultM  <= ALUResultE;
            WriteDataM  <= WriteDataE;
            RdM         <= RdE;
            PCPlus4M    <= PCPlus4E;
			ImmExtM		<= ImmExtE;
        end
    end
endmodule