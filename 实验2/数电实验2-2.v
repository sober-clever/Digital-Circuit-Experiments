//2选1数据选择器
module selector (
    input a,b,sel
    output c
);
    assign c = ~sel&a|sel&b; 
endmodule

//2选1数据选择器另一种写法
module selector2(
    input a,b,sel
    output c
);
    wire f1,f2,f3;

    and (f2,a,f1),
        (f3,b,sel);
    or (c,f2,f3);
    not(f1,sel);
endmodule

//4选1数据选择器
module selector4 (
    input a,b,c,d,sel0,sel1;
    output out
);
    wire f1,f2;
    selector sel_inst1(
        .a(a),
        .b(b),
        .sel(sel0)
        .c(f1)
    );
    selector sel_inst2(
        .a(c),
        .b(d),
        .sel(sel0)
        .c(f2)
    );
    selector sel_inst3(
        .a(f1),
        .b(f2),
        .sel(sel1)
        .c(out)
    );
endmodule