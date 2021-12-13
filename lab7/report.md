<div style="text-align:center;font-size:2em;font-weight:bold">中国科学技术大学计算机学院</div>



<div style="text-align:center;font-size:2em;font-weight:bold">《数字电路实验报告》</div>







<img src="logo.png" style="zoom: 50%;" />





<div style="display: flex;flex-direction: column;align-items: center;font-size:1.5em">
<div>
<p>实验题目：实验 07 FPGA 实验平台及 IP 核使用 </p>
<p>学生姓名：谭骏飞</p>
<p>学生学号：PB20061276</p>
<p>完成时间：2021.12.4</p>
</div>
</div>


<div style="page-break-after:always"></div>

## 实验题目

## 	实验 07 FPGA 实验平台及 IP 核使用

## 实验练习

#### 题目 1. 例化一个 16$\times$8bit 的 ROM，并对其进行初始化，输入端口由 4 个开关控制，输出端口连接到七段数码管上（七段数码管与 LED 复 用相同的一组管脚），控制数码管显示与开关相对应的十六进制数字， 例如四个开关输入全为零时，数码管显示“0”，输入全为 1 时，数 码管显示“F”。

​		

##### 	按下图方式例化了一个$16\times8$bit的ROM

![](img/屏幕截图 2021-12-09 204210.png)

##### 利用ip.coe文件对其进行初始化，ip.coe的内容如下（每个地址上存的是其对应十六进制数在七段数码管上显示时每段数码管的亮灭情况）。

```
memory_initialization_radix=16;
memory_initialization_vector=3f 6 5b 4f 66 6d 7d 7 7f 6f 77 7c 39 5e 7b 71;  

```

##### 有了例化的ROM，再在Verilog设计文件中将相应的模块（dist_mem_gen_0）实例化，并将输入的地址和输出的数据分别与sw和led相对应即可。

```Verilog
module test(
    input  [3:0]sw,
    output [7:0]led 
);
dist_mem_gen_0 dist_mem_gen_0(.a(sw),.spo(led));

endmodule 
```

##### 附上相应的约束文件。（仅保留用到的引脚）

```cmake

set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVCMOS33 } [get_ports { led[3] }];
set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVCMOS33 } [get_ports { led[4] }];
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVCMOS33 } [get_ports { led[5] }];
set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVCMOS33 } [get_ports { led[6] }];
set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVCMOS33 } [get_ports { led[7] }];



set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];


```

##### 		在FPGAOL平台上运行的部分结果如下。

<center class="half">
    <img src="img/屏幕截图 2021-12-09 204822.png" width="275"/>
    <img src="img/屏幕截图 2021-12-09 204932.png" width="275"/>
</center>	







#### 题目 2. 采用 8 个开关作为输入，两个十六进制数码管作为输出，采 用时分复用的方式将开关的十六进制数值在两个数码管上显示出来， 例如高四位全为 1，低四位全为 0 时，数码管显示“F0”。

##### `时分复用（Time Division Multiplexing，TDM）`是采用同意物理连接的不同时段来传输不同信号的方式。在本题中，其体现在通过不同时刻显示不同的数码管并利用人的视觉暂留，以达到将多为数值输出到十六进制数码管的目的。

##### 通过翻阅FPGAOL的相关手册可知，八个数码管仅使能由`AN[2:0]`所表示的二进制数所对应的数位；在显示的数字方面，不再通过`SEG`信号独立控制每个段（segment），而是直接显示`D[3:0]`形成的16进制数。并且建议的扫描频率为**50Hz**，本题要驱动2个数码管，对应的频率为**100Hz**.

##### 由此编写出的Verilog代码如下。其中cnt用于记录时钟上升沿的数量，flag每经过1000000个时钟信号就翻转一次，以产生100Hz扫描频率。通过对flag的0/1状况控制不同的数码管，达到时分复用显示十六进制数的目的。

```verilog
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

```

##### 附上相关的约束文件。（只保留用到的引脚）

```cmake
## This file is a general .xdc for FPGAOL_BOARD (adopted from Nexys4 DDR Rev. C)
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz


## FPGAOL SWITCH

set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVCMOS33 } [get_ports { sw[2] }];
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { sw[3] }];
set_property -dict { PACKAGE_PIN E16   IOSTANDARD LVCMOS33 } [get_ports { sw[4] }];
set_property -dict { PACKAGE_PIN F13   IOSTANDARD LVCMOS33 } [get_ports { sw[5] }];
set_property -dict { PACKAGE_PIN G13   IOSTANDARD LVCMOS33 } [get_ports { sw[6] }];
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sw[7] }];


## FPGAOL HEXPLAY

set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { d[0] }];
set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { d[1] }];
set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33 } [get_ports { d[2] }];
set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33 } [get_ports { d[3] }];
set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { an[0] }];
set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { an[1] }];
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { an[2] }];


```

##### 在FPGAOL平台上的部分运行结果如下。

<center class="half">
    <img src="img/屏幕截图 2021-12-09 210249.png" width="275"/>
    <img src="img/屏幕截图 2021-12-09 210416.png" width="275"/>
</center>	







#### 题目 3.  利用本实验中的时钟管理单元或周期脉冲技术，设计一个精 度为 0.1 秒的计时器，用 4 位数码管显示出来，数码管从高到低，分 别表示分钟、秒钟十位、秒钟个位、十分之一秒，该计时器具有复位 功能（可采用按键或开关作为复位信号），复位时计数值为 1234， 即 1 分 23.4 秒。



##### Verilog设计文件的代码如下。本题用到了4位数码管，相应的扫描频率为200Hz，故代码中的flag每500000时钟周期加1。为了达到计时的目的，sec2(用于表示十分之一秒)每隔10000000个时钟周期加1（由于FPGA时钟频率为100mHz，故其每隔0.1s加1），sec2达到10后sec（秒钟）进1，sec达到60后min（分钟）进1，从而实现题目要求。

```verilog
`timescale 1ns / 1ps


module test(
    input clk,rst,
    output reg [2:0]an,
    output reg [3:0]d
    );
reg [3:0]min;
reg [5:0]sec;
reg [3:0]sec2;
reg [31:0] cnt;
reg [1:0]flag;

always@(posedge clk)
begin
    if(rst==1'b1)
    begin
        min<=1'b1;
        sec<=5'b10111;//2'd23
        sec2<=3'b100;//1'd4
    end
    cnt<=cnt+1'b1;
    if(cnt % 500000 == 0)
    begin
        flag <= flag+1'b1;
    end
    if(cnt == 10000000)
    begin
        cnt <= 1'b0;
        sec2 <= sec2+1'b1;   
        if(sec2 == 4'b1001)//sec2==9
        begin
            sec2 <= 1'b0;
            sec <=sec+1'b1;
            if(sec == 6'b111011)//sec==59
            begin
                min<=min+1'b1;
                sec<=1'b0;
            end
        end
    end
end

always@(*)
begin
    case(flag)
        2'b00:
            begin
                an<=3'b000;
                d<=sec2;
            end
        2'b01:
            begin
                an<=3'b001;
                d<=sec%10;
            end
      2'b10:
            begin
                an<=3'b010;
                d<=sec/10;
            end
      2'b11:
            begin
                an<=3'b011;
                d<=min;
            end
    endcase
end
    
endmodule

```

##### 附上相应的约束文件。（只保留用到的引脚）

```cmake
## This file is a general .xdc for FPGAOL_BOARD (adopted from Nexys4 DDR Rev. C)
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
set_property -dict { PACKAGE_PIN B18   IOSTANDARD LVCMOS33 } [get_ports { rst }];


## FPGAOL HEXPLAY

set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVCMOS33 } [get_ports { d[0] }];
set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVCMOS33 } [get_ports { d[1] }];
set_property -dict { PACKAGE_PIN A16   IOSTANDARD LVCMOS33 } [get_ports { d[2] }];
set_property -dict { PACKAGE_PIN A15   IOSTANDARD LVCMOS33 } [get_ports { d[3] }];
set_property -dict { PACKAGE_PIN B17   IOSTANDARD LVCMOS33 } [get_ports { an[0] }];
set_property -dict { PACKAGE_PIN B16   IOSTANDARD LVCMOS33 } [get_ports { an[1] }];
set_property -dict { PACKAGE_PIN A18   IOSTANDARD LVCMOS33 } [get_ports { an[2] }];

```

##### 烧写到FPGAOL平台上的部分运行结果如下。（左侧为刚复位没多久的显示结果）

<center class="half">
    <img src="img/屏幕截图 2021-12-09 211959.png" width="275"/>
    <img src="img/屏幕截图 2021-12-09 212218.png" width="275"/>
</center>	







## 总结与思考

##### 本次实验任务较多，但也给人较大的收获。实验7首先介绍了时钟管理单元和片内存存储单元两种ip核，前者在给定输入时钟频率的情况下可以产生一定范围内频率的时钟，后者则提供了存储单元模块，使用ip核大大便利了平时的编码，省去了很多“造轮子”时的繁琐过程。在实验练习过程中，通过使用Verilog实现时分复用功能，我对数电实验中时分复用方面相关知识点的认识进一步加深，时分复用的效果也通过在FPGAOL平台上的烧写变得更为直观、易于接受。同时通过使用片内存存储单元，我对内存的功能和其内部的构造有了新的认识。这些都为后续的深入实验打下了基础。