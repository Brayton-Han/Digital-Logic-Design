`include "lab6.svh"
module lab6 #(
    parameter logic SIM = 1'b0
)(
    input logic clk, resetn,
    input logic has_car,
    output logic [1:0] red, yellow, green,
    output logic [1:0][3:0] hour, minute, second
);
    clock    #(.N(SIM ? 100 : 2_000_000)) timing(.clk, .resetn, .hour, .minute, .second);
    control  #(.N(SIM ? 100 : 2_000_000)) display(.clk, .resetn, .has_car, .red, .yellow, .green);
endmodule

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