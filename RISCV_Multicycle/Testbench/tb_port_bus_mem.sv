`include "Inc/data_type.svh"
`include "Inc/conf.svh"
`include "Inc/if.svh"
`timescale 1ns/10ps



// План
// 1) Чтение из UFM
// 2) Запись в UFM
// 3) Чтение из UFM запись в RAM
// 4) Чтение из RAM

module tb_port_bus_mem;

    bit clk, rst;

    port ctrl_port();
    virtual port v_port = ctrl_port;
    port mtr();
	port_receive_type from_ufm;
    port_receive_type from_ram;
    port_transmite_type  to_slaves;
    logic ufm_chsel;
    logic ram_chsel;

	assign from_ram.waitrequest = 1'd0;
	 
	masterPort mp(
		.clk(clk),
		.rst(rst),
		.cpu_master(ctrl_port.slave),
	    .master_slave(mtr.master)
	);

	bus bus (
        .master_bus(mtr.slave),
        // From Slave 1 (UFM)
        .from_ufm(from_ufm),
        // From Slave 2 (RAM)
        .from_ram(from_ram),
        // To Slaves
        .to_slaves(to_slaves),
        .ufm_chsel(ufm_chsel),
        .ram_chsel(ram_chsel)
    );

	ufm mem (
	    .clock(clk),                   //    clk.clk
		.avmm_data_addr(to_slaves.addr[18:2]),          //   data.address
		.avmm_data_read(to_slaves.read & ufm_chsel),          //       .read
		.avmm_data_readdata(from_ufm.rdata),      //       .readdata
		.avmm_data_waitrequest(from_ufm.waitrequest),   //       .waitrequest
		.avmm_data_readdatavalid(from_ufm.valid), //       .readdatavalid
		.avmm_data_burstcount(to_slaves.burstcount),    //       .burstcount
		.reset_n(rst)                  // nreset.reset_n
	);

	data_ram ram (
        .clk(clk),
        .rst(rst),
        .read(to_slaves.read & ram_chsel),
        .write(to_slaves.write & ram_chsel),
        .byteena(to_slaves.dataena),
        .addr(to_slaves.addr[11:2]),
        .wdata(to_slaves.wdata),
        .valid(from_ram.valid),
        .rdata(from_ram.rdata)
    );

    initial begin
        clk = 0;
        rst = 0;
        v_port.addr = 0;
        v_port.wdata = 0;
        v_port.read = 0;
        v_port.write = 0;
        v_port.dataena = 0;
        v_port.burstcount = 0;
        
        
        forever begin
            clk = #10 ~clk;
        end
    end

    initial begin
        repeat(2) @(posedge clk);
        rst = 1;
    end

    initial begin
        wait(rst);
        // taskRead(ctrl_port, `RAM_OFFSET, 10, 4);
        // taskRead(ctrl_port, `RAM_OFFSET, 10, 2);
        // taskRead(ctrl_port, `RAM_OFFSET, 10, 1);

        for(int i = 0; i < 20; i++) begin
            taskRead(ctrl_port, `UFM_OFFSET + i*4, 1, 4);
            taskWrite(ctrl_port, `RAM_OFFSET + i*4, v_port.rdata, 4);
        end
        taskRead(ctrl_port, `RAM_OFFSET, 20, 2);

        repeat(10) @(posedge clk);
        $stop;
    end
        
task taskRead(virtual port pt, logic [31:0] bass_addr, int cnt, int size);
    begin
        $display("-------------------START READ TASK---------------------");
        if(size == 4) $display("----> READ WORD <--------");
        else if(size == 2) $display("----> READ HALFWORD <--------");
        else if(size == 1) $display("----> READ BYTE <--------");
        for(int i = 0; i < cnt; i++) begin
            @(posedge clk);
            pt.read = 1;
            pt.write = 0;
            pt.burstcount = 1;
            pt.addr = bass_addr + i*size;
            pt.dataena = res_dataena(pt.addr[1:0], size);
            @(posedge pt.valid);
            $display("[%d] -> ADDR = %x, READ_DATA = %x, DATAEAN = %d", $time, pt.addr, pt.rdata, pt.dataena);
        end
        pt.read = 0;
        pt.write = 0;
        $display("-------------------END READ TASK---------------------");
        $display("");
    end
endtask 


task taskWrite(virtual port pt, logic [31:0] bass_addr, logic [31:0] data, int size);
    begin
        $display("-------------------START WRITE TASK---------------------");
        if(size == 4) $display("----> WRITE WORD <--------");
        else if(size == 2) $display("----> WRITE HALFWORD <--------");
        else if(size == 1) $display("----> WRITE BYTE <--------");
        @(posedge clk);
        pt.read = 0;
        pt.write = 1;
        pt.burstcount = 1;
        pt.addr = bass_addr;
        pt.wdata = data;
        pt.dataena = res_dataena(pt.addr[1:0], size);
        @(posedge pt.valid);
        $display("-------------------END WRITE TASK---------------------");
        $display("");
        pt.read = 0;
        pt.write = 0;
    end
endtask

endmodule






function logic [3:0] res_dataena(logic [1:0] addr, int size);
    begin
        if(size == 4) return 4'b1111;
        else if(size == 2) begin
            if(addr == 2) return 4'b1100;
            else return 4'b0011;
        end 
        else if(size == 1) begin
            if(addr == 0)       return 4'b0001;
            else if(addr == 1)  return 4'b0010;
            else if(addr == 2)  return 4'b0100;
            else                return 4'b1000;
        end
    end
    
endfunction