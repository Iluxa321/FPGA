`timescale 1ns / 1ns
module testbench();
	reg clk;
	reg [7:0] step;
	wire rw;
	wire [7:0] data;
	dds_generator dut(
				.clk(clk),
				.step(step),
				.rw(rw),
				.dac_code(data)
				);
	initial begin
		clk = 0;
		step = 1;
		#20;
		forever begin
			#10; clk = ~clk;
		end
	end


endmodule