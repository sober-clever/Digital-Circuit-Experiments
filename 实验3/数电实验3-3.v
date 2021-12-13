module counter(//异步复位
    input clk,rst,
    output reg [3:0]d_out
);

always @(posedge clk or negedge rst) begin//异步复位
    if(rst==0)
        d_out<=4'b0000;
    else if(d_out==4'b1111)//模16计数器
        d_out<=4'b0000;
    else
        d_out<=d_out+1'b1;
end
endmodule //数电实验3-3