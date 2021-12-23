`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/06 21:28:10
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
    input clk,button,rst,
    output reg[3:0] hexplay_data,
    output reg[2:0] hexplay_an
    );
    //组合电路
    reg [3:0] cnt1;
    reg [3:0] cnt2;
    reg [31:0] cnt;
    reg  flag;
    wire button_clean;
    reg [15:0] button_cnt;
    always@(posedge clk)
    begin
        if(button==1'b0)
            button_cnt <= 1'b0;
        if(button_cnt<16'h8000)
            button_cnt<=button_cnt+1'b1;
    end
    assign button_clean = button_cnt[15];
    always@(posedge clk)
    begin
        if(rst)
        begin
            cnt1 <= 4'hf;
            cnt2 <= 1'b1;
        end
        cnt <= cnt+1'b1;
        if(cnt == 100000000)
        begin            
            cnt <= 1'b0;        
            if(!button_clean)
            begin
                cnt1 <= cnt1+1'b1;
                if(cnt1 == 4'b1111)
                    cnt2 <= cnt2+1'b1;
             end
             else
             begin
                cnt1 <= cnt1-1'b1;
                if(cnt1 == 4'b0000)
                    cnt2 <= cnt2-1'b1;
             end      
        end
        if(cnt % 1000000 == 0)
        begin
            flag <= flag+1'b1;
        end

    end
    always@(*)
    begin
        case(flag)
        1'b0: begin
                hexplay_data <= cnt1;
                hexplay_an <= 1'b0;
               end
         1'b1:begin
                 hexplay_data <= cnt2;
                 hexplay_an <= 1'b1;
               end
         endcase
    end
endmodule
