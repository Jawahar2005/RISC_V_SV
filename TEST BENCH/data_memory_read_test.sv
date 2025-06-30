class DataMemory_ReadTest;


  virtual RISV_V_intf vif;
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction
 
  bit [15:0] expected_memory[7:0];
  int pass_count = 0;
  int fail_count = 0;
int addr1;
  task read_memory_test();
    $display("\n[%0t] === DATA MEMORY READ TEST START ===", $time);
    
    repeat(30) begin
      test_read_memory_generate();
      compare();
    end
      
  if (fail_count == 0)
      $display("[%0t] ALL DATA MEMORY READ TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] DATA MEMORY READ TEST FAILED: %0d passed, %0d failed",
                $time, pass_count, fail_count);

    $display("=== DATA MEMORY READ TEST Completed ===");
  endtask  
  task test_read_memory_generate();
     foreach (expected_memory[i]) begin
      vif.mem_access_addr = i;
      vif.mem_write_data  = $random;
      vif.mem_write_en    = 1;
      vif.mem_read_en     = 0;

       @(posedge vif.clk); 
       expected_memory[i] = vif.mem_write_data;
    end

   
    vif.mem_write_en = 0;
    vif.mem_read_en  = 1;

   
  
      addr1 = $urandom_range(0, 7);
      vif.mem_access_addr = addr1;
  endtask
    task compare();
      @(posedge vif.clk); 

      if (vif.mem_read_data == expected_memory[addr1]) begin
        pass_count++;
        $display("[%0t] [PASS] Addr[%0d] = %0d", $time, addr1, vif.mem_read_data);
      end else begin
        fail_count++;
        $display("[%0t] [FAIL] Addr[%0d] = %0d (Expected = %0d)", $time,
                 addr1, vif.mem_read_data, expected_memory[addr1]);
      end
      endtask

   
  
  
  

endclass
