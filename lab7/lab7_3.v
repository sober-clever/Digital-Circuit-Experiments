`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/04 15:48:02
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
    input clk,rst,
    output reg [2:0]an,
    output reg [3:0]d
    );
reg [3:0]min;
reg [5:0]sec;
reg [3:0]sec2;
reg [31:0] cnt;
reg [1:0]flag;

always@(posedge clk)
begin
    if(rst==1'b1)
    begin
        min<=1'b1;
        sec<=5'b10111;//2'd23
        sec2<=3'b100;//1'd4
    end
    cnt<=cnt+1'b1;
    if(cnt % 500000 == 0)
    begin
        flag <= flag+1'b1;
    end
    if(cnt == 10000000)
    begin
        cnt <= 1'b0;
        sec2 <= sec2+1'b1;   
        if(sec2 == 4'b1001)//sec2==10
        begin
            sec2 <= 1'b0;
            sec <=sec+1'b1;
            if(sec == 6'b111011)//sec==59
            begin
                min<=min+1'b1;
                sec<=1'b0;
            end
        end
    end
end

always@(*)
begin
    case(flag)
        2'b00:
            begin
                an<=3'b000;
                d<=sec2;
            end
        2'b01:
            begin
                an<=3'b001;
                d<=sec%10;
            end
      2'b10:
            begin
                an<=3'b010;
                d<=sec/10;
            end
      2'b11:
            begin
                an<=3'b011;
                d<=min;
            end
    endcase
end
    
endmodule
