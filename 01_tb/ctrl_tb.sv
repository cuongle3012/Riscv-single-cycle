//tat ca cac assertion bi fail --> check lai cu phap

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
`define FORWARD	 4'b1111 // in case of grab only immediate value in LUI instruction

// Immediate generation type 
`define I_type 3'b000
`define S_type 3'b001
`define B_type 3'b010
`define J_type 3'b011
`define U_type 3'b100

// Control signal (funct3) for Branch Comparator
`define BEQ  3'b000
`define BNE  3'b001
`define BLT  3'b100
`define BGE  3'b101
`define BLTU 3'b110
`define BGEU 3'b111

module ctrl_tb();
logic [31:0] instr_i;
logic BrEq, BrLt;
logic PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW;
logic [1:0] WBSel;
logic [2:0] ImmSel_o;
logic [3:0] AluSel_o;

ctrl_unit dut (.inst_i(instr_i),
.BrEq_i(BrEq),
.BrLt_i(BrLt),
.PCSel_o(PCSel_o),
.RegWEn_o(RegWEn),
.BrUn_o(BrUn),
.Asel_o(Asel_o),
.Bsel_o(Bsel_o),
.MemRW_o(MemRW),
.WBSel_o(WBSel),
.ImmSel_o(ImmSel_o),
.AluSel_o(AluSel_o)
);

initial begin
instr_i = 32'h0;
BrEq = 1'b0;
BrLt = 1'b0;
$dumpfile("ctrlunitdump.vcd");
$dumpvars;
end

initial begin
$display("TEST 1");	//PASSED
#3;
instr_i = 32'b00000000000000000111010100110111;	//lui x10,7
#1;
assert ((!PCSel_o) && (ImmSel_o == `U_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `FORWARD) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//load gia tri imm vao 20 bit cao cua thanh ghi dich
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);

$display("=================================================");
$display("TEST 2");	//PASSED
#3;
instr_i = 32'b00000000000000000111010100010111;	//auipc x10,7
#1;
assert ((!PCSel_o) && (ImmSel_o == `U_type) && RegWEn && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua PC hien tai + imm roi luu gia tri do vao thanh ghi dich
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 3");	//PASSED
#3;
instr_i = 32'b00000000101000000000001011101111;	//jal x5,10
#1;
assert (PCSel_o && (ImmSel_o == `J_type) && RegWEn && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b10)) $display("PASSED");	//lay gia tri cua PC ke tiep (PC+4) luu vao thanh ghi dich, con tro PC thi nhay toi dia chi (PC+offset)
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 4");	//FAILED--CHECKED--RECHECK INSTR
#3;
instr_i = 32'b00000000000000010000001011100111;	//jalr x5,0(x2)
#1;
assert (PCSel_o && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b10)) $display("PASSED");	//lay gia tri cua PC ke tiep (PC+4) luu vao thanh ghi dich, con tro PC thi nhay toi dia chi (rs1_data+offset)
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 5");	//FAILED
#3;
BrEq = 1'b0;
instr_i = 32'b00000000101001011000010001100011;	//beq x11,x10,8
#1;
assert ((!PCSel_o) && (ImmSel_o == `B_type) && (!RegWEn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#2;
BrEq = 1'b1;
#1;
$display("TEST 5'");	//FAILED
assert (PCSel_o && (ImmSel_o == `B_type) && (!RegWEn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 6");	//FAILED
#3;
instr_i = 32'b00000000101001011001011001100011;	//bne x11,x10,12
#1;
assert ((!PCSel_o) && (ImmSel_o == `B_type) && (!RegWEn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#2;
BrEq = 1'b0;
#1;
$display("TEST 6'");	//FAILED
assert (PCSel_o && (ImmSel_o == `B_type) && (!RegWEn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 7");	//FAILED
#3;
BrLt = 1'b0;
instr_i = 32'b00000001000001111100010001100011;	//blt x15,x16,8
#1;
assert ((!PCSel_o) && (ImmSel_o == `B_type) && (!RegWEn) && (!BrUn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#2;
BrLt = 1'b1;
#1;
$display("TEST 7'");	//FAILED
assert (PCSel_o && (ImmSel_o == `B_type) && (!RegWEn) && (!BrUn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 8");	//FAILED
#3;
instr_i = 32'b00000000110000111101001001100011;	//bge x7,x12,4
#1;
assert ((!PCSel_o) && (ImmSel_o == `B_type) && (!RegWEn) && (!BrUn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#2;
BrLt = 1'b0;
#1;
$display("TEST 8'");	//FAILED
assert (PCSel_o && (ImmSel_o == `B_type) && (!RegWEn) && (!BrUn) && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 9");	//FAILED
#3;
instr_i = 32'b00000000010100011110010001100011;	//bltu x3,x5,8
#1;
assert ((!PCSel_o) && (ImmSel_o == `B_type) && (!RegWEn) && BrUn && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#2;
BrLt = 1'b1;
#1;
$display("TEST 9'");	//FAILED
assert (PCSel_o && (ImmSel_o == `B_type) && (!RegWEn) && BrUn && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 10");	//FAILED
#3;
instr_i = 32'b00000001000001111111010001100011;	//bgeu x15,x16,8
#1;
assert ((!PCSel_o) && (ImmSel_o == `B_type) && (!RegWEn) && BrUn && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#2;
BrLt = 1'b0;
#1;
$display("TEST 10'");	//FAILED
assert (PCSel_o && (ImmSel_o == `B_type) && (!RegWEn) && BrUn && Bsel_o && Asel_o && (AluSel_o == `ADD) && (!MemRW)) $display("PASSED");	//so sanh gia tri cua 2 thanh ghi, neu dung thi nhay toi dia chi(PC+8), con 0 thi tro toi dia chi ke tiep
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 11");
#3;
instr_i = 32'b00000000000000110010101000000011;	//lw x20,0(x6)
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b00)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 12");
#3;
instr_i = 32'b00000000100000011000010000000011;	//lb x8,8(x3)
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b00)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd

else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 13");
#3;
instr_i = 32'b00000000001000011001010000000011;	//lh x8,2(x3)
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b00)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 14");
#3;
instr_i = 32'b00000000000100011100010000000011;	//lbu x8,1(x3)
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b00)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 15");
#3;
instr_i = 32'b00000000000000011101010000000011;	//lhu x8,0(x3)
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b00)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 16");
#3;
instr_i = 32'b00000000100100010010001000100011;	//sw x9,4(x2)
#1;
assert ((!PCSel_o) && (ImmSel_o == `S_type) && (!RegWEn) && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && MemRW) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 17");
#3;
instr_i = 32'b00000000101000011000010110100011;	//sb x10,11(x3)
#1;
assert ((!PCSel_o) && (ImmSel_o == `S_type) && (!RegWEn) && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && MemRW) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 18");
#3;
instr_i = 32'b00000000101000011001010100100011;	//sh x10,10(x3)
#1;
assert ((!PCSel_o) && (ImmSel_o == `S_type) && (!RegWEn) && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && MemRW) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 19");
#3;
instr_i = 32'b11111111101110001000110010010011;	//addi x26,x17,-5
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `ADD) && (WBSel == 2'b01)) $display("PASSED");	//cong nhu cong thanh ghi binh thuong
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 20");	//FAILED
#3;
instr_i = 32'b00000000010110001010110010010011;	//slti x26,x17,5
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `SLT) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 21");	//FAILED
#3;
instr_i = 32'b00000000010110001011110010010011;	//sltiu x26,x17,5
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `SLTU) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 22");
#3;
instr_i = 32'b00000000100110010100001010010011;	//xori x5,x18,9
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `XOR) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 23");
#3;
instr_i = 32'b00000000101100101110011000010011;	//ori x5,x12,11
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `OR) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 24");	//FAILED
#3;
instr_i = 32'b00000000011101001111001010010011;	//andi x5,x9,7
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `AND) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 25");
#3;
instr_i = 32'b00000000011001001001001010010011;	//slli x5,x9,6
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `SLL) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 26");
#3;
instr_i = 32'b00000000001101010101001010010011;	//srli x5,x10,3
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `SRL) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 27");	//FAILED
#3;
instr_i = 32'b01000000110001010101010110010011;	//srai x11,x10,12
#1;
assert ((!PCSel_o) && (ImmSel_o == `I_type) && RegWEn && Bsel_o && (!Asel_o) && (AluSel_o == `SRA) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 28");
#3;
instr_i = 32'b00000000010101010000010110110011;	//add x11,x10,x5
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `ADD) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 29");
#3;
instr_i = 32'b01000000010101010000010110110011;	//sub x11,x10,x5
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `SUB) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 30");
#3;
instr_i = 32'b00000000011100110010010010110011;	//slt x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `SLT) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 31");	//FAILED
#3;
instr_i = 32'b00000000011100110010001010110011;	//sltu x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `SLT) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 32");
#3;
instr_i = 32'b00000000011100110100010010110011;	//xor x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `XOR) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 33");
#3;
instr_i = 32'b00000000011100110110010010110011;	//or x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `OR) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 34");	//FAILED
#3;
instr_i = 32'b00000000011100110111010010110011;	//and x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `AND) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 35");
#3;
instr_i = 32'b00000000011100110001010010110011;	//sll x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `SLL) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 36");
#3;
instr_i = 32'b00000000011100110101010010110011;	//srl x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `SRL) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


$display("=================================================");
$display("TEST 37");
#3;
instr_i = 32'b01000000011100110101010010110011;	//sra x5,x6,x7
#1;
assert ((!PCSel_o) && RegWEn && (!Bsel_o) && (!Asel_o) && (AluSel_o == `SRA) && (!MemRW) && (WBSel == 2'b01)) $display("PASSED");	//lay gia tri cua thanh ghi rs1 + offset wa thanh ghi lsu no se truy ra gia tri cua dia chi o nho do roi ghi vao thanh ghi rd
else $error("Assertion failed");
$display("PCSel: %b, RegWEn: %b, BrUn: %b, ASel: %b, BSel: %b, MemRW: %b, WBSel: %b, ImmSel: %b, AluSel: %b", PCSel_o, RegWEn, BrUn, Asel_o, Bsel_o, MemRW, WBSel, ImmSel_o, AluSel_o);


#10;
$finish();
end

endmodule
