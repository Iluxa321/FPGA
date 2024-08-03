
`ifndef PORT
`define PORT

interface port;
    logic   [31:0]  addr;
    logic   [31:0]  wdata;
    logic           read; 
    logic           write;
    logic   [3:0]   dataena;
    logic   [1:0]   burstcount;

    logic   [31:0]  rdata;
    logic           valid;
    logic           waitrequest;

    modport master (
        output addr,
        output wdata,
        output read, 
        output write,
        output dataena,
        output burstcount,

        input rdata,
        input valid,
        input waitrequest
    );

    modport slave (
        input addr,
        input wdata,
        input read, 
        input write,
        input dataena,
        input burstcount,

        output rdata,
        output valid,
        output waitrequest
    );
endinterface 


`endif