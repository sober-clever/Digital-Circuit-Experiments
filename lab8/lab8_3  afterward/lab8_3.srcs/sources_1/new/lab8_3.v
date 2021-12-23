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
module signal_edge(
    input clk,button,
    output button_edge
    );
    reg button_r1,button_r2;
    always@(posedge clk)
    begin
        button_r1 <= button;
    end
    always@(posedge clk)
    begin
        button_r2 <= button_r1;
    end
    assign button_edge = button_r1 & (~button_r2);
endmodule

module test(
    input clk,button,sw,sw1,
    output reg[3:0] hexplay_data,
    output reg[2:0] hexplay_an
    );
    //组合电路
    reg [3:0] cnt1;
    reg [3:0] cnt2;
    reg [31:0] cnt;
    reg  flag;
   wire button_edge;
   signal_edge ins(.clk(clk),.button(button),.button_edge(button_edge));
    
    always@(posedge clk)
    begin
        if(button_edge)
        begin
            if(sw1)//复位
            begin
                cnt1 <= 4'hf;
                cnt2 <= 1'b1;
            end
            else
            begin
                if(sw)
                begin
                    if(cnt1 == 4'hf)
                        cnt2 <= cnt2 + 1'b1;
                    cnt1 <= cnt1 + 1'b1;
                end   
                else
                begin
                    if(cnt1 == 4'h0)
                        cnt2 <= cnt2 - 1'b1;
                    cnt1 <= cnt1 - 1'b1;
                end   
            end
        end
        cnt <= cnt+1'b1;
       
        if(cnt == 1000000)
        begin
            cnt <= 1'b0;
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
