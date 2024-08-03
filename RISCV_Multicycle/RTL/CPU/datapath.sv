module datapath(
input logic clk, rst,
input logic PCWrite, AddrSrc, IRWrite, RegWrite, WDSrc,
input logic [1:0] SrcA, SrcB, ResSrc, DataSrc,
input logic [3:0] ALUControll,
input logic [2:0] ImmSrc,
input logic [31:0] readData,
output logic zero_flag, comp_flag,
output logic [6:0] op,
output logic [2:0] funct3,
output logic funct7,
output logic [31:0] addr, writeData,

output logic [31:0] test
);
    logic [31:0]addrInst, resData, instr, oldAddrInst, memData, addrRes;
    flopre #(32) PC(.clk(clk), .rst(rst), .en(PCWrite), .d(resData), .q(addrInst));
    mux2 #(32) addrMux(.A(addrInst), .B(resData), .s(AddrSrc), .Y(addrRes)); 
    flope #(32) instReg(.clk(clk), .en(IRWrite), .d(readData), .q(instr));
    flope #(32) addrReg(.clk(clk), .en(IRWrite), .d(addrInst), .q(oldAddrInst));
    flop #(32) dataReg(.clk(clk), .d(readData), .q(memData));
    
    

    logic [4:0] rs1, rs2, rd;
    logic [31:0] wd;
    assign {rs1, rs2, rd} = {instr[19:15], instr[24:20], instr[11:7]};
    mux2 #(32) wdMux(.A(resData), .B(addrInst), .s(WDSrc), .Y(wd));

    logic [31:0] A,B;
    logic [31:0] rA, rB;
    regfile RF(.clk(clk), .we(RegWrite), .addrA(rs1), .addrB(rs2), .addrWD(rd),
                .writeData(wd), .RD1(A), .RD2(B), .RD_TEST(test)); 
    flop #(32) AReg(.clk(clk), .d(A), .q(rA));
    flop #(32) BReg(.clk(clk), .d(B), .q(rB));

    logic [31:0] memToRegData, immData;
    dataExt dataExt(.dataSrc(DataSrc), .inData(memData), .outData(memToRegData));
    immExt immExt(.instr(instr[31:7]), .extType(ImmSrc), .immext(immData));
    
    logic [31:0] aluA, aluB, aluRes;
    logic aluZero;
    mux4 #(32) aluMuxA(.A(addrInst), .B(oldAddrInst), .C(rA), .D(32'd0), .s(SrcA), .Y(aluA));
    mux3 #(32) aluMuxB(.A(rB), .B(immData), .C(32'd4), .s(SrcB), .Y(aluB));
    alu alu(.A(aluA), .B(aluB), .alu_controll(ALUControll), .zero_flag(aluZero), .alu_out(aluRes));
    

    logic [31:0] rAluRes;
    flop #(32) aluFlop(.clk(clk), .d(aluRes), .q(rAluRes));

    mux3 #(32) resMux(.A(rAluRes), .B(memToRegData), .C(aluRes), .s(ResSrc), .Y(resData));

    assign addr = addrRes;
    assign {op, funct3, funct7} = {instr[6:0], instr[14:12], instr[30]};
    assign zero_flag = aluZero;
    assign comp_flag = aluRes[0];
    assign writeData = rB;

endmodule


module regfile (
input logic clk, we,
input logic [4:0] addrA, addrB, addrWD,
input logic [31:0] writeData,
output logic [31:0] RD1,RD2,
output logic [31:0] RD_TEST
);
    logic [31:0] rfile [31:0];
    initial begin
         $readmemh("init_regfile.txt", rfile);
    end
    assign RD1 = addrA == 0 ? 31'd0 : rfile[addrA];
    assign RD2 = addrB == 0 ? 31'd0 : rfile[addrB];
    assign RD_TEST = rfile[3];
    always_ff @(posedge clk) begin
        if(we)
            rfile[addrWD] <= writeData;
    end
endmodule


module dataExt (
input logic [1:0] dataSrc,
input logic [31:0] inData,
output logic [31:0] outData
);
    always_comb begin
        case (dataSrc)
            2'b00: outData = inData;                            // lw, lhu, lbu
            2'b01: outData = {{24{inData[7]}}, inData[7:0]};    // lb
            2'b10: outData = {{16{inData[15]}}, inData[15:0]};  // lh
            default: outData = '0;
        endcase
    end
endmodule

module immExt (
input logic [31:7] instr,
input logic [2:0] extType,
output logic [31:0] immext
);
    localparam [2:0] immI = 3'd0,
               immS = 3'd1,
               immB = 3'd2,
               immJ = 3'd3,
               immU = 3'd4;
    always_comb begin
        case (extType)
            immI: immext = {{20{instr[31]}}, instr[31:20]};
            immS: immext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            immB: immext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            immJ: immext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            immU: immext = {instr[31:12], 12'd0};
            default: immext = 32'dx;
        endcase
    end
endmodule


module flop #(parameter WIDTH = 8) (
input logic  clk,
input logic [WIDTH-1:0] d,
 output logic [WIDTH-1:0] q
);
    always_ff @(posedge clk) begin
        q <= d;
    end
endmodule

module flope #(parameter WIDTH = 8) (
input logic clk, en,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q
 );
    always_ff @(posedge clk) begin
        if(en) q <= d;
    end
endmodule

module flopre #(parameter WIDTH = 8) (
input logic clk, rst, en,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q
 );
    always_ff @(posedge clk) begin
        if (~rst) q <= 0;
        else if(en) q <= d;
    end
endmodule



module mux2 #(parameter WIDTH = 8)
(
input logic [WIDTH-1:0] A, B,
input logic s,
output logic [WIDTH-1:0] Y
);
    assign Y = s ? B : A;
endmodule


module mux3 #(parameter WIDTH = 8)
(
input logic [WIDTH-1:0] A, B, C,
input logic [1:0] s,
output logic [WIDTH-1:0] Y
);
    assign Y = s[1] ? C : s[0] ? B : A;
endmodule

module mux4 #(parameter WIDTH = 8)
(
input logic [WIDTH-1:0] A, B, C, D,
input logic [1:0] s,
output logic [WIDTH-1:0] Y
);
    always_comb begin
        case (s)
            2'b00: Y = A;
            2'b01: Y = B;
            2'b10: Y = C;
            2'b11: Y = D;
        endcase
    end
endmodule

