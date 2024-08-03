`timescale 1ns / 1ns
module testbench_adc();
	
	reg clk1;
	reg rst, go;
	wire data;
	wire sclk;
	wire cs;
	wire [11:0] odata;
	wire addr;
	reg [2:0] ch;
	wire en;
	
	
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
	adc_model adc_model(
				.clk(sclk),
				.cs(cs),
				.din(addr),
				.dout(data)
				);
	initial begin
		rst = 0;
		go = 0;
		ch = 0;
		clk1 = 0;
		#10;
		rst = 1;
		go = 1;
		forever begin
			#10; clk1 = ~clk1;
		end
	
	end
endmodule
