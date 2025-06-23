`timescale 1ns / 1ps

module clock_divider (
    input wire clk_in,        // 100 MHz input clock from Nexys 4 DDR
    input wire rst,           // active-high synchronous reset
    output reg clk_out        // divided clock output
);

// Set CLOCK_DIVISOR according to desired frequency
// For example, to get 1 Hz from 100 MHz:
// CLOCK_DIVISOR = 100,000,000 (50M up, 50M down)
parameter CLOCK_DIVISOR = 100000000;

reg [27:0] counter;

always @(posedge clk_in or posedge rst) begin
    if (rst) begin
        counter <= 28'd0;
        clk_out <= 1'b0;
    end else begin
        if (counter >= (CLOCK_DIVISOR - 1)) begin
            counter <= 28'd0;
            clk_out <= ~clk_out; // toggle output clock
        end else begin
            counter <= counter + 1;
        end
    end
end

endmodule
