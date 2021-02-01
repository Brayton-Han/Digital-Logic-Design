module sim (
    
);
    logic clk, resetn;
    logic [15:0] SW;
    logic [15:0] LED;
    top #(.SIM(1'b1)) top_inst(.clk, .resetn, .SW, .LED);

    parameter logic[3:0]x = 4'b1010;
    parameter logic[3:0]y = 4'b0111;
    initial begin
        clk = 1'b0;
        resetn = 1'b0;
        #100 resetn = 1'b1;
        SW[7:5] = 3'b111;
        SW[15:8] = 8'b00000000;
        SW[4:0] = 5'b00000;
        LED[15:0] = 16'b0000000000000000;
        // input x(10) to U2
        #100 SW[11:8] = x;
        #100 SW[7] = 1'b0;
        #100 SW[7] = 1'b1;
        #100 SW[6] = 1'b0;
        #100 SW[6] = 1'b1;
        // input y(7) to U3
        #100 SW[11:8] = y;
        #100 SW[7] = 1'b0;
        #100 SW[7] = 1'b1;
        #100 SW[5] = 1'b0;
        #100 SW[5] = 1'b1;
        // clean U5
        #100 SW[11:8] = 4'b0000;
        #100 SW[7] = 1'b0;
        #100 SW[7] = 1'b1;
        // input U2 to U4
        #100 SW[14:13] = 2'b01;
        #100 SW[0] = 1'b1;
        #100 SW[0] = 1'b0;
        // input U3 to U2
        #100 SW[14:13] = 2'b10;
        #100 SW[6] = 1'b0;
        #100 SW[6] = 1'b1;
        // input U4 to U3
        #100 SW[14:13] = 2'b11;
        #100 SW[5] = 1'b0;
        #100 SW[5] = 1'b1;
        // clean U4
        #100 SW[14:13] = 2'b00;
        #100 SW[0] = 1'b1;
        #100 SW[0] = 1'b0;
        // clesn U6, U5
        #100 SW[6] = 1'b0;
        #100 SW[6] = 1'b1;
        #100 SW[5] = 1'b0;
        #100 SW[5] = 1'b1;
        $finish;
    end

    always #5 clk = ~clk;

    
endmodule
