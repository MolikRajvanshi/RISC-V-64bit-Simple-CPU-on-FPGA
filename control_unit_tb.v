`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module control_unit_tb;

    // Inputs to DUT
    reg [6:0] opcode;

    // Outputs from DUT
    wire [1:0] ctrl_ALU_op;
    wire       ctrl_ALU_src;
    wire       ctrl_reg_w;
    wire       ctrl_mem_w;
    wire       ctrl_mem_r;
    wire       ctrl_mem_to_reg;
    wire       ctrl_branch;

    // Instantiate the Unit Under Test (UUT)
    control_unit UUT (
        .opcode(opcode),
        .ctrl_ALU_op(ctrl_ALU_op),
        .ctrl_ALU_src(ctrl_ALU_src),
        .ctrl_reg_w(ctrl_reg_w),
        .ctrl_mem_w(ctrl_mem_w),
        .ctrl_mem_r(ctrl_mem_r),
        .ctrl_mem_to_reg(ctrl_mem_to_reg),
        .ctrl_branch(ctrl_branch)
    );

    // Opcode definitions (RISC-V base)
    localparam [6:0]
        LOAD    = 7'b0000011,
        STORE   = 7'b0100011,
        ARITH   = 7'b0110011,
        BRANCH  = 7'b1100011;

    localparam half_period = 5;
    localparam period      = half_period * 2;

    initial begin
        $display("Starting control_unit_tb...");

        // Test LOAD
        opcode = LOAD;
        #period;
        if (ctrl_ALU_src    == 1'b1 &&
            ctrl_mem_to_reg == 1'b1 &&
            ctrl_reg_w      == 1'b1 &&
            ctrl_mem_r      == 1'b1 &&
            ctrl_mem_w      == 1'b0 &&
            ctrl_branch     == 1'b0 &&
            ctrl_ALU_op     == 2'b00) begin
            $display("LOAD test PASSED");
        end else begin
            $display("LOAD test FAILED");
        end

        // Test STORE
        opcode = STORE;
        #period;
        if (ctrl_ALU_src    == 1'b1 &&
            ctrl_mem_to_reg == 1'b0 &&
            ctrl_reg_w      == 1'b0 &&
            ctrl_mem_r      == 1'b0 &&
            ctrl_mem_w      == 1'b1 &&
            ctrl_branch     == 1'b0 &&
            ctrl_ALU_op     == 2'b00) begin
            $display("STORE test PASSED");
        end else begin
            $display("STORE test FAILED");
        end

        // Test ARITH
        opcode = ARITH;
        #period;
        if (ctrl_ALU_src    == 1'b0 &&
            ctrl_mem_to_reg == 1'b0 &&
            ctrl_reg_w      == 1'b1 &&
            ctrl_mem_r      == 1'b0 &&
            ctrl_mem_w      == 1'b0 &&
            ctrl_branch     == 1'b0 &&
            ctrl_ALU_op     == 2'b10) begin
            $display("ARITH test PASSED");
        end else begin
            $display("ARITH test FAILED");
        end

        // Test BRANCH
        opcode = BRANCH;
        #period;
        if (ctrl_ALU_src    == 1'b0 &&
            ctrl_mem_to_reg == 1'b0 &&
            ctrl_reg_w      == 1'b0 &&
            ctrl_mem_r      == 1'b0 &&
            ctrl_mem_w      == 1'b0 &&
            ctrl_branch     == 1'b1 &&
            ctrl_ALU_op     == 2'b01) begin
            $display("BRANCH test PASSED");
        end else begin
            $display("BRANCH test FAILED");
        end

        $display("control_unit_tb completed.");
        $finish;
    end

endmodule
