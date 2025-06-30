class ALU_EdgeTest;
 virtual RISV_V_intf vif;
  
  int pass_count = 0;
  int fail_count = 0;
  int expected_result;
  int expected_zero;

  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

  task check(string testname);
    

    case (vif.alu_ctrl)
      3'b000: expected_result = vif.a + vif.b;           
      3'b001: expected_result = vif.a - vif.b;           
      3'b010: expected_result = ~vif.a;                  
      3'b011: expected_result = vif.a << vif.b;          
      3'b100: expected_result = vif.a >> vif.b;          
      3'b101: expected_result = vif.a & vif.b;           
      3'b110: expected_result = vif.a | vif.b;           
      3'b111: expected_result = (vif.a < vif.b) ? 16'd1 : 16'd0;  
      default: expected_result = 16'd0;
    endcase

    expected_result = expected_result & 16'hFFFF;
    expected_zero = (expected_result == 16'd0);

    #1;

    if (vif.result == expected_result && vif.zero == expected_zero) begin
      pass_count++;
      $display("[PASS] %s | a=%0d b=%0d alu_ctrl=%0d => result=%0d, zero=%0b",
               testname, vif.a, vif.b, vif.alu_ctrl, vif.result, vif.zero);
    end else begin
      fail_count++;
      $display("[FAIL] %s | a=%0d b=%0d alu_ctrl=%0d => result=%0d (expected=%0d), zero=%0b (expected=%0b)",
               testname, vif.a, vif.b, vif.alu_ctrl, vif.result, expected_result, vif.zero, expected_zero);
    end
  endtask

  task run_edge_tests();
    $display ("\n [%0t] === ALU EDGE CASE TEST STARTED ===", $time);

    vif.a = 16'hFFFF; vif.b = 1;   vif.alu_ctrl = 3'b000; check("ADD_OVERFLOW");
    vif.a = -1;       vif.b = -1;  vif.alu_ctrl = 3'b001; check("SUB_ZERO");
    vif.a = 16'hFFFF; vif.b = 0;   vif.alu_ctrl = 3'b010; check("NOT_ALL_1s");
    vif.a = 1;        vif.b = 16;  vif.alu_ctrl = 3'b011; check("SLL_MAX_SHIFT");
    vif.a = 16'h8000; vif.b = 16;  vif.alu_ctrl = 3'b100; check("SRL_HIGH_BIT");
    vif.a = 16'hABCD; vif.b = 0;   vif.alu_ctrl = 3'b101; check("AND_ZERO");
    vif.a = 0;        vif.b = 0;   vif.alu_ctrl = 3'b110; check("OR_ZERO");
    vif.a = 500;      vif.b = 500; vif.alu_ctrl = 3'b111; check("SLT_EQUAL");

    if (fail_count == 0)
      $display("[%0t] ALL EDGE TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] EDGE TESTS FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== ALU EDGE CASE TEST COMPLETED ===");
  endtask

endclass
