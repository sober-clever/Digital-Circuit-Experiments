module sub_test(
    input a,b,
    output c
);
  assign c = (a<b)?a:b;
endmodule //实验4-4

module test(
    input  a,b,c,
    output o 
);
wire temp;
sub_test ins_name1(
    .a (a),
    .b (b),
    .c (temp)
);
sub_test ins_name2(//两个实例的名字不能一样
    .a(temp),
    .b(c),
    .c(o)
);

endmodule //实验4-4