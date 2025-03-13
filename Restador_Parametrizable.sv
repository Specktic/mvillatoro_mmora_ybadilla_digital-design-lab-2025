module Restador_Parametrizable #(parameter n = 2)(
	input logic clk,			// Señal de reloj para el registro
	input logic rst,			// Señal de reset asincrónico
	input logic [n-1:0] a, 	// Primer operando de N bits
	input logic [n-1:0] b, 	// Segundo operando de N bits
	output logic [n-1:0] z	// Resultado de N bits
	);

	always @ (posedge clk or posedge rst) begin
		z <= (rst) ? a : a - b;
	end
	
endmodule 
