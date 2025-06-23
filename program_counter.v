module program_counter (
    input clk,
    input rst,

    input        ALU_zero_flag,
    input signed [63:0] offset,              // RISC-V immediate offset
    input        ctrl_branch,

    output reg [7:0] instruction_address     // 8-bit PC for 256 instructions
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            instruction_address <= 8'd0;
        end else begin
            if (ALU_zero_flag && ctrl_branch)
                instruction_address <= instruction_address + (offset[7:0] << 1);  // branch target offset (shifted left by 1)
            else
                instruction_address <= instruction_address + 8'd1;               // normal increment
        end
    end

endmodule
