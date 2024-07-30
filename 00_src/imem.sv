module imem(
   input logic [31:0] addr_i,
   input logic rst_ni,
   output logic inst_o
);
   logic [31:0] mem[2048]; //8KB
   
   assign inst_o = (rst_ni == 1'b0) ? 32'b0 : mem[addr_i[31:2]];
   
   initial begin 
     // $readmem();
   end
   
endmodule
