module sub_test(
    input a,b,
    output [1:0]o
);
assign o = a+b;
endmodule //实验4-5

module test(
    input a,b,
    output [1:0]c
);
sub_test sub_test1(a,b,c);
endmodule //实验4-5