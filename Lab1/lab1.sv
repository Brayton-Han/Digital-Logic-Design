module decoder4_16 (
    input logic [3:0] in,
    output logic [15:0] out,
    input logic en
);
    always_comb begin
        out = 16'h0000;
        if(en)
            unique case(in)
                4'b0000: out[0] = 1'b1;
                4'b0001: out[1] = 1'b1;
                4'b0010: out[2] = 1'b1;
                4'b0011: out[3] = 1'b1;
                4'b0100: out[4] = 1'b1;
                4'b0101: out[5] = 1'b1;
                4'b0110: out[6] = 1'b1;
                4'b0111: out[7] = 1'b1;
                4'b1000: out[8] = 1'b1;
                4'b1001: out[9] = 1'b1;
                4'b1010: out[10] = 1'b1;
                4'b1011: out[11] = 1'b1;
                4'b1100: out[12] = 1'b1;
                4'b1101: out[13] = 1'b1;
                4'b1110: out[14] = 1'b1;
                4'b1111: out[15] = 1'b1;
            endcase
    end
endmodule

module decoder5_32 (
    input logic [4:0] in,
    output logic [31:0] out
);
    decoder4_16 decoder1(in[3:0], out[15:0], ~in[4]);
    decoder4_16 decoder2(in[3:0], out[31:16], in[4]);
endmodule

module encoder16_4 (
    input logic [15:0]in,
    output logic [3:0]out
);
    always_comb
        unique case(in)
            16'b0000000000000001: out = 4'b0000;
            16'b0000000000000010: out = 4'b0001;
            16'b0000000000000100: out = 4'b0010;
            16'b0000000000001000: out = 4'b0011;
            16'b0000000000010000: out = 4'b0100;
            16'b0000000000100000: out = 4'b0101;
            16'b0000000001000000: out = 4'b0110;
            16'b0000000010000000: out = 4'b0111;
            16'b0000000100000000: out = 4'b1000;
            16'b0000001000000000: out = 4'b1001;
            16'b0000010000000000: out = 4'b1010;
            16'b0000100000000000: out = 4'b1011;
            16'b0001000000000000: out = 4'b1100;
            16'b0010000000000000: out = 4'b1101;
            16'b0100000000000000: out = 4'b1110;
            16'b1000000000000000: out = 4'b1111;
        endcase
endmodule

module priority_encoder16_4(
    input logic [15:0]in,
    output logic [3:0]out
);
    always_comb
        priority case(1'b1)
            in[15]: out = 4'b1111;
            in[14]: out = 4'b1110;
            in[13]: out = 4'b1101;
            in[12]: out = 4'b1100;
            in[11]: out = 4'b1011;
            in[10]: out = 4'b1010;
            in[9]: out = 4'b1001;
            in[8]: out = 4'b1000;
            in[7]: out = 4'b0111;
            in[6]: out = 4'b0110;
            in[5]: out = 4'b0101;
            in[4]: out = 4'b0100;
            in[3]: out = 4'b0011;
            in[2]: out = 4'b0010;
            in[1]: out = 4'b0001;
            in[0]: out = 4'b0000;
        endcase
endmodule