
module ALU_control (
    input  [2:0] funct3,
    input  [6:0] funct7,
    input  [1:0] ctrl_ALU_op,
    output reg [2:0] ALU_ctrl
);

    always @(*) begin
        case (ctrl_ALU_op)
            2'b00: ALU_ctrl = 3'b000; // ld/st
            2'b01: ALU_ctrl = 3'b110; // beq
            2'b10: begin
                if (funct7 == 7'b0000000 && funct3 == 3'b000)
                    ALU_ctrl = 3'b010;
                else if (funct7 == 7'b0100000 && funct3 == 3'b000)
                    ALU_ctrl = 3'b110;
                else if (funct7 == 7'b0000000 && funct3 == 3'b111)
                    ALU_ctrl = 3'b000;
                else if (funct7 == 7'b0000000 && funct3 == 3'b110)
                    ALU_ctrl = 3'b001;
                else
                    ALU_ctrl = 3'b000; // default
            end
            default: ALU_ctrl = 3'b000;
        endcase
    end

endmodule
