/*Testbench*/

module decoderTestbench();
    logic [3:0] bin; // Entrada binaria para prueba
    logic [3:0] decenas; // Salida esperada => Decenas
    logic [3:0] unidades;// Salida esperada => Unidades
	 // 7 segmentos
	 logic [6:0] display0;
	 logic [6:0] display1;

    // Se instancia el modulo que se probara
    decoder uut (
        .bin(bin),
        //.decenas(decenas),
        //.unidades(unidades)
		  .display1(display0),
        .display2(display1)
    );
	 

	 
/*
Tabla de verdad para guia de los pines para el Display de 7 segmentos:

| Número | A | B | C | D | E | F | G | Código en 7 segmentos |
|--------|---|---|---|---|---|---|---|-----------------------|
| 0      | 1 | 1 | 1 | 1 | 1 | 1 | 0 | 7'b0111111            |
| 1      | 0 | 1 | 1 | 0 | 0 | 0 | 0 | 7'b0000110            |
| 2      | 1 | 1 | 0 | 1 | 1 | 0 | 1 | 7'b1011011            |
| 3      | 1 | 1 | 1 | 1 | 0 | 0 | 1 | 7'b1001111            |
| 4      | 0 | 1 | 1 | 0 | 0 | 1 | 1 | 7'b1100110            |
| 5      | 1 | 0 | 1 | 1 | 0 | 1 | 1 | 7'b1101101            |
| 6      | 1 | 0 | 1 | 1 | 1 | 1 | 1 | 7'b1111101            |
| 7      | 1 | 1 | 1 | 0 | 0 | 0 | 0 | 7'b0000111            |
| 8      | 1 | 1 | 1 | 1 | 1 | 1 | 1 | 7'b1111111            |
| 9      | 1 | 1 | 1 | 1 | 0 | 1 | 1 | 7'b1101111            |

*/

		// Proceso de prueba
    initial begin
        $display("Inicio de la simulación\n");
        $display("Binario | Decenas | Unidades | Display0 | Display1");
        $monitor("%b      | %b     | %b      | %b       | %b", bin, decenas, unidades, display0, display1);

        // Prueba todos los valores del 0 al 15
        for (int i = 0; i < 16; i++) begin
            bin = i;
            #10;  // Espera 10 unidades de tiempo
        end

        $display("Fin de la simulación");
        $finish;
    end

endmodule