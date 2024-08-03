`timescale 1 ns / 1 ps

module test_controller_and_agu;
	
	reg clk, reset, start;
	wire conv_end, inc_addr, WRmem, rst_addr, work, rst_swap, en_swap;
	wire [4:0] addr_A, addr_B;
	wire [3:0] addr_Tw;
	
	reg [4:0] del_addr_A[2:0];
	reg [4:0] del_addr_B[2:0];	 
	
	integer i;
	
	controller dut(
					.clk(clk),
					.reset(reset),
					.start(start),
					.done(conv_end),
					.work(work),
					.rst_addr(rst_addr),
					.inc_addr(inc_addr),
					.WRmem(WRmem),
					.rst_swap(rst_swap),	
					.en_swap(en_swap)	
					);
	agu agu
			(
			.clk(clk),
			.rst(rst_addr),
			.en(inc_addr),
			.addr_A(addr_A),
			.addr_B(addr_B),
			.addr_Tw(addr_Tw),
			.conv_end(conv_end)
			);

	initial begin
		clk = 0;
		start = 0;
		reset = 1;
		#5;
		clk = 1;
		#5;
		clk = 0;
		reset = 0;
		start = 1;
		forever begin
			#5; clk = ~clk;
		end
	end
	
	always @(negedge clk) begin
		if(conv_end) begin
			#5;
			$stop;
		end
	end
	
	always @(posedge clk) begin
		del_addr_A[0] <= addr_A;
		del_addr_B[0] <= addr_B;
		for(i = 1; i < 3; i = i + 1) begin
			del_addr_A[i] <= del_addr_A[i-1];
			del_addr_B[i] <= del_addr_B[i-1];
		end
	
	
	end
	
endmodule

