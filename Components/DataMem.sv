module DataMem (
    input clk, we,
    input [31:0] addr, wdata,
    output reg [31:0] rdata
);
    
reg [31:0] mem [0:1023];
localparam mem_size = 1024;

initial begin
    $readmemb("./DataMem.mif", mem);
end

wire [31:0] word_addr = addr >> 2;

always @(posedge clk) begin
    if (we == 1'b1 && word_addr < mem_size) begin
        mem[word_addr] <= wdata;
    end
end

always @(*) begin
    if (word_addr < mem_size) begin
        rdata = mem[word_addr];
    end else begin
        rdata = 32'b0;
    end
end

endmodule