import OpCodeEnum::*;


module ALU #(parameter N=4)(
  input  logic [N-1:0] A,
  input  logic [N-1:0] B,
  input  OpCode op,
  output logic [N-1:0] out,
  output logic [N-1:0] suma_result,
  output logic carry_out,
  //Flags
  output logic Z,   // Zero
  output logic Nf,  // Negative
  output logic V,   // Overflow
  output logic Cout,    // Carry output
  output logic Cin  // carry input
);
  
  // instancia del sumador
  sumador #(.n(N)) operacion_suma(.a(A), .b(B), .cin(Cin), .s(suma_result), .cout(carry_out));
  
  // Operaciones
  always_comb begin
	 Z = 0;
    Nf = 0;
    V = 0;
	 Cin= 0;
    Cout = 0;
    
	 case (op)
      Add:				begin
								out = suma_result; Cout = carry_out;
							end
      Sub:				out = A - B;
		Mult:				out = A * B;
		Div:				out = A / B;
		Mod:				out = A % B;
		And:				out = A & B;
      Or:				out = A | B;
      Xor:				out = A ^ B;
      LShift:			out = A << B;
      RShift:			out = A >> B;

      default:       out = '0;
    endcase
  end
endmodule

module sumador#(parameter n)(
	input logic a, b, //numeros de entrada
	input logic cin, //acarreo de entrada
	output logic s, // resultado de la suma
	output logic cout //acarreo de salida
);
	logic p, g;
	always_comb
		begin
			p = a ^ b; // a XOR b
			g = a & b; // a AND b
			s = p ^ cin; // p XOR cin
			cout = g | (p & cin); // g OR (p AND cin)
		end
endmodule