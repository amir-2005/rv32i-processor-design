module ALU (
    input [31:0] src1,
    input [31:0] src2,
    input [3:0] alu_control,
    output reg [31:0] alu_result,
    output zero
);

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

always @(*) begin
    case (alu_control)
        ALU_ADD:    alu_result = src1 + src2;
        ALU_SUB:    alu_result = src1 - src2;
        ALU_AND:    alu_result = src1 & src2;
        ALU_OR:     alu_result = src1 | src2;
        ALU_XOR:    alu_result = src1 ^ src2;
        ALU_SLT:    alu_result = ($signed(src1) < $signed(src2)) ? 32'd1 : 32'd0;
        ALU_SLTU:   alu_result = (src1 < src2) ? 32'd1 : 32'd0;
        ALU_SLL:    alu_result = src1 << src2[4:0];
        ALU_SRL:    alu_result = src1 >> src2[4:0];
        ALU_SRA:    alu_result = $signed(src1) >>> src2[4:0];
        default:    alu_result = 32'bx;
    endcase
end

assign zero = (alu_result == 32'b0);

endmodule
