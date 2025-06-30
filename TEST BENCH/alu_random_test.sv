class ALU_RandomizedFunctionalTest;

  reg [15:0] expected_result;
  reg expected_zero;

  int pass_count = 0;
  int fail_count = 0;

  ALU_packet pkt;

  
  virtual RISV_V_intf vif;
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  task alu_test();
    $display("\n[%0t] === ALU RANDOMIZATION VERIFICATION START ===", $time);

    repeat(40) begin 
      generate_signals();
      compare();
    end
    $display("[%0t] === ALU TESTING COMPLETED ===", $time);
    $display("[%0t] PASSED: %0d | FAILED: %0d", $time, pass_count, fail_count);

    if (fail_count == 0)
      $display("[%0t] *** ALL TESTS PASSED ***", $time);
    else
      $display("[%0t] *** SOME TESTS FAILED ***", $time);
  endtask

  task generate_signals();
    pkt = new();
    assert(pkt.randomize());
    vif.a         = pkt.a;
    vif.b         = pkt.b;
    vif.alu_ctrl  = pkt.alu_ctrl; 
  endtask

  task compare();
    case (vif.alu_ctrl)
      3'b000: expected_result = vif.a + vif.b;   
      3'b001: expected_result = vif.a - vif.b;   
      3'b010: expected_result = ~vif.a;   
      3'b011: expected_result = vif.a << vif.b;   
      3'b100: expected_result = vif.a >> vif.b;   
      3'b101: expected_result = vif.a & vif.b; 
      3'b110: expected_result = vif.a | vif.b;
      3'b111: expected_result = (vif.a < vif.b) ? 16'd1 : 16'd0;
      default: expected_result = vif.a + vif.b;
    endcase

    expected_zero = (expected_result == 0);
    #1; 

    if (vif.result == expected_result && vif.zero == expected_zero) begin
      pass_count++;
      $display("[%0t] [PASS] ALU_OP: %0d | A: %0d | B: %0d => Result: %0d, Zero: %0b", 
               $time, vif.alu_ctrl, vif.a, vif.b, vif.result, vif.zero);
    end 
    else begin
      fail_count++;
      $display("[%0t] [FAIL] ALU_OP: %0d | A: %0d | B: %0d => DUT Result: %0d (Expected: %0d), DUT Zero: %0b (Expected: %0b)",
               $time, vif.alu_ctrl, vif.a, vif.b, vif.result, expected_result, vif.zero, expected_zero);
    end

  endtask

endclass
