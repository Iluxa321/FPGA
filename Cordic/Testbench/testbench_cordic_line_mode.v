`timescale 1 ns / 1 ps

module testbench_cordic_line_mode;

	reg [15:0] a,b,c;
	reg clk, en;
	wire [15:0] res, error;
	wire done;

	real A,B,C,RES;

	event start_div, start_mult;

	cordic_line_mode c1(clk, en, a, b, c, res, error, done);

	initial begin
		clk = 0;
		en = 0;
		a = 0;
		b = 0;
		c = 0;
		A = 0;
		B = 0;
		C = 0; 
		RES = 0;

		forever begin
			#10 clk = ~clk;
		end

	end

	initial begin
		#30 ->start_div;
	end

	always @(start_mult) begin
		@(negedge clk);
		en = 1;
		A = 0.8;
		C = 0.6;
		a = A * 16'd32767;
		c = C * 16'd32767;
		@(negedge clk);
		A = 0.8;
		C = 0.1;
		a = A * 16'd32767;
		c = C * 16'd32767;
		@(negedge clk);
		A = 0.44;
		C = 0.32;
		a = A * 16'd32767;
		c = C * 16'd32767;
		@(negedge clk);
		A = 0.2;
		C = 0.6;
		a = A * 16'd32767;
		c = C * 16'd32767;
		@(negedge clk);
		en = 0;
		wait(!done);
		repeat(10) @(posedge clk);

		$stop;
	
	end

	always @(start_div) begin
		@(negedge clk);
		en = 1;
		B = 0.6;
		A = 0.8;
		a = A * 16'd32767;
		b = B * 16'd32767;
		@(negedge clk);
		B = 0.25;
		A = 0.5;
		a = A * 16'd32767;
		b = B * 16'd32767;
		@(negedge clk);
		B = 0.6;
		A = 0.7;
		a = A * 16'd32767;
		b = B * 16'd32767;
		@(negedge clk);
		B = 0.2;
		A = 0.6;
		a = A * 16'd32767;
		b = B * 16'd32767;
		@(negedge clk);
		en = 0;
		wait(!done);
		repeat(10) @(posedge clk);

		$stop;
	end

	always @(posedge clk) begin
		if(done) begin
			RES = $itor($signed(error));
			RES = RES / 32767;
		end
	end


endmodule

