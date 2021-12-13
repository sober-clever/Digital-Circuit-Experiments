`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 17:19:55
// Design Name: 
// Module Name: test_bench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_bench( );
reg [3:0] in;
wire [7:0] out;
lab5 ins(.in(in),.out(out));
initial
begin
          in = 3'b000;
      #20 in = 3'b001;
      #20 in = 3'b010;
      #20 in = 3'b011;
      #20 in = 3'b100;
      #20 in = 3'b101;
      #20 in = 3'b110;
      #20 in = 3'b111;
      #20 $finish;
end
endmodule
