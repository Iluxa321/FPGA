`timescale 1ns/10ps

`include "Inc/conf.svh"
`include "Inc/data_type.svh"
`include "Inc/if.svh"

module tb_bus;

    bit clk;

    port master_bus();
    virtual port mb;
    port_receive_type from_ufm;
    port_receive_type from_ram;
    port_receive_type from_seg;
    port_transmite_type  to_slaves;
    logic ufm_chsel;
    logic ram_chsel;
    logic seg_chsel;
    bus dut (
// From/To Master
    .master_bus(master_bus),

// From Slave 1 (UFM)
    .from_ufm(from_ufm),
    
// From Slave 2 (RAM)
    .from_ram(from_ram),

// From Slave 3 (SEG)
    .from_seg(from_seg),

// To Slaves
    .to_slaves(to_slaves),
    .ufm_chsel(ufm_chsel),
    .ram_chsel(ram_chsel),
    .seg_chsel(seg_chsel)
);

    initial begin
        mb = master_bus;
        clk = 0;
        mb.master.addr = 0;
        mb.master.wdata = 0;
        mb.master.read = 0;
        mb.master.write = 0;
        mb.master.dataena = 0;
        mb.master.burstcount = 0;

        from_ram.rdata = 12;
        from_ram.valid = 1;
        from_ram.waitrequest = 1;

        from_ufm.rdata = 23;
        from_ufm.valid = 1;
        from_ufm.waitrequest = 0;

        from_seg.rdata = 5;
        from_seg.valid = 1;
        from_seg.waitrequest = 0;

        forever begin
            clk = #10 ~clk;
        end
    end

    initial begin
        repeat(3) @(posedge clk);

        mb.master.addr = `RAM_OFFSET;
        mb.master.wdata = 150;
        mb.master.read = 0;
        mb.master.write = 1;
        mb.master.dataena = 15;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);

        mb.master.addr = `RAM_OFFSET+4;
        mb.master.wdata = 0;
        mb.master.read = 1;
        mb.master.write = 0;
        mb.master.dataena = 15;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);

        mb.master.addr = `UFM_OFFSET;
        mb.master.wdata = 0;
        mb.master.read = 1;
        mb.master.write = 0;
        mb.master.dataena = 15;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);

        mb.master.addr = `UFM_OFFSET+8;
        mb.master.wdata = 233;
        mb.master.read = 0;
        mb.master.write = 1;
        mb.master.dataena = 3;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);

        mb.master.addr = `PERIPH_BASE+0;
        mb.master.wdata = 233;
        mb.master.read = 0;
        mb.master.write = 1;
        mb.master.dataena = 3;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);

        mb.master.addr = `PERIPH_BASE+4;
        mb.master.wdata = 233;
        mb.master.read = 1;
        mb.master.write = 0;
        mb.master.dataena = 3;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);

        mb.master.addr = `PERIPH_BASE+8;
        mb.master.wdata = 233;
        mb.master.read = 1;
        mb.master.write = 0;
        mb.master.dataena = 3;
        mb.master.burstcount = 1;

        repeat(3) @(posedge clk);
        $stop;
    end


endmodule