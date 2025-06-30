class Instruction_Memory_Verification;

  virtual RISV_V_intf vif;

  int pass_count = 0;
  int fail_count = 0;
  bit [15:0] expected_memory [0:15];
  int addr;


  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction


  task instruction_memory_test();
    

    $display("[%0t]\n === INSTRUCTION MEMORY VERIFICATION START ===", $time);

    $readmemb("test.prog", expected_memory, 0, 14);

    repeat (16) begin
      generate_signals();
      compare();
    end

    $display("=== INSTRUCTION MEMORY VERIFICATION COMPLETED ===");
    $display("PASSED: %0d | FAILED: %0d", pass_count, fail_count);

    if (fail_count == 0)
      $display("*** ALL TESTS PASSED ***");
    else
      $display("*** SOME TESTS FAILED ***"); 
  endtask

  task generate_signals();   
    vif.pc = $random;
    addr   = vif.pc[4:1];
  endtask

  

  task compare();
    #1;
    if (vif.instruction == expected_memory[addr]) begin
      pass_count++;
      $display("[%0t] [PASS] PC=%0d (Addr=%0d) => Instruction: %b",
               $time, vif.pc, addr, vif.instruction);
    end else begin
      fail_count++;
      $display("[%0t] [FAIL] PC=%0d (Addr=%0d) => DUT: %b | Expected: %b",
               $time, vif.pc, addr, vif.instruction, expected_memory[addr]);
    end
  endtask

  // $finish;

endclass
