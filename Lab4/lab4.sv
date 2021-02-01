module lab4 (
    input logic [3:0]in,
    output logic [6:0]out_use138, out_use151
);
    seg_138 seg_138_inst(.in, .out(out_use138));
    seg_151 seg_151_inst(.in, .out(out_use151));
endmodule

module seg_138 (
    input logic [3:0]in,
    output logic [6:0]out
);
    // TODO: add logic here
    // NOTE: "always_comb" are not allowed here. You should use mod_74LS138 instants and logic gates(assign) here
    logic [15:0]o;
    mod_74LS138 m1(.A(in[0]), .B(in[1]), .C(in[2]), .G1(in[3]), .outputs(o[15:8]));
    mod_74LS138 m2(.A(in[0]), .B(in[1]), .C(in[2]), .G1(~in[3]), .outputs(o[7:0]));
    assign out[0] = ~(o[1] & o[4] & o[11] & o[13]);
    assign out[1] = ~(o[5] & o[6] & o[11] & o[12] & o[14] & o[15]);
    assign out[2] = ~(o[2] & o[12] & o[14] & o[15]);
    assign out[3] = ~(o[1] & o[4] & o[7] & o[10] & o[15]);
    assign out[4] = ~(o[1] & o[3] & o[4] & o[5] & o[7] & o[9]);
    assign out[5] = ~(o[1] & o[2] & o[3] & o[7] & o[13]);
    assign out[6] = ~(o[0] & o[1] & o[7] & o[12]);
endmodule

module mod_74LS138 (
    // TODO: add ports here
    input logic A, B, C,
    input logic G1, G2,
    output logic [7:0]outputs
);
    // TODO: add logic here
    // NOTE: No syntax limitation
    assign outputs[0] = ~(~A & ~B & ~C & G1);
    assign outputs[1] = ~(A & ~B & ~C & G1);
    assign outputs[2] = ~(~A & B & ~C & G1);
    assign outputs[3] = ~(A & B & ~C & G1);
    assign outputs[4] = ~(~A & ~B & C & G1);
    assign outputs[5] = ~(A & ~B & C & G1);
    assign outputs[6] = ~(~A & B & C & G1);
    assign outputs[7] = ~(A & B & C & G1);
endmodule

module seg_151 (
    input logic [3:0]in,
    output logic [6:0]out
);
    // TODO: add logic here
    // NOTE: "always_comb" are not allowed here. You should use mod_74LS151 instants and logic gates(assign) here
    logic [7:0]ou0 = 8'b00000001;
    logic [7:0]ou1 = 8'b00000010;
    logic [7:0]ou2 = 8'b00000100;
    logic [7:0]ou3 = 8'b00001000;
    logic [7:0]ou4 = 8'b00010000;
    logic [7:0]ou5 = 8'b00100000;
    logic [7:0]ou6 = 8'b01000000;
    logic [7:0]ou7 = 8'b10000000;
    logic [15:0]m;
    mod_74LS151 m3(.S(in[2:0]), .E(in[3]), .I(ou0), .Z(m[0]));
    mod_74LS151 m4(.S(in[2:0]), .E(in[3]), .I(ou1), .Z(m[1]));
    mod_74LS151 m5(.S(in[2:0]), .E(in[3]), .I(ou2), .Z(m[2]));
    mod_74LS151 m6(.S(in[2:0]), .E(in[3]), .I(ou3), .Z(m[3]));
    mod_74LS151 m7(.S(in[2:0]), .E(in[3]), .I(ou4), .Z(m[4]));
    mod_74LS151 m8(.S(in[2:0]), .E(in[3]), .I(ou5), .Z(m[5]));
    mod_74LS151 m9(.S(in[2:0]), .E(in[3]), .I(ou6), .Z(m[6]));
    mod_74LS151 m10(.S(in[2:0]), .E(in[3]), .I(ou7), .Z(m[7]));
    mod_74LS151 m11(.S(in[2:0]), .E(~in[3]), .I(ou0), .Z(m[8]));
    mod_74LS151 m12(.S(in[2:0]), .E(~in[3]), .I(ou1), .Z(m[9]));
    mod_74LS151 m13(.S(in[2:0]), .E(~in[3]), .I(ou2), .Z(m[10]));
    mod_74LS151 m14(.S(in[2:0]), .E(~in[3]), .I(ou3), .Z(m[11]));
    mod_74LS151 m15(.S(in[2:0]), .E(~in[3]), .I(ou4), .Z(m[12]));
    mod_74LS151 m16(.S(in[2:0]), .E(~in[3]), .I(ou5), .Z(m[13]));
    mod_74LS151 m17(.S(in[2:0]), .E(~in[3]), .I(ou6), .Z(m[14]));
    mod_74LS151 m18(.S(in[2:0]), .E(~in[3]), .I(ou7), .Z(m[15]));
    assign out[0] = m[1] | m[4] | m[11] | m[13];
    assign out[1] = m[5] | m[6] | m[11] | m[12] | m[14] | m[15];
    assign out[2] = m[2] | m[12] | m[14] | m[15];
    assign out[3] = m[1] | m[4] | m[7] | m[10] | m[15];
    assign out[4] = m[1] | m[3] | m[4] | m[5] | m[7] | m[9];
    assign out[5] = m[1] | m[2] | m[3] | m[7] | m[13];
    assign out[6] = m[0] | m[1] | m[7] | m[12];
endmodule

module mod_74LS151 (
    // TODO: add ports here
    input logic [2:0]S,
    input logic E,
    input logic [7:0]I,
    output logic Z, Z_
);
    // TODO: add logic here
    // NOTE: No syntax limitation
    assign Z = ~E & (I[0]&~S[0]&~S[1]&~S[2] | I[1]&S[0]&~S[1]&~S[2] |
                      I[2]&~S[0]&S[1]&~S[2] | I[3]&S[0]&S[1]&~S[2] | 
                      I[4]&~S[0]&~S[1]&S[2] | I[5]&S[0]&~S[1]&S[2] |
                      I[6]&~S[0]&S[1]&S[2] | I[7]&S[0]&S[1]&S[2]);
    assign Z_ = ~Z;
endmodule