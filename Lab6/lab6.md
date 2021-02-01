# lab6：有限状态机
#### By:陈俊含 19307130180
***
### 一、数字时钟
1. 代码：
```
module clock(
    input logic clk, resetn,
    output logic [1:0][3:0] hour, minute, second
);
    assign hour = 'd0;
    assign minute = 'd0;
    assign second = 'd0;
    always_ff @(posedge clk) begin
        second <= second + 1;
        if(second == 9 || second == 25 || second == 41 || second == 57 || second == 73)
            second <= second + 7;
        else if(second == 'd89) begin
            second <= 'd0;
            minute <= minute + 1;
            if(minute == 9 || minute == 25 || minute == 41 || minute == 57 || minute == 73)
                minute <= minute + 7;
            else if(minute == 'd89) begin
                minute <= 'd0;
                hour <= hour + 1;
                if(hour == 9 || hour == 25 || hour == 41 || hour == 57 || hour == 73)
                    hour <= hour + 7;
                else if(hour == 'd89 || ~resetn) begin
                    second <= 'd0;
                    minute <= 'd0;
                    hour <= 'd0;
                end
            end
        end
    end
endmodule
```
2. 基本思路：先初始化时分秒为0，每次上升沿second+1；然后逐一判断second、minute、hour是否越界，若越界则清零并进位。
***
### 二、十字路口红绿灯
1. 代码：
```
module control(
    input logic clk, resetn,
    input logic has_car,
    output logic [1:0] red, yellow, green
);
    logic [1:0] state = 2'b00; // hg=00, hy=01, fg=10, fy=11
    logic [2:0] timee = 3'b001;
    assign red = 2'b01;
    assign yellow = 2'b00;
    assign green = 2'b10;
    always_ff @(posedge clk) begin
        if(state == 2'b00 || ~resetn || ~has_car)
            if(timee < 3'd2) begin
                state <= 2'b00 ;
                timee <= timee + 1 ;
                red <= 2'b01;
                green <= 2'b10;
                yellow <= 2'b00;
            end else if(timee == 3'd2) begin
                if(~resetn || ~has_car)
                    state <= 2'b00;
                else
                    state <= 2'b01 ;
                timee <= 3'd0;
            end
        if(state == 2'b01) begin
            red <= 2'b01;
            green <= 2'b00;
            yellow <= 2'b10;
            state <= 2'b10 ;
         end
         if(state == 2'b10)
            if(timee < 3'd2) begin
                state <= 2'b10 ;
                timee <= timee + 1 ;
                red <= 2'b10;
                green <= 2'b01;
                yellow <= 2'b00;
            end else if(timee == 3'd2) begin
                state <= 2'b11;
                timee <= 3'd0;
            end
         if(state == 2'b11) begin
            red <= 2'b10;
            green <= 2'b00;
            yellow <= 2'b01;
            state <= 2'b00;
         end
    end
endmodule
```
2. 解释：
- state的00,01,10,11分别对应高速绿灯、高速黄灯、农场路绿灯、农场路黄灯。
- 由于有resetn和has_car两个条件，所以判断时需要额外注意，在state==2'b00内部需要额外判断是否更新为2'b01。
- clock与control并行，互不干扰。
- 信号灯变量中，高位代表高速路的情况，低位代表农场路的情况。
