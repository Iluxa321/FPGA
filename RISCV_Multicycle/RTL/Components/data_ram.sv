module data_ram (
    input logic clk, rst,
// From/to master
    input logic read, write,
    input logic [3:0] byteena,
    input logic [9:0] addr, 
    input logic [31:0] wdata,
    output logic valid,
    output logic [31:0] rdata
);

    logic we;
    logic [9:0] addr_ram;
    logic [3:0] byteena_ram;
    logic [31:0] rdata_ram, wdata_ram;

	ram r(
		.address(addr_ram),
	    .byteena(byteena_ram),
	    .clock(clk),
	    .data(wdata_ram),
	    .wren(we),
	    .q(rdata_ram)
    );    

    typedef enum logic [1:0] {IDLE, READ, WRITE} controller_state;  

    controller_state state, next;
    logic delay;
    always_ff @(posedge clk) begin
        if(~rst) state <= IDLE;
        else state <= next;
    end

//  Next state logic
    always_comb begin
        case (state)
            IDLE: 
                if(read) next = READ;
                else if(write) next = WRITE;
                else next = IDLE;
            READ:
                if(delay == 0) next = IDLE;
                else next = READ;
            WRITE:
                next = IDLE;
            default: next = IDLE; 
        endcase
    end

// Output logic

    always_ff @(posedge clk) begin
        if(~rst) begin
            valid <= 1'd0;
            rdata <= '0;
            we <= 1'd0;
        end
        case (state)
            IDLE: begin
                if(read) begin
                    addr_ram <= addr;
                    byteena_ram <= byteena;
                    delay <= 1'd1;
                end
                else if(write) begin
                    addr_ram <= addr;
                    wdata_ram <= wdata;
                    we <= 1'd1;
                    byteena_ram <= byteena;
                end
                valid <= 1'd0;
				end
            READ:
                if(delay > 1'd0) delay <= delay - 1'd1;
                else begin
                    valid <= 1'd1;
                    rdata <= (rdata_ram & {{8{byteena_ram[3]}}, {8{byteena_ram[2]}}, {8{byteena_ram[1]}}, {8{byteena_ram[0]}}});
                end
            WRITE: begin
                we <= 1'd0;
            end
            default: begin
                valid <= 1'd0;
                we <= 1'd0;
            end
        endcase
    end
    
endmodule


