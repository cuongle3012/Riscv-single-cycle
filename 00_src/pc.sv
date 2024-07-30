module pc(
   input logic [31:0] data_in,
   input logic clk_i,
   input logic rst_ni,
   output logic [31:0] data_o
);
   always_ff @(posedge clk_i) begin
      if (~rst_ni) 
         data_o <= 32'b0;
      else 
         data_o <= data_in;
   end
endmodule

