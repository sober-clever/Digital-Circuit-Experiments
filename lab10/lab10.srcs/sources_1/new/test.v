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

    parameter   C_IDLE          = 4'b0000;//����״̬�����յ��������ݺ���ת����һ״̬C_CMD_DC
    parameter   C_CMD_DC        = 4'b0010;//��������״̬�������������е��������ͣ���д�ֽڡ����ֽڵ�
    parameter   C_CMD_WB        = 4'b0011;//д���ݽ׶Σ������������ݣ�������д���Ӧ��ַ����:wb 01 f0,����01�ŵ�ַд������f0 
    parameter   C_CMD_RB        = 4'b0100;//�����ݽ׶Σ������������ݣ���ȡ��Ӧ��ַ�����ݣ���:rb a1,���a1��ַ��ȡ����  
    parameter   C_CMD_ERR       = 4'b0111;//����״̬����λ�����͵������ʽ����ʱ�����״̬������λ������"ERR��"���� 
    parameter   C_CMD_LS        = 4'b1000;
    parameter   C_TXFIFO_WR     = 4'b0101;//�ȴ��׶Σ������ݻ򷵻���Ϣ��ASCII���ʽ���뷢�ͻ�����
    parameter   C_TXFIFO_WAIT   = 4'b0110;//���͵ȴ��׶Σ������ͻ������е�����������ASCII���ʽ�Ӵ��ڷ���
    wire                tx_ready;
    wire        [7:0]   tx_data;//���͵�����
    wire        [7:0]   rx_data;//���յ�������

    reg         [3:0]   curr_state;
    reg         [3:0]   next_state;

    wire                is_wb_cmd;
    wire                is_rb_cmd;
    wire                is_ls_cmd;//�жϵ�ǰ���������

    reg         [7:0]   tx_byte_cnt;//�洢һ��Ҫ������ٸ��ַ�

    reg         [3:0]   rx_byte_cnt;//�洢һ���յ��˶��ٸ��ֽڵ�����
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
    reg      [3:0]      wr_addr;//Ҫд��ĵ�ַ
    reg      [7:0]      wr_data;//д��õ�ַ������

    reg                 rd_en;
    reg      [3:0]      rd_addr;
    reg      [7:0]      rd_data;

    reg      [7:0]      tx_fifo_din;
    reg                 tx_fifo_wr_en;
    wire                tx_fifo_full;
    wire                tx_fifo_empty;

    reg      [23:0]     hex_seg_scan;
    reg      [31:0]     hex_seg_buff;

    always@(posedge clk or posedge rst)//��tx_byte_buffд��tx_fifo
    begin
        if(rst)
        begin
            tx_fifo_wr_en   <= 1'b0;
            tx_fifo_din     <= 8'h0;
        end
        else if(curr_state==C_TXFIFO_WR)
        //�ȴ��׶Σ���Ҫͨ�����ڴ�������ݷ����뻺����
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

    always@(posedge clk or posedge rst)//����rd_addr
    begin
        if(rst)
        begin
            rd_en        <= 1'b0;
            rd_addr      <= 4'h0; 
        end
        else if(curr_state==C_CMD_RB)//�����ȡ���ݵ�ָ��
        begin
            rd_en   <= 1'b1;//�򿪶�����ʹ��
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
        else if(curr_state==C_CMD_RB) //���ֽڣ������ֽ����ݵ�ASCII�뼰���з�����"0f\n"
            tx_byte_cnt <= 8'h2;
        else if(curr_state==C_CMD_ERR)//����״̬�������ַ���"ERR��\n"
            tx_byte_cnt <= 8'h4;
        else if(curr_state==C_CMD_LS)
            tx_byte_cnt <= 8'h13;
        else if(curr_state==C_TXFIFO_WR)
        begin
            if(tx_byte_cnt!=8'h0)
                tx_byte_cnt <= tx_byte_cnt - 8'h1;
        end
    end

    always@(posedge clk or posedge rst)//����tx_byte_buff
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
        else if(curr_state==C_CMD_RB)//�����ȡ����ָ��
        begin
            tx_byte_buff_0  <= "\n";
            if(rd_data[7:4]<=4'h9)//0~9
                tx_byte_buff_2  <= {4'h3,rd_data[7:4]};
                //��0~9ת����Ӧ��ASCII���ַ�
            else
                tx_byte_buff_2  <= rd_data[7:4] - 4'ha + "a";
                //��a~fת����Ӧ��ASCII���ַ�
            if(rd_data[3:0]<=4'h9)//0~9
                tx_byte_buff_1  <= {4'h3,rd_data[3:0]};
            else
                tx_byte_buff_1  <= rd_data[3:0] - 4'ha + "a";
        end
        else if(curr_state==C_CMD_ERR)//������ָ��
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


    always@(posedge clk or posedge rst)//״̬ת��
    begin
        if(rst)
            curr_state  <= C_IDLE;
        else
            curr_state  <= next_state;
    end

    always@(*)//״̬ת�Ʋ���
    begin
        case(curr_state)
            C_IDLE:
                if((rx_vld==1'b1)&&(rx_data==8'h0a)) 
                //��⵽���з�����ʾ�����Ѿ�ȫ�����嵽FIFO��
                    next_state  = C_CMD_DC;//������Ҫ���������
                else
                    next_state  = C_IDLE;
            C_CMD_DC:
                if(rx_fifo_empty)//�Ѿ���ָ��ȫ����������
                begin
                    if(is_wb_cmd)//������дָ��
                        next_state  = C_CMD_WB;//������ת��дָ��״̬
                    else if(is_rb_cmd)//�����Ƕ�ָ��
                        next_state  = C_CMD_RB;//������ת��������״̬
                    else if(is_ls_cmd)
                        next_state  = C_CMD_LS;
                    else//�����������˵��ָ��ĸ�ʽ�д���
                        next_state  = C_CMD_ERR;
                end
                else
                    next_state  = C_CMD_DC;
            C_CMD_WB://д����״̬
                next_state  = C_IDLE;
            C_CMD_RB://������״̬
                if(rd_en==1'b1)//�����Ѿ��ҵ�Ҫ��ȡ������
                    next_state  = C_TXFIFO_WR;
                    //ת���ȴ��׶Σ���ָ��Ҫ��ȡ�����ݴ��뷢�ͻ�����
                else
                    next_state  = C_CMD_RB;
            C_CMD_ERR:
                next_state = C_TXFIFO_WR;
                //������Ҫ��������Ϣ�������ڲ����ͳ�ȥ
            C_CMD_LS:
                next_state = C_TXFIFO_WR;
            C_TXFIFO_WR:
                if(tx_byte_cnt==8'h0)
                    next_state = C_TXFIFO_WAIT;
                else
                    next_state = C_TXFIFO_WR;
            C_TXFIFO_WAIT://��FIFO�����������ݴӴ��ڷ���
                if(tx_fifo_empty)
                    next_state = C_IDLE;
                else
                    next_state = C_TXFIFO_WAIT;
            default:
                    next_state = C_IDLE;
        endcase
    end

    //ֻ�д��� ���������ָ�� ��һ״̬ʱ�������FIFO�ж�ȡ����
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
    //���ռ����������ڶ������еĸ��ֽڱ��
    //ÿһ�������ض�һ������
    begin
        if(rst)
            rx_byte_cnt <= 4'h0;
        else if(curr_state==C_CMD_DC)
        begin
            if((rx_fifo_en)&&(rx_fifo_empty==1'b0)&&(rx_byte_cnt<4'hf))//ֻҪFIFOû�գ��ͽ��Ŷ�ȡFIFO������
                rx_byte_cnt <= rx_byte_cnt + 4'b1;
        end
        else
            rx_byte_cnt <= 4'h0;
    end

    always@(posedge clk or posedge rst)//��������״̬
    begin
        if(rst)//��λ
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
        else if(curr_state==C_CMD_DC)//��ǰ���ڽ��������״̬������rx_fifo�����ȡָ�����Ϣ
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

    //�ж��Ƕ�ָ���дָ��
    //rx_byte_buff_0~7�洢���Ƕ���ָ���ÿһ���ֽڵ���Ϣ
    //Ҳ����ÿһ���ַ���ʲô
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
                        
    always@(posedge clk or posedge rst)//����д���ݵ�ָ��
    begin
        if(rst)
        begin
            wr_en   <= 1'b0;
            wr_addr <= 4'h0;
        end
        else if(curr_state == C_CMD_WB)//����д���ݵ�״̬
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

    //vld validation ���ܷ��������
    rx                  rx_inst(
    .clk                (clk),
    .rst                (rst),
    .rx                 (rx),
    .rx_vld             (rx_vld),
    .rx_data            (rx_data)   //�Ӵ��ڽ��յ�������
    );//ͨ�����ڽ�������         
    tx                  tx_inst(
    .clk                (clk),
    .rst                (rst),
    .tx                 (tx ),
    .tx_ready           (~tx_fifo_empty),
    .tx_rd              (tx_rd),
    .tx_data            (tx_data)
    );//ͨ�����ڴ�������

    //����ʹ����IP���е�FIFO�洢��
    //----����----
    //wr_en FIFOдʹ��
    //rd_en FIFO��ʹ��
    //din   ��FIFO��д�������

    //----���----
    //dout ��FIFO�ж�ȡ������
    //full  FIFO���ź�
    //empty FIFO���ź�
    fifo_32x8bit_0      rx_fifo( //���ڻ��洮�ڷ���������
    .clk                (clk), 
    .rst                (rst), 
    .din                (rx_data), //��rx_dataд��FIFO��ʱ������
    .wr_en              (rx_vld), 
    .rd_en              (rx_fifo_en), 
    .dout               (rx_fifo_data), //rx_fifo_dataΪ8λ��wire
    .full               (), 
    .empty              (rx_fifo_empty)
    );

    fifo_32x8bit_0      tx_fifo( //���ڻ��潫Ҫͨ�����ڷ��ͳ�ȥ������
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


    always@(*)//��ȡrd_data
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
