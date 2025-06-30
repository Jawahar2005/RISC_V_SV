`include "parameter_file.sv"
`include "instruction_memory.sv"
`include "data_memory.sv"
`include "register_file.sv"
`include "ALU_unit.sv"
`include "ALU_control_unit.sv"
`include "control_unit.sv"
`include "data_path.sv"

module Risc_16_bit (
    input clk,
    input reset
);
    wire [15:0] reg_write_data;
    wire [15:0] pc_current;
    wire [3:0] opcode;
    wire reg_dst, alu_src, mem_to_reg;
    wire reg_write, mem_read, mem_write;
    wire beq, bne, jump;
    wire [1:0] alu_op;
    Control_Unit CU (
        .opcode(opcode),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .beq(beq),
        .bne(bne),
        .jump(jump),
        .alu_op(alu_op)
    );
    Datapath_Unit DP (
        .clk(clk),
        .reset(reset),
        .reg_dst(reg_dst),
        .alu_src(alu_src),
        .mem_to_reg(mem_to_reg),
        .reg_write(reg_write),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .beq(beq),
        .bne(bne),
        .jump(jump),
        .alu_op(alu_op),
        .opcode(opcode)
        //.pc_current(pc_current)
    );
endmodule
