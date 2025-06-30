class Control_Unit_Random_test;

  virtual RISV_V_intf vif; 
  ControlUnit_packet pkt;

  int pass_count = 0;
  int fail_count = 0;

 
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  task check(
    input string name,
    input [3:0] opcode_val,
    input [1:0] exp_alu_op,
    input exp_jump, exp_beq, exp_bne, exp_mem_read, exp_mem_write,
    input exp_alu_src, exp_reg_dst, exp_mem_to_reg, exp_reg_write
  );
    begin
      vif.opcode = opcode_val; #1;
      if (vif.alu_op      == exp_alu_op &&
          vif.jump        == exp_jump &&
          vif.beq         == exp_beq &&
          vif.bne         == exp_bne &&
          vif.mem_read    == exp_mem_read &&
          vif.mem_write   == exp_mem_write &&
          vif.alu_src     == exp_alu_src &&
          vif.reg_dst     == exp_reg_dst &&
          vif.mem_to_reg  == exp_mem_to_reg &&
          vif.reg_write   == exp_reg_write) begin
        $display("PASS: %s (opcode=%b)", name, opcode_val);
        pass_count++;
      end else begin
        $display("FAIL: %s (opcode=%b)", name, opcode_val);
        $display("  Got     : alu_op=%b jump=%b beq=%b bne=%b mem_read=%b mem_write=%b alu_src=%b reg_dst=%b mem_to_reg=%b reg_write=%b",
                 vif.alu_op, vif.jump, vif.beq, vif.bne, vif.mem_read, vif.mem_write,
                 vif.alu_src, vif.reg_dst, vif.mem_to_reg, vif.reg_write);
        $display("  Expected: alu_op=%b jump=%b beq=%b bne=%b mem_read=%b mem_write=%b alu_src=%b reg_dst=%b mem_to_reg=%b reg_write=%b",
                 exp_alu_op, exp_jump, exp_beq, exp_bne, exp_mem_read, exp_mem_write,
                 exp_alu_src, exp_reg_dst, exp_mem_to_reg, exp_reg_write);
        fail_count++;
      end
    end
  endtask


  task random_opcode_test();
    pkt = new();
    assert(pkt.randomize());
    $display("\n[%0t]=== RANDOM OPCODE TEST START ===",$time);
    repeat (20) begin
      vif.opcode = pkt.opcode; #1;
      case (vif.opcode)
        4'b0000: check("RAND_LOAD",   vif.opcode, 2'b10, 0,0,0, 1,0, 1,0,1,1);
        4'b0001: check("RAND_STORE",  vif.opcode, 2'b10, 0,0,0, 0,1, 1,0,0,0);
        4'b0010: check("RAND_ADD",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b0011: check("RAND_SUB",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b0100: check("RAND_AND",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b0101: check("RAND_OR",     vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b0110: check("RAND_NOT",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b0111: check("RAND_SLL",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b1000: check("RAND_SRL",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b1001: check("RAND_SLT",    vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
        4'b1011: check("RAND_BEQ",    vif.opcode, 2'b01, 0,1,0, 0,0, 0,0,0,0);
        4'b1100: check("RAND_BNE",    vif.opcode, 2'b01, 0,0,1, 0,0, 0,0,0,0);
        4'b1101: check("RAND_JUMP",   vif.opcode, 2'b00, 1,0,0, 0,0, 0,0,0,0);
        default: check("RAND_DEFAULT",vif.opcode, 2'b00, 0,0,0, 0,0, 0,1,0,1);
      endcase
    end

    $display("=== RANDOM OPCODE TEST COMPLETE ===");
    if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);
  endtask

endclass
