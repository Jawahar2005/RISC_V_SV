class DataMemory_ReadDisableTest;

  
  virtual RISV_V_intf vif;
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction
 
  int pass_count = 0;
  int fail_count = 0;
int addr;
  task read_disable_test();
    $display("\n[%0t] === READ DISABLE TEST START ===", $time);
    
    repeat(30) begin
       test_read_disable_generate();  
      compare();
    end
      if (fail_count == 0)
      $display("[%0t] ALL READ DISABLE TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] READ DISABLE TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== READ DISABLE TEST Completed ===");
 endtask


    task test_read_disable_generate();  
      for (int i = 0; i < 8; i++) begin
      vif.mem_access_addr = i;
      vif.mem_write_data  = i * 10;
      vif.mem_write_en    = 1;
      vif.mem_read_en     = 0;
      @(posedge vif.clk);
     end

    vif.mem_write_en = 0;
    vif.mem_read_en  = 0;
    
       addr = $urandom_range(0, 7);
      vif.mem_access_addr = addr;
    endtask
    task compare();
      @(posedge vif.clk);
      if (vif.mem_read_data !== 16'd0) begin
        fail_count++;
        $display("[%0t] [FAIL] Read disabled, but data at Addr[%0d] = %0d (Expected = 0)", 
                  $time, addr, vif.mem_read_data);
      end else begin
        pass_count++;
        $display("[%0t] [PASS] Read disabled correctly at Addr[%0d] = %0d", 
                  $time, addr, vif.mem_read_data);
      end
    
      endtask
   
    

endclass
