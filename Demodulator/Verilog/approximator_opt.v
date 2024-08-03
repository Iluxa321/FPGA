module approximator_opt
// апроксиматор принимает данные с ацп и sin, cos от генератора
// расчитывает 2048 точек и выдает результат
// approximator_opt отличается от approximator тем что сдвиг на 52 просходит для значений A и  B
#(parameter 
WIDTH_DATA = 10, 
WIDTH_SIN_COS = 9, 
WIDTH_1 = WIDTH_DATA+WIDTH_SIN_COS + 1, 	// Для 10Bit: 10 + 9 + 1 = 20; 	Для 12Bit: 12 + 9 + 1 = 22; 	Для 8Bit: 8 + 9 + 1 = 18;
WIDTH_2 = WIDTH_SIN_COS + WIDTH_SIN_COS, 	// Для 10Bit: 9 + 9 = 18; 			Для 12Bit: 9 + 9 = 18; 			Для 8Bit: 9 + 9 = 18;
WIDTH_3 = WIDTH_1 + WIDTH_SIN_COS, 			// Для 10Bit: 20 + 9 = 29;  		Для 12Bit: 22 + 9  = 31; 		Для 8Bit: 18 + 9 = 27;
WIDTH_4 = WIDTH_3 + 12, 						// Для 10Bit: 29 + 12 = 41; 		Для 12Bit: 31 + 12 = 43; 		Для 8Bit: 27 + 12 = 39;
WIDTH_5 = WIDTH_2 + 12, 						// Для 10Bit: 18 + 12 = 30; 		Для 12Bit: 18 + 12 = 30; 		Для 8Bit: 18 + 12 = 30;
WIDTH_6 = WIDTH_4 + WIDTH_5, 					// Для 10Bit: 41 + 30 = 71; 		Для 12Bit: 43 + 30 = 73; 		Для 8Bit: 39 + 30 = 69;
WIDTH_7 = WIDTH_5 + WIDTH_5, 					// Для 10Bit: 30 + 30 = 60; 		Для 12Bit: 30 + 30 = 60; 		Для 8Bit: 30 + 30 = 60;
WIDTH_8 = WIDTH_6 + WIDTH_6, 					// Для 10Bit: 71 + 71 = 142; 		Для 12Bit: 73 + 73 = 146; 		Для 8Bit: 69 + 69 = 138; (это число надо загрузить в sqrt)
WIDTH_9 = WIDTH_8 / 2 							// Для 10Bit: 142 / 2 = 71; 		Для 12Bit: 146 / 2 = 73; 		Для 8Bit: 138 / 2 = 69
)
(
input clk,
input en,
input [WIDTH_DATA-1:0] data,
input [WIDTH_SIN_COS-1:0] sin, cos,
output [WIDTH_DATA-1:0] amp
);
	wire [WIDTH_1-1:0] dc_amp = 11'd0 * 9'd255; // постоянная составляющая сигнала
	reg reg_en;
	reg [WIDTH_DATA-1:0] reg_data;
	reg [WIDTH_SIN_COS-1:0] reg_sin, reg_cos;
	always @(posedge clk) begin // фиксируем принятые данные
		reg_en <= en;
		reg_data <= data;
		reg_sin <= sin;
		reg_cos <= cos;
	
	end
	wire [10:0] cnt_iteration; // счетчик итераций
	counter #(.WIDTH(11)) counter(.clk(clk), .en(reg_en), .cnt(cnt_iteration));
	
	//-------------adc -> reg----------------------
	//parameter WIDTH_1 = WIDTH_DATA+WIDTH_SIN_COS + 1; // 20
	wire [WIDTH_1-1:0] correct_adc, correct_adc_reg;
	signed_mult_opt #(.WIDTH_A(WIDTH_DATA+1), .WIDTH_B(WIDTH_SIN_COS)) mult_adc_const(.a({1'b0,reg_data}), .b(9'd255), .m(correct_adc));
	registor_opt #(.WIDTH(WIDTH_1)) reg_adc(.clk(clk), .en(reg_en), .d(correct_adc - dc_amp), .q(correct_adc_reg));
	//---------------------------------------------
	
	wire [WIDTH_SIN_COS-1:0] reg2_sin, reg2_cos; // для симметрии
	registor_opt #(.WIDTH(WIDTH_SIN_COS)) r_sin(.clk(clk), .en(reg_en), .d(reg_sin), .q(reg2_sin));
	registor_opt #(.WIDTH(WIDTH_SIN_COS)) r_cos(.clk(clk), .en(reg_en), .d(reg_cos), .q(reg2_cos));
	
	//-------------Линии задержки------------------
	reg [1:0] line_delay1;
	reg  line_delay2;
	always @(posedge clk) begin
		line_delay1 <= {line_delay1[0], reg_en};
		line_delay2 <= &cnt_iteration;
	end
	//---------------------------------------------
	
	//-------------Fc, Fs, C, S, d-----------------
	//parameter WIDTH_2 = WIDTH_SIN_COS + WIDTH_SIN_COS; // 9 + 9 = 18
	//parameter WIDTH_3 = WIDTH_1 + WIDTH_SIN_COS; // 20 + 9 = 29
	//parameter WIDTH_4 = WIDTH_3 + 12; // 29 + 12 = 41
	//parameter WIDTH_5 = WIDTH_2 + 12; // 18 + 12 = 30
	wire [WIDTH_2-1:0] sin2, cos2, sin_cos;
	wire [WIDTH_3-1:0] adc_sin, adc_cos;
	wire [WIDTH_4-1:0] Fs, Fc;
	wire [WIDTH_5-1:0] S, C, d;
	signed_mult_opt #(.WIDTH_A(WIDTH_SIN_COS), .WIDTH_B(WIDTH_SIN_COS)) mult_sin_sin(.a(reg2_sin), .b(reg2_sin), .m(sin2));
	signed_mult_opt #(.WIDTH_A(WIDTH_SIN_COS), .WIDTH_B(WIDTH_SIN_COS)) mult_cos_cos(.a(reg2_cos), .b(reg2_cos), .m(cos2));
	signed_mult_opt #(.WIDTH_A(WIDTH_SIN_COS), .WIDTH_B(WIDTH_SIN_COS)) mult_sin_cos(.a(reg2_sin), .b(reg2_cos), .m(sin_cos));
	signed_mult_opt #(.WIDTH_A(WIDTH_1), .WIDTH_B(WIDTH_SIN_COS)) mult_adc_sin(.a(correct_adc_reg), .b(reg2_sin), .m(adc_sin));
	signed_mult_opt #(.WIDTH_A(WIDTH_1), .WIDTH_B(WIDTH_SIN_COS)) mult_adc_cos(.a(correct_adc_reg), .b(reg2_cos), .m(adc_cos));
	
	accumulator_opt #(.WIDTH(WIDTH_3)) accum_Fs(.clk(clk), .en(line_delay1[0]), .reset(line_delay1[1] & line_delay2), .a(adc_sin), .s(Fs));
	accumulator_opt #(.WIDTH(WIDTH_3)) accum_Fc(.clk(clk), .en(line_delay1[0]), .reset(line_delay1[1] & line_delay2), .a(adc_cos), .s(Fc));
	accumulator_opt #(.WIDTH(WIDTH_2)) accum_S(.clk(clk), .en(line_delay1[0]), .reset(line_delay1[1] & line_delay2), .a(sin2), .s(S));
	accumulator_opt #(.WIDTH(WIDTH_2)) accum_C(.clk(clk), .en(line_delay1[0]), .reset(line_delay1[1] & line_delay2), .a(cos2), .s(C));
	accumulator_opt #(.WIDTH(WIDTH_2)) accum_d(.clk(clk), .en(line_delay1[0]), .reset(line_delay1[1] & line_delay2), .a(sin_cos), .s(d));

	//---------------------------------------------
	
	
	
	//------------A, B, delta---------------------
	//parameter WIDTH_6 = WIDTH_4 + WIDTH_5; // 41 + 30 = 71
	//parameter WIDTH_7 = WIDTH_5 + WIDTH_5; // 30 + 30 = 60
	wire [WIDTH_6-1:0] Fs_d, Fc_s, A;
	wire [WIDTH_6-1:0] Fc_d, Fs_c, B;
	wire [WIDTH_7-1:0] C_S, d2; // delta;
	
	signed_mult_opt #(.WIDTH_A(WIDTH_4), .WIDTH_B(WIDTH_5)) mult_Fs_d(.a(Fs), .b(d), .m(Fs_d));
	signed_mult_opt #(.WIDTH_A(WIDTH_4), .WIDTH_B(WIDTH_5)) mult_Fc_s(.a(Fc), .b(S), .m(Fc_s));
	assign A = Fc_s - Fs_d;
	
	signed_mult_opt #(.WIDTH_A(WIDTH_4), .WIDTH_B(WIDTH_5)) mult_Fc_d(.a(Fc), .b(d), .m(Fc_d));
	signed_mult_opt #(.WIDTH_A(WIDTH_4), .WIDTH_B(WIDTH_5)) mult_Fs_c(.a(Fs), .b(C), .m(Fs_c));
	assign B = Fs_c - Fc_d;
	
	signed_mult_opt #(.WIDTH_A(WIDTH_5), .WIDTH_B(WIDTH_5)) mult_C_S(.a(C), .b(S), .m(C_S));
	signed_mult_opt #(.WIDTH_A(WIDTH_5), .WIDTH_B(WIDTH_5)) mult_d_d(.a(d), .b(d), .m(d2));
	//assign delta = C_S - d2;
	
	wire [WIDTH_6-1-52:0] A_r, B_r; 
	//wire [87:0] delta_r;
	registor_opt #(.WIDTH(WIDTH_6-52)) A_reg(.clk(clk), .en(line_delay1[1] & line_delay2), .d(A[70:52]), .q(A_r));
	registor_opt #(.WIDTH(WIDTH_6-52)) B_reg(.clk(clk), .en(line_delay1[1] & line_delay2), .d(B[70:52]), .q(B_r));
	//registor #(.WIDTH(88)) delta_reg(.clk(clk), .en(line_delay1[2] & line_delay2[1]), .d(delta), .q(delta_r));
	//---------------------------------------------
	
	//-----------------AMP-------------------------
	//parameter WIDTH_8 = WIDTH_6 + WIDTH_6; // 71 + 71 = 142 - 104 = 38
	//parameter WIDTH_9 = WIDTH_8 / 2; // 142 / 2 = 71 - 52 = 19
	wire [WIDTH_8-1-104:0] A_r2, B_r2;
	wire [WIDTH_8-1-104:0] A_r2_add_B_r2;
	wire [WIDTH_9-1-52:0] sqrt_AB;
	signed_mult_opt #(.WIDTH_A(WIDTH_6-52), .WIDTH_B(WIDTH_6-52)) mult_Ar_Ar(.a(A_r), .b(A_r), .m(A_r2));
	signed_mult_opt #(.WIDTH_A(WIDTH_6-52), .WIDTH_B(WIDTH_6-52)) mult_Br_Br(.a(B_r), .b(B_r), .m(B_r2));
	assign A_r2_add_B_r2 = A_r2 + B_r2;
	SQRT sqrt(.radical(A_r2_add_B_r2), .q(sqrt_AB), .remainder());
	//wire [WIDTH_9-1:0] temp = sqrt_AB >> 52; // 52 константа при рассчете 2048 точек  
	assign amp = sqrt_AB[9:0]; 
	
	//---------------------------------------------

endmodule


/*
module table_sin_cos
// таблица синусов и косинусов
// задержка 2 такта, т.к. присутствуют 2 тригера (один от счетчика, другой внутри ROM)
(
input clk, 
input en,
input [7:0] modul_step, // кратность частоты
input [3:0] fractional_step,
output [8:0] cos, sin
);
	reg [14:0] total_address; // общий адресс 
	wire [10:0] address; // адрес подаваемый в таблицу
	reg sign_sin, sign_cos;
	wire [8:0] addr_sin, addr_cos; // адресс подаваемы в таблицу
	wire [8:0] sin_1sym, cos_1sym; // 1-ая симетрия сигнала
	initial begin
		total_address <= 15'b111_1111_1111_1111; // инициализируем счетчик
	end
	ROM rom(.address_a(addr_sin), .address_b(addr_cos), .clock(clk), .q_a(sin_1sym), .q_b(cos_1sym));
	assign address = total_address[14:4];
	assign addr_sin = address[9] ? ~address[8:0] : address[8:0];
	assign addr_cos = ~address[9] ? ~address[8:0] : address[8:0];
	assign sin = sign_sin ? -sin_1sym : sin_1sym;
	assign cos = sign_cos ? -cos_1sym : cos_1sym;
	always @(posedge clk) begin
		if(en) begin
			total_address <= total_address + {modul_step, fractional_step};
		end
		sign_sin <= address[10];
		sign_cos <= address[10] ^ address[9];
	end
endmodule
*/

module accumulator_opt 
#(parameter WIDTH = 8) // ширина шины (по умолчанию)
(
input clk,
input en,
input reset,
input [WIDTH-1:0] a,
output reg [(WIDTH-1+12):0] s // ширина определяется как WIDTH + log(2048)
);
	initial begin
		s <= {(WIDTH-1+12){1'b0}};
	end
	always @(posedge clk) begin
		if(reset) begin
			s <= {(WIDTH-1+12){1'b0}};
		end
		else if(en) begin
			s <= s + {{12{a[WIDTH-1]}},a};
		end
	end
endmodule


module counter_opt 
#(parameter WIDTH = 8)
(
input clk,
input en,
output reg [WIDTH-1:0] cnt
);
	initial begin
		cnt <= {WIDTH{1'b1}}; // инициализируем FFF чтобы очистить регистры
	end
	always @(posedge clk) begin
		if(en) begin
			cnt <= cnt + 1'd1;
		end
	end
endmodule

module registor_opt
#(parameter WIDTH = 8)
(
input clk,
input en,
input [WIDTH-1:0] d,
output reg [WIDTH-1:0] q
);
	always @(posedge clk) begin
		if(en) begin
			q <= d;
		end
	end
endmodule

module signed_mult_opt
#(parameter WIDTH_A = 8, WIDTH_B = 8)
(
input [WIDTH_A-1:0] a, 
input [WIDTH_B-1:0] b,
output [WIDTH_A+WIDTH_B-1:0] m
);
	assign m = {{WIDTH_B{a[WIDTH_A-1]}},a} * {{WIDTH_A{b[WIDTH_B-1]}},b};
endmodule


module unsigned_mult_opt
#(parameter WIDTH_A = 8, WIDTH_B = 8)
(
input [WIDTH_A-1:0] a, 
input [WIDTH_B-1:0] b,
output [WIDTH_A+WIDTH_B-1:0] m
);
	assign m = {{WIDTH_B{1'd0}},a} * {{WIDTH_A{1'd0}},b};
endmodule

