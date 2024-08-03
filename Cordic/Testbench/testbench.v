`timescale 1 ns / 1 ps

module testbench;
	
	reg [15:0] angle;
	reg clk, en;
	wire signed [15:0] Y0, X0, theta;
	wire done;
	reg [15:0] a, b;
	wire [15:0] res;
	
	parameter [15:0] init_val = 16'd19895;
	event start;
	//cordic1 c(angle, sin, cos, theta);
	
	
	cordic_pipeline c(clk, en, angle, init_val, 16'd0, X0, Y0, theta, done);
	
	real res_sin, res_cos, res_angle;
	real real_a, real_b, real_res;
	integer i;
	parameter B = 32767;
	
	initial begin
		clk = 0;
		en = 0;
		angle = 0;
		a = 0;
		b = 0;
		i = 0;
		real_res = 0;
		forever begin
			#10 clk = ~clk;
		end
	end
	
	initial begin
		#30 ->start;
	end
	
	always @(start) begin
		@(negedge clk);
		en = 1;
		for(i = 0; i < 427670; i = i + 5) begin
			@(negedge clk);
			angle = i;
			res_angle = angle;
			res_angle = res_angle / 16'd32767 * 16'd360;
			
		end
		en = 0;
		wait(!done);
		repeat(100) @(posedge clk);
		$stop;
	end
	
	always @(negedge clk) begin
		if(done) begin
			res_sin = Y0;
			res_sin = res_sin / 16'd32767;
		
			res_cos = X0;
			res_cos = res_cos / 16'd32767;
		end
		
	end
	
	
	/*
	initial begin
	
		for(i = 0; i < 427670; i = i + 10) begin
			angle = i;
			#1;
			res_angle = angle;
			res_angle = res_angle / 16'd32767 * 16'd360;
		
			res_sin = sin;
			res_sin = res_sin / 16'd32767;
		
			res_cos = cos;
			res_cos = res_cos / 16'd32767;
		
		end
	
		angle = 16'd8000;		// 85 град
		
		#1;
		res_angle = angle;
		res_angle = res_angle / 16'd32767 * 16'd360;
		
		res_sin = sin;
		res_sin = res_sin / B;
		
		res_cos = cos;
		res_cos = res_cos / B;
		#100;
		
		
		
		angle = 16'd455;	// 5 град
		
		#1;
		res_angle = angle;
		res_angle = res_angle / 16'd32767 * 16'd360;
		
		res_sin = sin;
		res_sin = res_sin / B;
		
		res_cos = cos;
		res_cos = res_cos / B;
		#100;
		
		angle = 16'd22755;	// 250 град
		
		#1;
		res_angle = angle;
		res_angle = res_angle / 16'd32767 * 16'd360;
		
		res_sin = sin;
		res_sin = res_sin / B;
		
		res_cos = cos;
		res_cos = res_cos / B;
		#100;
		
		angle = 16'd29126;		// 320 град
		#1;
		res_angle = angle;
		res_angle = res_angle / 16'd32767 * 16'd360;
		
		res_sin = sin;
		res_sin = res_sin / B;
		
		res_cos = cos;
		res_cos = res_cos / B;
		#100;
		
		$stop;
	end
	*/
	
	
endmodule
