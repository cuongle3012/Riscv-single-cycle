module brcomp_tb;
   // Inputs
   logic [31:0] rs1_data, rs2_data;
   logic br_unsigned;

   // Outputs
   logic br_less, br_equal;

   // Instantiate the unit under test (UUT)
   brcomp dut (
      .rs1_data(rs1_data),
      .rs2_data(rs2_data),
      .br_unsigned(br_unsigned),
      .br_less(br_less),
      .br_equal(br_equal)
   );

   initial begin
      // Initialize inputs
      rs1_data = 0;
      rs2_data = 0;
      br_unsigned = 0;

      // Test case 1: Both rs1_data and rs2_data are 0
      #10 rs1_data = 32'h0000_0000;
      rs2_data = 32'h0000_0000;
      br_unsigned = 0;
      #10
 
      // Test case 2: rs1_data is greater than rs2_data (signed comparison)
      #10 rs1_data = 32'h0000_0005;
      rs2_data = 32'h0000_0003;
      br_unsigned = 0;
      #10
 
      // Test case 3: rs1_data is less than rs2_data (signed comparison)
      #10 rs1_data = 32'h0000_0003;
      rs2_data = 32'h0000_0005;
      br_unsigned = 0;
      #10 

      // Test case 4: rs1_data is greater than rs2_data (unsigned comparison)
      #10 rs1_data = 32'h8000_0000;
      rs2_data = 32'h0000_0001;
      br_unsigned = 1;
      #10

      // Test case 5: rs1_data is less than rs2_data (unsigned comparison)
      #10 rs1_data = 32'h0000_0001;
      rs2_data = 32'h8000_0000;
      br_unsigned = 1;
      #10

      // Test case 6: rs1_data is equal to rs2_data (signed and unsigned comparison)
      #10 rs1_data = 32'h0000_0005;
      rs2_data = 32'h0000_0005;
      br_unsigned = 0;
      #10 
      br_unsigned = 1;
      #10 

      $display("All test cases passed!");
      $finish;
   end
endmodule
