module cordic
(

// input clk,
// input en,
// input [15:0] a, b, c,					// перменожаемые числа формат IQ 1.15					
// output [15:0] res,						// результат формат IQ 1.15
// output [15:0] error,						// ошибка формат IQ 1.15
// output done


input clk,
input en,
input [15:0] angle,					// угол нормализованный к формату [-1, 0.99999] (IQ 1.15)
input [15:0] X,Y,						// Начальные значения
output [15:0] X0, Y0,		// sin, cos приведенный к формату IQ 1.15
output [15:0] theta,					// ошибка формат IQ 1.15
output done

/*
input [15:0] angle,			// угол нормализованный к формату [-1, 0.99999] (IQ 1.15)
output [15:0] sin, cos,		// sin, cos приведенный к формату IQ 1.15
output [15:0] theta			// ошибка формат IQ 1.15
*/
);
	// cordic_line_mode c1(clk, en, a, b, c, res, error, done);
	cordic_hyperbolic_mode c1(clk, en ,angle, X, Y, X0, Y0, theta, done);
	//cordic1 c1(angle, sin, cos, theta);

endmodule




module cordic_pipeline
// Cordic можно использовать для расчета sin и cos 
// если на angle подать угол, на X 16'd19895, и на Y 0
// в таком случае X0 и Y0 будут соответсвовать sin и cos приведенные к формату IQ 1.15 [-1, 0.99999]
// Rotate mode
(
input clk,
input en,
input [15:0] angle,					// угол нормализованный к формату [-1, 0.99999] (IQ 1.15)
input [15:0] X,Y,						// Начальные значения
output [15:0] X0, Y0,		// sin, cos приведенный к формату IQ 1.15
output [15:0] theta,					// ошибка формат IQ 1.15
output reg done
);
	
	parameter [3:0] N = 4'd14;
	wire  [15:0] x_i [N:0];
	wire  [15:0] y_i [N:0];
	wire  [15:0] angle_i [N:0];
	reg [15:0] const_angle [N:0];
	
	reg [15:0] reg_X;
	reg [15:0] reg_Y;
	reg [13:0] cur_angle;	// текущий угл
	reg [1:0] quarter;		// номер четверть
	reg [N-1:0] reg_en;
	reg [15:0] in_X, in_Y;
	
	integer j;
	genvar i;
	
	initial begin
		$readmemh("coef.txt", const_angle);
	end
	
	always @(posedge clk) begin
	// сохоняем полученные данные
		if(en) begin
			reg_X <= X;
			reg_Y <= Y;
			{quarter, cur_angle} <= angle;		
		end
		reg_en <= {reg_en[N-2:0], en};
	end
	
	assign angle_i[0] = {2'd0,cur_angle};	// расчет ведем только для I четверти	
	assign x_i[0] = in_X;
	assign y_i[0] = in_Y; 
	
	always @(*) begin	// поворачиваем вектора в зависимости от четверти
		case(quarter)
			2'd0: {in_Y, in_X} = {reg_Y, reg_X};
			2'd1: {in_Y, in_X} = {reg_X, reg_Y};
			2'd2: {in_Y, in_X} = {reg_Y, -reg_X};
			2'd3: {in_Y, in_X} = {-reg_X, reg_Y};
		endcase
	end
	
	generate
		
		for(i = 1; i < N+1; i = i + 1) begin : cord
			cordic_pipeline_stage cor(
								.clk(clk),
								.en(reg_en[i-1]),
								.x(x_i[i-1]),
								.y(y_i[i-1]),
								.theta(angle_i[i-1]),
								.n(i[3:0]-4'd1),
								.del_angle(const_angle[i-1]),
								.x1(x_i[i]),
								.y1(y_i[i]),
								.theta1(angle_i[i])
								);
								
								
			
		end
	endgenerate
	
	
	always @(posedge clk) begin
		done <= reg_en[N-1];	
	end
	
	assign X0 = (x_i[N]);
	assign Y0 = (y_i[N]);
	assign theta = angle_i[N];
	
endmodule


module cordic_line_mode
(
input clk,
input en,
input [15:0] a, b, c,						// перменожаемые числа формат IQ 1.15					
output [15:0] res,						// результат формат IQ 1.15
output [15:0] error,						// ошибка формат IQ 1.15
output reg done
);

	parameter [3:0] N = 4'd14;
	parameter [15:0] init_data = 16'b0100_0000_0000_0000;	// 2^-1
	wire  [15:0] x_i [N:0];
	wire  [15:0] y_i [N:0];
	wire  [15:0] angle_i [N:0];
	
	genvar i;
	
	reg [15:0] reg_A;
	reg [15:0] reg_B;
	reg [15:0] reg_C;
	reg [N-1:0] reg_en;
	
	always @(posedge clk) begin
	// сохоняем полученные данные
		if(en) begin
			reg_A <= a;
			reg_B <= b;	
			reg_C <= c;	
		end
		reg_en <= {reg_en[N-2:0], en};
	end
	
	assign angle_i[0] = reg_C;	// расчет ведем только для I четверти	
	assign x_i[0] = reg_A;
	assign y_i[0] = reg_B; 
	
	generate
		
		for(i = 1; i < N+1; i = i + 1) begin : cord
			cordic_div cor(
								.clk(clk),
								.en(reg_en[i-1]),
								.x(x_i[i-1]),
								.y(y_i[i-1]),
								.theta(angle_i[i-1]),
								.n(i[3:0]-4'd1),
								.del_angle(init_data),
								.x1(x_i[i]),
								.y1(y_i[i]),
								.theta1(angle_i[i])
								);
	
		end
	endgenerate
	
	always @(posedge clk) begin
		done <= reg_en[N-1];	
	end
	
	assign res = (y_i[N]);
	assign error = angle_i[N];

endmodule

module cordic_hyperbolic_mode
(
input clk,
input en,
input [15:0] angle,					// угол нормализованный к формату [-1, 0.99999] (IQ 1.15)
input [15:0] X,Y,						// Начальные значения
output [15:0] X0, Y0,		// sin, cos приведенный к формату IQ 1.15
output [15:0] theta,					// ошибка формат IQ 1.15
output reg done
);
	//------------------Первая реализация------------------------
	
	// parameter [4:0] N = 5'd13;
	// parameter [4:0] L = N + 5'd2;	// 2 это количество дополнительных итераций
	// wire [15:0] x_i [L:0];
	// wire [15:0] y_i [L:0];
	// wire [15:0] angle_i [L:0];
	// reg [15:0] const_angle [L:0];	// значения гиперболичесого тангенса
	
	// reg [15:0] reg_X;
	// reg [15:0] reg_Y;
	// reg [13:0] cur_angle;	// текущий угл
	// reg [1:0] quarter;		// номер четверть
	// reg [L-1:0] reg_en;
	// reg [15:0] in_X, in_Y;
	


	// initial begin
	// 	$readmemh("hcoef.txt", const_angle);
	// end
	
	// always @(posedge clk) begin
	// // сохоняем полученные данные
	// 	if(en) begin
	// 		reg_X <= X;
	// 		reg_Y <= Y;
	// 		{quarter, cur_angle} <= angle;		
	// 	end
	// 	reg_en <= {reg_en[L-2:0], en};
	// end
	
	// assign angle_i[0] = {2'd0,cur_angle};	// расчет ведем только для I четверти	
	// assign x_i[0] = in_X;
	// assign y_i[0] = in_Y; 
	
	// always @(*) begin	// поворачиваем вектора в зависимости от четверти
	// 	case(quarter)
	// 		2'd0: {in_Y, in_X} = {reg_Y, reg_X};
	// 		2'd1: {in_Y, in_X} = {reg_X, reg_Y};
	// 		2'd2: {in_Y, in_X} = {reg_Y, -reg_X};
	// 		2'd3: {in_Y, in_X} = {-reg_X, reg_Y};
	// 	endcase
	// end
	// generate
	// 	genvar i;
	// 	for(i = 1; i < L+1; i = i + 1) begin : cord
	// 		if(i < 5) begin
	// 			cordic_hyperbolic_vector_mode cor1(
	// 							.clk(clk),
	// 							.en(reg_en[i-1]),
	// 							.x(x_i[i-1]),
	// 							.y(y_i[i-1]),
	// 							.theta(angle_i[i-1]),
	// 							.n(i[4:0]),
	// 							.del_angle(const_angle[i-1]),
	// 							.x1(x_i[i]),
	// 							.y1(y_i[i]),
	// 							.theta1(angle_i[i])
	// 							);
	// 		end
	// 		else if(i >= 5 && i < 15) begin // (3*i+1)
	// 			cordic_hyperbolic_vector_mode cor(
	// 							.clk(clk),
	// 							.en(reg_en[i-1]),
	// 							.x(x_i[i-1]),
	// 							.y(y_i[i-1]),
	// 							.theta(angle_i[i-1]),
	// 							.n(i[4:0]-5'd1),
	// 							.del_angle(const_angle[i-1]),
	// 							.x1(x_i[i]),
	// 							.y1(y_i[i]),
	// 							.theta1(angle_i[i])
	// 							);	
	// 		end		
	// 		else if (i >= 15) begin
	// 			cordic_hyperbolic_vector_mode cor(
	// 							.clk(clk),
	// 							.en(reg_en[i-1]),
	// 							.x(x_i[i-1]),
	// 							.y(y_i[i-1]),
	// 							.theta(angle_i[i-1]),
	// 							.n(i[4:0]-5'd2),
	// 							.del_angle(const_angle[i-1]),
	// 							.x1(x_i[i]),
	// 							.y1(y_i[i]),
	// 							.theta1(angle_i[i])
	// 							);
	// 		end
			
	// 	end
	// endgenerate
	
	
	// always @(posedge clk) begin
	// 	done <= reg_en[L-1];	
	// end
	
	// assign X0 = (x_i[L]);
	// assign Y0 = (y_i[L]);
	// assign theta = angle_i[L];

	//-----------------Вторая реализация-------------------------------

	parameter [4:0] N = 5'd13;
	parameter [4:0] L = N + 5'd2;	// 2 это количество дополнительных итераций
	reg signed [15:0] x_i [L:0];
	reg signed [15:0] y_i [L:0];
	reg signed [15:0] angle_i [L:0];
	reg [15:0] const_angle [L:0];	// значения гиперболичесого тангенса
	
	reg [15:0] reg_X;
	reg [15:0] reg_Y;
	reg [13:0] cur_angle;	// текущий угл
	reg [1:0] quarter;		// номер четверть
	reg [L:0] reg_en;
	reg signed [15:0] in_X, in_Y;
	


	initial begin
		$readmemh("hcoef.txt", const_angle);
	end
	
	always @(posedge clk) begin
	// сохоняем полученные данные
		if(en) begin
			reg_X <= X;
			reg_Y <= Y;
			{quarter, cur_angle} <= angle;		
		end
		reg_en <= {reg_en[L-1:0], en};
	end
	
	always @(*) begin	// поворачиваем вектора в зависимости от четверти
		case(quarter)
			2'd0: {in_Y, in_X} = {reg_Y, reg_X};
			2'd1: {in_Y, in_X} = {reg_X, reg_Y};
			2'd2: {in_Y, in_X} = {reg_Y, -reg_X};
			2'd3: {in_Y, in_X} = {-reg_X, reg_Y};
		endcase
	end

	integer i;
	always @(posedge clk) begin
		if(reg_en[0]) begin
			x_i[0] <= (in_Y <= 0) ? in_X +  (in_Y >>> 1) : in_X - (in_Y >>> 1);
			y_i[0] <= (in_Y <= 0) ? in_Y + (in_X >>> 1) : in_Y - (in_X >>> 1);
			angle_i[0] <= (in_Y <= 0) ? {2'd0,cur_angle} - const_angle[0] : {2'd0,cur_angle} + const_angle[0];
		end
		for(i = 1; i < L+1; i = i + 1) begin
			if(reg_en[i]) begin
				if(i < 5) begin
					x_i[i] <= (y_i[i-1] <= 0) ? x_i[i-1] +  (y_i[i-1] >>> i+1) : x_i[i-1] - (y_i[i-1] >>> i+1);
					y_i[i] <= (y_i[i-1] <= 0) ? y_i[i-1] + (x_i[i-1] >>> i+1) : y_i[i-1] - (x_i[i-1] >>> i+1);
					angle_i[i] <= (y_i[i-1] <= 0) ? angle_i[i-1] - const_angle[i] : angle_i[i-1] + const_angle[i];
				end
				else if (i>=5 && i<15) begin
					x_i[i] <= (y_i[i-1] <= 0) ? x_i[i-1] +  (y_i[i-1] >>> i) : x_i[i-1] - (y_i[i-1] >>> i);
					y_i[i] <= (y_i[i-1] <= 0) ? y_i[i-1] + (x_i[i-1] >>> i) : y_i[i-1] - (x_i[i-1] >>> i);
					angle_i[i] <= (y_i[i-1] <= 0) ? angle_i[i-1] - const_angle[i] : angle_i[i-1] + const_angle[i];
				end
				else if (i>=15) begin
					x_i[i] <= (y_i[i-1] <= 0) ? x_i[i-1] +  (y_i[i-1] >>> i-1) : x_i[i-1] - (y_i[i-1] >>> i-1);
					y_i[i] <= (y_i[i-1] <= 0) ? y_i[i-1] + (x_i[i-1] >>> i-1) : y_i[i-1] - (x_i[i-1] >>> i-1);
					angle_i[i] <= (y_i[i-1] <= 0) ? angle_i[i-1] - const_angle[i] : angle_i[i-1] + const_angle[i];
				end
				
			end			
		end
	end

	always @(posedge clk) begin
		done <= reg_en[L];	
	end
	
	assign X0 = (x_i[L]);
	assign Y0 = (y_i[L]);
	assign theta = angle_i[L];


endmodule

module cordic_hyperbolic_vector_mode
// !!! При расчете квадратного корня входные значения должны быть в диапозоне [0.5, 2) !!!
// Если не попасть в диапозон, то увеличится ошибка от расчета
(
input clk, 
input en,
input signed [15:0] x, y, theta,
input [4:0] n, 
input  signed [15:0] del_angle,
output reg signed [15:0] x1, y1, theta1
);

	wire signed [15:0] tmp_y = (y >>> n);
	wire signed [15:0] tmp_x = (x >>> n);
	always @(posedge clk) begin
		if(en) begin
			x1 <= (y <= 0) ? x +  tmp_y : x - tmp_y;
			y1 <= (y <= 0) ? y + tmp_x : y - tmp_x;
			theta1 <= (y <= 0) ? theta - del_angle : theta + del_angle;
		end
	end
endmodule

module cordic_pipeline_stage
(
input clk, 
input en,
input signed [15:0] x, y, theta,
input [3:0] n, 
input  signed [15:0] del_angle,
output reg signed  [15:0] x1, y1, theta1
);

	wire signed [15:0] tmp_y = (y >>> n);
	wire signed [15:0] tmp_x = (x >>> n);
	always @(posedge clk) begin
		if(en) begin
			x1 <= theta[15] ? x +  tmp_y : x - tmp_y;
			y1 <= theta[15] ? y - tmp_x : y + tmp_x;
			theta1 <= theta[15] ? theta + del_angle : theta - del_angle;
		end
	end
endmodule

module cordic_multiplier
(
input clk, 
input en,
input signed [15:0] x, y, theta,
input [3:0] n, 
input  signed [15:0] del_angle,
output reg signed  [15:0] x1, y1, theta1
);

	wire signed [15:0] tmp_x = (x >>> n+1);
	wire signed [15:0] tmp_angle = del_angle >>> n;
	always @(posedge clk) begin
		if(en) begin
			x1 <= x;
			y1 <= theta[15] ? y - tmp_x : y + tmp_x;
			theta1 <= theta[15] ? theta + tmp_angle : theta - tmp_angle;
		
		end
		
	end

endmodule

module cordic_div
(
input clk, 
input en,
input signed [15:0] x, y, theta,
input [3:0] n, 
input  signed [15:0] del_angle,
output reg signed  [15:0] x1, y1, theta1
);

	wire signed [15:0] tmp_x = (x >>> n+1);
	wire signed [15:0] tmp_angle = del_angle >>> n;
	always @(posedge clk) begin
		if(en) begin
			x1 <= x;
			y1 <= y[15] ? y + tmp_x : y - tmp_x;
			theta1 <= y[15] ? theta - tmp_angle : theta + tmp_angle;
		
		end
		
	end

endmodule


module cordic_pipeline_stage2
(
input clk, 
input en,
input signed [15:0] x, y, theta,
input [3:0] n, 
input  signed [15:0] del_angle,
output reg signed  [15:0] x1, y1, theta1
);

	wire signed [15:0] tmp_y = (y >>> n);
	wire signed [15:0] tmp_x = (x >>> n);
	always @(posedge clk) begin
		if(en) begin
			x1 <= y[15] ? x -  tmp_y : x + tmp_y;
			y1 <= y[15] ? y + tmp_x : y - tmp_x;
			theta1 <= y[15] ? theta - del_angle : theta + del_angle;
		end
	end
endmodule


module cordic1
(
input [15:0] angle,			// угол нормализованный к формату [-1, 0.99999] (IQ 1.15)
output [15:0] sin, cos,		// sin, cos приведенный к формату IQ 1.15
output [15:0] theta			// ошибка формат IQ 1.15
);
	
	parameter [15:0] init_val = 16'd19895;			// единичный вектор(32767) помноженный на маштабирующий коэффициент (0.60725) (запишем результат чуть меньше реального чтобы убрать переполнения на пиках)
	parameter [3:0] N = 4'd14;
	wire  [15:0] x_i [N:0];
	wire  [15:0] y_i [N:0];
	wire  [15:0] angle_i [N:0];
	reg [15:0] const_angle [N:0];
	wire [1:0] quarter = angle[15:14];	// сохроняем для какой четверти находим угол
	reg [15:0] in_x, in_y;
	
	assign angle_i[0] = {2'd0,angle[13:0]};			// расчет ведем только для I четверти
	assign x_i[0] = in_x;
	assign y_i[0] = in_y;
	
	always @(*) begin
		case(quarter)
			2'd0: {in_y, in_x} = {16'd0, init_val};
			2'd1: {in_y, in_x} = {init_val, 16'd0};
			2'd2: {in_y, in_x} = {16'd0, -init_val};
			2'd3: {in_y, in_x} = {-init_val, 16'd0};
		endcase
	end
	
	initial begin
		$readmemh("coef.txt", const_angle);
	end
	
	genvar i;
	generate
		
		for(i = 1; i < N+1; i = i + 1) begin : cord
			cordic_stage cor(
								x_i[i-1],
								y_i[i-1],
								angle_i[i-1],
								i[3:0]-4'd1,
								const_angle[i-1],
								x_i[i],
								y_i[i],
								angle_i[i]
								);
		end
	endgenerate
	
	assign sin = (y_i[N]);
	assign cos = (x_i[N]);
	assign theta = angle_i[N];
	
	
	

endmodule



module cordic_stage
(
input signed [15:0] x, y, theta,
input [3:0] n, 
input  signed [15:0] del_angle,
output signed [15:0] x1, y1, theta1
);

	wire signed [15:0] tmp_y = (y >>> n);
	wire signed [15:0] tmp_x = (x >>> n);
	assign x1 = theta[15] ? x +  tmp_y : x - tmp_y;
	assign y1 = theta[15] ? y - tmp_x : y + tmp_x;
	assign theta1 = theta[15] ? theta + del_angle : theta - del_angle;
	
endmodule

