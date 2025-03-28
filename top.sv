module top( 
  input logic clk,
  input logic rst_n,
  input logic SW_A, SW_B, SW_C, SW_D, SW_E, SW_F, SW_G, SW_H,
  input logic [2:0] KEY,           // KEY[3]=Reset, KEY[2]=Suma, KEY[1]=Resta, KEY[0]=Mult
  output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0

);

  parameter N = 4;


  // Combinar switches en dos números de 4 bits
  logic [3:0] sw_x, sw_y;
  assign sw_x = {SW_A, SW_B, SW_C, SW_D};
  assign sw_y = {SW_E, SW_F, SW_G, SW_H};

  logic signed [N-1:0] A, B;
  assign A = $signed(sw_x);
  assign B = $signed(sw_y);

  logic signed [N-1:0] out;
  logic [N-1:0] suma_result, resta_result;
  logic [2*N-1:0] mult_result;
  logic carry_out, borrow_out;
  logic Z, Nf, V, Cout, Cin;

  OpCode op_sel;
  logic [3:0] KEY_prev;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      op_sel <= Add;
      KEY_prev <= 4'b1111;
    end else begin
      if (KEY_prev[2] && !KEY[2]) op_sel <= Add;
      else if (KEY_prev[1] && !KEY[1]) op_sel <= Sub;
      else if (KEY_prev[0] && !KEY[0]) op_sel <= Mult;

      KEY_prev <= KEY;
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

  // Convertir A, B y resultado a dígitos decimales
  logic signed [7:0] val_a, val_b, val_res;
  logic is_neg_a, is_neg_b, is_neg_res;
  integer abs_a, abs_b, abs_res;
  logic [3:0] A_dig1, A_dig0;
  logic [3:0] B_dig1, B_dig0;
  logic [3:0] R_dig1, R_dig0;

  always_comb begin
    val_a = A;
    val_b = B;
    val_res = (op_sel == Mult) ? mult_result[7:0] : out;

    is_neg_a = (val_a < 0);
    abs_a = is_neg_a ? -val_a : val_a;
    A_dig0 = abs_a % 10;
    A_dig1 = (abs_a / 10) % 10;

    is_neg_b = (val_b < 0);
    abs_b = is_neg_b ? -val_b : val_b;
    B_dig0 = abs_b % 10;
    B_dig1 = (abs_b / 10) % 10;

    is_neg_res = (val_res < 0);
    abs_res = is_neg_res ? -val_res : val_res;
    R_dig0 = abs_res % 10;
    R_dig1 = (abs_res / 10) % 10;
  end

  // Mostrar en displays
  always_comb begin
    // Resultado
    HEX0 = to_hex7seg_digit(R_dig0);
    HEX1 = is_neg_res ? 7'b011_1111 : to_hex7seg_digit(R_dig1);  // '-' o decena
    // B
    HEX2 = to_hex7seg_digit(B_dig0);
    HEX3 = is_neg_b ? 7'b011_1111 : to_hex7seg_digit(B_dig1);
    // A
    HEX4 = to_hex7seg_digit(A_dig0);
    HEX5 = is_neg_a ? 7'b011_1111 : to_hex7seg_digit(A_dig1);
  end

  // Función para convertir dígito decimal a display
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

endmodule

