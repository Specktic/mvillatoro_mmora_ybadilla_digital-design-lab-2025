
import OpCodeEnum::*;

module ALU_testbench #(parameter N=4)();
  logic [N-1:0] A, B;  
   OpCode op;
  logic [N-1:0] out;
  logic [N-1:0] suma_result, resta_result;
  logic carry_out, borrow_out;
  logic [2*N-1:0] mult_result;
  // Flags
  logic Z, Nf, V, Cout, Cin;
  
  // Instancia de la ALU
  ALU #(N) dut (
    .A(A),
    .B(B),
    .op(op),
    .out(out),
    .suma_result(suma_result),
    .carry_out(carry_out),
    .resta_result(resta_result),
    .borrow_out(borrow_out),
    .mult_result(mult_result),
    .Z(Z),
    .Nf(Nf),
    .V(V),
    .Cout(Cout),
    .Cin(Cin)
  );
  
  initial begin
    // --- Prueba 1: Suma 3 + 2 = 5
    Cin = 0;
    A = 4'b0011; // 3
    B = 4'b0010; // 2
    op = Add;
    #10;
    $display("Suma: A=%b, B=%b => resultado=%b, carry_out=%b", A, B, suma_result, carry_out);

    // --- Prueba 2: Resta 7 - 4 = 3
    A = 4'b0011; // 3
    B = 4'b0010; // 2
    op = Sub;
    #10;
    $display("Resta: A=%b, B=%b => resultado=%b, borrow_out=%b", A, B, out, Cout);

    // --- Prueba 3: Multiplicación 3 * 2 = 6
    A = 4'b0011; // 3
    B = 4'b0010; // 2
    op = Mult;
    #10;
    $display("Multiplicación: A=%b, B=%b => resultado=%b (mult_result=%b)", A, B, out, mult_result);


  end
endmodule

