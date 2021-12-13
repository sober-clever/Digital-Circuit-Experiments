`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 15:15:06
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
reg clk,D,RST_N;
initial clk = 1'b0; 
always #5 clk = ~clk;
initial
begin
            D = 1'b0; RST_N = 1'b0;
        #13 D = ~D;
        #14 RST_N = ~RST_N;
        #10 D = ~D;
        #13 $finish;
end
endmodule
