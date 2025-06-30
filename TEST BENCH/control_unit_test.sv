class Control_Unit_test;

  virtual RISV_V_intf vif; 

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
        $display("[%0t] PASS: %s (opcode=%b)", $time,name, opcode_val);
        pass_count++;
      end else begin
        $display("[%0t] FAIL: %s (opcode=%b)",$time, name, opcode_val);
        $display("  Got     : alu_op=%b jump=%b beq=%b bne=%b mem_read=%b mem_write=%b alu_src=%b reg_dst=%b mem_to_reg=%b reg_write=%b",
                 vif.alu_op, vif.jump, vif.beq, vif.bne, vif.mem_read, vif.mem_write, vif.alu_src, vif.reg_dst, vif.mem_to_reg, vif.reg_write);
        $display("  Expected: alu_op=%b jump=%b beq=%b bne=%b mem_read=%b mem_write=%b alu_src=%b reg_dst=%b mem_to_reg=%b reg_write=%b",
                 exp_alu_op, exp_jump, exp_beq, exp_bne, exp_mem_read, exp_mem_write, exp_alu_src, exp_reg_dst, exp_mem_to_reg, exp_reg_write);
        fail_count++;
      end
    end
  endtask

  task ctrl_unit_test();
    $display("\n [%0t] === CONTROL UNIT VERIFICATION START ===", $time);

    check("LOAD",   4'b0000, 2'b10, 0,0,0, 1,0, 1,0,1,1);
    check("STORE",  4'b0001, 2'b10, 0,0,0, 0,1, 1,0,0,0);
    check("ADD",    4'b0010, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("SUB",    4'b0011, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("AND",    4'b0100, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("OR",     4'b0101, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("NOT",    4'b0110, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("SLL",    4'b0111, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("SRL",    4'b1000, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("SLT",    4'b1001, 2'b00, 0,0,0, 0,0, 0,1,0,1);
    check("BEQ",    4'b1011, 2'b01, 0,1,0, 0,0, 0,0,0,0);
    check("BNE",    4'b1100, 2'b01, 0,0,1, 0,0, 0,0,0,0);
    check("JUMP",   4'b1101, 2'b00, 1,0,0, 0,0, 0,0,0,0);
    check("DEFAULT",4'b1111, 2'b00, 0,0,0, 0,0, 0,1,0,1);

    if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== CONTROL UNIT VERIFICATION COMPLETED ===");
  endtask

endclass
