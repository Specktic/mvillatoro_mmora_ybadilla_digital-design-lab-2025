module decodificador_7seg (
    input logic [3:0] digito,        // Número a mostrar (0-9)
    output logic [6:0] segmentos     // Salida para display de 7 segmentos (a-g)
);
    /*
        Segmentos:
         a
        ---
      f|   |b
        -g-
      e|   |c
        ---
         d

        segmentos[6] = a
        segmentos[5] = b
        segmentos[4] = c
        segmentos[3] = d
        segmentos[2] = e
        segmentos[1] = f
        segmentos[0] = g
    */

    always_comb begin
        case (digito)
            4'd0: segmentos = 7'b1111110;
            4'd1: segmentos = 7'b0110000;
            4'd2: segmentos = 7'b1101101;
            4'd3: segmentos = 7'b1111001;
            4'd4: segmentos = 7'b0110011;
            4'd5: segmentos = 7'b1011011;
            4'd6: segmentos = 7'b1011111;
            4'd7: segmentos = 7'b1110000;
            4'd8: segmentos = 7'b1111111;
            4'd9: segmentos = 7'b1111011;
            default: segmentos = 7'b0000001; // Guión medio para valores inválidos
        endcase
    end

endmodule
