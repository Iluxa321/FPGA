module adc_control
(	
input iRST,
input iCLK,
input iGO,
input iDOUT,
input	[2:0] iCH,
output [11:0] odata,
output oDIN,
output oCS_n,
output oSCLK,
output reg en_data // переменная сообщающая апроксиматору о старте работы
);
	wire [2:0] ch_sel;
	wire iCLK_n;
	reg data;
	reg go_en;
	reg sclk;
	reg [3:0] cont;
	reg [3:0] m_cont;
	reg [11:0] adc_data;
	reg [11:0] led;
	
	assign iCLK_n = ~iCLK;
	assign oCS_n = ~go_en;
	assign oSCLK = (go_en) ? iCLK : 1'd1; // clock для ADC
	assign oDIN	= data;
	assign ch_sel = iCH;
	assign odata = led;

	//always@(posedge iGO or negedge iRST)
	always@(posedge iCLK)
	// Начало работы 
	// iGo запускает spi
	// iRST отключает spi
	begin
		if(!iRST)
			go_en	<=	0;
		else
		begin
			if(iGO)
				go_en	<=	1;
		end
	end

	always@(posedge iCLK or negedge go_en)
	// Сброс счетчика при начале работы
	begin
		if(!go_en)
			cont <= 0;
		else
		begin
			if(iCLK) // счетчика считаем по верхнему фронту
				cont <= cont + 4'd1;
		end
	end

	always@(posedge iCLK_n)
	// задрежка на пол такта для шины data
	begin
		if(iCLK_n)
			m_cont <= cont;
	end

	always@(posedge iCLK_n or negedge go_en)
	// Передача адресса 
	begin
		if(!go_en)
			data <= 0;
		else
		begin
			if(iCLK_n)
			begin
				if (cont == 2)
					data	<=	iCH[2];
				else if (cont == 3)
					data	<=	iCH[1];
				else if (cont == 4)
					data	<=	iCH[0];
				else
					data	<=	0;
			end
		end
	end

	always@(posedge iCLK or negedge go_en)
	// Загрузка данных
	begin
		if(!go_en)
		begin
			adc_data	<=	0;
			led <=	8'h00;
		end
		else
		begin
			if(iCLK)
			begin
				if (m_cont == 4)
					adc_data[11] <=	iDOUT;
				else if (m_cont == 5)
					adc_data[10] <=	iDOUT;
				else if (m_cont == 6)
					adc_data[9] <=	iDOUT;
				else if (m_cont == 7)
					adc_data[8]	<=	iDOUT;
				else if (m_cont == 8)
					adc_data[7]	<=	iDOUT;
				else if (m_cont == 9)
					adc_data[6]	<=	iDOUT;
				else if (m_cont == 10)
					adc_data[5]	<=	iDOUT;
				else if (m_cont == 11)
					adc_data[4]	<=	iDOUT;
				else if (m_cont == 12)
					adc_data[3]	<=	iDOUT;
				else if (m_cont == 13)
					adc_data[2]	<=	iDOUT;
				else if (m_cont == 14)
					adc_data[1]	<=	iDOUT;
				else if (m_cont == 15)
					adc_data[0]	<=	iDOUT;
				else if (m_cont == 1)
					led <=	adc_data[11:0];
			end
		end
	end
	
	always @(posedge iCLK)
		en_data <= m_cont == 1;
	endmodule
	