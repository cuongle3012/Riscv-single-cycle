module alu(
		input  [31:0] operand_a,
		input  [31:0] operand_b,
		input  [3:0] f,
		output logic [31:0] s
	);

	 logic [31:0] bb, sum,sub,xor_res, or_res, and_res, sll_res, srl_res, sra_res;
  logic sub_en;
  logic slt_res, sltu_res;
  logic [32:0] ua, ub, uc;

  // Subtraction control
  assign sub_en= f[3]|f[1];
  assign bb= {32{sub_en}}^operand_b;
  
  // Adder, Xor, Or, And
  assign sum= operand_a + operand_b;
  assign sub= operand_a + bb + sub_en;
  assign xor_res= operand_a ^ operand_b;
  assign or_res= operand_a | operand_b;
  assign and_res = operand_a & operand_b;
  
  //SLTU
  assign ua = {1'b0,operand_a};
  assign ub = {1'b0,operand_b};
  assign uc = ua + ~ub + 33'h1;
  
  // Set if less than, set if less than unsign
  assign slt_res = (sub[31]) ? 32'h1 : 32'h0;
  assign sltu_res = (uc[32]) ? 32'h1 : 32'h0;
  
  // Shift left logic, Shift right logic
  assign sll_res = operand_a << operand_b [4:0];
  assign srl_res = operand_a >> operand_b [4:0];
  
  // Shift right arithmetic
  shift_right_arith sra(operand_a,operand_b[4:0], sra_res);
  // Output select
  always_comb
     case(f[3:0])
        4'b0000: s = sum;
        4'b1000: s = sub;
        4'b0001: s = sll_res;
        4'b0010: s = slt_res;
        4'b0011: s = sltu_res;
        4'b0100: s = xor_res;
        4'b0101: s = srl_res;
        4'b1101: s = sra_res;
        4'b0110: s = or_res;
        4'b0111: s = and_res;
        4'b1111: s = operand_b;
      endcase
endmodule
  
