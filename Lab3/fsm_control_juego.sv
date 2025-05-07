module fsm_control_juego (
    input  logic clk,
    input  logic reset,
    input  logic listo,              // Ya se eligió el jugador inicial
    input  logic place_en,           // Botón presionado
    input  logic auto_jugar,         // Tiempo agotado
    input  logic valid_move,         // Ficha colocada exitosamente
    output logic enable_placer,      // Habilita colocación manual
    output logic enable_auto,        // Habilita colocación automática
    output logic enable_timer        // Habilita contador de tiempo
);

    typedef enum logic [2:0] {
        ESPERA_INICIO,
        JUGADA_MANUAL,
        JUGADA_AUTO,
        CAMBIO_TURNO,
        ESPERA_ESTABILIZACION
    } estado_t;

    estado_t estado_actual, estado_siguiente;

    // === Estado siguiente ===
    always_comb begin
        estado_siguiente = estado_actual;

        unique case (estado_actual)
            ESPERA_INICIO: begin
                if (listo)
                    estado_siguiente = JUGADA_MANUAL;
            end

            JUGADA_MANUAL: begin
                if (place_en)
                    estado_siguiente = ESPERA_ESTABILIZACION;
                else if (auto_jugar)
                    estado_siguiente = JUGADA_AUTO;
            end

            JUGADA_AUTO: begin
                estado_siguiente = ESPERA_ESTABILIZACION;
            end

            ESPERA_ESTABILIZACION: begin
                if (valid_move)
                    estado_siguiente = CAMBIO_TURNO;
            end

            CAMBIO_TURNO: begin
                estado_siguiente = JUGADA_MANUAL;
            end
        endcase
    end

    // === Registro de estado ===
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            estado_actual <= ESPERA_INICIO;
        else
            estado_actual <= estado_siguiente;
    end

    // === Salidas según estado ===
    always_comb begin
        enable_placer  = 0;
        enable_auto    = 0;
        enable_timer   = 0;

        unique case (estado_actual)
            JUGADA_MANUAL: begin
                enable_placer = 1;
                enable_timer  = 1;
            end
            JUGADA_AUTO: begin
                enable_auto   = 1;
            end
        endcase
    end

endmodule
