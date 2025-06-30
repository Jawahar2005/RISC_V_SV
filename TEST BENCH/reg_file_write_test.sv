class RegisterFile_WriteTest;

  virtual RISV_V_intf vif;

  bit [15:0] expected_regs[7:0];


  int pass_count = 0;
  int fail_count = 0;

  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction


  task write_registers_test();
    $display("\n[%0t] === REGISTER FILE WRITE TEST START ===", $time);
    foreach (expected_regs[i])
      expected_regs[i] = 16'd0;

    repeat (30) begin 
      generate_signals();
      compare();
    end
    
    $display("=== REGISTER FILE WRITE TEST COMPLETED ===");
    if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);
  endtask

  task generate_signals();
    vif.reg_write_en    = 1;
    vif.reg_write_dest  = $urandom_range(0, 7);        
    vif.reg_write_data  = $urandom_range(0, 65535);    
    vif.reg_read_addr_1 = vif.reg_write_dest;
  endtask


  task compare();
    @(posedge vif.clk);
    if (vif.reg_write_en)
      expected_regs[vif.reg_write_dest] = vif.reg_write_data;


    @(negedge vif.clk);
    if (vif.reg_read_data_1 !== expected_regs[vif.reg_read_addr_1]) begin
      $display("[%0t] [FAIL] Write mismatch at R[%0d]: Got %0d, Expected %0d",
               $time, vif.reg_write_dest, vif.reg_read_data_1, expected_regs[vif.reg_write_dest]);
      fail_count++;
    end else begin
      $display("[%0t] [PASS] Register[%0d] written correctly: %0d",
               $time, vif.reg_write_dest, vif.reg_write_data);
      pass_count++;
    end
    
    // $finish;
  endtask

endclass
