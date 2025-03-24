import OpCodeEnum::*;

module ALU_testbench #(parameter N=4)();
	logic [N-1:0] A,B;	
	OpCode op;
	logic [N-1:0] out;
	logic [N-1:0] suma_result;
	logic carry_out;
	//Flags
	logic Z, Nf, V, Cout, Cin;
	
	// Instancia de la ALU
	ALU #(N) dut (
		.A(A),
		.B(B),
		.op(op),
		.out(out),
		.suma_result(suma_result),
		.carry_out(carry_out),
		.Z(Z),
		.Nf(Nf),
		.V(V),
		.Cout(Cout),
		.Cin(Cin)
	);
	
	 initial begin
    // Inicialización
    Cin = 0;

    // Prueba de suma
    A = 4'b0011; B = 4'b0001; op = Add; #10;
    $display("Suma: A=%b, B=%b, out=%b, suma_result=%b, carry_out=%b", A, B, out, suma_result, carry_out);
	 // Finaliza la simulación
    $finish;
	end
endmodule

