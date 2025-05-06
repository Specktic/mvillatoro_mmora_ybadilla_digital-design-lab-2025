module fsm_connect4 (
    input logic clk,
    input logic reset,
	 input logic listo,              // Señal del inicializador_juego
	 input logic jugador_inicial,     // 0 = FPGA (J1), 1 = Arduino (J2)
    input logic jugada_fpga_valida,        // Señal: Jugador 1 hizo jugada
    input logic jugada_arduino_valida,     // Señal: Jugador 2 hizo jugada
    input logic tiempo_agotado,            // Señal: se acabaron los 10 segundos
    input logic juego_terminado,           // Señal: hay ganador o empate
    input logic jugador_actual, // 0 = FPGA, 1 = Arduino
    output logic [2:0] estado_actual,
    output logic enable_timer,             // Habilita temporizador
    output logic reset_timer,              // Reinicia temporizador
    output logic escribir_tablero,         // Permite registrar jugada
    output logic revisar_ganador,          // Activa revisión de victoria
    output logic mostrar_ganador,          // Señal para resaltar línea ganadora
    output logic cambiar_turno             // Cambia de jugador
);

    // Estados codificados como enum
    typedef enum logic [2:0] {
        INICIO,
        ESPERA_JUGADA,
        TIEMPO_AGOTADO_ESTADO,
        ACTUALIZA_TABLERO,
        REVISA_GANADOR,
        GANADOR,
        CAMBIO_TURNO
    } estado_t;

    estado_t estado, siguiente;

    // Registro de estado
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            estado <= INICIO;
        else
            estado <= siguiente;
    end

    // Lógica de transición
    always_comb begin
        // Valores por defecto
        siguiente = estado;
        enable_timer = 0;
        reset_timer = 0;
        escribir_tablero = 0;
        revisar_ganador = 0;
        mostrar_ganador = 0;
        cambiar_turno = 0;

        case (estado)

				INICIO: begin
					 reset_timer = 1;
					 if (listo) begin
						  if (jugador_inicial == 0)
								siguiente = ESPERA_JUGADA; // Jugador FPGA inicia
						  else
								siguiente = ESPERA_JUGADA; // Arduino inicia (pero debes usar cambiar_turno también)
					 end
				end

				ESPERA_JUGADA: begin
					 enable_timer = 1;

					 if ((jugador_actual == 0 && jugada_fpga_valida) ||
						  (jugador_actual == 1 && jugada_arduino_valida))
						  siguiente = ACTUALIZA_TABLERO;
					 else if (tiempo_agotado)
						  siguiente = TIEMPO_AGOTADO_ESTADO;
				end


            TIEMPO_AGOTADO_ESTADO: begin
                escribir_tablero = 1;  // Jugada aleatoria
                siguiente = REVISA_GANADOR;
            end

            ACTUALIZA_TABLERO: begin
                escribir_tablero = 1;
                siguiente = REVISA_GANADOR;
            end

            REVISA_GANADOR: begin
                revisar_ganador = 1;
                if (juego_terminado)
                    siguiente = GANADOR;
                else
                    siguiente = CAMBIO_TURNO;
            end

            GANADOR: begin
                mostrar_ganador = 1;
                // Se queda aquí hasta reset
            end

            CAMBIO_TURNO: begin
                cambiar_turno = 1;
                reset_timer = 1;
                siguiente = ESPERA_JUGADA;
            end

        endcase
    end

    // Para monitorear estado actual si es útil en testbench o VGA
    assign estado_actual = estado;

endmodule
