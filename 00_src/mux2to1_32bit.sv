module mux2to1_32bit(
   input logic [31:0] a_i, b_i,
   input logic se_i,
   output logic [31:0] c_o
);

  assign c_o = (se_i) ? b_i : a_i;
endmodule
