module dds_generator
(
input clk,
input [7:0] step,
output rw,
output [7:0] dac_code
);
	wire dac_clk;
	wire [7:0] tmp_sin;
	reg [10:0] total_address = 11'd0;
	wire [8:0] address;
	PLL pll(.inclk0(clk), .c0(dac_clk)); // adc_clk / 16
	ROM rom(.address(address), .clock(dac_clk), .q(tmp_sin)); // addr 0..511; q 0..127
	always @(posedge dac_clk) begin
		total_address <= total_address + step;
	end
	assign address = total_address[9] ? ~total_address[8:0] : total_address[8:0];
	assign dac_code = total_address[10] ? 8'h80 - tmp_sin : 8'h80 + tmp_sin;
	assign rw = ~dac_clk;
endmodule
