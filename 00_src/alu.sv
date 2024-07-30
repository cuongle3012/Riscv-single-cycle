module alu(
		input  [31:0] operand_a,
		input  [31:0] operand_b,
		input  [3:0] f,
		output logic [31:0] s
	);

	/*	localparam ADD  = 4'h0;
		localparam SUB  = 4'h1;
		localparam SLT  = 4'h2;
		localparam SLTU = 4'h3;
		localparam XOR  = 4'h4;
		localparam OR   = 4'h5;
		localparam AND  = 4'h6;
		localparam SLL  = 4'h7;
		localparam SRL  = 4'h8;
		localparam SRA  = 4'h9;*/

  logic [31:0] bb, sum, xor_res, or_res, and_res, sll_res, srl_res, sra_res;
  logic sub_en;
  logic slt_res, sltu_res;
  logic [32:0] ua, ub, uc;

  // Subtraction control
  assign sub_en= f[3]|f[1];
  assign bb= {32{sub_en}}^operand_b;
  
  // Adder, Xor, Or, And
  assign sum= operand_a + bb + sub_en;
  assign xor_res= operand_a ^ operand_b;
  assign or_res= operand_a | operand_b;
  assign and_res = operand_a & operand_b;
  
  //SLTU
  assign ua = {1'b0,operand_a};
  assign ub = {1'b0,operand_b};
  assign uc = ua + ~ub + 33'h1;
  
  // Set if less than, set if less than unsign
  assign slt_res = (sum[31]) ? 32'h1 : 32'h0;
  assign sltu_res = (uc[32]) ? 32'h1 : 32'h0;
  
  // Shift left logic, Shift right logic
  assign sll_res = operand_a << operand_b [4:0];
  assign srl_res = operand_a >> operand_b [4:0];
  
  // Shift right arithmetic
  shift_right_arith sra(.a(operand_a),.b(operand_b[4:0]),.c_o(sra_res));
  // Output select
  always_comb
     case(f[2:0])
        3'b000: s = sum;
        3'b001: s = sll_res;
        3'b010: s = slt_res;
        3'b011: s = sltu_res;
        3'b100: s = xor_res;
        3'b101: s = (f[3])? sra_res : srl_res;
        3'b110: s = or_res;
        3'b111: s = and_res;
      endcase
endmodule
  
