`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/17 14:15:23
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


module test_bench();
reg clk,rst_n,clk_a;
reg [7:0] r1,r2,r3;
integer i;
initial clk = 0;
always #5 clk = ~clk;
initial
begin
    rst_n = 0;
    #55 rst_n = 1;
    #245 $stop;   //��ʾֹͣ����
end

initial//��ʼ�� ֻ�ڷ��濪ʼʱ����һ��
begin
    clk_a = 0;
    forever #5 clk_a = ~clk_a; // #5��ʾ5��ʱ�䵥λ����ʱ
end

initial
begin
    r1 = 0;
    repeat(10)
    begin//�ظ�10��
        @(posedge clk);
         #2 r1 = $random%256; //$random��ʾ����һ������� randomΪϵͳ������
    end 
end

initial
begin
    for(i=0;i<20;i=i+1)
    begin
        r2 = i;#10;
    end
end

initial
begin
    r3=0;
    while(r3<10)
    begin
        @(posedge clk);
        r3 = r3 +1;
    end
end
endmodule
