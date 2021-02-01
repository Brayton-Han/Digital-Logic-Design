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