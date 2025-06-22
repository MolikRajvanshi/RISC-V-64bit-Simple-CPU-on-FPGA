module control_unit (
    input  [6:0] opcode,  // Replacing opcode_t with 7-bit opcode input

    output reg [1:0] ctrl_ALU_op,
    output reg       ctrl_ALU_src,
    output reg       ctrl_reg_w,
    output reg       ctrl_mem_w,
    output reg       ctrl_mem_r,
    output reg       ctrl_mem_to_reg,
    output reg       ctrl_branch
);

    always @(*) begin
        case (opcode)
            7'b0000011: begin  // LOAD
                ctrl_ALU_op     = 2'b00;
                ctrl_ALU_src    = 1'b1;
                ctrl_reg_w      = 1'b1;
                ctrl_mem_w      = 1'b0;
                ctrl_mem_r      = 1'b1;
                ctrl_mem_to_reg = 1'b1;
                ctrl_branch     = 1'b0;
            end

            7'b0100011: begin  // STORE
                ctrl_ALU_op     = 2'b00;
                ctrl_ALU_src    = 1'b1;
                ctrl_reg_w      = 1'b0;
                ctrl_mem_w      = 1'b1;
                ctrl_mem_r      = 1'b0;
                ctrl_mem_to_reg = 1'b0;
                ctrl_branch     = 1'b0;
            end

            7'b0110011: begin  // ARITHMETIC (R-type)
                ctrl_ALU_op     = 2'b10;
                ctrl_ALU_src    = 1'b0;
                ctrl_reg_w      = 1'b1;
                ctrl_mem_w      = 1'b0;
                ctrl_mem_r      = 1'b0;
                ctrl_mem_to_reg = 1'b0;
                ctrl_branch     = 1'b0;
            end

            7'b1100011: begin  // BRANCH
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
