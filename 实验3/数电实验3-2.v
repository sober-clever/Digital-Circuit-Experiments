module d_ff_r(
    input clk,rst,d,
    output reg q 
);
always @(posedge clk) begin
    if(rst==1'b1)//置位信号高电平有效
        q<=1'b1;
    else
        q<=d;
end
endmodule //数电实验3-2