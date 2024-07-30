module mux3to1_32bit_tb;

    // Testbench signals
    logic [31:0] a, b, c;
    logic [1:0] sel;
    logic [31:0] r;

    // Instantiate the 3-to-1 multiplexer
    mux3to1_32bit uut (
        .a(a),
        .b(b),
        .c(c),
        .sel(sel),
        .r(r)
    );

    initial begin
        // Initialize inputs
        a = 32'hAAAA_AAAA;
        b = 32'hBBBB_BBBB;
        c = 32'hCCCC_CCCC;

        // Apply test cases
        // Test case 1: se_i = 2'b00, should select a_i
        sel = 2'b00;
        #10;
        //$display("se_i = %b, r_o = %h (expected: %h)", se_i, r_o, a_i);

        // Test case 2: se_i = 2'b01, should select b_i
        sel = 2'b01;
        #10;
        //$display("se_i = %b, r_o = %h (expected: %h)", se_i, r_o, b_i);

        // Test case 3: se_i = 2'b10, should select c_i
        sel = 2'b10;
        #10;
        //$display("se_i = %b, r_o = %h (expected: %h)", se_i, r_o, c_i);

        // Test case 4: se_i = 2'b11, should also select c_i (if applicable)
        sel = 2'b11;
        #10;
       // $display("se_i = %b, r_o = %h (expected: %h)", se_i, r_o, c_i);

        $finish;
    end

endmodule

