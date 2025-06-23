module ALU_control (
    input  [2:0] funct3,
    input  [6:0] funct7,
    input  [1:0] ctrl_ALU_op,
    output reg [1:0] ALU_ctrl
);

    // ALU operation codes
    localparam [1:0] ADD = 2'b00;
    localparam [1:0] SUB = 2'b01;
    localparam [1:0] AND = 2'b10;
    localparam [1:0] OR  = 2'b11;

    always @(*) begin
        case (ctrl_ALU_op)
            2'b00: ALU_ctrl = ADD; // load/store
            2'b01: ALU_ctrl = SUB; // branch
            2'b10: begin
                if (funct7 == 7'b0000000 && funct3 == 3'b000)
                    ALU_ctrl = ADD;
                else if (funct7 == 7'b0100000 && funct3 == 3'b000)
                    ALU_ctrl = SUB;
                else if (funct7 == 7'b0000000 && funct3 == 3'b111)
                    ALU_ctrl = AND;
                else if (funct7 == 7'b0000000 && funct3 == 3'b110)
                    ALU_ctrl = OR;
                else
                    ALU_ctrl = AND;
            end
            default: ALU_ctrl = AND;
        endcase
    end

endmodule
