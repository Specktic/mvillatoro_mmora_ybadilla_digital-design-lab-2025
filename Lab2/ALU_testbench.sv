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

    // --- Prueba 5: Resta con overflow: -8 - 1 = -9 (fuera de rango)
    A = 4'b1000; // -8
    B = 4'b0001; // 1
    op = Sub;
    #10;
    $display("Resta ovf: %b - %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);
	 
	 // --- Prueba 6: 3 * -2 = -6
    A = 4'b0011;
    B = 4'b1110; // -2
    op = Mult;
    #10;
    $display("Multiplicacion: %b * %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);
	 
	 
	 // --- Prueba 7: 3 * -2 = -6
    A = 4'b0011;
    B = 4'b1110; // -2
    op = Mult;
    #10;
    $display("Multiplicacion: %b * %b = %b | Z=%b N=%b V=%b C=%b", A, B, out, Z, Nf, V, Cout);
	 
	     // --- Prueba 8: 6 / 2 = 3
    A = 4'b0110;
    B = 4'b0010;
    op = Div;
    #10;
    $display("Division : %b / %b = %b", A, B, out);

    // --- Prueba 9: -8 / 2 = -4
    A = 4'b1000; // -8
    B = 4'b0010; // 2
    op = Div;
    #10;
    $display("Division : %b / %b = %b", A, B, out);
	 
	     // --- Prueba 10: 7 % 3 = 1
    A = 4'b0111;
    B = 4'b0011;
    op = Mod;
    #10;
    $display("Modulo   : %b %% %b = %b", A, B, out);

    // --- Prueba 11: -7 % 3 = -1
    A = 4'b1001; // -7 en 4 bits (overflow esperado)
    B = 4'b0011;
    op = Mod;
    #10;
    $display("Modulo   : %b %% %b = %b", A, B, out);


	     // --- Prueba 12: 1101 & 1010 = 1000
    A = 4'b1101;
    B = 4'b1010;
    op = And;
    #10;
    $display("AND      : %b & %b = %b", A, B, out);

    // --- Prueba 13: 1111 & 0000 = 0000
    A = 4'b1111;
    B = 4'b0000;
    op = And;
    #10;
    $display("AND      : %b & %b = %b", A, B, out);

	     // --- Prueba 14: 1100 | 1010 = 1110
    A = 4'b1100;
    B = 4'b1010;
    op = Or;
    #10;
    $display("OR       : %b | %b = %b", A, B, out);

    // --- Prueba 15: 0000 | 0000 = 0000
    A = 4'b0000;
    B = 4'b0000;
    op = Or;
    #10;
    $display("OR       : %b | %b = %b", A, B, out);
	 
	     // --- Prueba 16: 1100 ^ 1010 = 0110
    A = 4'b1100;
    B = 4'b1010;
    op = Xor;
    #10;
    $display("XOR      : %b ^ %b = %b", A, B, out);

    // --- Prueba 17: 1111 ^ 1111 = 0000
    A = 4'b1111;
    B = 4'b1111;
    op = Xor;
    #10;
    $display("XOR      : %b ^ %b = %b", A, B, out);
	 
	     // --- Prueba 18: 0011 <<< 2 = 1100
    A = 4'b0011;
    B = 4'b0010;
    op = LShift;
    #10;
    $display("LShift   : %b <<< %d = %b", A, B, out);

    // --- Prueba 19: 1001 <<< 1 = 0010 (desplazamiento circular si aplica)
    A = 4'b1001;
    B = 4'b0001;
    op = LShift;
    #10;
    $display("LShift   : %b <<< %d = %b", A, B, out);


    // --- Prueba 19: 1100 >>> 2 = 1111 (aritmético, relleno con signo)
    A = 4'b1100; // -4
    B = 4'b0010;
    op = RShift;
    #10;
    $display("RShift   : %b >>> %d = %b", A, B, out);

    // --- Prueba 20: 0100 >>> 1 = 0010
    A = 4'b0100; // 4
    B = 4'b0001;
    op = RShift;
    #10;
    $display("RShift   : %b >>> %d = %b", A, B, out);
	 

    $display("\n=========== FIN DE PRUEBAS ===========\n");
    $stop;
  end

endmodule



