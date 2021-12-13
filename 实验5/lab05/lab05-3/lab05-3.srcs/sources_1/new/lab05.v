`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 15:26:03
// Design Name: 
// Module Name: lab05
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


module d_ff_r(
input clk,rst_n,d,
output reg q);
always@(posedge clk)
begin
    if(rst_n==0)//Í¬²½¸´Î»
        q <= 1'b0;
    else
        q <= d;
end
endmodule
