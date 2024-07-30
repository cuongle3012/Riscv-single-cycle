module brcomp(
   input logic [31:0] rs1_data, rs2_data,
   input logic BrUn_i,
   output logic BrL_o,
   output logic BrE_o
); 
   logic [32:0] ua, ub, uc;
   logic [31:0] c;
   logic less, uless;

   assign ua = {1'b0,rs1_data};
   assign ub = {1'b0,rs2_data};
   assign uc = ua + ~ub + 33'h1;
   assign c = rs1_data + ~rs2_data + 32'h1;
  
   assign less = (c[31]) ? 1 : 0;
   assign uless = (uc[32]) ? 1 : 0;

   assign BrL_o = (BrUn_i) ? uless : less;
   assign BrE_o = ~|c;
   
endmodule

   

  
