`timescale 1ns/1ps

module TopLevel_tb;

    reg clk;
    reg rst;

    TopLevel dut (
        .clk(clk),
        .rst(rst)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Memory Before Sort:");
        dump_memory();

        clk = 0;
        rst = 1;

        #20;
        rst = 0;

        #25000;

        $display("================================");
        $display("Memory After Sort");

        dump_memory();
        $stop;
    end

    task dump_memory;
        integer i;
        begin
            for (i = 0; i < 20; i = i + 1) begin
                $display("mem[%0d] = %0d", i,  $signed(dut.datapath.data_mem.mem[i]));
            end
        end
    endtask


endmodule
