`include "Inc/conf.svh"
`include "Inc/if.svh"
`include "Inc/data_type.svh"


// module bus (
// // From Master
//     input   port_transmit_type  from_master,
//     input   logic   [31:0]  m_addr,
//     input   logic   [31:0]  m_wdata,
//     input   logic           m_read, m_write,
//     input   logic   [3:0]   m_dataena,
//     input   logic   [3:0]   m_burstcount,

// // To Master
//     input   port_receive_type   to_master
//     output  logic   [31:0]  m_rdata,
//     output  logic           m_valid, m_waitrequest,

// // From Slave 1 (UFM)

//     input  logic   [31:0]  ufm_rdata,
//     input  logic           ufm_valid, ufm_waitrequest,

// // To Slave 1 (UFM)
//     output  logic   [$clog2(`UFM_SIZE)-1:0]  ufm_addr,
//     output  logic            ufm_chsel,

// // From Slave 2 (RAM)

//     input  logic   [31:0]  ram_rdata,
//     input  logic           ram_valid, ram_waitrequest,

// // To Slave 2 (RAM)
//     output  logic  [$clog2(`RAM_SIZE)-1:0]  ram_addr,
//     output  logic           ram_chsel,

// // To Slave
//     output  logic    [31:0]  wdata,
//     output  logic            read, write,
//     output  logic    [3:0]   dataena,
//     output  logic    [3:0]   burstcount
// );
    
//     logic [31:0] o_addr;
//     logic data_sel;
//     addr_decoder addr_decoder (
//         .in_addr(m_addr),
//         .ufm_addr(ufm_addr),
//         .ram_addr(ram_addr),
//         .ufm_chsel(ufm_chsel),
//         .ram_chsel(ram_chsel), 
//         .mux_slave(data_sel) 
//     );



//     logic [31:0] tmp_data;
//     data_mux data_mux (
//         .data_sel(data_sel), 
//     // Slave 1 (UFM
//         .ufm_data(ufm_rdata), 
//         .ufm_valid(ufm_valid),
//         .ufm_waitrequest(ufm_waitrequest),
//     // Slave 2 (RAM
//         .ram_data(ram_rdata), 
//         .ram_valid(ram_valid),
//         .ram_waitrequest(ram_waitrequest),
//     // OUTPUT
//         .data(tmp_data),
//         .valid(m_valid), 
//         .waitrequest(m_waitrequest)
//     );

//     assign m_rdata = tmp_data >> m_addr[1:0];

//     assign wdata = m_wdata << m_addr[1:0];
//     assign read = m_read;
//     assign write = m_write;
//     assign dataena = m_dataena;
//     assign burstcount = m_burstcount;

// endmodule


typedef enum logic [1:0] { UFM, RAM, SEG, NONE } slave_code;

module bus (
    
// From/To Master
    port.slave  master_bus,

// From Slave 1 (UFM)
    input   port_receive_type from_ufm,
    
// From Slave 2 (RAM)
    input   port_receive_type from_ram,

// From Slave 3 (SEG)
    input   port_receive_type from_seg,

// To Slaves
    output  port_transmite_type  to_slaves,
    output  logic           ufm_chsel,
    output  logic           ram_chsel,
    output  logic           seg_chsel
);
    slave_code data_sel;
    addr_decoder addr_decoder (
        .in_addr(master_bus.addr),
        .ufm_chsel(ufm_chsel),
        .ram_chsel(ram_chsel), 
        .seg_chsel(seg_chsel),
        .mux_slave(data_sel) 
    );



    logic [31:0] tmp_data;
    data_mux data_mux (
        .data_sel(data_sel), 
    // Slave 1 (UFM)
        .from_ufm(from_ufm),
    // Slave 2 (RAM)
        .from_ram(from_ram),
	 // Slave 2 (RAM)
		  .from_seg(from_seg),
    // OUTPUT
        .data(tmp_data),
        .valid(master_bus.valid), 
        .waitrequest(master_bus.waitrequest)
    );

    assign master_bus.rdata = tmp_data >> (master_bus.addr[1:0] * 8);

    assign to_slaves.addr = master_bus.addr;
    assign to_slaves.wdata = master_bus.wdata << (master_bus.addr[1:0] * 8);
    assign to_slaves.read = master_bus.read;
    assign to_slaves.write = master_bus.write;
    assign to_slaves.dataena = master_bus.dataena;
    assign to_slaves.burstcount = master_bus.burstcount;

endmodule

module addr_decoder (
    input   logic   [31:0]  in_addr,
    output  logic           ufm_chsel,
    output  logic           ram_chsel,
    output  logic           seg_chsel, 
    output  slave_code      mux_slave
);




    logic is_ram, is_periph;
    assign is_periph = in_addr >= `PERIPH_BASE;
    assign is_ram = in_addr >= `RAM_OFFSET;
    always_comb begin
        if(is_periph) begin
            if(in_addr <= `SEG) begin
                ram_chsel = 0;
                ufm_chsel = 0;
                seg_chsel = 1;
                mux_slave = SEG;
            end
				else begin
					ram_chsel = 0;
               ufm_chsel = 0;
               seg_chsel = 0;
               mux_slave = NONE;
				end
        end
        else if(is_ram) begin
            ram_chsel = 1;
            ufm_chsel = 0;
            seg_chsel = 0;
            mux_slave = RAM;
        end
        else begin
            ram_chsel = 0;
            ufm_chsel = 1;
            seg_chsel = 0;
            mux_slave = UFM;
        end
    end
    
endmodule

module data_mux (
    input   slave_code        data_sel, 
// Slave 1 (UFM)
    input   port_receive_type from_ufm,

// Slave 2 (RAM)
    input   port_receive_type from_ram,

// Slave 3 (SEG)
    input   port_receive_type from_seg,

// OUTPUT
    output  logic   [31:0]  data,
    output  logic           valid, waitrequest

);

    always_comb begin
        case (data_sel)
            UFM: begin
                data = from_ufm.rdata;
                valid = from_ufm.valid;
                waitrequest = from_ufm.waitrequest;
            end
            RAM: begin
                data = from_ram.rdata;
                valid = from_ram.valid;
                waitrequest = from_ram.waitrequest;
            end
            SEG: begin
                data = from_seg.rdata;
                valid = from_seg.valid;
                waitrequest = from_seg.waitrequest;
            end 
            default: begin
					data = '0;
               valid = 1'd0;
               waitrequest = 1'd0;
				end
        endcase
    end
    
endmodule
