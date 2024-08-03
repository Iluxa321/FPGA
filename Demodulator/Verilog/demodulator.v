module demodulator
// модуль соединяющий ацп, dds генератор и апроксиматор
(
input clk, 
input spi_rst,
input spi_go,
input [2:0] adc_ch,
input idout,
//input [7:0] module_step,
output odin,
output ocs_n,
output osclk,
output [9:0] amp
);
	wire clk_adc, clk_dds;
	
	wire [11:0] odata;
	wire en_data;
	reg reg_spi_rst, reg_spi_go;
	//reg [2:0] reg_adc_ch;
	PLL pll(.inclk0(clk), .c0(clk_adc), .c1(clk_dds));
	adc_control adc_control(	
						.iRST(reg_spi_rst),
						.iCLK(clk_adc),
						.iGO(reg_spi_go),
						.iDOUT(idout),
						.iCH(3'd0),
						.odata(odata),
						.oDIN(odin),
						.oCS_n(ocs_n),
						.oSCLK(osclk),
						.en_data(en_data)
						);
	
	wire [8:0] cos, sin;
	wire [7:0] module_step;
	dds_generator dds_generator(
						.clk(clk_dds), 
						.module_step(module_step), 
						.cos(cos),
						.sin(sin)
						);
						
	approximator_opt #(.WIDTH_DATA(10), .WIDTH_SIN_COS(9)) approximator(
						.clk(clk_adc),
						.en(en_data),
						.data(odata[11:2]),
						.sin(sin),
						.cos(cos),
						.amp(amp)
						);
						
	debug debug(
			.probe(amp),  //  probes.probe
			.source(module_step)  // sources.source
			);
	always @(posedge clk_adc) begin // синхронизация
		reg_spi_rst <= spi_rst;
		reg_spi_go <= spi_go;
		//reg_adc_ch<= adc_ch;
	end
endmodule
