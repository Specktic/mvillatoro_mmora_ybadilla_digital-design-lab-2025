module bin_to_bcd(
	input  logic [3:0] bin, //entrada binaria 4 bits =>se ingresa con los switches
	output logic [3:0] decenas, // Salida BCD primer digito (decenas)4 bits
	output logic [3:0] unidades //Salida BCD segundo digito (unidades) 4 bits
);
    //----Conversion de binario a BCD----//
    //-------------Ecuaciones------------//
  
    //Para los del primer digito decenas
	 assign decenas[0] = bin[3] & (bin[2] | bin[1]);
    assign decenas[1] = 0;
    assign decenas[2] = 0;
    assign decenas[3] = 0;
	 
	 //Para los del segundo digito unidades

    assign unidades[0] = bin[0] ^ (bin[3] & bin[1]);
    assign unidades[1] = bin[1] ^ (bin[3] & bin[2]);
    assign unidades[2] = bin[2] & ~bin[3];
    assign unidades[3] = 0;
endmodule