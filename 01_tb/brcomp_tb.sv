module brcomp_tb();

    logic [31:0] rs1_i, rs2_i;
    logic BrUn_i;
    logic BrEq_o, BrLt_o;

    // Instantiate the brcomp module
    brcomp uut (
        .rs1_i(rs1_i),
        .rs2_i(rs2_i),
        .BrUn_i(BrUn_i),
        .BrEq_o(BrEq_o),
        .BrLt_o(BrLt_o)
    );

    initial begin
        $display("Starting testbench...");

        // Test case 1: rs1_i == rs2_i
        rs1_i = 32'd10;
        rs2_i = 32'd10;
        BrUn_i = 0;
        #10;
        $display("Case 1: rs1_i == rs2_i, BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 2: rs1_i < rs2_i, signed comparison
        rs1_i = 32'd5;
        rs2_i = 32'd10;
        BrUn_i = 0;
        #10;
        $display("Case 2: rs1_i < rs2_i (signed), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 3: rs1_i > rs2_i, signed comparison
        rs1_i = 32'd20;
        rs2_i = 32'd10;
        BrUn_i = 0;
        #10;
        $display("Case 3: rs1_i > rs2_i (signed), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 4: rs1_i < rs2_i, unsigned comparison
        rs1_i = 32'd5;
        rs2_i = 32'd10;
        BrUn_i = 1;
        #10;
        $display("Case 4: rs1_i < rs2_i (unsigned), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 5: rs1_i > rs2_i, unsigned comparison
        rs1_i = 32'd20;
        rs2_i = 32'd10;
        BrUn_i = 1;
        #10;
        $display("Case 5: rs1_i > rs2_i (unsigned), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 6: rs1_i < rs2_i, signed comparison with negative values
        rs1_i = -32'd5;
        rs2_i = 32'd10;
        BrUn_i = 0;
        #10;
        $display("Case 6: rs1_i < rs2_i (signed with negative), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 7: rs1_i > rs2_i, signed comparison with negative values
        rs1_i = 32'd10;
        rs2_i = -32'd5;
        BrUn_i = 0;
        #10;
        $display("Case 7: rs1_i > rs2_i (signed with negative), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        // Test case 8: rs1_i < rs2_i, unsigned comparison with high values
        rs1_i = 32'hFFFFFFFF;
        rs2_i = 32'd10;
        BrUn_i = 1;
        #10;
        $display("Case 8: rs1_i < rs2_i (unsigned with high value), BrUn_i = %b => BrEq_o = %b, BrLt_o = %b", BrUn_i, BrEq_o, BrLt_o);

        $display("Testbench completed.");
        $stop;
    end
endmodule

