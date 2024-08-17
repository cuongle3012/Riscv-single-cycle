module adder_32bit(
    input logic [31:0] a_i, 
    input logic [31:0] b_i,
    output logic [31:0] re_o,
    output logic c_o
);

    logic [32:0] temp;
    assign temp[0] = 1'b0;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : full_adder_loop
            full_adder A(
                .a_i(a_i[i]), 
                .b_i(b_i[i]), 
                .c_i(temp[i]), 
                .s_o(re_o[i]), 
                .c_o(temp[i + 1])
            );
        end
    endgenerate

    assign c_o = temp[32];

endmodule

