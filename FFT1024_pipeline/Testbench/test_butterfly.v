`timescale 1 ns / 1 ps

module test_butterfly;
	
	reg clk;
	reg [16:0] A_re;
	reg [16:0] A_img;
	reg [16:0] B_re;
	reg [16:0] B_img;
	reg [15:0] W_re;
	reg [15:0] W_img;

	wire signed [16:0] X_re;
	wire signed [16:0] X_img;
	wire signed [16:0] Y_re;
	wire signed [16:0] Y_img;
	
	reg [31:0] W;
	reg [33:0] A, B;
	
	reg signed [16:0] res_X_re, res_X_img, res_Y_re, res_Y_img; 
	
	butterfly #(.DATA_WIDTH(34), .TW_DATA_WIDTH(32)) dut(clk, A_re, A_img, B_re, B_img, W_re, W_img, X_re, X_img, Y_re, Y_img);
	
	integer fp1, fp2, fp3, fp4, fp5; // индентификатор файлов
	integer i, res, j;
	
	
	initial begin
		fp1 = $fopen("twiddle_factor.txt", "r");
		fp2 = $fopen("data_A.txt", "r");
		fp3 = $fopen("data_B.txt", "r");
		fp4 = $fopen("data_X.txt", "r");
		fp5 = $fopen("data_Y.txt", "r");
		j = 0;
		A_re = 0;
		A_img = 0;
		B_re = 0;
		B_img = 0;
		W_re = 0;
		W_img = 0;
		res_X_re = 0;
		res_X_img = 0;
		res_Y_re = 0;
		res_Y_img = 0;
		
		
		if(fp1 == 0 || fp2 == 0 || fp3 == 0 || fp4 == 0 || fp5 == 0) begin
			$display("File Error");
			$stop;
		end
		
		clk = 0;
		forever begin
			#5 clk = ~clk;
		end
	end
	
	always @(negedge clk) begin
		j = j + 1;
		i = $fscanf(fp1,"%d", W);
		if(i == -1) begin // если данные в файле нет, то заврещаем моделирование
			$display("Test finish");
			$fclose(fp1);
			$fclose(fp2);
			$fclose(fp3);
			$fclose(fp4);
			$fclose(fp5);
			$stop;
		end
		i = $fscanf(fp2,"%d %d", A[33:17], A[16:0]);
		if(i == -1) begin // если данные в файле нет, то заврещаем моделирование
			$display("Test finish");
			$fclose(fp1);
			$fclose(fp2);
			$fclose(fp3);
			$fclose(fp4);
			$fclose(fp5);
			$stop;
		end
		i = $fscanf(fp3,"%d %d", B[33:17], B[16:0]);
		if(i == -1) begin // если данные в файле нет, то заврещаем моделирование
			$display("Test finish");
			$fclose(fp1);
			$fclose(fp2);
			$fclose(fp3);
			$fclose(fp4);
			$fclose(fp5);
			$stop;
		end
		
		A_re = A[33:17];
		A_img = A[16:0];
		B_re = B[33:17];
		B_img = B[16:0];
		W_re = W[31:16];
		W_img = W[15:0];
		
		if(abs(X_re, res_X_re) > 3 || abs(X_img, res_X_img) > 3) begin
			$display("**************Test error****************\n");
			$display("FOR X\n");
			$display("Re: X_re: %d res_X_re: %d res: %d\n", X_re, res_X_re, abs(X_re, res_X_re));
			$display("Im: X_img: %d res_X_img: %d res: %d\n", X_img, res_X_img, abs(X_img, res_X_img));
			$stop;

			
		end
		
		if(abs(Y_re, res_Y_re) > 3 || abs(Y_img, res_Y_img) > 3) begin
			$display("**************Test error****************\n");
			$display("FOR Y\n");
			$display("Re: Y_re: %d res_Y_re: %d res: %d\n", Y_re, res_Y_re, abs(Y_re, res_Y_re));
			$display("Im: Y_img: %d res_Y_img: %d res: %d\n", Y_img, res_Y_img, abs(Y_img, res_Y_img));

			
		end
		
		
	end
	
	always @(posedge clk) begin
		i = $fscanf(fp4,"%d %d", res_X_re, res_X_img);
		if(i == -1) begin // если данные в файле нет, то заврещаем моделирование
			$display("Test finish");
			$fclose(fp1);
			$fclose(fp2);
			$fclose(fp3);
			$fclose(fp4);
			$fclose(fp5);
			$stop;
		end
		i = $fscanf(fp5,"%d %d", res_Y_re, res_Y_img);
		if(i == -1) begin // если данные в файле нет, то заврещаем моделирование
			$display("Test finish");
			$fclose(fp1);
			$fclose(fp2);
			$fclose(fp3);
			$fclose(fp4);
			$fclose(fp5);
			$stop;
		end
		
		
	
	end

	function integer abs (input integer a, input integer b);
	integer i;
	begin
		i = a - b;
		abs = i > 0 ? i : -i;
	end
	
	
endfunction
	
endmodule


	