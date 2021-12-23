module test(
    input clk,rst,
    output led
);
reg [1:0] cnt;
reg [1:0] q;
always @(*) begin
    cnt=q+1'b1;
end
always @(posedge clk) begin
    if(rst == 1'b0)
        q<=1'b0;
    else
        q<=cnt;
end
assign led = (cnt == 2'b11)?1'b1:1'b0;
endmodule //lab8_1