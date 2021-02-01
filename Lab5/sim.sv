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