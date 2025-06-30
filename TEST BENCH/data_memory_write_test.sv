class DataMemory_WriteTest;

  virtual RISV_V_intf vif;
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  bit [15:0] expected_mem [7:0];
  int pass_count = 0;
  int fail_count = 0;
  bit [2:0] addr;
  bit [15:0] data;

 
  task write_memory_test();
    $display("\n[%0t] === DATA MEMORY WRITE TEST START ===", $time);

    $readmemb("test.data", expected_mem, 0, 7);
    repeat(30) begin
      test_write_memory_generate();
      compare();
    end
    
    if (fail_count == 0)
      $display("[%0t] ALL DATA MEMORY TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] DATA MEMORY TEST FAILED: %0d passed, %0d failed",
                $time, pass_count, fail_count);

    $display("=== DATA MEMORY WRITE TEST Completed ===");
  endtask
task test_write_memory_generate();
    
      addr = $urandom_range(0, 7);
      data = $random;

     
      vif.mem_access_addr = addr;
      vif.mem_write_data  = data;
      vif.mem_write_en    = 1;
      vif.mem_read_en     = 0;

      @(posedge vif.clk);  
      expected_mem[addr] = data;

      
      vif.mem_write_en = 0;
      vif.mem_read_en  = 1;
 endtask
      task compare();
      @(posedge vif.clk); 

      if (vif.mem_read_data != expected_mem[addr]) begin
        $display("[%0t] [FAIL] Addr[%0d] = %0d, Expected = %0d",
                  $time, addr, vif.mem_read_data, expected_mem[addr]);
        fail_count++;
      end else begin
        $display("[%0t] [PASS] Addr[%0d] = %0d",
                  $time, addr, vif.mem_read_data);
        pass_count++;
      end
      endtask

endclass
