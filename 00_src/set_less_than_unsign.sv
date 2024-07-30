module set_less_than_unsign(
input logic [31:0] rs1_i, rs2_i,
output logic [31:0] rd_o
);
  logic [32:0] u1, u2, u3;
  assign u1 = {1'b0,rs1_i};
  assign u2 = {1'b0,rs2_i};
  assign u3 = u1 + ~u2 + 33'h1;
  assign rd_o = (u3[32]) ? 32'h1:32'h0;	
	
endmodule
