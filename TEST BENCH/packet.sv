// ALU
class ALU_packet;
  rand logic [15:0] a;
  rand logic [15:0] b;
  rand logic [2:0] alu_ctrl;
  logic [15:0] result;
  logic zero;
endclass

// Instruction Memory
class InstructionMemory_packet;
  rand logic [15:0] pc;
  logic [15:0] instruction;
endclass

// Register File
class RegisterFile_packet;
  rand logic reg_write_en;
  rand logic [2:0] reg_write_dest;
  rand logic [15:0] reg_write_data;
  rand logic [2:0] reg_read_addr_1;
  rand logic [2:0] reg_read_addr_2;
  logic [15:0] reg_read_data_1;
  logic [15:0] reg_read_data_2;
endclass

// Data Memory
class DataMemory_packet;
  rand logic [15:0] mem_access_addr;
  rand logic [15:0] mem_write_data;
  rand logic mem_write_en;
  rand logic mem_read_en;
  logic [15:0] mem_read_data;
endclass

// ALU Control Unit
class ALUControl_packet;
  rand logic [1:0] ALUOp;
  rand logic [3:0] Opcode;
  logic [2:0] ALU_Cnt;
endclass

// Control Unit
class ControlUnit_packet;
  rand logic [3:0] opcode;
  logic [1:0] alu_op;
  logic jump, beq, bne, mem_read, mem_write, alu_src, reg_dst, mem_to_reg, reg_write;
endclass
