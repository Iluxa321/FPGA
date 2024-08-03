`ifndef DATATYPE
`define DATATYPE

typedef struct packed {
    logic   [31:0]  addr;
    logic   [31:0]  wdata;
    logic           read; 
    logic           write;
    logic   [3:0]   dataena;
    logic   [1:0]   burstcount;
} port_transmite_type;

typedef struct packed {
    logic   [31:0]  rdata;
    logic           valid;
    logic           waitrequest;
} port_receive_type;

`endif