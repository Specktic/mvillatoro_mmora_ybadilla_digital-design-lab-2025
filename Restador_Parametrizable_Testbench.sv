module Restador_Parametrizable_Testbench();
	
	logic clk = 1'b0;
	logic rst; 
	
	// Para el restador N = 2
	parameter n1 = 2;
	logic [n1-1:0] a1;
	logic [n1-1:0] b1;
	logic [n1-1:0] z1;
	
	Restador_Parametrizable #(.n(n1)) Restador_Parametrizable2bits (
		.clk(clk),
		.rst(rst),
		.a(a1),
		.b(b1),
		.z(z1)
	);
	
	// Para el restador N = 4
	parameter n2 = 4;
	logic [n2-1:0] a2;
	logic [n2-1:0] b2;
	logic [n2-1:0] z2;
	
	Restador_Parametrizable #(.n(n2)) Restador_Parametrizable4bits (
		.clk(clk),
		.rst(rst),
		.a(a2),
		.b(b2),
		.z(z2)
	);
	
	// Para el restador N = 6
	parameter n3 = 6;
	logic [n3-1:0] a3;
	logic [n3-1:0] b3;
	logic [n3-1:0] z3;
	
	Restador_Parametrizable #(.n(n3)) Restador_Parametrizable6bits (
		.clk(clk),
		.rst(rst),
		.a(a3),
		.b(b3),
		.z(z3)
	);
	
	// Generador de reloj
	initial begin
		forever begin
			clk = ~clk;
			#5;
		end 
	end
	
	initial begin
		rst = 1;
		#10; 
		rst = 0;
		
		// Casos de prueba 1
		a1 = 2'b11; 		b1 = 2'b01; 		// 3 - 1 = 2
		a2 = 4'b1100;		b2 = 4'b0101;		// 12 - 5 = 7
		a3 = 6'b110101;	b3 = 6'b010010;	// 53 - 18 = 35
		#10;
		
		// Casos de prueba 2
		a1 = 2'b01; 		b1 = 2'b10;			// 1 - 2 = ?
		a2 = 4'b1111;		b2 = 4'b0110;		// 15 - 13 = 2
		a3 = 6'b101010;	b3 = 6'b011001;	// 42 - 25 = 17
		#10;
		
		rst = 1;
		#10; 
		rst = 0;
		
		// Casos de prueba 3
		a1 = 2'b11; 		b1 = 2'b11;			// 3 - 3 = 0
		a2 = 4'b1010;		b2 = 4'b1010;		// 10 - 10 = 0
		a3 = 6'b010101;	b3 = 6'b010101;	// 21 - 21 = 0
		#10;
		
		$finish;
		
	end

endmodule 
