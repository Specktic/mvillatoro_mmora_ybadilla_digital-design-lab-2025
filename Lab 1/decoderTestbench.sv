/*Testbench*/

module decoderTestbench();
    logic [3:0] bin; // Entrada binaria para prueba
    logic [3:0] decenas; // Salida esperada => Decenas
    logic [3:0] unidades;// Salida esperada => Unidades
	 // 7 segmentos
	 logic [6:0] display1;
	 logic [6:0] display2;

    // Se instancia el modulo que se probara
    decoder uut (
        .bin(bin),
        .decenas(decenas),
        .unidades(unidades),
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
	 //Conversion de BCD a mostrar en display 7 segmentos
	 always_comb begin
        // Decenas => primer digito
        case (decenas)
            4'b0000: display1 = 7'b0111111;  // mostraria 0
            4'b0001: display1 = 7'b0000110;  // mostraria 1
            4'b0010: display1 = 7'b1011011;  // mostraria 2
            4'b0011: display1 = 7'b1001111;  // 3
            4'b0100: display1 = 7'b1100110;  // 4
            4'b0101: display1 = 7'b1101101;  // 5
            4'b0110: display1 = 7'b1111101;  // 6
            4'b0111: display1 = 7'b0000111;  // 7
            4'b1000: display1 = 7'b1111111;  // 8
            4'b1001: display1 = 7'b1101111;  // 9
            default: display1 = 7'b0000000;  //Estaria pagado
        endcase

        // Unidades =>> segundo digito del numero
        case (unidades)
            4'b0000: display2 = 7'b0111111;  // mostraria 0
            4'b0001: display2 = 7'b0000110;  // 1
            4'b0010: display2 = 7'b1011011;  // 2
            4'b0011: display2 = 7'b1001111;  // 3
            4'b0100: display2 = 7'b1100110;  // 4
            4'b0101: display2 = 7'b1101101;  // 5
            4'b0110: display2 = 7'b1111101;  // 6
            4'b0111: display2 = 7'b0000111;  // 7
            4'b1000: display2 = 7'b1111111;  // 8
            4'b1001: display2 = 7'b1101111;  // 9
            default: display2 = 7'b0000000;  // Apagado
        endcase
    end
	 

    /* Inicio de la prueba
    initial begin
        //Texto a mostrar 
        $display("Prueba de decodificador de Binario a BCD");
        $display("Binario | Decenas | Unidades");
        
        //se recorren las entradas de la tabla del (0 al 15 en decimal)
        for (int i = 0; i < 16; i++) begin
            bin = i; // Se asigna el valor de prueba
            #10; // Esperamos para evaluar la salida
            
            // resultado
            $display("   %b   |   %b   |   %b   ", bin, decenas, unidades);
        end

        $finish;
    end*/
	 
	 initial begin
    bin = 4'b0000;
    
    // Muestra binarios del 0-9, se usa el #10 para esperar 10 ns para el encendido y apagado
    #10 bin = 4'b0000;  // Muestra 0
    #10 bin = 4'b0001;  // Muestra 1
    #10 bin = 4'b0010;  // Muestra 2
    #10 bin = 4'b0011;  // Muestra 3
    #10 bin = 4'b0100;  // Muestra 4
    #10 bin = 4'b0101;  // Muestra 5
    #10 bin = 4'b0110;  // Muestra 6
    #10 bin = 4'b0111;  // Muestra 7
    #10 bin = 4'b1000;  // Muestra 8
    #10 bin = 4'b1001;  // Muestra 9

    //Muestra binarios del 10-15 (primer digito siempre es 1 => decenas)
    #10 bin = 4'b1010;  // Muestra 10
    #10 bin = 4'b1011;  // Muestra 11
    #10 bin = 4'b1100;  // Muestra 12
    #10 bin = 4'b1101;  // Muestra 13
    #10 bin = 4'b1110;  // Muestra 14
    #10 bin = 4'b1111;  // Muestra 15

    // termina simulación
    #10 $finish;
  end

  // Monitorear los valores
  initial begin
    $monitor("Tiempo=%0t, bin=%b, Decenas=%b, Unidades=%b, Display1=%b, Display2=%b", $time, bin, decenas, unidades, display1, display2);
  end
	 
endmodule
