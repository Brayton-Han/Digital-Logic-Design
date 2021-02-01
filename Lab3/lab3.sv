module lab3 (
    input logic [3:0]a, b, cin,
    output logic [3:0]c_ripple, c_ahead,
    output logic cout_ripple, cout_ahead
    // c = a + b
);
    ripple_adder ripple_adder(.a, .b, .cin, .c(c_ripple), .cout(cout_ripple));
    ahead_adder ahead_adder(.a, .b, .cin, .c(c_ahead), .cout(cout_ahead));
endmodule

module full_adder (
    input logic a, b, cin,
    output logic c, cout
);
    // TODO: Add logic here
    assign c = a^b^cin;
    assign cout = a&b | b&cin | a&cin;
endmodule

module ripple_adder (
    input logic [3:0]a, b,
    input logic cin,
    output logic [3:0]c,
    output logic cout
);
    // TODO: Add logic here; Only use full_adder instants here
    logic [2:0]ci;
    full_adder mfa1( .a(a[0]), .b(b[0]), .cin(cin),   .c(c[0]), .cout(ci[0]) );
    full_adder mfa2( .a(a[1]), .b(b[1]), .cin(ci[0]), .c(c[1]), .cout(ci[1]) );
    full_adder mfa3( .a(a[2]), .b(b[2]), .cin(ci[1]), .c(c[2]), .cout(ci[2]) );
    full_adder mfa4( .a(a[3]), .b(b[3]), .cin(ci[2]), .c(c[3]), .cout(cout)  );
endmodule

module ahead_adder (
    input logic [3:0]a, b,
    input logic cin,
    output logic [3:0]c,
    output logic cout
);
    // NOTE: It's recommended to define other modules to help accomplish this task
    // TODO: Add logic here
    logic [2:0]cou;
    ahead_add maa( .a(a), .b(b), .cin(cin) , .cout(cout), .cou(cou) );
    assign c[0] = a[0]^b[0]^cin;
    assign c[1] = a[1]^b[1]^cou[0];
    assign c[2] = a[2]^b[2]^cou[1];
    assign c[3] = a[3]^b[3]^cou[2];
endmodule

// NOTE: You can define other modules here
module ahead_add (
    input logic [3:0]a, b,
    input logic cin,
    output logic cout,
    output logic [2:0]cou
);
    assign cou[0] = a[0]&b[0] | (a[0]|b[0])&cin;
    assign cou[1] = a[1]&b[1] | (a[1]|b[1])&(a[0]&b[0] | (a[0]|b[0])&cin);
    assign cou[2] = a[2]&b[2] | (a[2]|b[2])&(a[1]&b[1] | (a[1]|b[1])&(a[0]&b[0] | (a[0]|b[0])&cin));
    assign cout   = a[3]&b[3] | (a[3]|b[3])&(a[2]&b[2] | (a[2]|b[2])&(a[1]&b[1] | (a[1]|b[1])&(a[0]&b[0] | (a[0]|b[0])&cin)));
endmodule