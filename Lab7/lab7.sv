module lab7 (
    input logic clk,
    input logic [15:0] SW,
    output logic [15:0] LED
);
    logic [3:0] q1, q2, q3, q4, yout, y2o;
    register U1(.E_(SW[7]), .clk(clk), .D(y2o), .Q(LED[11:8]));
    assign q1 = LED[11:8];
    register U2(.E_(SW[6]), .clk(clk), .D(yout),.Q(LED[ 3:0]));
    assign q2 = LED[3:0];
    register U3(.E_(SW[5]), .clk(clk), .D(yout),.Q(LED[ 7:4]));
    assign q3 = LED[7:4];
    ram2     U4(.clk(clk), .wen(SW[0]), .addr(SW[4:1]), .din(yout), .qout(LED[15:12]));
    assign q4 = LED[15:12];
    choose2  U5(.E(SW[12]), .a(SW[11:8]), .b(yout), .y(y2o));
    choose4  U6(.E(SW[14:13]), .a(q1), .b(q2), .c(q3), .d(q4), .y(yout));
endmodule

module register(
    input logic E_, clk,
    input logic [3:0] D,
    output logic [3:0] Q, Q_
);
    always_ff @(posedge clk)
        if(~E_) begin
            Q  <=  D;
            Q_ <= ~D;
        end
        else begin
            Q  <=  Q;
            Q_ <= Q_;
        end
endmodule

module ram2 (
    input logic clk, 
    input logic wen,
    input logic [3:0] addr,
    input logic [3:0] din,
    output logic [3:0] qout
);
    logic [15:0][3:0] ram;
    for(genvar i=0; i<16; i++)
        always_ff @(posedge clk)
            if (wen && i[3:0] == addr)
                ram[i] <= din;
    assign qout = ram[addr];
endmodule

module choose2(
    input logic E,
    input logic [3:0] a, b,
    output logic [3:0] y
);
    always_comb
        if(E == 1'b0)
            y = a;
        else
            y = b;
endmodule

module choose4(
    input logic [1:0] E,
    input logic [3:0] a, b, c, d,
    output logic [3:0] y
);
    always_comb
        if(E == 2'b00)
            y = a;
        else if(E == 2'b01)
            y = b;
        else if(E == 2'b10)
            y = c;
        else
            y = d;
endmodule
