`timescale 1 ns / 1 ps

module test_fft_pipeline;

	reg clk, reset, load, start;
	reg [31:0] in_data;
	reg [4:0] addr_wr, addr_rd;
	wire done;
	wire [31:0] o;
	integer i, re, img, res;
	
	reg [5:0] cnt;
	reg [31:0] data [31:0];
	reg flag;
	
	fft_pipeline dut(
		.clk(clk),
		.reset(reset),
		.load(load),
		.start(start),
		.in_data(in_data),
		.addr_wr(addr_wr), .addr_rd(addr_rd),
		.fft_done(done),
		.o_data(o)
		);
	
	initial begin
		$readmemh("data2.dat",data);
		flag = 0;
		clk = 0;
		load = 0;
		start = 0;
		reset = 0;
		in_data = 0;
		forever begin
			#5 clk = ~clk;
		end
	end
	
	initial begin
		reset = 1;
		#20;
		reset = 0;
		//#10;
		//start = 1;
	end
	
	// Загрузка данных в RAM
	always @(negedge clk) begin
		
		if(cnt != 32) begin
			load = 1;
			addr_wr = {cnt[0], cnt[1], cnt[2], cnt[3], cnt[4]};
			in_data = data[cnt[4:0]];			
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin 
			cnt = 0;
			load = 0;
		end
		else if(cnt != 32) begin 
			cnt = cnt + 1;
			if(cnt == 32) begin 
				load = 0;
				start = 1;
				flag = 1;
			end
		end
	end

	
	//---------------------------------
	
	always @(posedge clk) begin
		if(start == 1) #15 start = 0;
		if(done & flag) begin			
			for(i = 0; i < 32; i = i +1) begin
				addr_rd = i;
				#30;
				re = $signed(o[31:16]);
				img = $signed(o[15:0]);
				res = $sqrt(re**2 + img**2);
				$display("%d: %d", i, res);
			end
			$stop;
		end
	end
	



endmodule


