    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 2020/03/24 10:33:43
    // Design Name: 
    // Module Name: top
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////

    module top(
    input               clk,rst,
    input               rx,
    output              tx,
    output wire [2:0]   hex_seg_an,
    output reg  [3:0]   hex_seg_data
    );

    parameter   C_IDLE          = 4'b0000;//空闲状态，接收到串口数据后跳转到下一状态C_CMD_DC
    parameter   C_CMD_DC        = 4'b0010;//解码命令状态，解析缓冲区中的命令类型，如写字节、读字节等
    parameter   C_CMD_WB        = 4'b0011;//写数据阶段，根据命令内容，将数据写入对应地址，如:wb 01 f0,则向01号地址写入数据f0 
    parameter   C_CMD_RB        = 4'b0100;//读数据阶段，根据命令内容，读取对应地址的数据，如:rb a1,则从a1地址读取数据  
    parameter   C_CMD_ERR       = 4'b0111;//错误状态，上位机发送的命令格式有误时进入此状态，向上位机发送"ERR！"字样 
    parameter   C_CMD_LS        = 4'b1000;
    parameter   C_TXFIFO_WR     = 4'b0101;//等待阶段，将数据或返回信息以ASCII码格式存入发送缓冲区
    parameter   C_TXFIFO_WAIT   = 4'b0110;//发送等待阶段，将发送缓冲区中的数据依次以ASCII码格式从串口发出
    wire                tx_ready;
    wire        [7:0]   tx_data;//发送的数据
    wire        [7:0]   rx_data;//接收到的数据

    reg         [3:0]   curr_state;
    reg         [3:0]   next_state;

    wire                is_wb_cmd;
    wire                is_rb_cmd;
    wire                is_ls_cmd;//判断当前命令的类型

    reg         [7:0]   tx_byte_cnt;//存储一共要输出多少个字符

    reg         [3:0]   rx_byte_cnt;//存储一共收到了多少个字节的数据
    reg         [7:0]   rx_byte_buff_0;
    reg         [7:0]   rx_byte_buff_1;
    reg         [7:0]   rx_byte_buff_2;
    reg         [7:0]   rx_byte_buff_3;
    reg         [7:0]   rx_byte_buff_4;
    reg         [7:0]   rx_byte_buff_5;
    reg         [7:0]   rx_byte_buff_6;
    reg         [7:0]   rx_byte_buff_7;

    reg         [7:0]   tx_byte_buff_0;
    reg         [7:0]   tx_byte_buff_1;
    reg         [7:0]   tx_byte_buff_2;
    reg         [7:0]   tx_byte_buff_3;
    reg         [7:0]   tx_byte_buff_4;
    reg         [7:0]   tx_byte_buff_5;
    reg         [7:0]   tx_byte_buff_6;
    reg         [7:0]   tx_byte_buff_7;
    reg         [7:0]   tx_byte_buff_8;
    reg         [7:0]   tx_byte_buff_9;
    reg         [7:0]   tx_byte_buff_10;
    reg         [7:0]   tx_byte_buff_11;
    reg         [7:0]   tx_byte_buff_12;
    reg         [7:0]   tx_byte_buff_13;
    reg         [7:0]   tx_byte_buff_14;
    reg         [7:0]   tx_byte_buff_15;
    reg         [7:0]   tx_byte_buff_16;
    reg         [7:0]   tx_byte_buff_17;
    reg         [7:0]   tx_byte_buff_18;
    reg         [7:0]   tx_byte_buff_19;
    reg         [7:0]   tx_byte_buff_20;

    reg                 rx_fifo_en;
    wire     [7:0]      rx_fifo_data;
    wire                rx_fifo_empty;

    reg                 wr_en;//write_enable
    reg      [3:0]      wr_addr;//要写入的地址
    reg      [7:0]      wr_data;//写入该地址的数据

    reg                 rd_en;
    reg      [3:0]      rd_addr;
    reg      [7:0]      rd_data;

    reg      [7:0]      tx_fifo_din;
    reg                 tx_fifo_wr_en;
    wire                tx_fifo_full;
    wire                tx_fifo_empty;

    reg      [23:0]     hex_seg_scan;
    reg      [31:0]     hex_seg_buff;

    always@(posedge clk or posedge rst)//把tx_byte_buff写入tx_fifo
    begin
        if(rst)
        begin
            tx_fifo_wr_en   <= 1'b0;
            tx_fifo_din     <= 8'h0;
        end
        else if(curr_state==C_TXFIFO_WR)
        //等待阶段，将要通过串口传输的数据发送入缓冲区
        begin
            tx_fifo_wr_en   <= 1'b1;
            case(tx_byte_cnt)
                8'h14:   tx_fifo_din <= tx_byte_buff_20;
                8'h13:   tx_fifo_din <= tx_byte_buff_19;
                8'h12:   tx_fifo_din <= tx_byte_buff_18;
                8'h11:   tx_fifo_din <= tx_byte_buff_17;
                8'h10:   tx_fifo_din <= tx_byte_buff_16;
                8'hf:   tx_fifo_din <= tx_byte_buff_15;
                8'he:   tx_fifo_din <= tx_byte_buff_14;
                8'hd:   tx_fifo_din <= tx_byte_buff_13;
                8'hc:   tx_fifo_din <= tx_byte_buff_12;
                8'hb:   tx_fifo_din <= tx_byte_buff_11;
                8'ha:   tx_fifo_din <= tx_byte_buff_10;
                8'h9:   tx_fifo_din <= tx_byte_buff_9;
                8'h8:   tx_fifo_din <= tx_byte_buff_8;
                8'h7:   tx_fifo_din <= tx_byte_buff_7;
                8'h6:   tx_fifo_din <= tx_byte_buff_6;
                8'h5:   tx_fifo_din <= tx_byte_buff_5;
                8'h4:   tx_fifo_din <= tx_byte_buff_4;
                8'h3:   tx_fifo_din <= tx_byte_buff_3;
                8'h2:   tx_fifo_din <= tx_byte_buff_2;
                8'h1:   tx_fifo_din <= tx_byte_buff_1;
                8'h0:   tx_fifo_din <= tx_byte_buff_0;
                default:tx_fifo_din <= 8'h0;
            endcase
        end
        else
        begin
            tx_fifo_wr_en   <= 1'b0;
            tx_fifo_din     <= 8'h0;
        end
    end

    always@(posedge clk or posedge rst)//处理rd_addr
    begin
        if(rst)
        begin
            rd_en        <= 1'b0;
            rd_addr      <= 4'h0; 
        end
        else if(curr_state==C_CMD_RB)//处理读取数据的指令
        begin
            rd_en   <= 1'b1;//打开读数据使能
            rd_addr <= rx_byte_buff_2[3:0];
        end    
        else
        begin
            rd_en       <= 1'b0;
            rd_addr     <= 4'h0; 
        end    
    end   
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            tx_byte_cnt <= 8'h0;
        else if(curr_state==C_IDLE)
            tx_byte_cnt <= 8'h0;
        else if(curr_state==C_CMD_RB) //读字节，发送字节数据的ASCII码及换行符，如"0f\n"
            tx_byte_cnt <= 8'h2;
        else if(curr_state==C_CMD_ERR)//错误状态，发送字符串"ERR！\n"
            tx_byte_cnt <= 8'h4;
        else if(curr_state==C_CMD_LS)
            tx_byte_cnt <= 8'h13;
        else if(curr_state==C_TXFIFO_WR)
        begin
            if(tx_byte_cnt!=8'h0)
                tx_byte_cnt <= tx_byte_cnt - 8'h1;
        end
    end

    always@(posedge clk or posedge rst)//处理tx_byte_buff
    begin
        if(rst)
        begin
            tx_byte_buff_0   <= 8'h0;
            tx_byte_buff_1   <= 8'h0;
            tx_byte_buff_2   <= 8'h0;
            tx_byte_buff_3   <= 8'h0;
            tx_byte_buff_4   <= 8'h0;
            tx_byte_buff_5   <= 8'h0;
            tx_byte_buff_6   <= 8'h0;
            tx_byte_buff_7   <= 8'h0;
            tx_byte_buff_8   <= 8'h0;
            tx_byte_buff_9   <= 8'h0;
            tx_byte_buff_10   <= 8'h0;
            tx_byte_buff_11   <= 8'h0;
            tx_byte_buff_12   <= 8'h0;
            tx_byte_buff_13   <= 8'h0;
            tx_byte_buff_14   <= 8'h0;
            tx_byte_buff_15   <= 8'h0;
            tx_byte_buff_16   <= 8'h0;
            tx_byte_buff_17   <= 8'h0;
            tx_byte_buff_18   <= 8'h0;
            tx_byte_buff_19   <= 8'h0;
            tx_byte_buff_20   <= 8'h0;
        end
        else if(curr_state==C_IDLE)
        begin
            tx_byte_buff_0   <= 8'h0;
            tx_byte_buff_1   <= 8'h0;
            tx_byte_buff_2   <= 8'h0;
            tx_byte_buff_3   <= 8'h0;
            tx_byte_buff_4   <= 8'h0;
            tx_byte_buff_5   <= 8'h0;
            tx_byte_buff_6   <= 8'h0;
            tx_byte_buff_7   <= 8'h0;
            tx_byte_buff_8   <= 8'h0;
            tx_byte_buff_9   <= 8'h0;
            tx_byte_buff_10   <= 8'h0;
            tx_byte_buff_11   <= 8'h0;
            tx_byte_buff_12   <= 8'h0;
            tx_byte_buff_13   <= 8'h0;
            tx_byte_buff_14   <= 8'h0;
            tx_byte_buff_15   <= 8'h0;
            tx_byte_buff_16   <= 8'h0;
            tx_byte_buff_17   <= 8'h0;
            tx_byte_buff_18   <= 8'h0;
            tx_byte_buff_19   <= 8'h0;
            tx_byte_buff_20   <= 8'h0;
        end
        else if(curr_state==C_CMD_RB)//处理读取数据指令
        begin
            tx_byte_buff_0  <= "\n";
            if(rd_data[7:4]<=4'h9)//0~9
                tx_byte_buff_2  <= {4'h3,rd_data[7:4]};
                //把0~9转成相应的ASCII码字符
            else
                tx_byte_buff_2  <= rd_data[7:4] - 4'ha + "a";
                //把a~f转成相应的ASCII码字符
            if(rd_data[3:0]<=4'h9)//0~9
                tx_byte_buff_1  <= {4'h3,rd_data[3:0]};
            else
                tx_byte_buff_1  <= rd_data[3:0] - 4'ha + "a";
        end
        else if(curr_state==C_CMD_ERR)//处理报错指令
        begin
            tx_byte_buff_4  <= "E";
            tx_byte_buff_3  <= "R";
            tx_byte_buff_2  <= "R";
            tx_byte_buff_1  <= "!";
            tx_byte_buff_0  <= "\n";
        end
        else if(curr_state==C_CMD_LS)
        begin
            tx_byte_buff_19 <= "0";
            tx_byte_buff_18 <= " ";
            tx_byte_buff_15 <= "\n";
            tx_byte_buff_14 <= "1";
            tx_byte_buff_13 <= " ";
            tx_byte_buff_10 <= "\n";
            tx_byte_buff_9  <= "2";
            tx_byte_buff_8  <= " ";
            tx_byte_buff_5  <= "\n";
            tx_byte_buff_4  <= "3";
            tx_byte_buff_3  <= " ";
            tx_byte_buff_0  <= "\n";
            if(hex_seg_buff[3:0]<=4'h9)
                tx_byte_buff_16 <= {4'h3,hex_seg_buff[3:0]};
            else
                tx_byte_buff_16 <= hex_seg_buff[3:0]-4'ha+"a";
            if(hex_seg_buff[7:4]<=4'h9)
                tx_byte_buff_17 <= {4'h3,hex_seg_buff[7:4]};
            else
                tx_byte_buff_17 <= hex_seg_buff[7:4]-4'ha+"a";
            if(hex_seg_buff[11:8]<=4'h9)
                tx_byte_buff_11 <= {4'h3,hex_seg_buff[11:8]};
            else
                tx_byte_buff_11 <= hex_seg_buff[11:8]-4'ha+"a";
            if(hex_seg_buff[15:12]<=4'h9)
                tx_byte_buff_12 <= {4'h3,hex_seg_buff[15:12]};
            else
                tx_byte_buff_12 <= hex_seg_buff[15:12]-4'ha+"a";
            if(hex_seg_buff[19:16]<=4'h9)
                tx_byte_buff_6 <= {4'h3,hex_seg_buff[19:16]};
            else
                tx_byte_buff_6 <= hex_seg_buff[19:16]-4'ha+"a";
            if(hex_seg_buff[23:20]<=4'h9)
                tx_byte_buff_7 <= {4'h3,hex_seg_buff[23:20]};
            else
                tx_byte_buff_7 <= hex_seg_buff[23:20]-4'ha+"a";
            if(hex_seg_buff[27:24]<=4'h9)
                tx_byte_buff_1 <= {4'h3,hex_seg_buff[27:24]};
            else
                tx_byte_buff_1 <= hex_seg_buff[27:24]-4'ha+"a";
            if(hex_seg_buff[31:28]<=4'h9)
                tx_byte_buff_2 <= {4'h3,hex_seg_buff[31:28]};
            else
                tx_byte_buff_2 <= hex_seg_buff[31:28]-4'ha+"a";
        end
    end


    always@(posedge clk or posedge rst)//状态转移
    begin
        if(rst)
            curr_state  <= C_IDLE;
        else
            curr_state  <= next_state;
    end

    always@(*)//状态转移部分
    begin
        case(curr_state)
            C_IDLE:
                if((rx_vld==1'b1)&&(rx_data==8'h0a)) 
                //检测到换行符，表示命令已经全部缓冲到FIFO内
                    next_state  = C_CMD_DC;//接下来要将命令解码
                else
                    next_state  = C_IDLE;
            C_CMD_DC:
                if(rx_fifo_empty)//已经把指令全部读出来了
                begin
                    if(is_wb_cmd)//表明是写指令
                        next_state  = C_CMD_WB;//接下来转到写指令状态
                    else if(is_rb_cmd)//表明是读指令
                        next_state  = C_CMD_RB;//接下来转到读数据状态
                    else if(is_ls_cmd)
                        next_state  = C_CMD_LS;
                    else//其他情况，则说明指令的格式有错误
                        next_state  = C_CMD_ERR;
                end
                else
                    next_state  = C_CMD_DC;
            C_CMD_WB://写数据状态
                next_state  = C_IDLE;
            C_CMD_RB://读数据状态
                if(rd_en==1'b1)//表明已经找到要读取的数据
                    next_state  = C_TXFIFO_WR;
                    //转到等待阶段，将指令要读取的数据存入发送缓冲区
                else
                    next_state  = C_CMD_RB;
            C_CMD_ERR:
                next_state = C_TXFIFO_WR;
                //接下来要将报错信息传给串口并发送出去
            C_CMD_LS:
                next_state = C_TXFIFO_WR;
            C_TXFIFO_WR:
                if(tx_byte_cnt==8'h0)
                    next_state = C_TXFIFO_WAIT;
                else
                    next_state = C_TXFIFO_WR;
            C_TXFIFO_WAIT://将FIFO缓冲区的数据从串口发出
                if(tx_fifo_empty)
                    next_state = C_IDLE;
                else
                    next_state = C_TXFIFO_WAIT;
            default:
                    next_state = C_IDLE;
        endcase
    end

    //只有处于 处理读数据指令 这一状态时才允许从FIFO中读取数据
    always@(posedge clk or posedge rst)
    begin
        if(rst)
            rx_fifo_en  <= 1'b0;
        else if(curr_state==C_CMD_DC)
            rx_fifo_en  <= 1'b1;
        else
            rx_fifo_en  <= 1'b0;
    end

    always@(posedge clk or posedge rst)
    //接收计数，并用于对命令中的各字节编号
    //每一个上升沿读一个数据
    begin
        if(rst)
            rx_byte_cnt <= 4'h0;
        else if(curr_state==C_CMD_DC)
        begin
            if((rx_fifo_en)&&(rx_fifo_empty==1'b0)&&(rx_byte_cnt<4'hf))//只要FIFO没空，就接着读取FIFO的数据
                rx_byte_cnt <= rx_byte_cnt + 4'b1;
        end
        else
            rx_byte_cnt <= 4'h0;
    end

    always@(posedge clk or posedge rst)//处理解码的状态
    begin
        if(rst)//复位
        begin
            rx_byte_buff_0  <= 8'h0;
            rx_byte_buff_1  <= 8'h0;
            rx_byte_buff_2  <= 8'h0;
            rx_byte_buff_3  <= 8'h0;
            rx_byte_buff_4  <= 8'h0;
            rx_byte_buff_5  <= 8'h0;
            rx_byte_buff_6  <= 8'h0;
            rx_byte_buff_7  <= 8'h0;
        end
        else if(curr_state==C_IDLE)
        begin
            rx_byte_buff_0  <= 8'h0;
            rx_byte_buff_1  <= 8'h0;
            rx_byte_buff_2  <= 8'h0;
            rx_byte_buff_3  <= 8'h0;
            rx_byte_buff_4  <= 8'h0;
            rx_byte_buff_5  <= 8'h0;
            rx_byte_buff_6  <= 8'h0;
            rx_byte_buff_7  <= 8'h0;
        end
        else if(curr_state==C_CMD_DC)//当前处于解码命令的状态，即从rx_fifo里面读取指令的信息
        begin
            case(rx_byte_cnt)
                4'h0:   rx_byte_buff_0 <= rx_fifo_data;
                4'h1:   rx_byte_buff_1 <= rx_fifo_data;
                4'h2:   rx_byte_buff_2 <= rx_fifo_data;
                4'h3:   rx_byte_buff_3 <= rx_fifo_data;
                4'h4:   rx_byte_buff_4 <= rx_fifo_data;
                4'h5:   rx_byte_buff_5 <= rx_fifo_data;
                4'h6:   rx_byte_buff_6 <= rx_fifo_data;
                4'h7:   rx_byte_buff_7 <= rx_fifo_data;
            endcase
        end
    end

    //判断是读指令还是写指令
    //rx_byte_buff_0~7存储的是读到指令的每一个字节的信息
    //也就是每一个字符是什么
    assign  is_wb_cmd = (curr_state==C_CMD_DC)
                        &&(rx_byte_buff_0=="w")&&(rx_byte_buff_1==" ")
                        &&(rx_byte_buff_2>="0")&&(rx_byte_buff_2<="3")
                        &&(rx_byte_buff_3==" ")
                        &&(((rx_byte_buff_4>="0")&&(rx_byte_buff_4<="9"))||((rx_byte_buff_4>="a")&&(rx_byte_buff_4<="f")))
                        &&(((rx_byte_buff_5>="0")&&(rx_byte_buff_5<="9"))||((rx_byte_buff_5>="a")&&(rx_byte_buff_5<="f")));

    assign  is_rb_cmd = (curr_state==C_CMD_DC)
                        &&(rx_byte_buff_0=="r")&&(rx_byte_buff_1==" ")
                        &&(rx_byte_buff_2>="0")&&(rx_byte_buff_2<="3");
        
    assign is_ls_cmd = (curr_state==C_CMD_DC)
                        &&(((rx_byte_buff_0=="l")&&(rx_byte_buff_1=="s"))
                        ||((rx_byte_buff_0=="d")&&(rx_byte_buff_1=="i")&&(rx_byte_buff_2=="r")));
                        
    always@(posedge clk or posedge rst)//处理写数据的指令
    begin
        if(rst)
        begin
            wr_en   <= 1'b0;
            wr_addr <= 4'h0;
        end
        else if(curr_state == C_CMD_WB)//处于写数据的状态
        begin
            wr_en   <= 1'b1;
            wr_addr <= rx_byte_buff_2[3:0];
            if((rx_byte_buff_4>="0")&&(rx_byte_buff_4<="9"))
                wr_data[7:4] <= rx_byte_buff_4[3:0];
            else
                wr_data[7:4] <= rx_byte_buff_4[2:0] + 4'h9;
            if((rx_byte_buff_5>="0")&&(rx_byte_buff_5<="9"))
                wr_data[3:0] <= rx_byte_buff_5[3:0];
            else
                wr_data[3:0] <= rx_byte_buff_5[2:0] + 4'h9;
        end
        else
        begin
            wr_en   <= 1'b0;
            wr_addr <= 4'h0;
        end
    end    

    //vld validation 即能否接收数据
    rx                  rx_inst(
    .clk                (clk),
    .rst                (rst),
    .rx                 (rx),
    .rx_vld             (rx_vld),
    .rx_data            (rx_data)   //从串口接收到的数据
    );//通过串口接收数据         
    tx                  tx_inst(
    .clk                (clk),
    .rst                (rst),
    .tx                 (tx ),
    .tx_ready           (~tx_fifo_empty),
    .tx_rd              (tx_rd),
    .tx_data            (tx_data)
    );//通过串口传输数据

    //这里使用了IP核中的FIFO存储器
    //----输入----
    //wr_en FIFO写使能
    //rd_en FIFO读使能
    //din   往FIFO内写入的数据

    //----输出----
    //dout 从FIFO中读取的数据
    //full  FIFO满信号
    //empty FIFO空信号
    fifo_32x8bit_0      rx_fifo( //用于缓存串口发来的命令
    .clk                (clk), 
    .rst                (rst), 
    .din                (rx_data), //把rx_data写入FIFO暂时存起来
    .wr_en              (rx_vld), 
    .rd_en              (rx_fifo_en), 
    .dout               (rx_fifo_data), //rx_fifo_data为8位的wire
    .full               (), 
    .empty              (rx_fifo_empty)
    );

    fifo_32x8bit_0      tx_fifo( //用于缓存将要通过串口发送出去的内容
    .clk                (clk), 
    .rst                (rst), 
    .din                (tx_fifo_din), 
    .wr_en              (tx_fifo_wr_en), 
    .rd_en              (tx_rd), 
    .dout               (tx_data), 
    .full               (tx_fifo_full), 
    .empty              (tx_fifo_empty)
    );



    always@(posedge clk or posedge rst)
    begin
        if(rst)
            hex_seg_scan <= 24'h0;
        else
            hex_seg_scan <= hex_seg_scan + 1'b1;
    end
    assign hex_seg_an = hex_seg_scan[20:18];
    always@(*)
    begin
        case(hex_seg_an)
            3'h0: hex_seg_data = hex_seg_buff[3:0];
            3'h1: hex_seg_data = hex_seg_buff[7:4];
            3'h2: hex_seg_data = hex_seg_buff[11:8];
            3'h3: hex_seg_data = hex_seg_buff[15:12];
            3'h4: hex_seg_data = hex_seg_buff[19:16];
            3'h5: hex_seg_data = hex_seg_buff[23:20];
            3'h6: hex_seg_data = hex_seg_buff[27:24];
            3'h7: hex_seg_data = hex_seg_buff[31:28];
        endcase
    end


    always@(*)//读取rd_data
    begin
        if(rd_en)
        begin
            case(rd_addr)
                4'h0:  rd_data = hex_seg_buff[7:0];
                4'h1:  rd_data = hex_seg_buff[15:8];
                4'h2:  rd_data = hex_seg_buff[23:16];
                4'h3:  rd_data = hex_seg_buff[31:24];
                default:rd_data = 8'h0;
            endcase
        end
        else
            rd_data = 8'h0;
    end
    always@(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            hex_seg_buff    <= 32'h0; 
        end    
        else if(wr_en)
        begin
            case(wr_addr)
                4'h0:  hex_seg_buff[7:0]   <= wr_data;
                4'h1:  hex_seg_buff[15:8]  <= wr_data;
                4'h2:  hex_seg_buff[23:16] <= wr_data;
                4'h3:  hex_seg_buff[31:24] <= wr_data;
            endcase
        end     
    end

    endmodule
