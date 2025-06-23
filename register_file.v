module register_file (
    input clk,
    input rst,

    input [4:0] reg_num_r0,   // rs1
    input [4:0] reg_num_r1,   // rs2
    input [4:0] reg_num_w,    // rd

    output [63:0] r_data_0,
    output [63:0] r_data_1,
    input  [63:0] w_data,

    input ctrl_reg_w,

    output [15:0] debug
);

    // 32 registers of 64 bits each
    reg [63:0] RF [0:31];

    integer i;

    // Initialize register values (simulation only)
    initial begin
        RF[0]  = 64'd0;
        RF[1]  = 64'd3;
        RF[2]  = 64'd6;
        RF[3]  = 64'd9;
        RF[4]  = 64'd12;
        RF[5]  = 64'd15;
        RF[6]  = 64'd18;
        RF[7]  = 64'd21;
        RF[8]  = 64'd24;
        RF[9]  = 64'd27;
        RF[10] = 64'd30;
        for (i = 11; i < 32; i = i + 1)
            RF[i] = 64'd0;
    end

    // Read ports
    assign r_data_0 = RF[reg_num_r0];
    assign r_data_1 = RF[reg_num_r1];
    assign debug    = RF[31][15:0];

    // Write port
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                RF[i] <= 64'd0;
        end else begin
            if (ctrl_reg_w && reg_num_w != 5'd0)  // x0 is always 0
                RF[reg_num_w] <= w_data;
        end
    end

endmodule
