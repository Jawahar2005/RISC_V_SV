`include "files.svh"

class run;

  virtual RISV_V_intf vif;

  clock_generation clk_h;


  ALU_RandomizedFunctionalTest    alu_h;
  ALU_Verification                aluf_h;
  ALU_EdgeTest                    alue_h;
  Instruction_Memory_Verification im_h;
  RegisterFileRandomRWTest        rf_h;
  RegisterFile_WriteTest          wr_h;
  RegisterFile_WriteDisableTest   wrd_h; 
  RegisterFile_ReadTest           rd_h; 

  Control_Unit_test               ctrl_h;
  Control_Unit_Random_test        ctrlr_h;
  ALU_ControlUnit_Verification    aluc_h;
  DataMemoryRandomRWTest          dm_h;
  DataMemory_WriteTest            dmw_h;
  DataMemory_ReadTest             dmr_h;
  DataMemory_ReadDisableTest      dmdr_h;
  DataMemory_WriteDisableTest     dmdw_h;


  function new(virtual RISV_V_intf vif);
    this.vif = vif;
  endfunction


  task build();
    clk_h   = new(vif);


    alu_h   = new(vif);
    aluf_h  = new(vif);
    alue_h  = new(vif);
    im_h    = new(vif);
    rf_h    = new(vif);
    wr_h    = new(vif);
    wrd_h   = new(vif);
    rd_h    = new(vif);
    
    ctrl_h  = new(vif);
    ctrlr_h = new(vif);
    aluc_h  = new(vif);
    dm_h    = new(vif);
    dmw_h   = new(vif);
    dmr_h   = new(vif);
    dmdr_h  = new(vif);
    dmdw_h  = new(vif);
  endtask


  task run_test();
    build(); 

    fork
      clk_h.clk_gen();
    join_none
    
         alu_h. alu_test();
    #10; aluf_h.run_all();
    #10; alue_h.run_edge_tests();
    #10; im_h.instruction_memory_test();
    #10; rf_h.register_file_test();
    #10; wr_h.write_registers_test();
    #10; wrd_h.write_disable_test();
    #10; rd_h.read_registers_test();



    #10; ctrl_h.ctrl_unit_test();
    #10; ctrlr_h.random_opcode_test();
    #10; aluc_h.alu_ctrl_unit_test();
    #10; dm_h.data_mem_test();
    #10; dmw_h.write_memory_test();
    #10; dmr_h.read_memory_test();
    #10; dmdr_h.read_disable_test();
    #10; dmdw_h.write_disable_test();

    $finish;
  endtask
endclass
