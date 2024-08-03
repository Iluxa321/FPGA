module controller (
input logic clk, rst,
input logic done,   // сигнал от шины данных
input logic [1:0] addr,
input logic [6:0] op,
input logic [2:0] funct3,
input logic funct7,
input logic zeroFlag, compFlag, // результаты вычисления ALU
// Сигналы управления процессора
output logic PCWrite, IRWrite, RegWrite, 
output logic AddrSrc, WDSrc,
output logic [1:0] SrcA, SrcB, ResSrc,
output logic [1:0] DataSrc,
output logic [2:0] ImmSrc,
output logic [3:0] ALUControll,
// Сигналы упрвления шины данных
output logic read, write,
output logic [3:0] mask
);
    logic ReadData, ReadInstr, WriteData;
    logic PCUpdate, branchFlag;
    logic [1:0] ALUOp;
    logic [5:0] branchVector;
    mainFSM mainFSM(.clk(clk), .rst(rst), .done(done), .op(op),
                    .ReadData(ReadData), .ReadInstr(ReadInstr), .WriteData(WriteData),
                    .AddrSrc(AddrSrc), .IRWrite(IRWrite), .RegWrite(RegWrite), .WDSrc(WDSrc),
                    .PCUpdate(PCUpdate), .Branch(branchFlag),
                    .SrcA(SrcA), .SrcB(SrcB), .ResSrc(ResSrc), .ALUOp(ALUOp));

    avalonMasterDecoder amd(.addr(addr), .funct3(funct3[1:0]), 
                        .readInst(ReadInstr), .readData(ReadData), .writeData(WriteData),
                        .read(read), .write(write), .mask(mask));

    aluDecoder aluDecoder(.ALUOp(ALUOp), .funct3(funct3), .op5(op[5]), .funct7(funct7), .ALUControll(ALUControll));

    branchDecoder branchDecoder(.funct3(funct3), .branch(branchVector));

    immExtDecoder immExtDecoder(.op(op), .immSrc(ImmSrc));   

    dataExtDecoder dataExtDecoder(.funct3(funct3), .dataSrc(DataSrc));

    assign PCWrite = PCUpdate | branchFlag & |(branchVector & {{2{~compFlag,compFlag}} ,~zeroFlag, zeroFlag});

endmodule

module mainFSM(
input clk, rst,
input logic done,
input logic [6:0] op,
output logic ReadData, ReadInstr, WriteData,
output logic AddrSrc, IRWrite, RegWrite, WDSrc,
output logic PCUpdate, Branch,
output logic [1:0] SrcA, SrcB, ResSrc,
output logic [1:0] ALUOp
);

    logic [16:0] fsmControll;

    // OP code
    localparam [6:0] LOAD = 7'd3,
                     SAVE = 7'd35,
                     LUI = 7'd55,
                     R = 7'd51,
                     I = 7'd19,
                     AUIPC = 7'd23,
                     JAL = 7'd111,
                     JALR = 7'd103,
                     BRANCH = 7'd99;
    
    typedef enum logic[4:0] {FETCH, DECODER, MEM_ADDR, READ_DATA, 
                    MEM_WB, WRITE_DATA,  EXECUTE_R, EXECUTE_I,
                    LOAD_UPPER, LOAD_PC, ALU_WB, JUMP, JUMP_LINK, ANY_BARNCH} stateType;
    
    stateType state, next;

    always_ff @( posedge clk ) begin
        if(~rst)
            state <= FETCH;
        else
            state <= next;
    end

    always_comb begin
        case (state)
            FETCH: begin
                if(done) begin
                    fsmControll = 17'b0_0_0_0_1_0_0_1_0_00_10_10_00;
                    next = DECODER;
                end
				else begin
				    fsmControll = 17'b0_1_0_0_0_0_0_0_0_00_10_10_00;
                    next = FETCH;
                end
            end
            DECODER: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_01_01_00_00;
                case (op)
                    LOAD, SAVE: next = MEM_ADDR;
                    LUI: next = LOAD_UPPER;
                    R: next = EXECUTE_R;
                    I: next = EXECUTE_I;
                    AUIPC: next = LOAD_PC;
                    JAL: next = JUMP;
                    JALR: next = JUMP_LINK;
                    BRANCH: next = ANY_BARNCH;
                    default: next = FETCH;
                endcase
            end
            MEM_ADDR: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_10_01_00_00;
                case (op)
                    LOAD: next = READ_DATA;
                    SAVE: next = WRITE_DATA;
                    default: next = FETCH;
                endcase
            end
            READ_DATA: begin   
                if(done) begin
                    fsmControll = 17'b0_0_0_1_0_0_0_0_0_10_01_00_00;
                    next = MEM_WB;
                end
                else begin
                    fsmControll = 17'b1_0_0_1_0_0_0_0_0_10_01_00_00;
                    next = READ_DATA;
                end
            end
            MEM_WB: begin
                fsmControll = 17'b0_0_0_0_0_1_0_0_0_00_00_01_00;
                next = FETCH;
            end
            WRITE_DATA: begin     
                if(done) begin
                    fsmControll = 17'b0_0_0_1_0_0_0_0_0_10_01_00_00;
                    next = FETCH;
                end
                else begin
                    fsmControll = 17'b0_0_1_1_0_0_0_0_0_10_01_00_00;
                    next = WRITE_DATA;
                end
            end
            EXECUTE_R: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_10_00_00_10;
                next = ALU_WB;
            end
            EXECUTE_I: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_10_01_00_10;
                next = ALU_WB;
            end
            LOAD_UPPER: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_11_01_00_00;
                next = ALU_WB;
            end
            LOAD_PC: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_01_01_00_00;
                next = ALU_WB;
            end
            JUMP: begin
                fsmControll = 17'b0_0_0_0_0_0_0_1_0_01_10_00_00;
                next = ALU_WB;
            end
            ALU_WB: begin
                fsmControll = 17'b0_0_0_0_0_1_0_0_0_00_00_00_00;
                next = FETCH;
            end
            
            JUMP_LINK: begin
                fsmControll = 17'b0_0_0_0_0_1_1_1_0_10_01_10_00;
                next = FETCH;
            end
            ANY_BARNCH: begin
                fsmControll = 17'b0_0_0_0_0_0_0_0_1_10_00_00_01;
                next = FETCH;
            end
            default: begin 
                fsmControll = 17'b0_0_0_0_0_0_0_0_0_00_00_00_00;
                next = FETCH; 
            end 
        endcase
    end

    assign {ReadData, ReadInstr, WriteData, 
            AddrSrc, IRWrite, RegWrite, WDSrc, 
            PCUpdate, Branch, SrcA, SrcB, ResSrc, ALUOp} = fsmControll;

endmodule


module branchDecoder (
input logic [2:0] funct3,
output logic [5:0] branch 
);
    localparam [2:0] BEQ = 3'b000,
                     BNE = 3'b001,
                     BLT = 3'b100,
                     BGE = 3'b101,
                     BLTU = 3'b110,
                     BGEU = 3'b111;
    always_comb begin
        case (funct3)
            BEQ: branch = 6'b000001;
            BNE: branch = 6'b000010; 
            BLT: branch = 6'b000100;
            BGE: branch = 6'b001000;
            BLTU: branch = 6'b010000;
            BGEU: branch = 6'b100000;
            default: branch = 6'd0;
        endcase
    end
endmodule

module avalonMasterDecoder (
// Формирует сигнал чтения или записи,
// а также маску данных для чтения и записи
input logic [1:0] addr, funct3,
input logic readInst, readData, writeData,
output logic read, write,
output logic [3:0] mask
);
    logic [3:0] tmp_mask;
    always_comb begin
        casex (funct3)
            2'b10: tmp_mask = 4'b1111;
            2'b01: tmp_mask = 4'b0011;
            2'b00: tmp_mask = 4'b0001;
            default: tmp_mask = 4'b0000;
        endcase
    end

    assign mask = readInst ? 4'b1111 : (tmp_mask << addr);
    assign read = readInst | readData;
    assign write = writeData;

endmodule

module immExtDecoder (
input logic [6:0] op,
output logic [2:0] immSrc
);

    localparam [6:0] op3 = 7'd3, op19 = 7'd19, op103 = 7'd103,
                     op23 = 7'd23, op55 = 7'd55,
                     op35 = 7'd35,
                     op99 = 7'd99,
                     op111 = 7'd111;
    always_comb begin
        case (op)
        // I
            op3, op19, op103: immSrc = 3'd0;
        // U
            op23, op55: immSrc = 3'd4;
        // S
            op35: immSrc = 3'd1;
        // B
            op99: immSrc = 3'd2;
        // J
            op111: immSrc = 3'd3;
            default: immSrc = 3'd0;
        endcase
    end
endmodule


module dataExtDecoder (
input logic [2:0] funct3,
output logic [1:0] dataSrc
);
    always_comb begin
        case (funct3)
            3'b000: dataSrc = 2'b01;     // ext singend byte
            3'b001: dataSrc = 2'b10;     // ext signed halfword
            default: dataSrc = 2'b00;    // unsigned
        endcase
    end
endmodule

module aluDecoder (
input logic [1:0] ALUOp,
input logic [2:0] funct3,
input logic op5, funct7,
output logic [3:0] ALUControll
);

    always_comb begin
        case (ALUOp)
            2'b00: ALUControll = 4'd0;
            2'b01: case (funct3)
                3'd0: ALUControll = 4'd1; // sub
                3'd1: ALUControll = 4'd1; // sub
                3'd4: ALUControll = 4'd5; // slt
                3'd5: ALUControll = 4'd5; // slt
                3'd6: ALUControll = 4'd7; // sltu
                3'd7:  ALUControll = 4'd7; // sltu
                default: ALUControll = 4'dx;
            endcase
            2'b10: case (funct3)
                3'd0: 
                    if(op5 & funct7)
                        ALUControll = 4'd1; // sub
                    else
                        ALUControll = 4'd0; // add
                3'd1: ALUControll = 4'd10; // <<
                3'd2: ALUControll = 4'd5; // slt
                3'd3: ALUControll = 4'd7; // sltu
                3'd4: ALUControll = 4'd4; // xor
                3'd5: 
                    if(funct7)
                        ALUControll = 4'd9; // >>>
                    else
                        ALUControll = 4'd8; // >>
                3'd6: ALUControll = 4'd3; // or
                3'd7: ALUControll = 4'd2; // and
                default: ALUControll = 4'dx;
            endcase
            default: ALUControll = 4'dx;
        endcase
    end
endmodule
