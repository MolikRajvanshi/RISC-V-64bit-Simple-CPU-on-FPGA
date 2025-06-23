`timescale 1 ns / 10 ps

module ALU_control_tb;

    // Inputs
    reg [2:0] funct3;
    reg [6:0] funct7;
    reg [1:0] ctrl_ALU_op;

    // Output
    wire [1:0] ALU_ctrl;

    // DUT instance
    ALU_control UUT (
        .funct3(funct3),
        .funct7(funct7),
        .ALU_ctrl(ALU_ctrl),
        .ctrl_ALU_op(ctrl_ALU_op)
    );

    // ALU operation encodings (same as enum)
    localparam [1:0] ADD = 2'b00;
    localparam [1:0] SUB = 2'b01;
    localparam [1:0] AND = 2'b10;
    localparam [1:0] OR  = 2'b11;


    localparam integer half_period = 5;
    localparam integer period      = 2 * half_period;

    initial begin
        funct3      = 3'b000;
        funct7      = 7'b0000000;
        ctrl_ALU_op = 2'b00;

        #period; // ld/sd

        // Test ADD (load/store)
        funct3 = 3'b011;
        funct7 = 7'b0000000;
        ctrl_ALU_op = 2'b00;
        #period;
        if (ALU_ctrl == ADD)
            $display("Test ld/sd: ALU_ctrl = ADD (%b) [PASS]", ALU_ctrl);
        else
            $display("Test ld/sd: ALU_ctrl = %b [FAIL]", ALU_ctrl);

        // Test R-type ADD
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        ctrl_ALU_op = 2'b10;
        #period;
        if (ALU_ctrl == ADD)
            $display("Test ADD: ALU_ctrl = ADD (%b) [PASS]", ALU_ctrl);
        else
            $display("Test ADD: ALU_ctrl = %b [FAIL]", ALU_ctrl);

        // Test R-type SUB
        funct3 = 3'b000;
        funct7 = 7'b0100000;
        ctrl_ALU_op = 2'b10;
        #period;
        if (ALU_ctrl == SUB)
            $display("Test SUB: ALU_ctrl = SUB (%b) [PASS]", ALU_ctrl);
        else
            $display("Test SUB: ALU_ctrl = %b [FAIL]", ALU_ctrl);

        // Test R-type AND
        funct3 = 3'b111;
        funct7 = 7'b0000000;
        ctrl_ALU_op = 2'b10;
        #period;
        if (ALU_ctrl == AND)
            $display("Test AND: ALU_ctrl = AND (%b) [PASS]", ALU_ctrl);
        else
            $display("Test AND: ALU_ctrl = %b [FAIL]", ALU_ctrl);

        // Test R-type OR
        funct3 = 3'b110;
        funct7 = 7'b0000000;
        ctrl_ALU_op = 2'b10;
        #period;
        if (ALU_ctrl == OR)
            $display("Test OR: ALU_ctrl = OR (%b) [PASS]", ALU_ctrl);
        else
            $display("Test OR: ALU_ctrl = %b [FAIL]", ALU_ctrl);

        // Test Branch (SUB)
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        ctrl_ALU_op = 2'b01;
        #period;
        if (ALU_ctrl == SUB)
            $display("Test BEQ: ALU_ctrl = SUB (%b) [PASS]", ALU_ctrl);
        else
            $display("Test BEQ: ALU_ctrl = %b [FAIL]", ALU_ctrl);

        $finish;
    end

endmodule
