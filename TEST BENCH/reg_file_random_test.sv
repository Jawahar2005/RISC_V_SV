class RegisterFileRandomRWTest;

  int pass_count = 0;
  int fail_count = 0;

  bit [15:0] expected_regs[7:0]; 

  virtual RISV_V_intf vif;
  
  RegisterFile_packet pkt; 

  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  task register_file_test();
    foreach (expected_regs[i]) expected_regs[i] = 16'd0;

    $display("\n[%0t] === REGISTER FILE VERIFICATION START ===", $time);
    
    repeat (30) begin
      generate_signals();
      compare();
    end
    
    $display("[%0t] === REGISTER FILE VERIFICATION COMPLETED ===", $time);
    $display("PASSED: %0d | FAILED: %0d", pass_count, fail_count);

    if (fail_count == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** SOME TESTS FAILED ***");
  endtask


  task generate_signals();
    pkt = new();
    assert(pkt.randomize());
    vif.reg_write_en    = pkt.reg_write_en;
    vif.reg_write_dest  = pkt.reg_write_dest;
    vif.reg_write_data  = pkt.reg_write_data;
    vif.reg_read_addr_1 = pkt.reg_read_addr_1;
    vif.reg_read_addr_2 = pkt.reg_read_addr_2;
  endtask

  task compare();
    @(posedge vif.clk);
    if (vif.reg_write_en)
      expected_regs[vif.reg_write_dest] = vif.reg_write_data;


    @(negedge vif.clk);
    if (vif.reg_read_data_1 === expected_regs[vif.reg_read_addr_1] &&
        vif.reg_read_data_2 === expected_regs[vif.reg_read_addr_2]) begin
      pass_count++;
      $display("[%0t] [PASS] R1[%0d]=%0d, R2[%0d]=%0d", $time,
               vif.reg_read_addr_1, vif.reg_read_data_1,
               vif.reg_read_addr_2, vif.reg_read_data_2);
    end else begin
      fail_count++;
      $display("[%0t] [FAIL] R1[%0d]=%0d (Expected=%0d), R2[%0d]=%0d (Expected=%0d)", $time,
               vif.reg_read_addr_1, vif.reg_read_data_1, expected_regs[vif.reg_read_addr_1],
               vif.reg_read_addr_2, vif.reg_read_data_2, expected_regs[vif.reg_read_addr_2]);
    end

  endtask

endclass
