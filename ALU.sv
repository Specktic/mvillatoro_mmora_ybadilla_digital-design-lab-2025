// ==========================
// Módulo sumador estructural
// ==========================
module sumador #(parameter n = 4)(
  input logic [n-1:0] a, b,
  input logic cin,
  output logic [n-1:0] s,
  output logic cout
);
  logic [n:0] carry;
  assign carry[0] = cin;

  genvar i;
  generate
    for (i = 0; i < n; i++) begin : adder_stage
      always_comb begin : logic_block
        s[i] = a[i] ^ b[i] ^ carry[i];
        carry[i+1] = (a[i] & b[i]) | (carry[i] & (a[i] ^ b[i]));
      end
    end
  endgenerate

  assign cout = carry[n];
endmodule

// ==========================
// Módulo restador estructural
// ==========================
module restador #(parameter n = 4)(
  input logic [n-1:0] a, b,
  input logic bin,
  output logic [n-1:0] d,
  output logic bout
);
  logic [n:0] borrow;
  assign borrow[0] = bin;

  genvar i;
  generate
    for (i = 0; i < n; i++) begin : subtractor_stage
      always_comb begin : logic_block
        d[i] = a[i] ^ b[i] ^ borrow[i];
        borrow[i+1] = (~a[i] & b[i]) | (borrow[i] & ~(a[i] ^ b[i]));
      end
    end
  endgenerate

  assign bout = borrow[n];
endmodule

// ============================
// Módulo multiplicador estructural
// ============================
module multiplicador #(parameter N = 4)(
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  output logic [2*N-1:0] result
);
  logic [2*N-1:0] partial_products [N-1:0];
  logic [2*N-1:0] acumulador;

  always_comb begin
    acumulador = '0;
    for (int i = 0; i < N; i++) begin
      partial_products[i] = (B[i]) ? (A << i) : '0;
      acumulador += partial_products[i];
    end
    result = acumulador;
  end
endmodule

// ============================
// Módulo principal ALU
// ============================
import OpCodeEnum::*;

module ALU #(parameter N=4)(
  input  logic signed [N-1:0] A,
  input  logic signed [N-1:0] B,
  input  OpCode op,
  output logic signed [N-1:0] out,
  output logic [N-1:0] suma_result,
  output logic carry_out,
  output logic [N-1:0] resta_result,
  output logic borrow_out,
  output logic [2*N-1:0] mult_result,
  // Flags
  output logic Z,     // Zero
  output logic Nf,    // Negative
  output logic V,     // Overflow
  output logic Cout,  // Carry output
  output logic Cin    // Carry input (control interno)
);
  
  // Instancias de operaciones aritméticas
  sumador #(.n(N)) operacion_suma(.a(A), .b(B), .cin(Cin), .s(suma_result), .cout(carry_out));
  restador #(.n(N)) operacion_resta(.a(A), .b(B), .bin(Cin), .d(resta_result), .bout(borrow_out));
  multiplicador #(.N(N)) mult_logic(.A(A), .B(B), .result(mult_result));

  // Lógica principal
  always_comb begin
    Z = 0;
    Nf = 0;
    V = 0;
    Cin = 0;
    Cout = 0;
    out = '0;

    case (op)
      Add: begin
        out = suma_result;
        Cout = carry_out;
        V = (A[N-1] == B[N-1]) && (out[N-1] != A[N-1]); // overflow con signo
      end

      Sub: begin
        out = resta_result;
        Cout = borrow_out;
        V = (A[N-1] != B[N-1]) && (out[N-1] != A[N-1]); // overflow en resta con signo
      end

      Mult: begin
        out = mult_result[N-1:0];
        Cout = 0;
        V = 0;
      end

      Div:    out = A / B;
      Mod:    out = A % B;
      And:    out = A & B;
      Or:     out = A | B;
      Xor:    out = A ^ B;
      LShift: out = A <<< $unsigned(B);
      RShift: out = A >>> $unsigned(B);

      default: out = '0;
    endcase

    Z = (out == 0);
    Nf = out[N-1];
  end
endmodule



//Código para probar si funciona en la FPGA
module top(
  input logic clk,
  input logic rst_n,
  input logic [3:0] SW_A,
  input logic [3:0] SW_B,
  input logic [2:0] KEY,          // 3 botones: KEY[2]=Suma, KEY[1]=Resta, KEY[0]=Mult
  output logic [6:0] HEX0         // Display de 7 segmentos
);

  parameter N = 4;

  // Internas
  logic signed [N-1:0] A = SW_A;
  logic signed [N-1:0] B = SW_B;
  logic signed [N-1:0] out;
  logic [N-1:0] suma_result, resta_result;
  logic [2*N-1:0] mult_result;
  logic carry_out, borrow_out;
  logic Z, Nf, V, Cout, Cin;

  OpCode op;

  // Lógica para seleccionar la operación
  always_comb begin
    if (!KEY[2])      op = Add;
    else if (!KEY[1]) op = Sub;
    else if (!KEY[0]) op = Mult;
    else              op = Add; // Default
  end

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

  // Muestra resultado en HEX0 (solo valores de 0–9)
  logic [3:0] result_to_display;
  always_comb begin
    if (op == Mult)
      result_to_display = mult_result[3:0]; // parte baja
    else
      result_to_display = out[3:0]; // suma/resta
  end

  assign HEX0 = to_hex7seg(result_to_display);

  // Función para display de 7 segmentos
  function automatic logic [6:0] to_hex7seg(input logic [3:0] num);
    case (num)
      4'd0: to_hex7seg = 7'b100_0000;
      4'd1: to_hex7seg = 7'b111_1001;
      4'd2: to_hex7seg = 7'b010_0100;
      4'd3: to_hex7seg = 7'b011_0000;
      4'd4: to_hex7seg = 7'b001_1001;
      4'd5: to_hex7seg = 7'b001_0010;
      4'd6: to_hex7seg = 7'b000_0010;
      4'd7: to_hex7seg = 7'b111_1000;
      4'd8: to_hex7seg = 7'b000_0000;
      4'd9: to_hex7seg = 7'b001_0000;
      default: to_hex7seg = 7'b111_1111; // apagado
    endcase
  endfunction

endmodule
