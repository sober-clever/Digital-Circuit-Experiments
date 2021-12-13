module d_ff (
    input clk,d,
    output reg q
);
always @(posedge clk) 
        q<=d;
endmodule //数电实验3-0

module d_ff_r( //同步复位触发器
    input clk,d,rst,
    output reg q
);
always @(posedge clk) begin
    if(rst == 0)
        q<=1'b0;//一种数据表示方式，一般表示为“数据位宽'进制数值”
    else
        q<=d;
end
endmodule //数电实验3-0

module d_ff_r2(//异步复位触发器
    input clk,d,rst,
    output reg q
);
always @(posedge clk or negedge rst) begin
    if(rst==0)
        q<=1'b0;
    else
        q<=d;
end
endmodule //数电实验3-0

module REG4(
        input CLK,RST_N,
        input [3:0] D_IN,
        output reg [3:0] q 
);
always @(posedge CLK) begin//同步复位
    if(RST_N==0)
        q<=4'b0;
    else
        q<=D_IN;
end
endmodule //数电实验3-0