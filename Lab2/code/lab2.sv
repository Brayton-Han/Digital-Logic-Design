module lab2 (
    input logic [31:0]instr,
    output logic [7:0]aluout
);
    // TODO: add signal declaration here
    logic [3:0] alufunc;
    logic [7:0] imm1, imm2;
    logic [2:0] shamt;
    logic write, read, skip;
    
    decoder myDecoder(
        // TODO: add ports here
        .instr(instr), .alufunc(alufunc), .imm1(imm1), .imm2(imm2), .shamt(shamt), .write(write), .read(read), .skip(skip)
    );
    
    alu myALU(
        // TODO: add ports here
        .alufunc(alufunc), .imm1(imm1), .imm2(imm2), .shamt(shamt), .aluout(aluout)
    );
endmodule

module decoder (
    input logic [31:0] instr,
    output logic [3:0] alufunc,
    output logic [7:0] imm1, imm2,
    output logic [2:0] shamt,
    output logic write, read, skip
);
    assign imm1 = instr[25:18];
    assign imm2 = instr[17:10];
    assign shamt = instr[9:7];
    always_comb
        unique case(instr[31:26])
            6'b000000:
                unique case(instr[5:0])
                    6'b100000: alufunc = 4'b0000;
                    6'b100010: alufunc = 4'b0001;
                    6'b101010: alufunc = 4'b0010;
                    6'b100100: alufunc = 4'b0011;
                    6'b100111: alufunc = 4'b0100;
                    6'b100101: alufunc = 4'b0101;
                    6'b100110: alufunc = 4'b0110;
                    6'b101111: alufunc = 4'b0111;
                    6'b000000: alufunc = 4'b1000;
                    6'b000010: alufunc = 4'b1001;
                    6'b000011: alufunc = 4'b1010;
                endcase
            6'b100011: read = 1'b1;
            6'b101011: write = 1'b1;
            6'b000010: skip = 1'b1;
            6'b000100: skip = 1'b1;
            6'b000101: skip = 1'b1;
        endcase
endmodule

module alu (
    // TODO: add port declaration here
    input logic [3:0] alufunc,
    input logic [7:0] imm1, imm2,
    input logic [2:0] shamt,
    output logic [7:0] aluout
);
    // TODO: add logic here
    always_comb
        unique case(alufunc)
            4'b0000: aluout = imm1+imm2;
            4'b0001: aluout = imm1-imm2;
            4'b0010: begin
                        if(signed'(imm1) < signed'(imm2))
                            aluout = 8'b00000001;
                        else
                            aluout = 8'b00000000;
                      end
            4'b0011: aluout = imm1&imm2;
            4'b0100: aluout = ~(imm1|imm2);
            4'b0101: aluout = imm1|imm2;
            4'b0110: aluout = imm1^imm2;
            4'b0111: aluout = ~imm1;
            4'b1000: aluout = imm1 << shamt;
            4'b1001: aluout = imm1 >> shamt;
            4'b1010: aluout = signed'(imm1) >>> shamt;
        endcase
endmodule