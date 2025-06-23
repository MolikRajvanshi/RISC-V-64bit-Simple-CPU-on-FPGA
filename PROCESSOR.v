// Top-level module for Nexys 4 DDR FPGA-compatible RISC-V core
// All signal names and module instantiations corrected

module top (
    input  wire        clk_200M,   // 200 MHz clock from Nexys 4 DDR
    input  wire        rst,        // Reset button (active high)
    output wire [15:0] debug       // Debug output (connected to LEDs, for example)
);

    // Clock division output
    wire clk;

    // Control signals
    wire [1:0] ctrl_ALU_op;
    wire       ctrl_ALU_src;
    wire       ctrl_reg_w;
    wire       ctrl_mem_w;
    wire       ctrl_mem_r;
    wire       ctrl_mem_to_reg;
    wire       ctrl_branch;

    // Instruction and Program Counter
    wire [31:0] instruction;
    wire [7:0]  instruction_address;

    // Register File
    wire [63:0] reg_read_data_0;
    wire [63:0] reg_read_data_1;

    // Immediate Generator
    wire signed [63:0] offset;

    // ALU
    wire [2:0] ALU_ctrl;
    wire [63:0] ALU_data_out;
    wire        ALU_zero_flag;

    // Data Memory
    wire [63:0] mem_read_data;

    // Clock divider module to get slower clock from 200 MHz
    clock_divider clock_div_inst (
        .clk_in(clk_200M),
        .rst(rst),
        .clk_out(clk)
    );

    // Control Unit
    control_unit control_unit_inst (
        .opcode(instruction[6:0]),
        .ctrl_ALU_op(ctrl_ALU_op),
        .ctrl_ALU_src(ctrl_ALU_src),
        .ctrl_reg_w(ctrl_reg_w),
        .ctrl_mem_w(ctrl_mem_w),
        .ctrl_mem_r(ctrl_mem_r),
        .ctrl_mem_to_reg(ctrl_mem_to_reg),
        .ctrl_branch(ctrl_branch)
    );

    // Program Counter
    program_counter pc_inst (
        .clk(clk),
        .rst(rst),
        .ALU_zero_flag(ALU_zero_flag),
        .offset(offset),
        .ctrl_branch(ctrl_branch),
        .instruction_address(instruction_address)
    );

    // Instruction Memory
    instruction_memory imem_inst (
        .instruction_address(instruction_address),
        .instruction_data(instruction)
    );

    // Register File
    register_file rf_inst (
        .clk(clk),
        .rst(rst),
        .reg_num_r0(instruction[19:15]),
        .reg_num_r1(instruction[24:20]),
        .reg_num_w(instruction[11:7]),
        .r_data_0(reg_read_data_0),
        .r_data_1(reg_read_data_1),
        .w_data(ctrl_mem_to_reg ? mem_read_data : ALU_data_out),
        .ctrl_reg_w(ctrl_reg_w),
        .debug(debug)
    );

    // Immediate Generator
    imm_generator imm_gen_inst (
        .instruction(instruction),
        .offset(offset)
    );

    // ALU Control
    ALU_control alu_ctrl_inst (
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .ALU_ctrl(ALU_ctrl),
        .ctrl_ALU_op(ctrl_ALU_op)
    );

    // ALU
    ALU alu_inst (
        .data_in_A(reg_read_data_0),
        .data_in_B(ctrl_ALU_src ? offset : reg_read_data_1),
        .data_out(ALU_data_out),
        .zero(ALU_zero_flag),
        .ALU_ctrl(ALU_ctrl)
    );

    // Data Memory
    data_memory dmem_inst (
        .clk(clk),
        .rst(rst),
        .w_data(reg_read_data_1),
        .r_data(mem_read_data),
        .address(ALU_data_out[7:0]),
        .ctrl_mem_w(ctrl_mem_w),
        .ctrl_mem_r(ctrl_mem_r)
    );

endmodule
