module PC (
    input clk, rst,
    input[31:0] next,
    output reg[31:0] current
);

always @(posedge clk, posedge rst) begin
    if (rst == 1'b1)
        current <= 32'b0;
    else
        current <= next;
end
    
endmodule
