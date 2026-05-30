module ImmExt (
    input [31:0] instruction,
    input [2:0] imm_src,
    output reg [31:0] imm_out
);

always @(*) begin
    case (imm_src)
        // I-type
        3'b000:
            imm_out = { {20{instruction[31]}}, instruction[31:20] };
        
        // S-type
        3'b001:
            imm_out = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
        
        // B-type
        3'b010:
            imm_out = { {20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
        
        // J-type (JAL)
        3'b100:
            imm_out = { {12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
            
        // U-type (LUI) 
        3'b011:
            imm_out = { instruction[31:12], 12'b0 };
        
        default: 
            imm_out = 32'bx;
    endcase
end

endmodule
