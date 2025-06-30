class ALU_Verification;

  
  int pass_count = 0;
  int fail_count = 0;

  
  virtual RISV_V_intf vif;

  
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction



  
  task test_add();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 65535);
      vif.alu_ctrl = 3'b000;
      #1;
      if (vif.result === ((vif.a + vif.b) & 16'hFFFF)) begin
        $display("[PASS] ADD: %0d + %0d = %0d", vif.a, vif.b, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] ADD: %0d + %0d => %0d (Expected: %0d)", vif.a, vif.b, vif.result, (vif.a + vif.b) & 16'hFFFF);
        fail_count++;
      end
    end
  endtask

  
  task test_sub();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 65535);
      vif.alu_ctrl = 3'b001;
      #1;
      if (vif.result === ((vif.a - vif.b) & 16'hFFFF)) begin
        $display("[PASS] SUB: %0d - %0d = %0d", vif.a, vif.b, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] SUB: %0d - %0d => %0d (Expected: %0d)", vif.a, vif.b, vif.result, (vif.a - vif.b) & 16'hFFFF);
        fail_count++;
      end
    end
  endtask

  
  task test_not();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.alu_ctrl = 3'b010;
      #1;
      if (vif.result === (~vif.a & 16'hFFFF)) begin
        $display("[PASS] NOT: ~%0h = %0h", vif.a, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] NOT: ~%0h => %0h (Expected: %0h)", vif.a, vif.result, ~vif.a & 16'hFFFF);
        fail_count++;
      end
    end
  endtask

 
  task test_sll();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 15);  // Shift amount limited to 4 bits
      vif.alu_ctrl = 3'b011;
      #1;
      if (vif.result === ((vif.a << vif.b) & 16'hFFFF)) begin
        $display("[PASS] SLL: %0d << %0d = %0d", vif.a, vif.b, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] SLL: %0d << %0d => %0d (Expected: %0d)", vif.a, vif.b, vif.result, (vif.a << vif.b) & 16'hFFFF);
        fail_count++;
      end
    end
  endtask

  // SRL (Shift Right Logical)
  task test_srl();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 15);
      vif.alu_ctrl = 3'b100;
      #1;
      if (vif.result === (vif.a >> vif.b)) begin
        $display("[PASS] SRL: %0d >> %0d = %0d", vif.a, vif.b, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] SRL: %0d >> %0d => %0d (Expected: %0d)", vif.a, vif.b, vif.result, vif.a >> vif.b);
        fail_count++;
      end
    end
  endtask

  // AND
  task test_and();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 65535);
      vif.alu_ctrl = 3'b101;
      #1;
      if (vif.result === (vif.a & vif.b)) begin
        $display("[PASS] AND: %0h & %0h = %0h", vif.a, vif.b, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] AND: %0h & %0h => %0h (Expected: %0h)", vif.a, vif.b, vif.result, vif.a & vif.b);
        fail_count++;
      end
    end
  endtask

  // OR
  task test_or();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 65535);
      vif.alu_ctrl = 3'b110;
      #1;
      if (vif.result === (vif.a | vif.b)) begin
        $display("[PASS] OR: %0h | %0h = %0h", vif.a, vif.b, vif.result);
        pass_count++;
      end else begin
        $display("[FAIL] OR: %0h | %0h => %0h (Expected: %0h)", vif.a, vif.b, vif.result, vif.a | vif.b);
        fail_count++;
      end
    end
  endtask

  // SLT (Set Less Than)
  task test_slt();
    repeat (10) begin
      vif.a = $urandom_range(0, 65535);
      vif.b = $urandom_range(0, 65535);
      vif.alu_ctrl = 3'b111;
      #1;
      if ((vif.a < vif.b && vif.result == 16'd1) || (vif.a >= vif.b && vif.result == 16'd0)) begin
        $display("[PASS] SLT: %0d < %0d => Result: %0d", vif.a, vif.b, vif.result);
        pass_count++;
      end
      else begin
        $display("[FAIL] SLT: %0d < %0d => Result: %0d (Expected: %0d)", vif.a, vif.b, vif.result, (vif.a < vif.b ? 1 : 0));
        fail_count++;
      end
    end
  endtask

  // Run All Tests
  task run_all();
    $display ("\n [%0t] === ALU VERIFICATION TEST STARTS ===", $time);
    repeat (2) begin
      test_add();
      test_sub();
      test_not();
      test_sll();
      test_srl();
      test_and();
      test_or();
      test_slt();
    end
    if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("=== ALU TESTING COMPLETED ===");
  endtask

endclass
