module d_ff_r(//高电平有效的异步复位
    input d,clk,rst,
    output reg q
);
    always @(posedge clk) begin
        if(rst==1)
            q<=1'b0;
        else
            q<=d;
    end
endmodule //数电实验3-5