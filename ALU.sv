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
  input logic [3:0] KEY,           // KEY[3]=Modo, KEY[2]=Suma, KEY[1]=Resta, KEY[0]=Mult
  output logic [6:0] HEX3, HEX2, HEX1, HEX0,
  output logic LED_MODE             // 1 = binario, 0 = decimal
);

  parameter N = 4;

  logic signed [N-1:0] A = SW_A;
  logic signed [N-1:0] B = SW_B;
  logic signed [N-1:0] out;
  logic [N-1:0] suma_result, resta_result;
  logic [2*N-1:0] mult_result;
  logic carry_out, borrow_out;
  logic Z, Nf, V, Cout, Cin;

  OpCode op_sel;
  logic [23:0] letter_timer = 0;
  logic show_letter = 0;

  // Estado anterior de teclas
  logic [3:0] KEY_prev;

  // Modo de visualización: binario o decimal
  logic display_binary = 0;
  logic prev_key3 = 1;
  assign LED_MODE = display_binary;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      op_sel <= Add;
      KEY_prev <= 4'b1111;
      letter_timer <= 0;
      show_letter <= 0;
      display_binary <= 0;
      prev_key3 <= 1;
    end else begin
      // Selección de operación por flanco de bajada
      if (KEY_prev[2] && !KEY[2]) begin
        op_sel <= Add;
        letter_timer <= 24'd12_000_000; // ~1 seg
        show_letter <= 1;
      end else if (KEY_prev[1] && !KEY[1]) begin
        op_sel <= Sub;
        letter_timer <= 24'd12_000_000;
        show_letter <= 1;
      end else if (KEY_prev[0] && !KEY[0]) begin
        op_sel <= Mult;
        letter_timer <= 24'd12_000_000;
        show_letter <= 1;
      end

      // Cambio de modo
      if (prev_key3 && !KEY[3])
        display_binary <= ~display_binary;

      prev_key3 <= KEY[3];
      KEY_prev <= KEY;

      if (letter_timer > 0)
        letter_timer <= letter_timer - 1;
      else
        show_letter <= 0;
    end
  end

  // ALU
  ALU #(N) dut (
    .A(A), .B(B), .op(op_sel), .out(out),
    .suma_result(suma_result),
    .carry_out(carry_out),
    .resta_result(resta_result),
    .borrow_out(borrow_out),
    .mult_result(mult_result),
    .Z(Z), .Nf(Nf), .V(V), .Cout(Cout), .Cin(Cin)
  );

  // Resultado
  logic signed [7:0] result_display;
  logic [3:0] dig0, dig1, dig2;
  logic is_negative;
  integer abs_val;

  always_comb begin
    result_display = (op_sel == Mult) ? mult_result[7:0] : out;
    is_negative = (result_display < 0);
    abs_val = is_negative ? -result_display : result_display;

    dig0 = abs_val % 10;
    dig1 = (abs_val / 10) % 10;
    dig2 = (abs_val / 100) % 10;
  end

  // Mostrar en display
  always_comb begin
    logic [3:0] result_bin = result_display[3:0];

    if (show_letter) begin
      logic [6:0] letter_seg;
      case (op_sel)
        Add:  letter_seg = 7'b000_1000; // A
        Sub:  letter_seg = 7'b001_0010; // S
        Mult: letter_seg = 7'b101_0000; // M
        default: letter_seg = 7'b111_1111;
      endcase
      HEX0 = letter_seg;
      HEX1 = letter_seg;
      HEX2 = letter_seg;
      HEX3 = letter_seg;

    end else if (display_binary) begin
      HEX0 = to_hex7seg_bit(result_bin[0]);
      HEX1 = to_hex7seg_bit(result_bin[1]);
      HEX2 = to_hex7seg_bit(result_bin[2]);
      HEX3 = to_hex7seg_bit(result_bin[3]);

    end else begin
      HEX0 = to_hex7seg_digit(dig0);
      HEX1 = to_hex7seg_digit(dig1);
      HEX2 = to_hex7seg_digit(dig2);
      HEX3 = is_negative ? 7'b011_1111 : 7'b111_1111; // - o apagado
    end
  end

  // Funciones de display
  function automatic logic [6:0] to_hex7seg_digit(input logic [3:0] num);
    case (num)
      4'd0: to_hex7seg_digit = 7'b100_0000;
      4'd1: to_hex7seg_digit = 7'b111_1001;
      4'd2: to_hex7seg_digit = 7'b010_0100;
      4'd3: to_hex7seg_digit = 7'b011_0000;
      4'd4: to_hex7seg_digit = 7'b001_1001;
      4'd5: to_hex7seg_digit = 7'b001_0010;
      4'd6: to_hex7seg_digit = 7'b000_0010;
      4'd7: to_hex7seg_digit = 7'b111_1000;
      4'd8: to_hex7seg_digit = 7'b000_0000;
      4'd9: to_hex7seg_digit = 7'b001_0000;
      default: to_hex7seg_digit = 7'b111_1111;
    endcase
  endfunction

  function automatic logic [6:0] to_hex7seg_bit(input logic bit_val);
    case (bit_val)
      1'b0: to_hex7seg_bit = 7'b100_0000;
      1'b1: to_hex7seg_bit = 7'b111_1001;
      default: to_hex7seg_bit = 7'b111_1111;
    endcase
  endfunction

endmodule



