module inicializador_juego (
    input logic clk,
    input logic reset,
    input logic start_inicial,
    input logic [3:0] valor_aleatorio, // viene del generador_aleatorio
    output logic jugador_inicial,      // 0 = J1, 1 = J2
    output logic listo                 // avisa a la FSM que ya puede iniciar
);
    typedef enum logic [1:0] {
        ESPERANDO,
        DECIDIENDO,
        LISTO
    } estado_t;

    estado_t estado_actual, estado_siguiente;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            estado_actual <= ESPERANDO;
        else
            estado_actual <= estado_siguiente;
    end

    always_comb begin
        estado_siguiente = estado_actual;
        case (estado_actual)
            ESPERANDO:
                if (start_inicial)
                    estado_siguiente = DECIDIENDO;

            DECIDIENDO:
                estado_siguiente = LISTO;

            LISTO:
                estado_siguiente = LISTO;
        endcase
    end

		always_ff @(posedge clk or posedge reset) begin
			 if (reset) begin
				  jugador_inicial <= 0;
				  listo <= 0;
			 end else begin
				  case (estado_actual)
						ESPERANDO: begin
							 listo <= 0;
						end
						DECIDIENDO: begin
							 if (estado_siguiente == LISTO)
								  jugador_inicial <= valor_aleatorio[0];
						end
						LISTO: begin
							 listo <= 1;
						end
				  endcase
			 end
		end

endmodule
