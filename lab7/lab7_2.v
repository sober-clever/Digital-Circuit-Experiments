module test(
    input clk,
    input [7:0] sw,
    output reg [2:0] an,
    output reg [3:0] d
    );
 reg [31:0]cnt;
 reg flag;
 always@(posedge clk)
 begin
      cnt<=cnt+1'b1;
      if(cnt >= 1000000)
     begin
           flag<=~flag;
           cnt<=1'b0;
     end
 end
 
 always@(*)
 begin
  case(flag)
        1'b0:
            begin
                d = sw[3:0];
                an = 3'b000;
            end
        1'b1:
            begin
                d = sw[7:4];
                an = 3'b001;
            end
     endcase 
   end
endmodule
