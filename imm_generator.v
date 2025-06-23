`timescale 1ns / 1ps

module imm_generator (
    input  wire [31:0] instruction,
    output reg  signed [63:0] offset
);

    // RISC-V opcodes (base 7-bit)
    localparam [6:0]
        LOAD   = 7'b0000011,
        STORE  = 7'b0100011,
        BRANCH = 7'b1100011;

    reg [6:0] opcode;
    reg [11:0] imm;

    always @(*) begin
        opcode = instruction[6:0];
        case (opcode)
            LOAD: begin
                imm = instruction[31:20];
                offset = {{52{imm[11]}}, imm};  // Sign-extend to 64 bits
            end

            STORE: begin
                imm = {instruction[31:25], instruction[11:7]};
                offset = {{52{imm[11]}}, imm};  // Sign-extend
            end

            BRANCH: begin
                imm = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]};
                offset = {{51{imm[11]}}, imm, 1'b0};  // Sign-extend and shift-left by 1
            end

            default: offset = 64'd0;
        endcase
    end

endmodule
