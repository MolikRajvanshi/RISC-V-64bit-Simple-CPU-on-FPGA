// Updated RISC-V Processor with Debug Outputsmodule riscv_processor_corrected (
    input wire clk,
    input wire reset,
    output wire [31:0] instruction,
    output wire [31:0] pc_out,
    output wire [31:0] alu_result,
    output wire [31:0] reg_data1,
    output wire [31:0] reg_data2,
    output wire [31:0] mem_data_out,
    output wire [31:0] write_data,
    output wire mem_write,
    output wire mem_read,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output wire reg_write
);

    // Internal signals
    wire [31:0] pc_current, pc_next;
    wire [31:0] immediate;
    wire [31:0] alu_input1, alu_input2;
    wire [2:0] alu_ctrl;
    wire [1:0] ctrl_ALU_op;
    wire ctrl_reg_write, ctrl_mem_write, ctrl_mem_read;
    wire ctrl_branch, ctrl_mem_to_reg, ctrl_ALU_src;
    wire ctrl_jump, ctrl_reg_dst;
    wire alu_zero;
    wire branch_taken;

    // Program Counter
    program_counter PC (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc_current(pc_current)
    );

    // Instruction Memory
    instruction_memory IMEM (
        .pc(pc_current[8:0]),
        .instruction(instruction)
    );

    // Control Unit
    control_unit CU (
        .opcode(instruction[6:0]),
        .reg_write(ctrl_reg_write),
        .mem_write(ctrl_mem_write),
        .mem_read(ctrl_mem_read),
        .branch(ctrl_branch),
        .mem_to_reg(ctrl_mem_to_reg),
        .ALU_src(ctrl_ALU_src),
        .ALU_op(ctrl_ALU_op),
        .jump(ctrl_jump),
        .reg_dst(ctrl_reg_dst)
    );

    // Immediate Generator
    immediate_generator IMMGEN (
        .instruction(instruction),
        .immediate(immediate)
    );

    // Decode instruction fields
    assign rs1 = instruction[19:15];
    assign rs2 = instruction[24:20];
    assign rd = instruction[11:7];

    // Register File
    register_file RF (
        .clk(clk),
        .reset(reset),
        .reg_write(ctrl_reg_write),
        .read_reg1(rs1),
        .read_reg2(rs2),
        .write_reg(rd),
        .write_data(write_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    // ALU input selection
    assign alu_input1 = reg_data1;
    assign alu_input2 = ctrl_ALU_src ? immediate : reg_data2;

    // ALU Control
    ALU_control ALU_CTRL (
        .ctrl_ALU_op(ctrl_ALU_op),
        .func7(instruction[30]),
        .func3(instruction[14:12]),
        .ALU_ctrl(alu_ctrl)
    );

    // ALU
    ALU ALU (
        .input1(alu_input1),
        .input2(alu_input2),
        .ALU_ctrl(alu_ctrl),
        .ALU_output(alu_result),
        .zero_flag(alu_zero)
    );

    // Data Memory
    data_memory DMEM (
        .clk(clk),
        .mem_write(ctrl_mem_write),
        .mem_read(ctrl_mem_read),
        .address(alu_result[8:0]),
        .write_data(reg_data2),
        .read_data(mem_data_out)
    );

    // Write back data selection
    assign write_data = ctrl_mem_to_reg ? mem_data_out : alu_result;

    // Branch logic
    assign branch_taken = ctrl_branch & alu_zero;

    // PC next calculation
    assign pc_next = (ctrl_jump | branch_taken) ? 
                     (pc_current + immediate) : 
                     (pc_current + 4);

    // Output assignments for debugging
    assign pc_out = pc_current;
    assign mem_write = ctrl_mem_write;
    assign mem_read = ctrl_mem_read;
    assign reg_write = ctrl_reg_write;

endmodule