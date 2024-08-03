`include "Inc/data_type.svh"

// module masterPort(
// 	input logic clk, rst,
// // core to/from port
// 	input logic m_read, m_write,
// 	input logic [3:0] m_dataena,
// 	input logic [3:0] m_burstcount,
// 	input logic [31:0] m_addr,
// 	input logic [31:0] m_wdata,
// 	output logic m_valid,
// 	output logic [31:0] m_rdata,

// // master_port to/from slave_port
// 	input logic [31:0] s_rdata,
// 	input logic readvalid, waitrequest,
// 	output logic s_read, s_write,
// 	output logic [3:0] s_dataena,
// 	output logic [3:0] s_burstcount,
// 	output logic [31:0] s_addr,
// 	output logic [31:0] s_wdata
// );


// 	logic [3:0] data_cnt;
// 	typedef enum logic [2:0] { IDLE, START_READ, READ, WRITE } port_state;
// 	port_state state, next;

//     always_ff @(posedge clk) begin
//         if(~rst) state <= IDLE;
//         else state <= next;
//     end

// // Next state logic
//     always_comb begin 
//         case (state)
//             IDLE: begin
//                 if(m_read) next = START_READ;
// 				else if(m_write) next = WRITE;
//                 else next = IDLE;
//             end
//             START_READ: begin
//                 if(~waitrequest & ~readvalid) next = READ;
//                 else next = START_READ;
//             end
//             READ: begin
//                 if(data_cnt > 4'd0) next = READ;
//                 else next = IDLE;
//             end
// 			WRITE: begin
// 				if(waitrequest) next = WRITE;
// 				else next = IDLE;
// 			end
//             default: next = IDLE;
//         endcase
//     end

// // Output logic
//     always_ff @( posedge clk ) begin
//         if(~rst) begin
//             data_cnt <= '0;
// 			s_read <= '0;
// 			s_write <= '0;
// 			s_dataena <= '0;
// 			s_burstcount <= '0;
// 			s_addr <= '0;
// 			s_wdata <= '0;
//         end
//         else begin
//             case (state)
//                 IDLE: begin
//                     m_valid <= 1'd0;
//                     if(m_read) begin
// 						s_read <= 1'd1;
//                         s_write <= 1'd0;
// 						s_dataena <= m_dataena;
// 						s_addr <= m_addr;
// 						s_burstcount <= m_burstcount;
//                         data_cnt <= m_burstcount;
// 					end 
// 					else if(m_write) begin
// 						s_write <= 1'd1;
//                         s_read <= 1'd0;
// 						s_dataena <= m_dataena;
// 						s_addr <= m_addr;
// 						s_wdata <= m_wdata;
// 						s_burstcount <= 4'd1;
// 					end
// 					else begin
//                         s_read <= 1'd0;
// 						s_write <= 1'd0;
// 					end
//                 end 
//                 START_READ: begin
//                     if(~waitrequest & ~readvalid) s_read <= 1'd0;
//                 end
//                 READ: begin
//                     if(data_cnt > 4'd0) begin
//                         if(readvalid) begin
//                             data_cnt <= data_cnt - 4'd1;
//                             m_rdata <= s_rdata;
//                             m_valid <= 1'd1;
//                         end
//                         else m_valid <= 1'd0;
//                     end
//                     else begin
//                         m_valid <= 1'd0;
//                         s_read <= 1'd0;
//                     end
//                 end
// 				WRITE: begin
// 					if(~waitrequest) begin
// 						m_valid <= 1'd1;
// 						s_write <= 1'd0;
// 					end
// 					else begin
//                         m_valid <= 1'd0;
//                         s_write <= 1'd1;
//                     end
// 				end
//                 default: begin
//                     m_valid <= 1'd0;
// 					s_read <= 1'd0;
//                 end
//             endcase
//         end
//     end

// endmodule

// module masterPort (
// 	input logic clk, rst,
// // core to/from port
//     input   port_transmite_type     cpu2master,
//     output  port_receive_type       master2cpu,
// // master_port to/from slave_port
    
//     output  port_transmite_type     master2slave,
//     input   port_receive_type       slave2master
    

// );


// 	logic [3:0] data_cnt;
// 	typedef enum logic [2:0] { IDLE, START_READ, READ, WRITE } port_state;
// 	port_state state, next;

//     always_ff @(posedge clk) begin
//         if(~rst) state <= IDLE;
//         else state <= next;
//     end

// // Next state logic
//     always_comb begin 
//         case (state)
//             IDLE: begin
//                 if(cpu2master.read) next = START_READ;
// 				else if(cpu2master.write) next = WRITE;
//                 else next = IDLE;
//             end
//             START_READ: begin
//                 if(~slave2master.waitrequest) next = READ;
//                 else next = START_READ;
//             end
//             READ: begin
//                 if(data_cnt > 4'd0) next = READ;
//                 else next = IDLE;
//             end
// 			WRITE: begin
// 				if(slave2master.waitrequest) next = WRITE;
// 				else next = IDLE;
// 			end
//             default: next = IDLE;
//         endcase
//     end

// // Output logic
//     always_ff @( posedge clk ) begin
//         if(~rst) begin
//             data_cnt <= '0;
// 			master2slave.read <= 1'd0;
// 			master2slave.write <= 1'd0;
// 			master2slave.dataena <= 4'd0;
// 			master2slave.burstcount <= 4'd0;
// 			master2slave.addr <= 32'd0;
// 			master2slave.wdata <= 32'd0;

//             master2cpu.waitrequest <= 1'd0;
//             master2cpu.valid <= 1'd0;
//         end
//         else begin
//             case (state)
//                 IDLE: begin
//                     master2cpu.valid <= 1'd0;
//                     if(cpu2master.read) begin
// 						master2slave.read <= 1'd1;
//                         master2slave.write <= 1'd0;
// 						master2slave.dataena <= cpu2master.dataena;
// 						master2slave.addr <= cpu2master.addr;
// 						master2slave.burstcount <= cpu2master.burstcount;
//                         data_cnt <= cpu2master.burstcount;
// 					end 
// 					else if(cpu2master.write) begin
// 						master2slave.write <= 1'd1;
//                         master2slave.read <= 1'd0;
// 						master2slave.dataena <= cpu2master.dataena;
// 						master2slave.addr <= cpu2master.addr;
// 						master2slave.wdata <= cpu2master.wdata;
// 						master2slave.burstcount <= 4'd1;      
// 					end
//                 end 
//                 START_READ: begin
//                     if(~slave2master.waitrequest) master2slave.read <= 1'd0;
//                 end
//                 READ: begin
//                     if(data_cnt > 4'd0) begin
//                         if(slave2master.valid) begin
//                             data_cnt <= data_cnt - 4'd1;
//                             master2cpu.rdata <= slave2master.rdata;
//                             master2cpu.valid <= 1'd1;
//                         end
//                         else master2cpu.valid <= 1'd0;
//                     end
//                     else begin
//                         master2cpu.valid <= 1'd0;
//                     end
//                 end
// 				WRITE: begin
// 					if(~slave2master.waitrequest) begin
// 						master2cpu.valid <= 1'd1;
// 						master2slave.write <= 1'd0;
// 					end
// 					else begin
//                         master2cpu.valid <= 1'd0;
//                         master2slave.write <= 1'd1;
//                     end
// 				end
//                 default: begin
//                     master2cpu.valid <= 1'd0;
//                     master2cpu.waitrequest <= 1'd0;
// 					master2slave.read <= 1'd0;
//                     master2slave.write <= 1'd0;
//                 end
//             endcase
//         end
//     end

// endmodule


`include "Inc/if.svh"

module masterPort (
	input logic clk, rst,

// core to/from port
    port.slave  cpu_master,

// master_port to/from slave_port
    port.master master_slave
);


	logic [3:0] data_cnt;
	typedef enum logic [2:0] { IDLE, START_READ, READ, WRITE } port_state;
	port_state state, next;

    always_ff @(posedge clk) begin
        if(~rst) state <= IDLE;
        else state <= next;
    end

// Next state logic
    always_comb begin 
        case (state)
            IDLE: begin
                if(cpu_master.read) next = START_READ;
				else if(cpu_master.write) next = WRITE;
                else next = IDLE;
            end
            START_READ: begin
                if(~master_slave.waitrequest) next = READ;
                else next = START_READ;
            end
            READ: begin
                if(data_cnt > 4'd0) next = READ;
                else next = IDLE;
            end
			WRITE: begin
				if(master_slave.waitrequest) next = WRITE;
				else next = IDLE;
			end
            default: next = IDLE;
        endcase
    end

// Output logic
    always_ff @( posedge clk ) begin
        if(~rst) begin
            data_cnt <= '0;
			master_slave.read <= 1'd0;
			master_slave.write <= 1'd0;
			master_slave.dataena <= 4'd0;
			master_slave.burstcount <= 2'd0;
			master_slave.addr <= 32'd0;
			master_slave.wdata <= 32'd0;

            cpu_master.waitrequest <= 1'd0;
            cpu_master.valid <= 1'd0;
        end
        else begin
            case (state)
                IDLE: begin
                    cpu_master.valid <= 1'd0;
                    if(cpu_master.read) begin
						master_slave.read <= 1'd1;
                        master_slave.write <= 1'd0;
						master_slave.dataena <= cpu_master.dataena;
						master_slave.addr <= cpu_master.addr;
						master_slave.burstcount <= cpu_master.burstcount;
                        data_cnt <= cpu_master.burstcount;
					end 
					else if(cpu_master.write) begin
						master_slave.write <= 1'd1;
                        master_slave.read <= 1'd0;
						master_slave.dataena <= cpu_master.dataena;
						master_slave.addr <= cpu_master.addr;
						master_slave.wdata <= cpu_master.wdata;
						master_slave.burstcount <= 2'd1;      
					end
                end 
                START_READ: begin
                    if(~master_slave.waitrequest) master_slave.read <= 1'd0;
                end
                READ: begin
                    if(data_cnt > 4'd0) begin
                        if(master_slave.valid) begin
                            data_cnt <= data_cnt - 4'd1;
                            cpu_master.rdata <= master_slave.rdata;
                            cpu_master.valid <= 1'd1;
                        end
                        else cpu_master.valid <= 1'd0;
                    end
                    else begin
                        cpu_master.valid <= 1'd0;
                    end
                end
				WRITE: begin
					if(~master_slave.waitrequest) begin
						cpu_master.valid <= 1'd1;
						master_slave.write <= 1'd0;
					end
					else begin
                        cpu_master.valid <= 1'd0;
                        master_slave.write <= 1'd1;
                    end
				end
                default: begin
                    cpu_master.valid <= 1'd0;
                    cpu_master.waitrequest <= 1'd0;
					master_slave.read <= 1'd0;
                    master_slave.write <= 1'd0;
                end
            endcase
        end
    end

endmodule



