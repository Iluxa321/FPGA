module dds_generator
// таблица синусов и косинусов
// задержка 2 такта, т.к. присутствуют 2 тригера (один от счетчика, другой внутри ROM)
(
input clk, 
input [7:0] module_step, // кратность частоты
output [8:0] cos, sin
);
	reg [10:0] address; // общий адресс
	reg sign_sin, sign_cos;
	wire [8:0] addr_sin, addr_cos; // адресс подаваемы в таблицу
	wire [8:0] sin_1sym, cos_1sym; // 1-ая симетрия сигнала
	initial begin
		address <= 11'b111_1111_1111;
	end
	ROM rom(.address_a(addr_sin), .address_b(addr_cos), .clock(clk), .q_a(sin_1sym), .q_b(cos_1sym));
	assign addr_sin = address[9] ? ~address[8:0] : address[8:0]; // получаем адресс который необходимо подать в таблицу
	assign addr_cos = ~address[9] ? ~address[8:0] : address[8:0];
	assign sin = sign_sin ? -sin_1sym : sin_1sym; // получаем данные из таблицы
	assign cos = sign_cos ? -cos_1sym : cos_1sym;
	always @(posedge clk) begin
		address <= address + module_step;
		sign_sin <= address[10];
		sign_cos <= address[10] ^ address[9];
	end

endmodule

