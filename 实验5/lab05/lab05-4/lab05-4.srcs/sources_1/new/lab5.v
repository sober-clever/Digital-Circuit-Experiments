`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 17:20:43
// Design Name: 
// Module Name: lab5
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


module lab5(
    input [2:0] in,
    output reg [7:0] out
    );
always@(*)
begin  
    case(in)
        3'b000: out = 8'b11111110;
        3'b001: out = 8'b11111101;
        3'b010: out = 8'b11111011;
        3'b011: out = 8'b11110111;
        3'b100: out = 8'b11101111;
        3'b101: out = 8'b11011111;
        3'b110: out = 8'b10111111;
        3'b111: out = 8'b01111111;
    endcase
end
endmodule
