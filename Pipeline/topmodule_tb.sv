`timescale 1ns / 1ns

module topmodule_tb;
    reg clk;
    reg rst;
    topmodule uut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;
    initial begin
		rst = 1; clk = 0;
		#12
		rst = 0;
        #1500;
        $stop;
    end

endmodule