module FetchRegister (
    input clk,
    input pause,
    input rst,
	input clear,
    input [31:0] InstrF ,
    input [31:0] PCF,
    input [31:0] PCPlus4F,
    output reg [31:0] InstrD,
    output reg [31:0] PCD,
    output reg [31:0] PCPlus4D
);
    initial begin
        InstrD = 0;
        PCD = 0;
        PCPlus4D = 0;
    end
    always @(posedge clk, posedge rst) begin
        if (rst || clear) begin
            InstrD    <= 32'b0;
            PCD       <= 32'b0;
            PCPlus4D  <= 32'b0;
        end else if (!pause) begin
            InstrD    <= InstrF;
            PCD       <= PCF;
            PCPlus4D  <= PCPlus4F;
        end
    end
endmodule
