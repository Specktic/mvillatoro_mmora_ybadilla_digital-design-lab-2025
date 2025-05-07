module decodificador_7seg (
    input  logic [3:0] bcd,         // Valor binario del 0 al 9 o 10
    output logic [6:0] segmentos    // Salida a -> g para display (anodo común)
);

    always_comb begin
        case (bcd)
			4'd0: segmentos = 7'b100_0000;
			4'd1: segmentos = 7'b111_1001;
			4'd2: segmentos = 7'b010_0100;
			4'd3: segmentos = 7'b011_0000;
			4'd4: segmentos = 7'b001_1001;
			4'd5: segmentos = 7'b001_0010;
			4'd6: segmentos = 7'b000_0010;
			4'd7: segmentos = 7'b111_1000;
			4'd8: segmentos = 7'b000_0000;
			4'd9: segmentos = 7'b001_0000;
			default: segmentos = 7'b111_1111;
        endcase
    end

endmodule
