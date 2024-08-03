`include "Inc/data_type.svh"

`timescale 1ns/10ps


// module tb_ram;
// //  TODO: Определится кто сдвигает считаниы и полученныве данные master или slave
//     int data[20];

//     logic clk, rst, valid;
//     logic read, write;
//     logic [3:0] byteena;
//     logic [31:0] addr, wdata, rdata;

//     logic m_read, m_write, m_valid;
//     logic [3:0] m_dataena;
//     logic [31:0] m_addr, m_wdata, m_rdata;

//     masterPort mp(
// 	    .clk(clk),
//         .rst(rst),
// // core to/from port
// 	    .m_read(m_read), 
//         .m_write(m_write),
// 	    .m_dataena(m_dataena),
// 	    .m_burstcount(4'd1),
// 	    .m_addr(m_addr),
// 	    .m_wdata(m_wdata),
// 	    .m_valid(m_valid),
// 	    .m_rdata(m_rdata),
// // master_port to/from slave_port
// 	    .s_rdata(rdata),
// 	    .readvalid(valid),
//         .waitrequest(1'd0),
// 	    .s_read(read),
//         .s_write(write),
// 	    .s_dataena(byteena),
// 	    .s_burstcount(),
// 	    .s_addr(addr),
// 	    .s_wdata(wdata)
// );

//     data_ram dut(
//         .clk(clk),
//         .rst(rst),
//         .read(read),
//         .write(write),
//         .byteena(byteena),
//         .addr(addr),
//         .wdata(wdata),
//         .valid(valid),
//         .rdata(rdata)
//     );






//     initial begin
//         $display("START GEN DATA");
//         for(int i = 0; i < 20; i++) begin
//             data[i] = $random();
//             $display("%x DATA = %x", i, data[i]);
//         end
//         $display("END GEN DATA");
//     end

//     initial begin
//         clk = 0;
//         rst = 0;
//         m_read = 0;
//         m_write = 0;
//         m_dataena = 0;
//         m_addr = 0;
//         m_wdata = 0;

//         forever begin
//             clk = #10 ~clk;
//         end
//     end

//     initial begin
//         repeat(2) @(posedge clk);
//         rst = 1;
//     end

//     initial begin
//         #1;
//         wait(rst);
//         write_ram(0, 20, 15, data);
//         @(posedge clk);
//         read_ram(0, 1);
//         read_ram(1, 2);
//         read_ram(2, 4);

//         read_ram(5, 3);
//         read_ram(6, 6);
//         read_ram(7, 12);
//         read_ram(13, 15);
//         repeat(10) @(posedge clk);
//         $stop;
//     end


// task automatic write_ram(int s_addr, int num, logic [3:0] byte_ena, ref int data [20]);
//     begin
//         @(posedge clk);
//         m_dataena = byte_ena;
//         m_write = 1;
//         for (int i = 0; i < num; i++ ) begin
//             m_addr = s_addr + i*4;
//             m_wdata = data[i];
//             @(posedge m_valid);
            
//         end
//         m_write = 0;
//     end 
// endtask

// task read_ram(int s_addr, logic [3:0] be);
//     int  read_data;
//     begin
//         m_addr = s_addr*4;
//         m_read = 1;
//         m_dataena = be;
//         @(posedge m_valid);
//         read_data = m_rdata;
//         #5 $display("[%t] - ADDR = %x, BYTEENA = %x, DATA = %x", $time, addr, byteena, read_data);
//     end
// endtask

// endmodule

`timescale 1ns/10ps


module tb_ram;
//  TODO: Определится кто сдвигает считаниы и полученныве данные master или slave
    int data[20];

    logic clk, rst;
    port_transmite_type cpu2master;
    port_receive_type master2cpu;
    port_receive_type slave2master;
    port_transmite_type master2slave;


    masterPort mp(
	    .clk(clk),
        .rst(rst),
// core to/from port
        .cpu2master(cpu2master),
        .master2cpu(master2cpu),
// master_port to/from slave_port
        .slave2master(slave2master),
        .master2slave(master2slave)
);

    data_ram dut(
        .clk(clk),
        .rst(rst),
        .read(master2slave.read),
        .write(master2slave.write),
        .byteena(master2slave.dataena),
        .addr(master2slave.addr),
        .wdata(master2slave.wdata),
        .valid(slave2master.valid),
        .rdata(slave2master.rdata)
    );






    initial begin
        $display("START GEN DATA");
        for(int i = 0; i < 20; i++) begin
            data[i] = $random();
            $display("%x DATA = %x", i, data[i]);
        end
        $display("END GEN DATA");
    end

    initial begin
        clk = 0;
        rst = 0;
        cpu2master.read = 0;
        cpu2master.write = 0;
        cpu2master.dataena = 0;
        cpu2master.addr = 0;
        cpu2master.wdata = 0;
        cpu2master.burstcount = 1;

        slave2master.waitrequest = 0;

        forever begin
            clk = #10 ~clk;
        end
    end

    initial begin
        repeat(2) @(posedge clk);
        rst = 1;
    end

    initial begin
        #1;
        wait(rst);
        write_ram(0, 20, 15, data);
        @(posedge clk);
        read_ram(0, 1);
        read_ram(1, 2);
        read_ram(2, 4);

        read_ram(5, 3);
        read_ram(6, 6);
        read_ram(7, 12);
        read_ram(13, 15);
        repeat(10) @(posedge clk);
        $stop;
    end


task automatic write_ram(int s_addr, int num, logic [3:0] byte_ena, ref int data [20]);
    begin
        @(posedge clk);
        cpu2master.dataena = byte_ena;
        cpu2master.write = 1;
        for (int i = 0; i < num; i++ ) begin
            cpu2master.addr = s_addr + i*4;
            cpu2master.wdata = data[i];
            @(posedge master2cpu.valid);
            
        end
        cpu2master.write = 0;
    end 
endtask

task read_ram(int s_addr, logic [3:0] be);
    int  read_data;
    begin
        cpu2master.addr = s_addr*4;
        cpu2master.read = 1;
        cpu2master.dataena = be;
        @(posedge master2cpu.valid);
        read_data = master2cpu.rdata;
        #5 $display("[%t] - ADDR = %x, BYTEENA = %x, DATA = %x", $time, cpu2master.addr, cpu2master.dataena, read_data);
    end
endtask

endmodule