module singlecycle(
	input logic clk_i,
	input logic rst_ni,
	input logic [31:0] io_sw_i,
	output logic [31:0] io_lcd_o,
	output logic [31:0] io_ledg_o,
	output logic [31:0] io_ledr_o,
	output logic [31:0] io_hex0_o,
	output logic [31:0] io_hex1_o,
	output logic [31:0] io_hex2_o,
	output logic [31:0] io_hex3_o,
	output logic [31:0] io_hex4_o,
	output logic [31:0] io_hex5_o,
	output logic [31:0] io_hex6_o,
	output logic [31:0] io_hex7_o
	);
	logic RegWEn_w, Bsel_w, MemRW_w, BrEq_w, BrLt_w, PCSel_w, BrUn_w, Asel_w;
	logic overf_pc_r;
	logic [31:0] pc_w, pc4_w, inst_w, dataWB_w, rs1_w, rs2_w, imm_w, rs2_pre_w, alu_w, dataW_w, mem_w;
	logic [31:0] pc_in_w, rs1_pre_w;
	logic [3:0] AluSel_w;
	logic [1:0] WBSel_w;
	logic [2:0] ImmSel_w;
	
 assign pc4_w = pc_w + 32'h04;

	mux2to1_32bit M0(
		.a_i(pc4_w),
		.b_i(alu_w),
		.se_i(PCSel_w),
		.c_o(pc_in_w)
		);
	
	pc PC(
		.data_in(pc_in_w), 
		//.WE_i(WE_w), 
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.data_o(pc_w)
		);
	
/*	adder_32bit PC_add4(
		.a_i(pc_w),
		.b_i(32'h04),
		.re_o(pc4_w),
		.c_o(overf_pc_r) */

	
	imem IMEM(
		.addr_i(pc_w),
		.rst_ni(rst_ni),
		.inst_o(inst_w)
		);
		
	regfile REG(
		.dataW_i(dataWB_w),
		.rsW_i(inst_w[11:7]),
		.rs1_i(inst_w[19:15]),
		.rs2_i(inst_w[24:20]),
		.RegWEn_i(RegWEn_w),
		.clk_i(clk_i),
		.rst_ni(rst_ni),
		.data1_o(rs1_pre_w),
		.data2_o(rs2_pre_w)
		);
		
	brcomp BC(
		.rs1_data(rs1_pre_w),
		.rs2_data(rs2_pre_w),
		.BrUn_i(BrUn_w),
		.BrL_o(BrLq_w),
		.BrE_o(BrEt_w)
		);
		
	imm_gen IG(
		.inst_i(inst_w[31:7]),
		.ImmSel_i(ImmSel_w),
		.imm_o(imm_w)
		);
		
	mux2to1_32bit M1(
		.a_i(rs2_pre_w),
		.b_i(imm_w),
		.se_i(Bsel_w),
		.c_o(rs2_w)
		);
		
	mux2to1_32bit M2(
		.a_i(rs1_pre_w),
		.b_i(pc_w),
		.se_i(Asel_w),
		.c_o(rs1_w)
		);
		
	alu ALU(
		.operand_a(rs1_w),
		.operand_b(rs2_w),
		.f(AluSel_w),
		.s(alu_w)
		);
		
	lsu LSU(
		.addr_i(alu_w),
		.dataW_i(rs2_pre_w),
		.MemRW_i(MemRW_w),
		.clk_i(clk_i),
		.dataR_o(mem_w),
		.rst_ni(rst_ni),
		.io_sw_i(io_sw_i),
		.io_lcd_o(io_lcd_o),
		.io_ledg_o(io_ledg_o),
		.io_ledr_o(io_ledr_o),
		.io_hex0_o(io_hex0_o),
		.io_hex1_o(io_hex1_o),
		.io_hex2_o(io_hex2_o),
		.io_hex3_o(io_hex3_o),
		.io_hex4_o(io_hex4_o),
		.io_hex5_o(io_hex5_o),
		.io_hex6_o(io_hex6_o),
		.io_hex7_o(io_hex7_o)
		);
		
	mux3to1_32bit M3(
		.a_i(mem_w),
		.b_i(alu_w),
		.c_i(pc4_w),
		.se_i(WBSel_w),
		.r_o(dataWB_w)
		);
		
	ctrl_unit CTRL(
		.inst_i(inst_w),
		.BrEq_i(BrEq_w),
		.BrLt_i(BrLt_w),
		.RegWEn_o(RegWEn_w),
		.AluSel_o(AluSel_w),
		.Bsel_o(Bsel_w),
		.ImmSel_o(ImmSel_w),
		.MemRW_o(MemRW_w),
		.WBSel_o(WBSel_w),
		.BrUn_o(BrUn_w),
		.PCSel_o(PCSel_w),
		.Asel_o(Asel_w)
		);
		
endmodule
