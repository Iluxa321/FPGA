`timescale 1 ns / 1 ps

module test_fft_pipeline2;
`include "../includes/fn.v"
	parameter IN_DATA_WIDTH = 10,
			  N = 1024,
			  OUT_DATA_WIDTH = 16;
	parameter ADDR_WIDTH = clog2(N);
	
	reg clk, reset, load, start;
	reg [IN_DATA_WIDTH-1:0] in_data;
	reg [ADDR_WIDTH-1:0] addr_wr, addr_rd;
	wire done;
	wire [OUT_DATA_WIDTH-1:0] o_real, o_img;
	integer i;
	reg [60:0] re, img, res;
	
	reg [IN_DATA_WIDTH-1:0] data [N*2-1:0];
	reg [ADDR_WIDTH:0] cnt;
	reg [ADDR_WIDTH-1:0] tmp_addr;
	
	integer cnt_iter; // счетчик итераций
	
	event reset_event, reset_done;
	event load_event, start_event;
	
	fft_pipeline #(.N(N), .IN_DATA_WIDTH(IN_DATA_WIDTH), .OUT_DATA_WIDTH(OUT_DATA_WIDTH)) dut(
		.clk(clk),
		.reset(reset),
		.load(load),
		.start(start),
		.in_data(in_data),
		.addr_wr(addr_wr), .addr_rd(addr_rd),
		.fft_done(done),
		.o_real(o_real),
		.o_img(o_img)
		);
		
	initial begin
		cnt = 0;
		$readmemh("data2.dat",data);
		clk = 0;
		reset = 0;
		start = 0;
		cnt_iter = 0;
		forever begin
			#5 clk = ~clk;
		end
	end
	
	initial begin
		#20->reset_event;
	end
	
	always @(reset_event) begin
		@(negedge clk);
		reset = 1;
		@(negedge clk)
		reset = 0;
		->load_event;
	end
		
	
	initial begin: LOAD
		forever begin
			@(load_event);
			load = 1;
			load_data();
			load = 0;
			-> start_event;
		end
	end
	
	initial begin: WORK
		forever begin
			@(start_event);
			@(negedge clk);
			start = 1;
			@(negedge clk);
			start = 0;
			wait(done);
			$display("---------- iteration: %d -------------", cnt_iter);
			read_data();
			cnt_iter = cnt_iter + 1;
			$display("--------------------------------------");
			if(cnt_iter == 2) $stop;
			->load_event;
		end
	end

task load_data();
	integer i,j;
	begin
		for(i = 0; i < N; i = i + 1) begin
			@(negedge clk);
			for(j = ADDR_WIDTH-1; j >= 0; j = j -1) begin	// битревесная адресация
				tmp_addr[ADDR_WIDTH-1-j] = cnt[j];
			end
			addr_wr = tmp_addr;
			in_data = data[cnt];
			@(posedge clk);
			cnt = cnt + 1;
		end
	end
endtask


task read_data();
	integer i;
	for(i = 0; i < N+1; i = i +1) begin
		@(negedge clk);
		addr_rd = i;
		@(posedge clk);
		//if(i == 0)	repeat(2) @(posedge clk);
		//else @(posedge clk);
		#1;
		if(i != 0) begin
			re = $signed(o_real);
			img = $signed(o_img);
			res = $sqrt(re**2 + img**2);
			$display("%d: %d", i, res);
		end
	end
endtask

	
endmodule



