module test ( //模块名称
    input in,   //输入信号声明
    output out, //输出信号声明
    output out_n 
);
//如需要，可在此处声明内部变量
/*****以下为逻辑描述部分*****/
    assign out = in;
    assign ou_n = ~in;
    
endmodule

module add (
    input a,b,
    output sum,cout//cout为向后一位的进位
);
assign {cout,sum}=a+b//拼接，将两个单bit信号拼成了一个2bit信号
    
endmodule

module full_add (
    input a,b,cin,
    output sum,cout
);
wire s,carry1,carry2;
add add_inst1(  //基于名字的端口映射方式
    .a (a ),
    .b (b ),
    .sum (s ),
    .cout(carry1));
add add_inst2(
    .a (s ),
    .b (cin ),
    .sum (sum ),
    .cout(carry2));
assign cout = carry1|carry2;
endmodule