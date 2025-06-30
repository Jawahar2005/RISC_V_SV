class RegisterFile_WriteDisableTest;

  bit [15:0] expected_regs [7:0];  
  int pass_count = 0;
  int fail_count = 0;
  int index;
  virtual RISV_V_intf vif;

  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  task write_disable_test();
    $display("\n[%0t] === WRITE DISABLE TEST START ===", $time);

    
    initialize_registers();

    repeat (10) begin
      generate_signals();
      compare();
    end

    if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== WRITE DISABLE TEST Completed ===");
  endtask

  // Task to initialize all registers with known values
  task initialize_registers();
    for (int i = 0; i < 8; i++) begin
      vif.reg_write_en    = 1;
      vif.reg_write_dest  = i[2:0];
      vif.reg_write_data  = i * 1000;
      vif.reg_read_addr_1 = i[2:0];

      @(posedge vif.clk);
      expected_regs[i] = vif.reg_write_data;
    end
    vif.reg_write_en = 0;
  endtask

  task generate_signals();
  
    vif.reg_write_en    = 0;  
    vif.reg_write_dest  = $urandom_range(0, 7);
    vif.reg_write_data  = $urandom_range(0, 65535);
    vif.reg_read_addr_1 = vif.reg_write_dest;

    @(posedge vif.clk); 
  endtask

  task compare();
    @(negedge vif.clk); 

    index = vif.reg_write_dest;
    if (vif.reg_read_data_1 !== expected_regs[index]) begin
      $display("[%0t] [FAIL] Write occurred at R[%0d] despite write_en=0: Got %0d, Expected %0d",
               $time, index, vif.reg_read_data_1, expected_regs[index]);
      fail_count++;
    end else begin
      $display("[%0t] [PASS] No write at R[%0d] as expected (write_en=0): Value = %0d",
               $time, index, vif.reg_read_data_1);
      pass_count++;
    end
  endtask
endclass
