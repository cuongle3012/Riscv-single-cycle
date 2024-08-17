
module single_cycle_tb;

logic clk=1'b0;
logic rst_n;
logic [31:0] Pc_o;
logic [31:0] reg_r1;
logic [31:0] reg_r2;
logic [31:0] reg_r3;
logic [31:0] reg_r4;
logic [31:0] reg_r5;
logic [31:0] reg_r6;
logic [31:0] reg_r7;
logic [31:0] reg_r8;
logic [31:0] reg_r9;
logic [31:0] reg_r10;
logic [31:0] io_sw;
logic [31:0] io_lcd, io_ledg, io_ledr, io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;

singlecycle CPU (.clk_i(clk),
		 .rst_ni(rst_n),
   //.data_o(data_o)
		 .io_sw_i(io_sw),
		 .io_lcd_o(io_lcd),
		 .io_ledg_o(io_ledg),
		 .io_ledr_o(io_ledr),
		 .io_hex0_o(io_hex0),
		 .io_hex1_o(io_hex1),
		 .io_hex2_o(io_hex2),
		 .io_hex3_o(io_hex3),
		 .io_hex4_o(io_hex4),
		 .io_hex5_o(io_hex5),
		 .io_hex6_o(io_hex6),
		 .io_hex7_o(io_hex7)
		 );
initial begin
		$dumpfile("Risc-v_processor.vcd");
		$dumpvars(0);
	end
 assign Pc_o = CPU.PC.data_o;	
 assign reg_r1 = CPU.REG.reg_r1_q;	
 assign reg_r2 = CPU.REG.reg_r2_q;	
 assign reg_r3 = CPU.REG.reg_r3_q;	
 assign reg_r4 = CPU.REG.reg_r4_q;	
 assign reg_r5 = CPU.REG.reg_r5_q;	
 assign reg_r6 = CPU.REG.reg_r6_q;	
 assign reg_r7 = CPU.REG.reg_r7_q;	
 assign reg_r8 = CPU.REG.reg_r8_q;	
 assign reg_r9 = CPU.REG.reg_r9_q;	
 assign reg_r10 = CPU.REG.reg_r10_q;	
initial begin
		rst_n <= 1'b0;
		#10;
		
		rst_n <= 1'b1;
		#4000;
		$finish;
	end
	
	always #10 clk = ~clk;

endmodule
