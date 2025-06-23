`timescale 1ns / 1ps

module data_memory (
    input  wire         clk,
    input  wire         rst,
    input  wire [63:0]  w_data,
    output reg  [63:0]  r_data,
    input  wire [8:0]   address,
    input  wire         ctrl_mem_w,
    input  wire         ctrl_mem_r
);

    localparam ROM_DEPTH = 256;
    localparam RAM_DEPTH = 256;

    reg [63:0] rom_memory [0:ROM_DEPTH-1];
    reg [63:0] ram_memory [0:RAM_DEPTH-1];

    integer i;

    initial begin
        $readmemh("data_memory.mem", rom_memory);
        for (i = 0; i < RAM_DEPTH; i = i + 1)
            ram_memory[i] = 64'd0;
    end

    always @(*) begin
        if (ctrl_mem_r) begin
            if (address < ROM_DEPTH)
                r_data = rom_memory[address];
            else
                r_data = ram_memory[address - ROM_DEPTH];
        end else begin
            r_data = 64'd0;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < RAM_DEPTH; i = i + 1)
                ram_memory[i] <= 64'd0;
        end else if (ctrl_mem_w && address >= ROM_DEPTH) begin
            ram_memory[address - ROM_DEPTH] <= w_data;
        end
    end

endmodule
