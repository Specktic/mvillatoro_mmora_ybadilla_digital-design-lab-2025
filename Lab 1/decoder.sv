/*
Tabla de Verdad utilizada

| Binary input    |         BCD       | 
|-----------------|-------------------|
| 0000 (0)        | 0000 0000 (00)    |
| 0001 (1)        | 0000 0001 (01)    |
| 0010 (2)        | 0000 0010 (02)    |
| 0011 (3)        | 0000 0011 (03)    |
| 0100 (4)        | 0000 0100 (04)    |
| 0101 (5)        | 0000 0101 (05)    |
| 0110 (6)        | 0000 0110 (06)    |
| 0111 (7)        | 0000 0111 (07)    |
| 1000 (8)        | 0000 1000 (08)    |
| 1001 (9)        | 0000 1001 (09)    |
| 1010 (10)       | 0001 0000 (10)    |
| 1011 (11)       | 0001 0001 (11)    |
| 1100 (12)       | 0001 0010 (12)    |
| 1101 (13)       | 0001 0011 (13)    |
| 1110 (14)       | 0001 0100 (14)    |
| 1111 (15)       | 0001 0101 (15)    | Maximo valor posible es 15 por cantidad de bits =>4
*/

module decoder(
	input  logic [3:0] bin, //entrada binaria 4 bits =>se ingresa con los switches
   output logic [3:0] decenas, // Salida BCD primer digito (decenas)4 bits
   output logic [3:0] unidades //Salida BCD segundo digito (unidades) 4 bits
	//DISPLAY 7 segmentos
	output logic [6:0] display1, //Display 1 es para las decenas
   output logic [6:0] display2  //Display 2 es para las unidades
	
);
  //Conversion de binario a BCD
  always_comb begin
        // Se inicializan las salidas
        decenas = 4'b0000;
        unidades = 4'b0000;

        // numero menor a 10 => implica decenas 0, unidades es el binary
        if (bin < 10) begin
            unidades = bin;
        end 
        // numero es mayor o igual a 10 => implica que si se calculan decenas y unidades
        else begin
            decenas = 4'b0001; // las decenas siempre van a ser 1
            unidades = bin - 10;
        end
    end
	 

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
            default: display1 = 7'b0000000;  // Error
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
            default: display2 = 7'b0000000;  // Error
        endcase
    end
	 
endmodule