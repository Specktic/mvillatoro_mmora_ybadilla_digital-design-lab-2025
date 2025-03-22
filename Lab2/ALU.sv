typedef enum {
  Add,
  Sub,
  Mult,
  Div,
  Mod,
  And,
  Or,
  Xor
  LShift,
  RShift,

} OpCode;


module ALU (
  input  logic [7:0] A,
  input  logic [7:0] B,
  input  OpCode      op,
  output logic [7:0] out
);

  always_comb begin
    case (op)
      Add:				out = A + B;
      Sub:				out = A - B;
		Mult:				out = A * B;
		Div:				out = A / B;
		Mod:				out = A % B;
		And:				out = A & B;
      Or:				out = A | B;
      Xor:				out = A ^ B;;
      LShift:			out = A << B;
      RShift:			out = A >> B;

      default:         out = '0;
    endcase
  end

endmodule