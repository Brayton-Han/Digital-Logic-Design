# lab5 触发器和寄存器
### 一、D触发器（异步置数，异步清零）
1. 源代码
```
module D_trigger(
    input logic clk, D, clr, set,
    output logic Q, notQ
);
    always_ff @(posedge clk, posedge clr, posedge set)
        if(set == 1)
            Q <= 1;
        else if(clr == 1)
            Q <= 0;
        else
            Q <= D;
endmodule
```
2. 功能描述（真值表）
|  clk  |  D  |  clr  |  set  |  Q  |  notQ  |
|  ---  | --- |  ---  |  ---  | --- |  ----  |
|   x   |  x  |   x   |   1   |  1  |   0    |
|   x   |  x  |   1   |   0   |  0  |   1    |
|   ↑   |  0  |   0   |   0   |  0  |   1    |
|   ↑   |  1  |   0   |   0   |  1  |   0    |

3. 仿真
- 代码
```
module sim ();
    logic clk_1hz, clk_100mhz, resetn;
    always #500_000_000 clk_1hz = ~clk_1hz;
    always #5 clk_100mhz = ~clk_100mhz;
    initial begin
        clk_1hz = '0;
        clk_100mhz = '0;
        resetn = 1'b0;
        #100 resetn = 1'b1;
    end
// TODO: declare variables here
    logic D, Q, notQ;
// TODO: add input drives here
    initial
        begin
            D = 1;
        #10 D = 0;
        #10 D = 0;
        #10 D = 1;
        #10 D = 0;
        end
// TODO: add module instantiation and other circuit codes here
    D_trigger sim1(.clk(clk_1hz), .D(D), .clr(0), .set(resetn), .Q(Q), .notQ(notQ));
endmodule
```
- 如何验证正确性：看仿真和标准答案的波形图是否一致
***
### 二、加法计数器
1. 源代码
```
module add_cnt(
    input logic [1:0]in,
    input logic clk,
    output logic [1:0]out
);
    always_ff @(posedge clk) begin
        out = in;
        if(~(clk==1 || clk==0))
            out = out + 1;
    end
endmodule
```
2. 功能描述（真值表）
3. 仿真
- 代码（不会写）
- 如何验证正确性：看仿真得到的数据和标准答案是否一致
***
### 三、74LS175
1. 源代码
```
module LS175(
    input logic clk, clr,
    input logic [3:0]D,
    output logic [3:0]Q
);
    always_ff @(posedge clk, posedge clr)
        if(clr == 0)
            Q <= 4'b0000;
        else if(clr == 1 && (clk==1 || clk==0));
        else
            Q <= D;
endmodule
```
2. 功能描述（真值表）
|  clr  |  clk  |  D3  |  D2  |  D1  |  D0  |  Q3  |  Q2  |  Q1  |  Q0  |
|  ---  |  ---  | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
|   0   |   x   |  x   |  x   |  x   |  x   |  0   |  0   |  0   |  0   |
|   1   |   ↑   |  D3  |  D2  |  D1  |  D0  |  D3  |  D2  |  D1  |  D0  |
|   1   |   1   |  x   |  x   |  x   |  x   |  →   |  →   |  →   |  →   |
|   1   |   0   |  x   |  x   |  x   |  x   |  →   |  →   |  →   |  →   |

3. 仿真
- 代码
```
module sim ();
    logic clk_1hz, clk_100mhz, resetn;
    always #500_000_000 clk_1hz = ~clk_1hz;
    always #5 clk_100mhz = ~clk_100mhz;
    initial begin
        clk_1hz = '0;
        clk_100mhz = '0;
        resetn = 1'b0;
        #100 resetn = 1'b1;
    end
// TODO: declare variables here
    logic [3:0]D;
    logic [3:0]Q;
// TODO: add input drives here
    initial
        begin
            D = 4'b1100;
        #10 D = 4'b1010;
        #10 D = 4'b1111;
        #10 D = 4'b1001;
        #10 D = 4'b0000;
        end
// TODO: add module instantiation and other circuit codes here
     LS175 sim3(.clk(clk_100mhz), .D(D), .clr(0), .Q(Q));
endmodule
```
- 如何验证正确性：看仿真和标准答案的波形图是否一致
****
### 四、74LS194
1. 源代码
```
module LS194(
    input logic MR, DSR, DSL, clk,
    input logic [1:0]S,
    input logic [3:0]P,
    output logic [3:0]Q
);
    always_ff @(posedge clk)
        if(MR==1)
            Q <= 4'b0000;
        else if(clk==0 || clk==1)
            if(S[1]==1 && S[0]==0)
                Q[3:0] <= {DSL, Q[3:1]};
            else if(S[1]==0 && S[0]==1)
                Q[3:0] <= {Q[2:0], DSR};
            else if(S[1]==1 && S[0]==1)
                Q <= P;
        else
            if(~S[1]==1 && ~S[0]==0)
                Q[3:0] <= {~DSL, Q[3:1]};
            else if(~S[1]==0 && ~S[0]==1)
                Q[3:0] <= {Q[2:0], ~DSR};
            else if(~S[1]==1 && ~S[0]==1)
                Q <= P;
endmodule
```
2. 功能描述（真值表）
|  MR  |  S1  |  S0  |  DSR  |  DSL  |  P  |  Q3  |  Q2  |  Q1  |  Q0  |
| ---- | ---- | ---- |  ---  |  ---  | --- | ---- | ---- | ---- | ---- |
|  1   |  x   |  x   |   x   |   x   |  x  |  0   |  0   |  0   |  0   |
|  0   |  l   |  l   |   x   |   x   |  x  |  Q3  |  Q2  |  Q1  |  Q0  |
|  0   |  h   |  l   |   x   |   l   |  x  |  0   |  Q3  |  Q2  |  Q1  |
|  0   |  h   |  l   |   x   |   h   |  x  |  1   |  Q3  |  Q2  |  Q1  |
|  0   |  l   |  h   |   l   |   x   |  x  |  Q2  |  Q1  |  Q0  |  0   |
|  0   |  l   |  h   |   h   |   x   |  x  |  Q2  |  Q1  |  Q0  |  1   |
|  0   |  h   |  h   |   x   |   x   |  P  |  P3  |  P2  |  P1  |  P0  |

3. 仿真
- 代码（不会写）
- 如何验证正确性：看仿真得到的数据和标准答案是否一致
4. 上板现象描述
- 同步置数：打开最右边的开关，灯等待1秒后亮起
- 左移：灯往左移动
- 保存数据：先置数，启动保存数据的开关，不管打开左移还是右移，灯都不移动
- 清零：灯全灭
