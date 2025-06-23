`timescale 1 ns / 10 ps  // time-unit = 1 ns, precision = 10 ps

module ALU_tb;

    reg   [63:0] data_in_A;
    reg   [63:0] data_in_B;
    wire  [63:0] data_out;
    wire         zero;
    reg   [1:0]  ALU_ctrl;

    // ALU operation codes
    localparam [1:0] AND_OP = 2'b00;
    localparam [1:0] OR_OP  = 2'b01;
    localparam [1:0] ADD_OP = 2'b10;
    localparam [1:0] SUB_OP = 2'b11;

    localparam half_period = 5;
    localparam period      = half_period * 2;

    // Instantiate the ALU module
    ALU uut (
        .data_in_A(data_in_A),
        .data_in_B(data_in_B),
        .data_out(data_out),
        .zero(zero),
        .ALU_ctrl(ALU_ctrl)
    );

    initial begin
        // AND
        ALU_ctrl = AND_OP;
        data_in_A = 64'd0;
        data_in_B = 64'd0;
        #period;
        data_in_A = 64'd223;
        data_in_B = 64'd132;
        #period;
        if (data_out == (64'd223 & 64'd132))
            $display("AND Test PASS: data_out = %d", data_out);
        else
            $display("AND Test FAIL: data_out = %d", data_out);

        // OR
        ALU_ctrl = OR_OP;
        data_in_A = 64'd4013;
        data_in_B = 64'd3022;
        #period;
        if (data_out == (64'd4013 | 64'd3022))
            $display("OR Test PASS: data_out = %d", data_out);
        else
            $display("OR Test FAIL: data_out = %d", data_out);

        // ADD
        ALU_ctrl = ADD_OP;
        data_in_A = 64'd5555;
        data_in_B = 64'd4321;
        #period;
        if (data_out == (64'd5555 + 64'd4321))
            $display("ADD Test PASS: data_out = %d", data_out);
        else
            $display("ADD Test FAIL: data_out = %d", data_out);

        // SUB
        ALU_ctrl = SUB_OP;
        data_in_A = 64'd999999;
        data_in_B = 64'd111111;
        #period;
        if (data_out == (64'd999999 - 64'd111111))
            $display("SUB Test PASS: data_out = %d", data_out);
        else
            $display("SUB Test FAIL: data_out = %d", data_out);

        $finish;
    end

endmodule
