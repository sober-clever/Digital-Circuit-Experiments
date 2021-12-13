module down_counter(//递减计数器
    input clk,rst,
    output reg [3:0]d_out
);

always @(posedge clk or negedge rst) begin//异步复位
    if(rst==0)
        d_out<=4'd9;
    else if(d_out==4'b0000)//减到0的时候就恢复到9
        d_out<=4'd9;
    else
        d_out<=d_in;
end
endmodule //数电实验3-4