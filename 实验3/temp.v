module my_dff(input clk,input d,output reg q);
	always@(posedge clk)
    	q <= d;
endmodule

module top_module ( input clk, input d, output q );
 // Write your code here
  wire q1,q2;
  my_dff ins_name1(
    .clk (clk),
    .d (d),
    .q (q1)
  );
  my_dff ins_name2(
    .clk (clk),
    .d (q1),
    .q (q2)
  );
  my_dff ins_name3(
    .clk (clk),
    .d (q2),
    .q (q)
  );
endmodule
