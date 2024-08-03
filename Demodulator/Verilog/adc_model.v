`timescale 1ns / 1ns
module adc_model(input clk, cs, din,
						output dout);
	reg [11:0] signals [6250:0];
	reg [12:0] i;
	reg [7:0] addr;
	reg [11:0] data;
	reg odout;
	initial begin
		addr = 8'dz;
		odout = 1'dz;
		data = 12'dz;
		$readmemh("signal.dat", signals);
		i = 0;
	end
	initial begin
		forever begin
			if(cs) begin
				@ (negedge cs);
				odout = 0;
				data = 12'd0;
			end
			
			//----
				@ (negedge clk); // 1
				@ (posedge clk); // 1
				addr[7] = din;
				
				@ (negedge clk); // 2
				@ (posedge clk); // 2
				addr[6] = din;

				
				@ (negedge clk); // 3
				@ (posedge clk); // 3
				addr[5] = din;

				
				@ (negedge clk); // 4
				@ (posedge clk); // 4
				addr[4] = din;
				
				@ (negedge clk); // 5
				#5;
				addr[3] = din;
				casex(addr)
				8'bxx000xxx: begin
					data = signals[i];
					i = i + 1;
				end
				8'bxx001xxx: data = 12'b01000000_0000;
				8'bxx010xxx: data = 12'b11000000_0000;
				8'bxx011xxx: data = 12'b00100000_0000;
				8'bxx100xxx: data = 12'b10100000_0000;
				8'bxx101xxx: data = 12'b01100000_0000;
				8'bxx110xxx: data = 12'b11100000_0000;
				8'bxx111xxx: data = 12'b00010000_0000;
				default: data = 12'dz;
				endcase
				odout = data[11];
				@ (posedge clk); // 5
				
				
				@ (negedge clk); // 6
				odout = data[10];
				@ (posedge clk); // 6
				addr[2] = din;
				
				@ (negedge clk); // 7
				odout = data[9];
				@ (posedge clk); // 7
				addr[1] = din;
				
				@ (negedge clk); // 8
				odout = data[8];
				@ (posedge clk); // 8
				addr[0] = din;
			
				@ (negedge clk); // 9
				odout = data[7];
				@ (posedge clk); // 9
				
				@ (negedge clk); // 10
				odout = data[6];
				@ (posedge clk); // 10
				
				@ (negedge clk); // 11
				odout = data[5];
				@ (posedge clk); // 11
				
				@ (negedge clk); // 12
				odout = data[4];
				@ (posedge clk); // 12
				
				@ (negedge clk); // 13
				odout = data[3];
				@ (posedge clk); // 13
				
				@ (negedge clk); // 14
				odout = data[2];
				@ (posedge clk); // 14
				
				@ (negedge clk); // 15
				odout = data[1];
				@ (posedge clk); // 15
				
				@ (negedge clk); // 16
				odout = data[0];
				@ (posedge clk); // 16
			
		end
	end
	always @(posedge clk)
		if(i == 6250)
			$stop;


	
	assign dout = odout;
	
endmodule
