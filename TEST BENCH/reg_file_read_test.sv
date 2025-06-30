class RegisterFile_ReadTest;

  bit [15:0] expected_regs[7:0];  
  int pass_count = 0;
  int fail_count = 0;

  virtual RISV_V_intf vif;

  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  task read_registers_test();
    $display("\n[%0t] === READ TEST START ===", $time);


    repeat (30) begin
      generate_signals();
      compare();
    end

  
    if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== READ TEST Completed ===");
  endtask

  task generate_signals();
        for (int i = 0; i < 8; i++) begin
      vif.reg_write_en   = 1;
      vif.reg_write_dest = i[2:0];
      vif.reg_write_data = $urandom_range(0, 65535);

      @(posedge vif.clk);
      expected_regs[i] = vif.reg_write_data;
    end
    vif.reg_write_en = 0;
    vif.reg_read_addr_1 = $urandom_range(0, 7);
    vif.reg_read_addr_2 = $urandom_range(0, 7);
    
  endtask

  task compare();
    #1; 
    if (vif.reg_read_data_1 === expected_regs[vif.reg_read_addr_1] &&
        vif.reg_read_data_2 === expected_regs[vif.reg_read_addr_2]) begin
      pass_count++;
      $display("[%0t] [PASS] Read: R1[%0d]=%0d, R2[%0d]=%0d", $time,
               vif.reg_read_addr_1, vif.reg_read_data_1,
               vif.reg_read_addr_2, vif.reg_read_data_2);
    end else begin
      fail_count++;
      $display("[%0t] [FAIL] Read mismatch: R1[%0d]=%0d (Expected=%0d), R2[%0d]=%0d (Expected=%0d)",
               $time,
               vif.reg_read_addr_1, vif.reg_read_data_1, expected_regs[vif.reg_read_addr_1],
               vif.reg_read_addr_2, vif.reg_read_data_2, expected_regs[vif.reg_read_addr_2]);
    end
  endtask

endclass
