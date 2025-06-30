module ALU(
 input  [15:0] a,  //src1
 input  [15:0] b,  //src2
 input  [2:0] alu_ctrl, //function sel
 
 output reg [15:0] result,  //result 
 output zero
);
  
always @(*)
begin 
  //$display("ALU Operation started");
 case(alu_ctrl)
 3'b000: result = a + b; // add
 3'b001: result = a - b; // sub
 3'b010: result = ~a;
 3'b011: result = a<<b;
 3'b100: result = a>>b;
 3'b101: result = a & b; // and
 3'b110: result = a | b; // or
 3'b111: begin if (a<b) result = 16'd1;
    else result = 16'd0;
    end
 default:result = a + b; // add
 endcase
  //$display("result=%0d,"result);
end
  
assign zero = (result==16'd0) ? 1'b1: 1'b0;
  /*initial begin
    $monitor("%0t alu_control=%0d a=%0d b=%0d result=%0d Zero=%0d",$time,alu_control,a,b,result,zero);
  end*/
endmodule
