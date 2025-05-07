module Temporizador_10s (
    input  logic clk,
    input  logic reset,
    input  logic movimiento,         // Se activa con jugada válida
    output logic tiempo_agotado      // 1 si pasan 10s sin jugada
);

    parameter int CLK_FREQ = 25_000_000;   // 25 MHz
    parameter int LIMITE   = 10 * CLK_FREQ;

    logic [27:0] contador;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            contador <= 0;
            tiempo_agotado <= 0;
        end else if (movimiento) begin
            contador <= 0;
            tiempo_agotado <= 0;
        end else if (!tiempo_agotado) begin
            if (contador < LIMITE) begin
                contador <= contador + 1;
            end else begin
                tiempo_agotado <= 1;
            end
        end
    end

endmodule
