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
    input logic [3:0] bin,
    output logic [6:0] display0,
    output logic [6:0] display1
);

    logic [3:0] decenas, unidades;

    bin_to_bcd converter(
        .bin(bin),
        .decenas(decenas),
        .unidades(unidades)
    );

    bcd_to_7seg display_decenas(
        .bcd(decenas),
        .display(display0)
    );

    bcd_to_7seg display_unidades(
        .bcd(unidades),
        .display(display1)
    );

endmodule

module bin_to_bcd(
    input logic [3:0] bin,
    output logic [3:0] decenas,
    output logic [3:0] unidades
);
    assign decenas[0] = bin[3] & (bin[2] | bin[1]);
    assign decenas[1] = 0;
    assign decenas[2] = 0;
    assign decenas[3] = 0;

    assign unidades[0] = bin[0] ^ (bin[3] & bin[1]);
    assign unidades[1] = bin[1] ^ (bin[3] & bin[2]);
    assign unidades[2] = bin[2] & ~bin[3];
    assign unidades[3] = 0;
endmodule

module bcd_to_7seg(
    input logic [3:0] bcd,
    output logic [6:0] display
);
    always_comb begin
        case (bcd)
            4'b0000: display = 7'b0111111;  // 0
            4'b0001: display = 7'b0000110;  // 1
            4'b0010: display = 7'b1011011;  // 2
            4'b0011: display = 7'b1001111;  // 3
            4'b0100: display = 7'b1100110;  // 4
            4'b0101: display = 7'b1101101;  // 5
            4'b0110: display = 7'b1111101;  // 6
            4'b0111: display = 7'b0000111;  // 7
            4'b1000: display = 7'b1111111;  // 8
            4'b1001: display = 7'b1101111;  // 9
            default: display = 7'b0000000;  // Apagado
        endcase
    end
endmodule




