module RegFile (
    input clk, rst, 
    input [4:0] rdreg1, rdreg2, 
    input [4:0] wreg,             
    input [31:0] wdata,         
    input we,                    
    output reg [31:0] rdata1, rdata2 
);

reg [31:0] X[0:31];
integer i;

always @(posedge clk, posedge rst) begin
    if (rst == 1'b1)
        for (i = 0; i < 32; i = i + 1) begin
            X[i] <= 32'b0;
        end
    else begin
        if (we == 1'b1)
            if (wreg != 5'b0)
                X[wreg] <= wdata; 
    end 
end

always @(*) begin
    rdata1 = X[rdreg1];
    rdata2 = X[rdreg2];
end
    
endmodule
