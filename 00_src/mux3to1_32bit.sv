module mux3to1_32bit(
			input logic [31:0] a_i, b_i, c_i,
			input logic [1:0] se_i,
			output logic [31:0] r_o
);
			logic [1:0] se_n;
			assign se_n = ~se_i;

			generate
							genvar i;
							for (i = 0; i < 32; i = i + 1) begin : mux_gen
											assign r_o[i] = (a_i[i] & se_n[0] & se_n[1]) | 
																											(b_i[i] & se_n[1] & se_i[0]) | 
																											(c_i[i] & se_i[1] & se_n[0]);
							end
			endgenerate

endmodule

