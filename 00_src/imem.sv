module imem( // A read-only memory for fetching instructions
	input logic [31:0] addr_i,
	input logic rst_ni,
	output logic [31:0] inst_o
	);
logic [31:0] mem [4095];
initial begin
		$readmemh("00_src/memfile.txt", mem); 
end
	assign inst_o = mem[addr_i[12:2]];

	
endmodule

	
