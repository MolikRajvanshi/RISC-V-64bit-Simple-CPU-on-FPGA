
module ALU (
    input  signed [63:0] data_in_A,
    input  signed [63:0] data_in_B,
    input  [2:0] ALU_ctrl,
    output reg signed [63:0] data_out,
    output wire zero
);

    assign zero = (data_out == {64{1'b0}});

    always @(*) begin
        case (ALU_ctrl)
             3'b000: data_out = data_in_A & data_in_B;
             3'b001 : data_out = data_in_A | data_in_B;
             3'b010: data_out = data_in_A + data_in_B;
             3'b110: data_out = data_in_A - data_in_B;
            default: data_out = {64{1'b0}};
        endcase
    end

endmodule
