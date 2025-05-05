module control_jugador (
    input  logic clk,
    input  logic reset,
    input  logic cambiar_turno,      // Desde FSM
    input  logic jugador_inicial,    // Desde inicializador_juego (0 = FPGA, 1 = Arduino)
    input  logic listo,              // Cuando inicializador termina
    output logic jugador_actual      // 0 = FPGA, 1 = Arduino
);

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            jugador_actual <= 0;
        else if (listo)
            jugador_actual <= jugador_inicial;
        else if (cambiar_turno)
            jugador_actual <= ~jugador_actual;
    end

endmodule
