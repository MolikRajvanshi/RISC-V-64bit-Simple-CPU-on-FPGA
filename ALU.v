module ALU (
    input  signed [63:0] data_in_A,
    input  signed [63:0] data_in_B,
    output signed [63:0] data_out,
    output               zero,
    input  [1:0]         ALU_ctrl
);

    assign zero = (data_out == 64'b0);

    reg signed [63:0] result;
    assign data_out = result;

    always @(*) begin
        case (ALU_ctrl)
            2'b00: result = data_in_A & data_in_B;
            2'b01: result = data_in_A | data_in_B;
            2'b10: result = data_in_A + data_in_B;
            2'b11: result = data_in_A - data_in_B;
            default: result = 64'b0;
        endcase
    end

endmodule
