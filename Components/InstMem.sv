module InstMem(
    input[31:0] addr, 
    output reg[31:0] out
);

reg [31:0] mem [0:1023];
localparam mem_size = 1024;

initial begin
    $readmemb("./InstMem.mif", mem);
end

wire [31:0] word_addr = addr >> 2;

always @(*) begin
    if (word_addr < mem_size) begin
        out = mem[word_addr];
    end else begin
        out = 32'b0;
    end
end

endmodule