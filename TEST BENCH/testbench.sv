`include "run.sv"


module top_tb;

  RISV_V_intf vif();

  // Initialization
  initial begin
    vif.a                = 0;
    vif.b                = 0;
    vif.alu_ctrl         = 0;
    vif.pc               = 0;
    vif.reg_write_en     = 0;
    vif.reg_write_dest   = 0;
    vif.reg_write_data   = 0;
    vif.reg_read_addr_1  = 0;
    vif.reg_read_addr_2  = 0;
    vif.mem_access_addr  = 0;
    vif.mem_write_data   = 0;
    vif.mem_write_en     = 0;
    vif.mem_read_en      = 0;
    vif.ALUOp            = 0;
    vif.Opcode           = 0;
    vif.opcode           = 0;
    vif.clk              = 0;
  end



  // ALU instance
  ALU dut (
    .a(vif.a), .b(vif.b), .alu_ctrl(vif.alu_ctrl),
    .result(vif.result), .zero(vif.zero)
  );

  // Instruction Memory
  Instruction_Memory im (
    .pc(vif.pc),
    .instruction(vif.instruction)
  );

  // GPRs
  GPRs gpr (
    .clk(vif.clk),
    .reg_write_en(vif.reg_write_en),
    .reg_write_dest(vif.reg_write_dest),
    .reg_write_data(vif.reg_write_data),
    .reg_read_addr_1(vif.reg_read_addr_1),
    .reg_read_addr_2(vif.reg_read_addr_2),
    .reg_read_data_1(vif.reg_read_data_1),
    .reg_read_data_2(vif.reg_read_data_2)
  );

  // Control Unit
  Control_Unit ctrl (
    .opcode(vif.opcode),
    .alu_op(vif.alu_op),
    .jump(vif.jump),
    .beq(vif.beq),
    .bne(vif.bne),
    .mem_read(vif.mem_read),
    .mem_write(vif.mem_write),
    .alu_src(vif.alu_src),
    .reg_dst(vif.reg_dst),
    .mem_to_reg(vif.mem_to_reg),
    .reg_write(vif.reg_write)
  );

  // ALU control
  alu_control adut (
    .ALUOp(vif.ALUOp),
    .Opcode(vif.Opcode),
    .ALU_Cnt(vif.ALU_Cnt)
  );

  // Data Memory
  Data_Memory uut (
    .clk(vif.clk),
    .mem_access_addr(vif.mem_access_addr),
    .mem_write_data(vif.mem_write_data),
    .mem_write_en(vif.mem_write_en),
    .mem_read(vif.mem_read_en),
    .mem_read_data(vif.mem_read_data)
  );


  // Handle
  run run_h = new(vif);

  initial begin
    run_h.run_test();
  end
  // Dump Waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end

endmodule
