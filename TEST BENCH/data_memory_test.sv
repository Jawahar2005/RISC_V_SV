class ALU_ControlUnit_Verification;
  
  ALUControl_packet pkt;

  int pass_count = 0;
  int fail_count = 0;
  bit [2:0] exp_cnt;


  virtual RISV_V_intf vif;
  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction

 
  function [2:0] expected_alu_cnt(input [1:0] alu_op_val, input [3:0] opcode_val);
    casez ({alu_op_val, opcode_val})
      6'b10zzzz: expected_alu_cnt = 3'b000;
      6'b01zzzz: expected_alu_cnt = 3'b001;
      6'b000010: expected_alu_cnt = 3'b000;
      6'b000011: expected_alu_cnt = 3'b001;
      6'b000100: expected_alu_cnt = 3'b010;
      6'b000101: expected_alu_cnt = 3'b011;
      6'b000110: expected_alu_cnt = 3'b100;
      6'b000111: expected_alu_cnt = 3'b101;
      6'b001000: expected_alu_cnt = 3'b110;
      6'b001001: expected_alu_cnt = 3'b111;
      default  : expected_alu_cnt = 3'b000;
    endcase
  endfunction

  
  task alu_ctrl_unit_test();
    $display("\n[%0t] === RANDOMIZED ALU CONTROL VERIFICATION START ===", $time);

    repeat (30) begin
       alu_ctrl_unit_test_generate();
      compare();
    end
      
       if (fail_count == 0)
      $display("[%0t] ALL TESTS PASSED (%0d cases)", $time, pass_count);
    else
      $display("[%0t] TEST FAILED: %0d passed, %0d failed", $time, pass_count, fail_count);

    $display("[%0t] === RANDOMIZED ALU CONTROL VERIFICATION END ===", $time);
  endtask

      
      
      
    task alu_ctrl_unit_test_generate();
      pkt = new();
      assert(pkt.randomize());
      vif.ALUOp = pkt.ALUOp;
      vif.Opcode = pkt.Opcode;
      #1;

      exp_cnt = expected_alu_cnt(vif.ALUOp, vif.Opcode);
    endtask
    task compare();
      if (vif.ALU_Cnt === exp_cnt) begin
        $display("[%0t] PASS: ALUOp=%b Opcode=%b => ALU_Cnt=%b", $time, vif.ALUOp, vif.Opcode, vif.ALU_Cnt);
        pass_count++;
      end else begin
        $display("[%0t] FAIL: ALUOp=%b Opcode=%b => Got=%b, Expected=%b", $time, vif.ALUOp, vif.Opcode, vif.ALU_Cnt, exp_cnt);
        fail_count++;
      end
     endtask

   
endclass
