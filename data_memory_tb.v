`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module data_memory_tb;

    // Local parameters
    parameter RISC_V_DATA_WIDTH = 64;
    parameter DATA_MEMORY_ADDRESS_WIDTH = 9;

    // DUT inputs
    reg clk;
    reg rst;
    reg [RISC_V_DATA_WIDTH - 1 : 0] w_data;
    reg [DATA_MEMORY_ADDRESS_WIDTH - 1 : 0] address;
    reg ctrl_mem_w;
    reg ctrl_mem_r;

    // DUT output
    wire [RISC_V_DATA_WIDTH - 1 : 0] r_data;

    localparam half_period = 5;
    localparam period = half_period * 2;

    // Instantiate the unit under test
    data_memory UUT (
        .clk(clk),
        .rst(rst),
        .w_data(w_data),
        .r_data(r_data),
        .address(address),
        .ctrl_mem_w(ctrl_mem_w),
        .ctrl_mem_r(ctrl_mem_r)
    );

    // Clock generation
    always #half_period clk = ~clk;

    // Stimulus
    initial begin
        clk = 1'b0;
        rst = 1'b0;
        w_data = 64'b0;
        address = 9'b0;
        ctrl_mem_w = 1'b0;
        ctrl_mem_r = 1'b0;

        #period;

        ctrl_mem_w = 1'b1;
        address = 9'h1AB;
        w_data = 64'hFEDCBA9876543210;

        #period;

        address = 9'h169;
        w_data = 64'hAAAAAAAABBBBBBBB;

        #period;

        address = 9'h103;
        w_data = 64'h0000123412341234;

        #period;

        ctrl_mem_w = 1'b0;
        w_data = 64'h0000000000000000;
        ctrl_mem_r = 1'b1;

        address = 9'h1AB;
        #period;
        if (r_data == 64'hFEDCBA9876543210)
            $display("Read OK: %h", r_data);
        else
            $display("Read ERROR: %h", r_data);

        address = 9'h169;
        #period;
        if (r_data == 64'hAAAAAAAABBBBBBBB)
            $display("Read OK: %h", r_data);
        else
            $display("Read ERROR: %h", r_data);

        address = 9'h103;
        #period;
        if (r_data == 64'h0000123412341234)
            $display("Read OK: %h", r_data);
        else
            $display("Read ERROR: %h", r_data);

        address = 9'h000;
        #period;
        if (r_data == 64'h0123456789ABCDEF)
            $display("Read OK: %h", r_data);
        else
            $display("Read ERROR: %h", r_data);

        address = 9'h001;
        #period;
        if (r_data == 64'hDEADBEEFDEADBEEF)
            $display("Read OK: %h", r_data);
        else
            $display("Read ERROR: %h", r_data);

        address = 9'h006;
        #period;
        if (r_data == 64'hABABABABABABABAB)
            $display("Read OK: %h", r_data);
        else
            $display("Read ERROR: %h", r_data);

        $finish;
    end

endmodule
