interface RISV_V_intf;
  // Clock 
  reg clk;

  // ALU
  reg [15:0] a;
  reg [15:0] b;
  reg [2:0] alu_ctrl;
  wire [15:0] result;
  wire zero;

  // Instruction Memory
  reg [15:0] pc;
  wire [15:0] instruction;

  // Register File
  reg reg_write_en;
  reg [2:0] reg_write_dest;
  reg [15:0] reg_write_data;
  reg [2:0] reg_read_addr_1;
  reg [2:0] reg_read_addr_2;
  wire [15:0] reg_read_data_1;
  wire [15:0] reg_read_data_2;

  // Data Memory
  reg [15:0] mem_access_addr;
  reg [15:0] mem_write_data;
  reg mem_write_en;
  reg mem_read_en;
  wire [15:0] mem_read_data;

  // ALU Control Unit
  reg [1:0] ALUOp;
  reg [3:0] Opcode;
  wire [2:0] ALU_Cnt;

  // Control Unit
  reg [3:0] opcode;
  wire [1:0] alu_op;
  wire jump, beq, bne, mem_read, mem_write, alu_src, reg_dst, mem_to_reg, reg_write;
  
endinterface
