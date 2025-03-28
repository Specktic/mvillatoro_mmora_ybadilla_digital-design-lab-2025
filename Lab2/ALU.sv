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




