`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 14:43:30
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
reg a,b;
initial
begin
             a = 1'b1; b = 1'b0;
       #100  a = 1'b1; b = 1'b1;
       #100  a = 1'b0; b = 1'b1;
       #75   a = 1'b0; b = 1'b0;
       #75   a = 1'b0; b = 1'b1;
       #50   $finish; 
end
endmodule
