`timescale 1ns / 1ns
module testbench2();
// такая же модель что и testbench, но частота ацп и dss генератора берется из pll 
	reg clk;
	reg rst, go;
	reg [2:0] ch;
	reg [7:0] module_step;
	wire data;
	wire addr;
	wire cs;
	wire sclk;
	wire [9:0] result;
	demodulator dut(
				.clk(clk), 
				.spi_rst(rst),
				.spi_go(go),
				.adc_ch(ch),
				.idout(data), 
				.module_step(module_step),
				.odin(addr),
				.ocs_n(cs),
				.osclk(sclk),
				.amp(result)
				);
	adc_model adc_model(
				.clk(sclk),
				.cs(cs),
				.din(addr),
				.dout(data)
				);
	initial begin 
		clk = 0;
		rst = 0;
		go = 0;
		ch = 0;
		module_step = 1;
		#10;
		rst = 1;
		go = 1;
		forever begin
			#10; clk = ~clk; 
		end
	
	end
endmodule
