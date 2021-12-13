`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/23 17:44:56
// Design Name: 
// Module Name: test
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


module test(
    input clk,
    input rst,
    output  [7:0] counter
);
reg [31:0] temp;
assign counter = temp[31:24];
always @(posedge clk or posedge rst) begin
    if(rst)
        temp<=1'b0;
    else
        temp<=temp+1'b1;
end
endmodule
