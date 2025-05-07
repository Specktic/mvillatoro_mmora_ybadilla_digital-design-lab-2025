module turno_jugador (
    input  logic clk,
    input  logic reset,
    input  logic listo,             // Señal de que ya se eligió el primer jugador
    input  logic jugador_inicial,   // 0 = rojo, 1 = amarillo
    input  logic ficha_colocada,    // 1 cuando se colocó una ficha válida
    output logic is_red             // 1 si es turno del jugador rojo
);

    logic inicializado;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            is_red <= 1'b0;
            inicializado <= 1'b0;
        end else if (!inicializado && listo) begin
            is_red <= ~jugador_inicial;
            inicializado <= 1'b1;
        end else if (ficha_colocada) begin
            is_red <= ~is_red;
        end
    end

endmodule
