module brcomp(
   input logic [31:0] rs1_i, rs2_i,
   input logic BrUn_i,
   output logic BrEq_o,
   output logic BrLt_o
  
); 
   logic [32:0] ua, ub, uc;
   logic [31:0] c;
   logic less, uless;

   assign ua = {1'b0,rs1_i};
   assign ub = {1'b0,rs2_i};
   assign uc = ua + ~ub + 33'h1;
   assign c = rs1_i + ~rs2_i + 32'h1;
  
   assign less = (c[31]) ? 1'b1 : 1'b0;
   assign uless = (uc[32]) ? 1'b1 : 1'b0;

   assign BrEq_o = ~|c;
   assign BrLt_o = (BrUn_i) ? uless : less;
  
   
endmodule

   

  
