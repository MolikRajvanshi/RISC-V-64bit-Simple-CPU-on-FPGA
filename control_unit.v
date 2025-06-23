`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,

    output reg  [1:0] ctrl_ALU_op,
    output reg        ctrl_ALU_src,
    output reg        ctrl_reg_w,
    output reg        ctrl_mem_w,
    output reg        ctrl_mem_r,
    output reg        ctrl_mem_to_reg,
    output reg        ctrl_branch
);

    // RISC-V base opcodes
    localparam [6:0]
        LOAD    = 7'b0000011,
        STORE   = 7'b0100011,
        ARITH   = 7'b0110011,
        BRANCH  = 7'b1100011;

    always @(*) begin
        case (opcode)
            LOAD: begin
                ctrl_ALU_op     = 2'b00;
                ctrl_ALU_src    = 1'b1;
                ctrl_reg_w      = 1'b1;
                ctrl_mem_w      = 1'b0;
                ctrl_mem_r      = 1'b1;
                ctrl_mem_to_reg = 1'b1;
                ctrl_branch     = 1'b0;
            end

            STORE: begin
                ctrl_ALU_op     = 2'b00;
                ctrl_ALU_src    = 1'b1;
                ctrl_reg_w      = 1'b0;
                ctrl_mem_w      = 1'b1;
                ctrl_mem_r      = 1'b0;
                ctrl_mem_to_reg = 1'b0;
                ctrl_branch     = 1'b0;
            end

            ARITH: begin
                ctrl_ALU_op     = 2'b10;
                ctrl_ALU_src    = 1'b0;
                ctrl_reg_w      = 1'b1;
                ctrl_mem_w      = 1'b0;
                ctrl_mem_r      = 1'b0;
                ctrl_mem_to_reg = 1'b0;
                ctrl_branch     = 1'b0;
            end

            BRANCH: begin
                ctrl_ALU_op     = 2'b01;
                ctrl_ALU_src    = 1'b0;
                ctrl_reg_w      = 1'b0;
                ctrl_mem_w      = 1'b0;
                ctrl_mem_r      = 1'b0;
                ctrl_mem_to_reg = 1'b0;
                ctrl_branch     = 1'b1;
            end

            default: begin
                ctrl_ALU_op     = 2'b00;
                ctrl_ALU_src    = 1'b0;
                ctrl_reg_w      = 1'b0;
                ctrl_mem_w      = 1'b0;
                ctrl_mem_r      = 1'b0;
                ctrl_mem_to_reg = 1'b0;
                ctrl_branch     = 1'b0;
            end
        endcase
    end

endmodule
