`timescale 1 ns / 1 ps

module testbench_cordic_hyperbolic_mode;
	reg clk, en;
	wire signed [15:0] Y0, X0, theta;
	wire done;
	reg [15:0] angle, X, Y;
	event start;
	real rA, rB;
	cordic_hyperbolic_mode c1(clk, en ,angle, X, Y, X0, Y0, theta, done);

	initial begin
		clk = 0;
		en = 0;
		angle = 0;
		X = 0;
		Y = 0;
		rA = 0;
		rB = 0;
		forever	begin
			#10 clk = ~clk;
 		end
	end

	initial begin
		#30 -> start;
	end

	always @(start) begin
		@(negedge clk);
		en = 1;
		rA = ((0.9 + 0.25) / 4) * 16'd32767 * 1.205;
		rB = ((0.9 - 0.25) / 4) * 16'd32767 * 1.205;
		X = rA;
		Y = rB;
		wait (!done);
		repeat(10) @(posedge clk);
		$stop;
	end


endmodule
