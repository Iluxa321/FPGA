module cpu (
    input logic             clk,
    input logic             rst,
    input logic             done,
    input logic [31:0]      rdata,
    output logic            write,
    output logic            read,
    output logic [3:0]      dataena,
    output logic [31:0]     addr,
    output logic [31:0]     wdata,

	output logic [31:0]     test

);

	logic [6:0] op;
	logic [2:0] funct3;
	logic funct7, zeroFlag, compFlag, PCWrite, IRWrite, RegWrite, WDSrc, AddrSrc;
	logic [1:0] SrcA, SrcB, ResSrc, DataSrc;
	logic [2:0] ImmSrc;
	logic [3:0] ALUControll;
	datapath dp(.clk(clk), .rst(rst), .PCWrite(PCWrite), .AddrSrc(AddrSrc),
				.IRWrite(IRWrite), .RegWrite(RegWrite), .WDSrc(WDSrc),
				.SrcA(SrcA), .SrcB(SrcB), .ResSrc(ResSrc), .DataSrc(DataSrc),
				.ALUControll(ALUControll), .ImmSrc(ImmSrc), .readData(rdata),
				.zero_flag(zeroFlag), .comp_flag(compFlag), .op(op), .funct3(funct3),
				.funct7(funct7), .addr(addr), .writeData(wdata), .test(test)
    );

	controller cntr(.clk(clk), .rst(rst), .done(done), .addr(addr[1:0]), .op(op), .funct3(funct3), 
					.funct7(funct7), .zeroFlag(zeroFlag), .compFlag(compFlag), .PCWrite(PCWrite), .IRWrite(IRWrite),
					.RegWrite(RegWrite), .AddrSrc(AddrSrc), .WDSrc(WDSrc), .SrcA(SrcA), .SrcB(SrcB), .ResSrc(ResSrc),
					.DataSrc(DataSrc), .ImmSrc(ImmSrc), .ALUControll(ALUControll), .read(read), .write(write), .mask(dataena)
    );

endmodule