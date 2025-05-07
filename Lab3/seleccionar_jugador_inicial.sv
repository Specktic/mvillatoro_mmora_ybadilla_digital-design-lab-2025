module seleccionar_jugador_inicial (
    input  logic clk,
    input  logic reset,
    input  logic boton_elegir,       // Botón para alternar jugador inicial
    input  logic iniciar_juego,      // Señal para fijar el jugador
    output logic jugador_inicial,    // 0 = rojo, 1 = amarillo
    output logic listo               // 1 cuando ya se fijó el jugador
);

    logic boton_elegir_reg, boton_elegir_prev;
    logic jugador_temp;

    // === Detección de flanco de subida para boton_elegir ===
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            boton_elegir_reg  <= 1'b0;
            boton_elegir_prev <= 1'b0;
        end else begin
            boton_elegir_prev <= boton_elegir_reg;
            boton_elegir_reg  <= boton_elegir;
        end
    end

    logic flanco_subida;
    assign flanco_subida = (boton_elegir_reg && !boton_elegir_prev);

    // === Lógica de selección de jugador ===
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            jugador_temp     <= 1'b0;
            jugador_inicial  <= 1'b0;
            listo            <= 1'b0;
        end else if (!listo) begin
            if (flanco_subida)
                jugador_temp <= ~jugador_temp;

            if (iniciar_juego) begin
                jugador_inicial <= jugador_temp;
                listo <= 1'b1;
            end
        end
    end

endmodule
