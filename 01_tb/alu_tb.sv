module alu_tb;

  // Inputs
  logic [31:0] operand_a;
  logic [31:0] operand_b;
  logic [3:0] f;

  // Output
  logic [31:0] s;

  // Instantiate the ALU module
  alu dut (
    .operand_a(operand_a), 
    .operand_b(operand_b), 
    .f(f), 
    .s(s)
  );

  initial begin
  $shm_open("wave.shm");
    // Initialize Inputs
    operand_a = 32'h0;
    operand_b = 32'h0;
    f = 4'b0000;

    // Wait for global reset
    #10;
    
    // Test ADD operation
    operand_a = 32'h00000010;
    operand_b = 32'h00000020;
    f = 4'b0000; // ADD
    #10;
    $display("ADD: %h + %h = %h", operand_a, operand_b, s);
    
    // Test SUB operation
    operand_a = 32'h00000030;
    operand_b = 32'h00000010;
    f = 4'b1000; // SUB
    #10;
    $display("SUB: %h - %h = %h", operand_a, operand_b, s);
    
    // Test SLL operation
    operand_a = 32'h00000001;
    operand_b = 32'h00000004;
    f = 4'b0001; // SLL
    #10;
    $display("SLL: %h << %h = %h", operand_a, operand_b, s);
    
    // Test SLT operation
    operand_a = 32'h00000010;
    operand_b = 32'h00000020;
    f = 4'b0010; // SLT
    #10;
    $display("SLT: %h < %h = %h", operand_a, operand_b, s);
    
    // Test SLTU operation
    operand_a = 32'hFFFFFFFF;
    operand_b = 32'h00000001;
    f = 4'b0011; // SLTU
    #10;
    $display("SLTU: %h < %h (unsigned) = %h", operand_a, operand_b, s);
    
    // Test XOR operation
    operand_a = 32'hAAAAAAAA;
    operand_b = 32'h55555555;
    f = 4'b0100; // XOR
    #10;
    $display("XOR: %h ^ %h = %h", operand_a, operand_b, s);
    
    // Test SRL operation
    operand_a = 32'h00000010;
    operand_b = 32'h00000002;
    f = 4'b0101; // SRL
    #10;
    $display("SRL: %h >> %h = %h", operand_a, operand_b, s);
    
    // Test SRA operation
    operand_a = 32'h80000000;
    operand_b = 32'h00000002;
    f = 4'b1101; // SRA
    #10;
    $display("SRA: %h >>> %h = %h", operand_a, operand_b, s);

    // Test OR operation
    operand_a = 32'hAAAAAAAA;
    operand_b = 32'h55555555;
    f = 4'b0110; // OR
    #10;
    $display("OR: %h | %h = %h", operand_a, operand_b, s);
    
    // Test AND operation
    operand_a = 32'h01010101;
    operand_b = 32'h10101011;
    f = 4'b0111; // AND
    #10;
    $display("AND: %h & %h = %h", operand_a, operand_b, s);

    // Test MOV operation (Move operand_b to s)
    operand_a = 32'h12345678;
    operand_b = 32'h87654321;
    f = 4'b1111; // MOV
    #10;
    $display("MOV: operand_b = %h -> s = %h", operand_b, s);

    // Finish the simulation
    $finish;
  end
      
endmodule

