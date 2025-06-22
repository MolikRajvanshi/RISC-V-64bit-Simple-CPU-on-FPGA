module clock_divider (
    input  clk_in,
    input  rst,
    output clk_out
);

    reg [27:0] counter;
    reg clk_out_reg;

    assign clk_out = clk_out_reg;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter     <= 28'd0;
            clk_out_reg <= 1'b0;
        end else begin
            if (counter >= 28'd99999999) begin  // 100 million - 1
                counter     <= 28'd0;
                clk_out_reg <= ~clk_out_reg;
            end else begin
                counter <= counter + 1;
            end
        end
    end

endmodule
