`timescale 1ns/10ps

typedef enum logic[4:0] {FETCH, DECODER, MEM_ADDR, READ_DATA, 
                    MEM_WB, WRITE_DATA,  EXECUTE_R, EXECUTE_I,
                    LOAD_UPPER, LOAD_PC, ALU_WB, JUMP, JUMP_LINK, ANY_BARNCH} stateType;

module tb_core;

    logic clk, rst;
    logic we;
    logic [31:0] readData;
    logic [31:0] addr, writeData;
    logic [3:0] mask;
    stateType fsmState, fsmNext;
    event start_write, start_read;
    riscv dut(.clk(clk), .rst(rst), .done(1'd1), .readData(readData),
            .mem_we(we), .mask(mask), .addr(addr), .writeData(writeData));


    memfile mf(.clk(clk), .we(we), .mask(mask), .addr(addr), .indata(writeData), .outdata(readData));

    initial begin
        clk = 0;
        rst = 0;
        we = 0;
        addr = 0;
        writeData = 0;
        mask = 0;

        forever begin
            clk = #10 ~clk;
        end
    end

    initial begin
        @(negedge clk);
        rst = 1;
        repeat(3) @(negedge clk);
        rst = 0;
    end

    // always @(posedge clk) begin
    //     repeat(20) @(negedge clk);
    //     $stop;
    // end
    assign fsmState = stateType'(dut.cntr.mainFSM.state);
    assign fsmNext = stateType'(dut.cntr.mainFSM.next);
    always @(posedge clk) begin
        if(fsmState == DECODER && fsmNext == FETCH) begin
            repeat(3) @(posedge clk);
            $stop;
        end
        if(dut.dp.RF.rfile[3] == 32'hFF)
            $finish;
    end





task  testReadMem();
    for(int i = 0; i < 6 ; i++) begin
        @(negedge clk);
        mask = 4'b1111;
        addr = i * 4;
    end
    for (int i = 0; i < 4 ; i++) begin
        @(negedge clk);
        mask = 4'b0001 << i;
        addr = i;
    end
    for (int i = 0; i < 2 ; i++) begin
        @(negedge clk);
        mask = 4'b0011 << i*2;
        addr = i*2;
    end
    @(negedge clk);
endtask 
task testWriteMem();
    @(negedge clk);
    we = 1;
    addr = 0;
    writeData = 32'hffaabbcc;
    mask = 4'b1111;
    @(negedge clk);
    addr = 1 * 4;
    writeData = 32'h000000cc;
    mask = 4'b0001;
    @(negedge clk);
    addr = 2 * 4 + 1;
    writeData = 32'h000000cc;
    mask = 4'b0010;
    @(negedge clk);
    addr = 3 * 4 + 2;
    writeData = 32'h000000cc;
    mask = 4'b0100;
    @(negedge clk);
    addr = 4 * 4 + 3;
    writeData = 32'h000000cc;
    mask = 4'b1000;
    @(negedge clk);
    addr = 0 * 4 + 3;
    writeData = 32'h00000044;
    mask = 4'b1000;
    @(negedge clk);
    addr = 5 * 4 + 2;
    writeData = 32'h0000ff44;
    mask = 4'b1100;
    @(negedge clk);
    addr = 5 * 4 + 0;
    writeData = 32'h0000ee22;
    mask = 4'b0011;
    @(negedge clk);
    we = 0;
endtask
    
endmodule



module memfile(

input  clk, we,
input [3:0] mask,
input  [31:0] addr,
input  [31:0] indata,
output  [31:0] outdata
);

    bit [31:0] mem [1024:0];
    initial begin
        $readmemh("main.hex", mem);
    end
    logic [31:0] wdata, mask32;
    assign wdata = indata << (addr[1:0] * 8);
    assign mask32 = {{8{mask[3]}},{8{mask[2]}},{8{mask[1]}},{8{mask[0]}}};
    always_ff @(posedge clk) begin
        if(we)
            mem[addr[31:2]] <= (mem[addr[31:2]] & ~mask32) | wdata;

    end
    assign outdata = (mem[addr[31:2]] & mask32) >> (addr[1:0] * 8);

endmodule
