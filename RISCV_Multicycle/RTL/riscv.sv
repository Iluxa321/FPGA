`include "Inc/conf.svh"
`include "Inc/data_type.svh"
`include "Inc/if.svh"


module riscv (
    input logic clk, rst,
    output logic [9:0] leds,

    output  [7:0]   HEX0,
	output  [7:0]   HEX1,
	output  [7:0]   HEX2,
	output  [7:0]   HEX3,
	output  [7:0]   HEX4,
	output  [7:0]   HEX5

);

	logic clk_test, cpu_clk;
    logic [31:0] test;

	pll pll(.inclk0(clk), .c0(cpu_clk), .c1(clk_test));

    port cpu_master();
    port master_bus();
    port_receive_type from_ufm;
    port_receive_type from_ram;
    port_receive_type from_seg;
    port_transmite_type  to_slaves;
    logic ufm_chsel;
    logic ram_chsel;
	 logic seg_chsel;

    assign leds = test[9:0];

    
    cpu cpu(
    .clk(cpu_clk),
    .rst(rst),
    .done(cpu_master.valid),
    .rdata(cpu_master.rdata),
    .write(cpu_master.write),
    .read(cpu_master.read),
    .dataena(cpu_master.dataena),
    .addr(cpu_master.addr),
    .wdata(cpu_master.wdata),
    .test(test)
    );

    assign cpu_master.burstcount = 1'd1;
    masterPort mp(
	    .clk(cpu_clk),
	    .rst(rst),
	    .cpu_master(cpu_master),
	    .master_slave(master_bus)
	);

    bus bus (
        .master_bus(master_bus),
        // From Slave 1 (UFM)
        .from_ufm(from_ufm),
        // From Slave 2 (RAM)
        .from_ram(from_ram),
        // From Slave 2 (RAM)
        .from_seg(from_seg),
        // To Slaves
        .to_slaves(to_slaves),
        .ufm_chsel(ufm_chsel),
        .ram_chsel(ram_chsel),
		  .seg_chsel(seg_chsel)
    );

    ufm mem (
	    .clock(cpu_clk),                   //    clk.clk
		.avmm_data_addr(to_slaves.addr[18:2]),          //   data.address
		.avmm_data_read(to_slaves.read & ufm_chsel),          //       .read
		.avmm_data_readdata(from_ufm.rdata),      //       .readdata
		.avmm_data_waitrequest(from_ufm.waitrequest),   //       .waitrequest
		.avmm_data_readdatavalid(from_ufm.valid), //       .readdatavalid
		.avmm_data_burstcount(to_slaves.burstcount),    //       .burstcount
		.reset_n(rst)                  // nreset.reset_n
	);

	assign from_ram.waitrequest = 1'd0;
	data_ram ram (
        .clk(cpu_clk),
        .rst(rst),
        .read(to_slaves.read & ram_chsel),
        .write(to_slaves.write & ram_chsel),
        .byteena(to_slaves.dataena),
        .addr(to_slaves.addr[11:2]),
        .wdata(to_slaves.wdata),
        .valid(from_ram.valid),
        .rdata(from_ram.rdata)
    );

    assign from_seg.waitrequest = 1'd0;
    seg_periph seg_periph(
        .clk(cpu_clk),
        .rst(rst),
// From Master
        .read(to_slaves.read & seg_chsel),
        .write(to_slaves.write & seg_chsel),
        .wdata(to_slaves.wdata),
        .addr(to_slaves.addr[2]),
// To Master
        .valid(from_seg.valid),
        .rdata(from_seg.rdata),
        // To 7seg
        .hex0(HEX0),
        .hex1(HEX1),
        .hex2(HEX2),
        .hex3(HEX3),
        .hex4(HEX4),
        .hex5(HEX5)
    );



endmodule




