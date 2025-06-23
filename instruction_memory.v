module instruction_memory (
    input  [7:0] instruction_address,     // 256 instructions (can adjust width)
    output [31:0] instruction_data
);

    // Instruction memory array (32-bit instructions)
    reg [31:0] memory [0:255];  // Adjust size as needed (e.g., 256 = 2^8)

    initial begin
        $readmemh("C:/Users/HP/Downloads/my_64bit_rtype_only/my_64bit_rtype_only.srcs/sources_1/new/instruction_memory.mem", memory, 8'h00, 8'hFF);
    end

    assign instruction_data = memory[instruction_address];

endmodule
