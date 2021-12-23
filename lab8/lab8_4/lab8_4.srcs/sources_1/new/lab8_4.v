`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/07 09:24:51
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
    input clk,button,sw,
    output reg [2:0] hexplay_an,
    output reg [3:0] hexplay_data
    );
    wire button_edge;
    parameter STATE_0 = 3'b000;
    parameter STATE_1 = 3'b001;
    parameter STATE_11 = 3'b010;
    parameter STATE_110 = 3'b011;
    parameter STATE_1100 = 3'b100;
    reg [3:0]state_num;//当前状态的编号
    reg [3:0] seq;//最近收到的4输入值
    reg [2:0] cur_state;
    reg [2:0] next_state;//状态机的下一个状态
    reg [31:0] cnt;//用于数码管显示
    reg [2:0] flag;//用于数码管显示
    
    reg [3:0]cnt_of_eff;//有效序列的数量
    reg button_r1,button_r2;

    always@(posedge clk)
        button_r1 <= button;
    always@(posedge clk)
        button_r2 <= button_r1;
    assign  button_edge = button_r1 & (~button_r2);
    
    always@(*)
    begin
        if(button_edge)
        begin
            if(sw)//sw == 1
            begin
                case(cur_state)
                    STATE_0: 
                        next_state =  STATE_1;
                    STATE_1: 
                        next_state =  STATE_11;
                    STATE_11: 
                        next_state = STATE_11;
                    STATE_110: 
                    begin
                        next_state = STATE_1;
                    end
                    STATE_1100: 
                        next_state = STATE_1;
                    default : 
                        next_state = STATE_1;      
                endcase    
            end

            else //sw == 0
            begin
                case(cur_state)
                    STATE_11: 
                        next_state = STATE_110;
                    STATE_110: 
                        next_state = STATE_1100;                        
                    default: 
                        next_state = STATE_0;

                endcase
            end
         end
    end

    always @(posedge clk) begin
        if(button_edge)
        begin
            cur_state <= next_state;
            //if(cur_state == STATE_1100)
            if(cur_state == STATE_110 && sw == 0) 
                cnt_of_eff <= cnt_of_eff + 1'b1;
         end    
    end
    
    always@(posedge clk)begin
        if(button_edge)
            seq <= {seq[2:0],sw};
    end
    
    always@(posedge clk) begin
        cnt <= cnt + 1'b1;
        if(cnt == 300000)
        begin
            cnt <= 1'b0;
            flag <= flag + 1'b1;
            if(flag == 3'b110)
                flag <= 3'b000;
        end
       
    end

    always @(*) begin
        case(flag)
            3'b000:
                begin
                    hexplay_an = 3'b110;
                    hexplay_data =  cnt_of_eff;               
                end
            3'b001:
                begin
                    hexplay_an = 3'b111;
                    hexplay_data = cur_state;
                end
            3'b010:
                begin
                    hexplay_an = 3'b000;
                    hexplay_data = seq[0];
                end
            3'b011:
                begin
                    hexplay_an = 3'b001;
                    hexplay_data = seq[1];
                end
            3'b100:
                begin
                    hexplay_an = 3'b010;
                    hexplay_data = seq[2];
                end
            3'b101:
                begin
                    hexplay_an = 3'b011;
                    hexplay_data = seq[3];
                end
            default:
                begin
                    hexplay_an = 3'b110;
                    hexplay_data =  cnt_of_eff;
                end
        endcase
    end
endmodule