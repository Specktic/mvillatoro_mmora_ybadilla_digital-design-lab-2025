`timescale 1ns / 1ps
import OpCodeEnum::*;

module ALU_testbench;

  parameter N = 4;

  logic signed [N-1:0] A, B;
  OpCode op;
  logic signed [N-1:0] out;
  logic [N-1:0] suma_result, resta_result;
  logic carry_out, borrow_out;
  logic [2*N-1:0] mult_result;
  logic Z, Nf, V, Cout, Cin;

  // Instancia de la ALU
  ALU #(N) dut (
    .A(A), .B(B), .op(op), .out(out),
    .suma_result(suma_result),
    .carry_out(carry_out),
    .resta_result(resta_result),
    .borrow_out(borrow_out),
    .mult_result(mult_result),
    .Z(Z), .Nf(Nf), .V(V), .Cout(Cout), .Cin(Cin)
  );

  initial begin
    $display("\n========== INICIO DE PRUEBAS ==========\n");

    // --- Prueba 1: 3 + 2 = 5
    A = 4'b0011;
    B = 4'b0010;
    op = Add;
    #10;
    $display("Suma     : %b + %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);

    // --- Prueba 2: 7 + 2 = -7 (overflow)
    A = 4'b0111;
    B = 4'b0010;
    op = Add;
    #10;
    $display("Suma     : %b + %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);

    // --- Prueba 3: 4 + 5 = -7 (overflow)
    A = 4'b0100;
    B = 4'b0101;
    op = Add;
    #10;
    $display("Suma ovf : %b + %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);

    // --- Prueba 4: 7 - 5 = 2
    A = 4'b0111;
    B = 4'b0101;
    op = Sub;
    #10;
    $display("Resta    : %b - %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);

    // --- Prueba 5: 3 * -2 = -6
    A = 4'b0011;
    B = 4'b1110; // -2
    op = Mult;
    #10;
    $display("Mult     : %b * %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);

    // --- Prueba 6: Resta con overflow: -8 - 1 = -9 (fuera de rango)
    A = 4'b1000; // -8
    B = 4'b0001; // 1
    op = Sub;
    #10;
    $display("Resta ovf: %b - %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);

    $display("\n=========== FIN DE PRUEBAS ===========\n");
    $stop;
  end

endmodule



