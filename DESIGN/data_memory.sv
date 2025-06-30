`include "parameter_file.sv"

module Data_Memory(
  input clk,
  input [15:0] mem_access_addr,
  input [15:0] mem_write_data,
  input mem_write_en,
  input mem_read,
  output logic [15:0] mem_read_data
);

  reg [`col - 1:0] memory [`row_d - 1:0];
  wire [2:0] ram_addr = mem_access_addr[2:0];

 

  initial begin
    
    $readmemb("test.data", memory, 0, 7);
    
    $display(  "time = %0d\n", $time, 
           "\tmemory[0] = %b\n", memory[0],   
           "\tmemory[1] = %b\n", memory[1],
           "\tmemory[2] = %b\n", memory[2],
           "\tmemory[3] = %b\n", memory[3],
           "\tmemory[4] = %b\n", memory[4],
           "\tmemory[5] = %b\n", memory[5],
           "\tmemory[6] = %b\n", memory[6],
           "\tmemory[7] = %b\n", memory[7]);
    

    

   // `simulation_time
  end

  always @(posedge clk) begin
    if (mem_write_en)
      memory[ram_addr] <= mem_write_data;
  end

  assign mem_read_data = (mem_read == 1'b1) ? memory[ram_addr] : 16'd0;

endmodule
