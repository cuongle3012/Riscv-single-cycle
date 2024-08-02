`define OP_Rtype 		 7'b0110011
`define OP_Itype 		 7'b0010011
`define OP_Itype_load 7'b0000011
`define OP_Stype 		 7'b0100011
`define OP_Btype 		 7'b1100011
`define OP_JAL 		   7'b1101111
`define OP_LUI 		   7'b0110111
`define OP_AUIPC 		 7'b0010111
`define OP_JALR 		  7'b1100111

// ALU function decode from funct3 and bit 5 of funct7
`define ADD  4'b0000
`define SUB  4'b1000
`define SLL  4'b0001
`define SLT  4'b0010
`define SLTU 4'b0011
`define XOR  4'b0100
`define SRL  4'b0101
`define SRA  4'b1101
`define OR   4'b0110
`define AND  4'b0111
`define B	 4'b1111 // in case of grab only immediate value in LUI instruction

// Immediate generation type 
`define I_TYPE 3'b000
`define S_TYPE 3'b001
`define B_TYPE 3'b010
`define J_TYPE 3'b011
`define U_TYPE 3'b100

// Control signal (funct3) for Branch Comparator
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111

module immGen_tb;

    logic  [31:0] instr;
logic [2:0] ImmSel;
    logic [31:0] imm;
	
	imm_gen dut (
    	.inst_i(instr[31:7]),
		.ImmSel_i(ImmSel),
		.imm_o(imm));
	
	initial begin
		instr     = 32'h0;
		$dumpfile("immGendump.vcd");
		$dumpvars;
	end
	
	initial begin
		#3;
		instr = 32'b00000000000000000100001010110111; //lui x5, 4
		ImmSel = `U_TYPE;		
	   #1	
		assert (imm == 32'h4000) $display("PASSED"); else $error("Assertion failed");
      #2
		instr = 32'b00000000000000001011001100010111; //auipc x6, 11
		ImmSel = `U_TYPE;
		#1
	   assert (imm == 32'hb000) $display("PASSED"); else $error("Assertion failed");
      #2
		instr = 32'b00000000100000000000010101101111; //jal x10, 8
		ImmSel = `J_TYPE;
		#1
	   assert (imm == 32'd8) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000110000110000000111100111; //jalr x3, 12(x6)
		ImmSel = `I_TYPE;
		#1
	   assert (imm == 32'd12) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000001001110100000011001100011; //beq x20, x19, 12
		ImmSel = `B_TYPE;
		#1
	   assert (imm == 32'd12) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000001001110100001010101100011; //bne x20, x19, 10
		ImmSel = `B_TYPE;
		#1
	   assert (imm == 32'd10) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000001001110100100001001100011; //blt x20, x19, 4
		ImmSel = `B_TYPE;
		#1
	   assert (imm == 32'd4) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000001001101111101001101100011; //bge x15, x19, 6
		ImmSel = `B_TYPE;
		#1
	   assert (imm == 32'd6) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000010100011110010001100011; // BLTU x3, x5, 8
		ImmSel = `B_TYPE;
		#1
	   assert (imm == 32'd8) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000001000001111111100001100011; // BGEU x15, x16, 16
		ImmSel = `B_TYPE;
		#1
		assert (imm == 32'd16) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000001100010000001010000011; //lb x5, 3(x2)
		ImmSel = `I_TYPE;
		#1
		assert (imm == 32'd3) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000001001111001001100000011; //lh x6, 2(x15)
		ImmSel = `I_TYPE;
		#1
		assert (imm == 32'd2) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000000101111100001100000011; //lbu x6, 1(x15)
		ImmSel = `I_TYPE;
		#1
		assert (imm == 32'd1) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000100001111101001100000011; //lhu x6, 8(x15)
		ImmSel = `I_TYPE;
		#1
		assert (imm == 32'd8) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000010011001111000001000100011; //sb x6, 36(x15)
		ImmSel = `S_TYPE;
		#1
		assert (imm == 32'd36) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000011001111001101000100011; //sh x6, 20(x15)
		ImmSel = `S_TYPE;

		#1
		assert (imm == 32'd20) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000000000110010101000000011; //LW x20, 0(x6)
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'd0) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000100100010010001000100011; //SW x9, 4(x2)
		ImmSel = `S_TYPE;
	
		#1
		assert (imm == 32'd4) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b11111111101110001000110100010011; //ADDI x26, x17, -5
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'b11111111111111111111111111111011) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b11111111101110001010110100010011; //SLTI x26, x17, -5
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'b11111111111111111111111111111011) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000010110001011110100010011; //SLTIU x26, x17, 5
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'd5) $display("PASSED"); else $error("Assertion failed"); //-5 in bin is considered in unsigned number
		#2
		instr = 32'b00000000010110001011110100010011; //SLTIU x26, x17, 5
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'd5) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000100110010100001010010011; //XORI x5, x18, 9
		ImmSel = `I_TYPE;

		#1
	   assert (imm == 32'd9) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000101101100110001010010011; //ORI x5, x12, 11
		ImmSel = `I_TYPE;

		#1
	   assert (imm == 32'd11) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b11111111110101001111001010010011; //ANDI x5, x9, -3
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'b11111111111111111111111111111101) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000011001001001001010010011; //SLLI x5, x9, 6
		ImmSel = `I_TYPE;

		#1
	   assert (imm == 32'd6) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000001101010101001010010011; //SRLI x5, x10, 3
		ImmSel = `I_TYPE;

		#1
		assert (imm == 32'd3) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000110001010101010110010011; //SRAI x11, x10, 12
		ImmSel = `I_TYPE;

		#1
	   assert (imm == 32'd12) $display("PASSED"); else $error("Assertion failed");
		#2
		instr = 32'b00000000010101010000010110110011; //ADD x11, x10, x5
		ImmSel = 3'b111;
		#1
	   assert (imm == 32'd0) $display("PASSED"); else $error("Assertion failed");
		#9 $finish;
	end

endmodule 
