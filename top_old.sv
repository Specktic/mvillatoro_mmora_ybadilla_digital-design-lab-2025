 
//Código para probar si funciona en la FPGA
module top(
  input logic clk,
  input logic SW_A,
  input logic SW_B,
  input logic SW_C,
  input logic SW_D,
  input logic SW_E,
  input logic SW_F,
  input logic SW_G,
  input logic SW_H,
  input logic [3:0] KEY,           // KEY[3]=Modo, KEY[2]=Suma, KEY[1]=Resta, KEY[0]=Mult
  output logic [6:0] HEX3, HEX2, HEX1, HEX0,
  output logic LED_MODE            // 1 = binario, 0 = decimal
);

  parameter N = 4;
  logic rst_n;
   assign rst_n = KEY[3];  // activo bajo

  logic signed [N-1:0] A = SW_A;
  logic signed [N-1:0] B = SW_B;
  logic signed [N-1:0] C = SW_C;
  logic signed [N-1:0] D = SW_D;
  logic signed [N-1:0] E = SW_E;
  logic signed [N-1:0] F = SW_F;
  logic signed [N-1:0] G = SW_G;
  logic signed [N-1:0] H = SW_H;
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
	 
//Unidades
    dig0 = abs_val % 10;
    dig1 = (abs_val / 10) % 10;
    dig2 = (abs_val / 100) % 10;
  end
  logic [3:0] result_bin;
  // Mostrar en display
  always_comb begin
    result_bin = result_display[3:0];

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
