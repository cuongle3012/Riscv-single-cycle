module single_cycle_tb;

logic clk;
logic rst_n;
logic [31:0] io_sw;
logic [31:0] io_lcd, io_ledg, io_ledr, io_hex0, io_hex1, io_hex2, io_hex3, io_hex4, io_hex5, io_hex6, io_hex7;

singlecycle dut (.clk_i(clk),
		 .rst_ni(rst_n),
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
	clk = 1'b0;
	forever #10 clk=~clk;
	$dumpfile("singlecycle.vcd");
	$dumpvars(0);
end

initial begin
rst_n = 1'b0;
#50;

rst_n = 1'b1;


#4000;
$finish;
end

endmodule
