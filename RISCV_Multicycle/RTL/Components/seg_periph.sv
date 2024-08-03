`include "Inc/conf.svh"
`include "Inc/if.svh"
`include "Inc/data_type.svh"

module seg_periph (
    input   logic           clk,
    input   logic           rst,

// From Master
    input   logic           read,
    input   logic           write,
    // input   logic [3:0]     byteena,
    input   logic           addr, 
    input   logic [31:0]    wdata,

// To Master
    output  logic           valid,
    output  logic [31:0]    rdata,


// To 7seg

    output  logic [7:0]    hex0,
    output  logic [7:0]    hex1,
    output  logic [7:0]    hex2,
    output  logic [7:0]    hex3,
    output  logic [7:0]    hex4,
    output  logic [7:0]    hex5

);

    logic [31:0] hex_data, hex_controll;
    always_ff @(posedge clk) begin
        if(~rst) begin
            hex_data <= '0;
            hex_controll <= '0;
            rdata <= '0;
            valid <= 1'd0;
        end
        else if(read) begin
            if(addr) rdata <= hex_data;
            else rdata <= hex_controll;
            valid <= 1'd1;
        end
        else if(write) begin
            if(addr) hex_data <= wdata;
            else hex_controll <= wdata;
            
        end
        else begin
            valid <= 1'd0; 
        end
    end

    logic [31:0] data;

    assign data = hex_controll[0] ? hex_data : '0;

    SEG7_LUT seg0(.iDIG(data[3:0]), .oSEG(hex0));
    SEG7_LUT seg1(.iDIG(data[7:4]), .oSEG(hex1));
    SEG7_LUT seg2(.iDIG(data[11:8]), .oSEG(hex2));
    SEG7_LUT seg3(.iDIG(data[15:12]), .oSEG(hex3));
    SEG7_LUT seg4(.iDIG(data[19:16]), .oSEG(hex4));
    SEG7_LUT seg5(.iDIG(data[23:20]), .oSEG(hex5));
    
endmodule



module SEG7_LUT	(
    input   logic [3:0] iDIG,
    output  logic [6:0] oSEG
);

    always_comb
    begin
            case(iDIG)
            4'h1: oSEG = 7'b1111001;	// ---t----
            4'h2: oSEG = 7'b0100100; 	// |	  |
            4'h3: oSEG = 7'b0110000; 	// lt	 rt
            4'h4: oSEG = 7'b0011001; 	// |	  |
            4'h5: oSEG = 7'b0010010; 	// ---m----
            4'h6: oSEG = 7'b0000010; 	// |	  |
            4'h7: oSEG = 7'b1111000; 	// lb	 rb
            4'h8: oSEG = 7'b0000000; 	// |	  |
            4'h9: oSEG = 7'b0011000; 	// ---b----
            4'ha: oSEG = 7'b0001000;
            4'hb: oSEG = 7'b0000011;
            4'hc: oSEG = 7'b1000110;
            4'hd: oSEG = 7'b0100001;
            4'he: oSEG = 7'b0000110;
            4'hf: oSEG = 7'b0001110;
            4'h0: oSEG = 7'b1000000;
            endcase
    end

endmodule