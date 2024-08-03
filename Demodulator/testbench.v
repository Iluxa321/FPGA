`timescale 1ns / 1ns
module testbench();
// подключение ацп и dds генератора к апроксиматору
// ацп берет данные из adc_model
	reg clk1, clk2;
	reg rst, go;
	wire data;
	wire sclk;
	wire cs;
	wire [11:0] odata;
	wire addr;
	reg [2:0] ch;
	wire en;
	reg [7:0] modul_step;
	wire [8:0] sin, cos;
	wire [9:0] result;
	// переменный для управления шагом
	reg [9:0] tmp_result;
	reg [3:0] cnt_step;
	//-----------------------------
	
	approximator #(.WIDTH_DATA(10), .WIDTH_SIN_COS(9)) approximator(
					.clk(clk1),
					.en(en),
					.data(odata[11:2]),
					.sin(sin),
					.cos(cos),
					.amp(result)
					);
	adc_control adc_control(	
				.iRST(rst),
				.iCLK(clk1),
				.iGO(go),
				.iDOUT(data),
				.iCH(ch),
				.odata(odata),
				.oDIN(addr),
				.oCS_n(cs),
				.oSCLK(sclk),
				.en_data(en)
				);
	dds_generator dds_generator(
						.clk(clk2), 
						.module_step(modul_step), 
						.cos(cos),
						.sin(sin)
						);
	adc_model adc_model(
				.clk(sclk),
				.cs(cs),
				.din(addr),
				.dout(data)
				);
	initial begin
		clk1 = 0;
		clk2 = 0;
		rst = 0;
		go = 0;
		ch = 0;
		modul_step = 1;
		tmp_result = result;
		cnt_step = 0;
		#100;
		rst = 1;
		go = 1;
		
		
	end
	
	initial begin
		forever begin
			#10; clk1 = ~clk1; 
		end
	end
	
	initial begin
		forever begin
			#160; clk2 = ~clk2; 
		end
	end
	
	always @(posedge clk1) begin
		if(tmp_result !== result) begin
			tmp_result = result;
			cnt_step = cnt_step + 1;
			if(cnt_step == 1) begin
				modul_step = 3;
			end
			else if(cnt_step == 2) begin
				modul_step = 5;
			end
		end
	end
	
	

endmodule

