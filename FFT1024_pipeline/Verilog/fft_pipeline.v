module fft_pipeline
#(parameter
N = 1024, 									// длинна БПФ
IN_DATA_WIDTH = 10,
OUT_DATA_WIDTH = 21,						// длинна выходных данных расчитывается как (IN_DATA_WIDTH + clog2(N) + 1)
ADDR_WIDTH = clog2(N)

)
(
input clk,
input reset,
input load,
input start,
input [IN_DATA_WIDTH-1:0] in_data,
input [ADDR_WIDTH-1:0] addr_wr, addr_rd,
output  fft_done,
output [OUT_DATA_WIDTH-1:0] o_real, o_img
);

`include "../includes/fn.v"
	
	
	
	localparam L_casc = N/2;								// длинна одного каскада (256/2) = 128
	localparam TW_ADDR_WIDTH = clog2(L_casc);			// длинна шины адресса для поворачивающих коэффициентов (cos/sin)
	localparam N_CASC = clog2(N);							// колличество каскадов
	localparam SIG = 1;
	localparam DATA_WIDTH_RAM = (IN_DATA_WIDTH + N_CASC + SIG) * 2; 	// (8+8+1)*2 = 34
	localparam HALF_DATA_WIDTH_RAM = DATA_WIDTH_RAM/2;
	localparam Lbit_for_casc = clog2(L_casc);	// число битов необходимых для хранения длины одного каскада
	
	
	wire [DATA_WIDTH_RAM-1:0] o_data;
	wire [HALF_DATA_WIDTH_RAM-1:0] o_data_r, o_data_i;
	wire done, WRmem, work, inc_addr, rst_addr, rst_swap, en_swap;
	wire [ADDR_WIDTH-1:0] addr_A, addr_B;
	wire [TW_ADDR_WIDTH-1:0] addr_Tw;
	reg reg_swap;
	
	
	
	agu #(.ADDR_WIDTH(ADDR_WIDTH), .TW_ADDR_WIDTH(TW_ADDR_WIDTH)) agu(
		.clk(clk),
		.rst(rst_addr),
		.en(inc_addr),
		.addr_A(addr_A),
		.addr_B(addr_B),
		.addr_Tw(addr_Tw),
		.conv_end(done)
		);
	
	
	
	controller #(.Lbit_for_casc(Lbit_for_casc)) controller(
		.clk(clk),
		.reset(reset),
		.start(start),
		.done(done),
		.work(work),
		.rst_addr(rst_addr),
		.inc_addr(inc_addr),
		.WRmem(WRmem),
		.rst_swap(rst_swap),	
		.en_swap(en_swap)	
		);
	


	
	
	

	
	data_path #(.ADDR_WIDTH(ADDR_WIDTH), .TW_ADDR_WIDTH(TW_ADDR_WIDTH), .IN_DATA_WIDTH(IN_DATA_WIDTH), .OUT_DATA_WIDTH(DATA_WIDTH_RAM)) dp(
		.clk(clk),
		.load(load),
		.FFT_work(work),
		.swap(reg_swap),
		.WRmem(WRmem),
		.addr_wr(addr_wr), .addr_rd(addr_rd),	// внешние адреса для запись и считывания
		.addr_A(addr_A), .addr_B(addr_B), 		// адресса для преобразования
		.addr_Tw(addr_Tw),
		.in_data(in_data), 							// данные для загрузки
		.o_data(o_data) 								// данные для чтения
);	
	
	//always @(posedge clk) begin
	//	if(done) fft_done <= 1'd1;
	//	else if(work) fft_done <= 1'd0;
	//end
	
	
	
	assign {o_data_r, o_data_i} = o_data;
	assign o_real = o_data_r[HALF_DATA_WIDTH_RAM-1:HALF_DATA_WIDTH_RAM-OUT_DATA_WIDTH];
	assign o_img = o_data_i[HALF_DATA_WIDTH_RAM-1:HALF_DATA_WIDTH_RAM-OUT_DATA_WIDTH];
	assign fft_done = ~work;
	
	always @(posedge clk) begin
		if(rst_swap) reg_swap <= 0;
		else if(en_swap) reg_swap <= ~reg_swap;
	end
	



	
endmodule


	
module agu									// address generator unit
#(parameter									// количество каскадов (8 = 3бит)
ADDR_WIDTH = 8,							// длина шины адресса
TW_ADDR_WIDTH = 7							// длина шины адресса для поворачивающих коэффициентов (cos/sin)
//Lbit_for_casc = clog2(L),			// количества бит для хранениня длины каскада (128 = 7бит)
//Nbit_for_casc = clog2(N)		
)
(
input clk,
input rst,
input en,
output [ADDR_WIDTH-1:0] addr_A,
output [ADDR_WIDTH-1:0] addr_B,
output [TW_ADDR_WIDTH-1:0] addr_Tw,
output conv_end	// конец преобразования
);

`include "../includes/fn.v"

	localparam Nbit_for_casc = clog2(ADDR_WIDTH);					// количества бит для хранениня количества каскадов
	localparam n_cascad = ADDR_WIDTH;									// число каскадов совпадает с шириной адрессной шины
	localparam LN = ADDR_WIDTH - 1 + Nbit_for_casc;

	reg [LN-1:0] cnt;
	wire [Nbit_for_casc-1:0] i;
	wire [ADDR_WIDTH-1:0] j, j1;
	wire [Nbit_for_casc-1:0] sub;
	
	always @(posedge clk) begin
		if(rst)
			cnt <= 7'd0;
		else if(en)
			cnt <= cnt + 7'd1;
	end
	
	assign i = cnt[LN-1:ADDR_WIDTH-1];				// число каскадов
	assign j = {cnt[ADDR_WIDTH-2:0], 1'd0};	// j*2 (число бабочек в одном каскаде)
	assign j1 = j + 1'd1;
	
	rotate #(.L(ADDR_WIDTH), .N(Nbit_for_casc)) rot1(.j(j), .i(i), .shf_j(addr_A));
	rotate #(.L(ADDR_WIDTH), .N(Nbit_for_casc)) rot2(.j(j1), .i(i), .shf_j(addr_B));
	
	assign sub = (n_cascad-1) - i;
	assign conv_end = &sub;	// если произошло переполенния, то преобразование закончилось
	
	localparam L_mask = (TW_ADDR_WIDTH)*2;	// длинна маски (7)*2 = 14бит
	localparam L_mask_half = L_mask/2;
	
	wire [L_mask-1:0] mask;	
	assign mask = {{L_mask_half{1'd0}}, {L_mask_half{1'd1}}}  << sub;
	assign addr_Tw = mask[L_mask_half-1:0] & j[TW_ADDR_WIDTH:1];



	
endmodule


module rotate	// циклический сдвиг на i битов
#(parameter
L = 8,
N = 3
)
(
input [L-1:0] j,
input [N-1:0] i,
output [L-1:0] shf_j
);
	
`include "../includes/fn.v"
	
	wire [L*2-1:0] tmp = {{L{1'd0}},j} << i;
	assign shf_j = tmp[L-1:0] | tmp[L*2-1:L];
	
endmodule


module mem_bank
#(parameter
DATA_WIDTH = 32,
ADDR_WIDTH = 8
)
(
input clk,
input load,
input FFT_work,
input swap,
input WRmem,	// разрешение на запись
input [ADDR_WIDTH-1:0] addr_wr, addr_rd,	// внешние адреса для запись и считывания
input [ADDR_WIDTH-1:0] addr_A, del_addr_A,	// адресс А для работы fft + задержаный адресс А
input [ADDR_WIDTH-1:0] addr_B, del_addr_B,	// адресс В для работы fft + задержаный адресс В
input [DATA_WIDTH-1:0] in_data,	// данные для записи
input [DATA_WIDTH-1:0] data_A, data_B,	// данные загружаемые в память при работе fft
output [DATA_WIDTH-1:0] A, B	// данные с выхода памяти
);
	reg [ADDR_WIDTH-1:0] _addr_A;
	wire [ADDR_WIDTH-1:0] _addr_B;
	wire [DATA_WIDTH-1:0] mux_A;
	wire WRmem_A, WRmem_B;
	
	always @(*) begin
		case({FFT_work, swap})
			2'b00: _addr_A = addr_wr;
			2'b01: _addr_A = addr_rd;
			2'b10: _addr_A = addr_A;
			2'b11: _addr_A = del_addr_A;
		endcase
	end
	
	assign _addr_B = swap ? del_addr_B : addr_B;
	assign mux_A = ~FFT_work ? in_data : data_A;
 	assign WRmem_A = ~FFT_work ? load & ~swap : WRmem & swap;
	assign WRmem_B = WRmem & swap;
	
	dual_port_ram_single_clock #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) ram(
		.addr_a(_addr_A),
		.addr_b(_addr_B),
		.clk(clk),
		.data_a(mux_A),
		.data_b(data_B),
		.we_a(WRmem_A),
		.we_b(WRmem_B),
		.q_a(A),
		.q_b(B)
		);
	
	/*
	ram ram(
		.address_a(_addr_A),
		.address_b(_addr_B),
		.clock(clk),
		.data_a(mux_A),
		.data_b(data_B),
		.wren_a(WRmem_A),
		.wren_b(WRmem_B),
		.q_a(A),
		.q_b(B)
		);
	*/

endmodule


module dual_port_ram_single_clock
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=6)
(
	input [(DATA_WIDTH-1):0] data_a, data_b,
	input [(ADDR_WIDTH-1):0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [(DATA_WIDTH-1):0] q_a, q_b
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];
	
	// Переменные для сохронения входных данных
	reg [(DATA_WIDTH-1):0] reg_data_a, reg_data_b;
	reg [(ADDR_WIDTH-1):0] reg_addr_a, reg_addr_b;
	reg reg_we_a, reg_we_b;
	
	always @(posedge clk) begin
		reg_data_a <= data_a;
		reg_data_b <= data_b;
		reg_addr_a <= addr_a;
		reg_addr_b <= addr_b;
		reg_we_a <= we_a;
		reg_we_b <= we_b;
	
	end
	
	// Port A 
	always @ (posedge clk)
	begin
		if (reg_we_a) 
		begin
			ram[reg_addr_a] <= reg_data_a;
			q_a <= reg_data_a;
		end
		else 
		begin
			q_a <= ram[reg_addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (reg_we_b) 
		begin
			ram[reg_addr_b] <= reg_data_b;
			q_b <= reg_data_b;
		end
		else 
		begin
			q_b <= ram[reg_addr_b];
		end 
	end

endmodule


module data_path
#(parameter
ADDR_WIDTH = 8,		// длинна адресной шины
TW_ADDR_WIDTH = 7,	// длинна адресной шины для (cos/sin)
IN_DATA_WIDTH = 8,	// длинна входных данных
OUT_DATA_WIDTH = 34
)
(
input clk,
input load,
input FFT_work,
input swap,
input WRmem,
input [ADDR_WIDTH-1:0] addr_wr, addr_rd,	// внешние адреса для запись и считывания
input [ADDR_WIDTH-1:0] addr_A, addr_B, 	// адресса для преобразования
input [TW_ADDR_WIDTH-1:0] addr_Tw,
input [(IN_DATA_WIDTH)-1:0] in_data, 		// данные для загрузки (только real)
output [OUT_DATA_WIDTH-1:0] o_data 			// данные для чтения
);

	
	
	
	wire [OUT_DATA_WIDTH-1:0] A, B; 
	wire [31:0] Tw_factor;
	wire [OUT_DATA_WIDTH-1:0] X, Y;	// выходные данные с бабочки
	
	reg [ADDR_WIDTH-1:0] del_addr_A[2:0];
	reg [ADDR_WIDTH-1:0] del_addr_B[2:0];
	
	wire [OUT_DATA_WIDTH-1:0] b0_A, b0_B, b1_A, b1_B;
	
	integer i;
	always @(posedge clk) begin
		del_addr_A[0] <= addr_A;
		del_addr_B[0] <= addr_B;
		for(i = 1; i < 3; i = i + 1) begin
			del_addr_A[i] <= del_addr_A[i-1];
			del_addr_B[i] <= del_addr_B[i-1];
		end
	end
	
	localparam HALF_DATA_WIDTH = OUT_DATA_WIDTH/2; 	//  34/2=17
	localparam ZERO_DATA_WIDTH = HALF_DATA_WIDTH - IN_DATA_WIDTH;
	
	mem_bank #(.DATA_WIDTH(OUT_DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) mem_bank0(
		.clk(clk),
		.load(load),
		.FFT_work(FFT_work),
		.swap(swap),
		.WRmem(WRmem),	// разрешение на запись
		.addr_wr(addr_wr), .addr_rd(addr_rd),	// внешние адреса для запись и считывания
		.addr_A(addr_A), .del_addr_A(del_addr_A[2]),	// адресс А для работы fft + задержаный адресс А
		.addr_B(addr_B), .del_addr_B(del_addr_B[2]),	// адресс В для работы fft + задержаный адресс В
		.in_data({{ZERO_DATA_WIDTH{1'd0}} ,in_data, {HALF_DATA_WIDTH{1'd0}}}),	// данные для записи
		.data_A(X), .data_B(Y),	// данные загружаемые в память при работе fft
		.A(b0_A), .B(b0_B)	// данные с выхода памяти
		);
		
	mem_bank #(.DATA_WIDTH(OUT_DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) mem_bank1(
		.clk(clk),
		.load(load),
		.FFT_work(FFT_work),
		.swap(~swap),
		.WRmem(WRmem),	// разрешение на запись
		.addr_wr(addr_wr), .addr_rd(addr_rd),	// внешние адреса для запись и считывания
		.addr_A(addr_A), .del_addr_A(del_addr_A[2]),	// адресс А для работы fft + задержаный адресс А
		.addr_B(addr_B), .del_addr_B(del_addr_B[2]),	// адресс В для работы fft + задержаный адресс В
		.in_data({{ZERO_DATA_WIDTH{1'd0}} ,in_data, {HALF_DATA_WIDTH{1'd0}}}),	// данные для записи
		.data_A(X), .data_B(Y),	// данные загружаемые в память при работе fft
		.A(b1_A), .B(b1_B)	// данные с выхода памяти
		);
	
	/*
	rom rom(
		.address(addr_Tw),
		.clock(clk),
		.q(Tw_factor)
		);
	*/

	my_rom #(.DATA_WIDTH(32), .ADDR_WIDTH(TW_ADDR_WIDTH)) rom(
		.addr(addr_Tw),
		.clk(clk),
		.q(Tw_factor)
		);

	assign A = swap ? b1_A : b0_A;
	assign B = swap ?	b1_B : b0_B;
	 
	butterfly #(.DATA_WIDTH(OUT_DATA_WIDTH/2), .TW_DATA_WIDTH(32)) butterfly(
		.clk(clk),
		.A_re(A[OUT_DATA_WIDTH-1:OUT_DATA_WIDTH/2]),
		.A_img(A[OUT_DATA_WIDTH/2-1:0]),
		.B_re(B[OUT_DATA_WIDTH-1:OUT_DATA_WIDTH/2]),
		.B_img(B[OUT_DATA_WIDTH/2-1:0]),
		.W_re(Tw_factor[31:16]),
		.W_img(Tw_factor[15:0]),
		.X_re(X[OUT_DATA_WIDTH-1:OUT_DATA_WIDTH/2]),
		.X_img(X[OUT_DATA_WIDTH/2-1:0]),
		.Y_re(Y[OUT_DATA_WIDTH-1:OUT_DATA_WIDTH/2]),
		.Y_img(Y[OUT_DATA_WIDTH/2-1:0])
		);
	
	assign o_data = swap ? b0_A : b1_A;
	
endmodule

module my_rom
#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [(ADDR_WIDTH-1):0] addr,
	input clk, 
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the ROM variable
	reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];
	reg [(ADDR_WIDTH-1):0] reg_addr;

	// Initialize the ROM with $readmemb.  Put the memory contents
	// in the file single_port_rom_init.txt.  Without this file,
	// this design will not compile.

	// See Verilog LRM 1364-2001 Section 17.2.8 for details on the
	// format of this file, or see the "Using $readmemb and $readmemh"
	// template later in this section.

	initial
	begin
		// Для моделирования
		//$readmemh("twiddle_factor1024.txt", rom);
		// Для загрузки в ПЛИС
		$readmemh("Twiddle_factor_data/twiddle_factor1024.txt", rom);
	end

	always @ (posedge clk)
	begin
		reg_addr <= addr;
		q <= rom[reg_addr];
	end

endmodule


module butterfly
#(parameter
DATA_WIDTH = 17,
TW_DATA_WIDTH = 32
)
(
input clk,
input signed [DATA_WIDTH-1:0] A_re,
input signed [DATA_WIDTH-1:0] A_img,
input signed [DATA_WIDTH-1:0] B_re,
input signed [DATA_WIDTH-1:0] B_img,
input signed [TW_DATA_WIDTH/2-1:0] W_re,
input signed [TW_DATA_WIDTH/2-1:0] W_img,

output signed [DATA_WIDTH-1:0] X_re,
output signed [DATA_WIDTH-1:0] X_img,
output signed [DATA_WIDTH-1:0] Y_re,
output signed [DATA_WIDTH-1:0] Y_img
);

	reg [DATA_WIDTH-1:0] qA_re, qA_img, qB_re, qB_img;
	wire [TW_DATA_WIDTH/2+DATA_WIDTH-1:0] b_re, b_img, tmp_b_re, tmp_b_img; 
	assign b_re = (B_re * W_re) + (B_img * W_img);
	assign b_img = (B_img * W_re) - (B_re * W_img);
	assign tmp_b_re = b_re >> (TW_DATA_WIDTH/2-1);
	assign tmp_b_img = b_img >> (TW_DATA_WIDTH/2-1);
	always @(posedge clk) begin
		qA_re <= A_re;
		qA_img <= A_img;
		qB_re <= tmp_b_re[DATA_WIDTH-1:0];			//qB_re <= b_re[30:15];
		qB_img <= tmp_b_img[DATA_WIDTH-1:0];		//qB_img <= b_img[30:15];
	end
	
	assign X_re = qA_re + qB_re;
	assign X_img = qA_img + qB_img;
	assign Y_re = qA_re - qB_re;
	assign Y_img = qA_img - qB_img;

endmodule

module controller
#(parameter
Lbit_for_casc = 7
)
(
input clk, 
input reset,
input start,		// сигнал старта
input done,			// сигнала завершения преобразования


output work,		// отражает работу преобразования
output rst_addr,	// сброс agu
output inc_addr,	// увеличение agu
output WRmem,		// разрешение записи в RAM
output rst_swap,	
output en_swap		// переключение между банками памяти
);
	wire en_cnt, rst_cnt;
	reg [7:0] control;
	reg [Lbit_for_casc-1:0] cnt;	// служит для формирования задержки (зависит от длинный каскада)
	
	initial begin
		cnt <= 2'd0;
	end
	
	assign {work, rst_addr, inc_addr, WRmem, rst_cnt, en_cnt, rst_swap, en_swap} = control;
	
	reg [2:0] state, next;
	localparam [2:0] RESET = 3'd0,
						 IDLE = 3'd1,
						 CASCAD = 3'd2,
						 WAIT = 3'd3,
						 SWAP = 3'd4,
						 DONE = 3'd5;
	
	localparam last_addr = 2**Lbit_for_casc-1;	// последний адресс счетчика (число каскадов)
	localparam cnt_wait = 1; 	// величина задержки 
	
	always @(posedge clk) begin
		if(reset) state <= RESET;
		else state <= next;
	end
	
	always @(posedge clk) begin
		if(rst_cnt) cnt <= 4'd0;
		else if(en_cnt) cnt <= cnt + 4'd1;
	end

	always @(state or start or done or cnt) begin
		case(state)
			RESET: begin
				control = 8'b1100_1010;
				next = IDLE;
			end
			IDLE: begin
				control = 8'b0000_0000;
				if(start) next = CASCAD;
				else next = IDLE;
			end
			CASCAD: begin
				control = 8'b1011_0100;
				if(cnt == last_addr) next = WAIT;
				else next = CASCAD;
			end
			WAIT: begin
				control = 8'b1001_0100;
				if((cnt == cnt_wait) & done) next = DONE;
				else if((cnt == cnt_wait) & ~done) next = SWAP;
				else next = WAIT;
			end
			SWAP: begin
				control = 8'b1001_1001;
				next = CASCAD;
			end
			DONE: begin
				control = 8'b1101_1000;
				next = IDLE;
			end
			default: next = RESET;
		endcase
	
	end


endmodule
