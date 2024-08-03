//ALTSQRT CBX_SINGLE_OUTPUT_FILE="ON" PIPELINE=0 Q_PORT_WIDTH=69 R_PORT_WIDTH=70 WIDTH=138 q radical remainder
//VERSION_BEGIN 14.1 cbx_mgl 2014:12:03:18:06:09:SJ cbx_stratixii 2014:12:03:18:04:04:SJ cbx_util_mgl 2014:12:03:18:04:04:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463



// Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
//  Your use of Altera Corporation's design tools, logic functions 
//  and other software and tools, and its AMPP partner logic 
//  functions, and any output files from any of the foregoing 
//  (including device programming or simulation files), and any 
//  associated documentation or information are expressly subject 
//  to the terms and conditions of the Altera Program License 
//  Subscription Agreement, the Altera Quartus II License Agreement,
//  the Altera MegaCore Function License Agreement, or other 
//  applicable license agreement, including, without limitation, 
//  that your use is for the sole purpose of programming logic 
//  devices manufactured by Altera and sold by Altera or its 
//  authorized distributors.  Please refer to the applicable 
//  agreement for further details.



//synthesis_resources = ALTSQRT 1 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  mg3u9
	( 
	q,
	radical,
	remainder) /* synthesis synthesis_clearbox=1 */;
	output   [68:0]  q;
	input   [137:0]  radical;
	output   [69:0]  remainder;

	wire  [68:0]   wire_mgl_prim1_q;
	wire  [69:0]   wire_mgl_prim1_remainder;

	ALTSQRT   mgl_prim1
	( 
	.q(wire_mgl_prim1_q),
	.radical(radical),
	.remainder(wire_mgl_prim1_remainder));
	defparam
		mgl_prim1.pipeline = 0,
		mgl_prim1.q_port_width = 69,
		mgl_prim1.r_port_width = 70,
		mgl_prim1.width = 138;
	assign
		q = wire_mgl_prim1_q,
		remainder = wire_mgl_prim1_remainder;
endmodule //mg3u9
//VALID FILE
