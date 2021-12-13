module test(
    input clk,
    input rst,
    output  reg [29:0] counter
);
always @(posedge clk or posedge rst) begin
    if(rst)
        counter<=1'b0;
    else if(counter==30'h3fffffff)
        counter<=1'b0;
    else
        counter<=counter+1'b1;
end
endmodule //1