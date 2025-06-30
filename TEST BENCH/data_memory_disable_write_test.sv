class DataMemory_WriteDisableTest;


  virtual RISV_V_intf vif;
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction


  bit [15:0] expected_memory[7:0];
  int pass_count = 0;
  int fail_count = 0;
  int addr;

  task write_disable_test();
    $display("\n[%0t] === WRITE DISABLE TEST START ===", $time);


    repeat (30) begin 
      generate_signals();
      compare();
    end




    if (fail_count == 0)
      $display("[%0t] ALL WRITE DISABLE TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] WRITE DISABLE TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== WRITE DISABLE TEST Completed ===");

  endtask 


  task generate_signals();
    for (int i = 0; i < 8; i++) begin
      vif.mem_access_addr = i;
      vif.mem_write_data  = i * 5;
      vif.mem_write_en    = 1;
      vif.mem_read_en     = 0;
      @(posedge vif.clk);
      expected_memory[i] = vif.mem_write_data;
    end


    vif.mem_write_en = 0;
    vif.mem_read_en  = 0;



    addr = $urandom_range(0, 7);
    vif.mem_access_addr = addr;
    vif.mem_write_data  = $random;

    @(posedge vif.clk); 


    vif.mem_write_en = 0;
    vif.mem_read_en  = 1;
  endtask
  task compare();
    @(posedge vif.clk);

    if (vif.mem_read_data != expected_memory[addr]) begin
      fail_count++;
      $display("[%0t] [FAIL] Write disabled but Addr[%0d] changed to %0d (Expected = %0d)",
               $time, addr, vif.mem_read_data, expected_memory[addr]);
    end else begin
      pass_count++;
      $display("[%0t] [PASS] Write disabled correctly at Addr[%0d] = %0d",
               $time, addr, vif.mem_read_data);
    end

    vif.mem_read_en = 0;

  endtask

endclass

