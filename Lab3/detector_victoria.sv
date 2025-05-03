module detector_victoria (
    input logic [1:0] tablero [0:5][0:6],
    output logic hay_ganador,
    output logic [1:0] jugador_ganador
);

    logic [1:0] actual;

    always_comb begin : all_checks
        hay_ganador = 0;
        jugador_ganador = 0;

        for (int fila = 0; fila < 6; fila++) begin
            for (int col = 0; col < 7; col++) begin
                actual = tablero[fila][col];
                if (actual != 0) begin

                    // Horizontal →
                    if (col <= 3) begin
                        if (actual == tablero[fila][col+1] &&
                            actual == tablero[fila][col+2] &&
                            actual == tablero[fila][col+3]) begin
                            hay_ganador = 1;
                            jugador_ganador = actual;
                            disable all_checks;
                        end
                    end

                    // Vertical ↓
                    if (fila <= 2) begin
                        if (actual == tablero[fila+1][col] &&
                            actual == tablero[fila+2][col] &&
                            actual == tablero[fila+3][col]) begin
                            hay_ganador = 1;
                            jugador_ganador = actual;
                            disable all_checks;
                        end
                    end

                    // Diagonal ↘
                    if (fila <= 2 && col <= 3) begin
                        if (actual == tablero[fila+1][col+1] &&
                            actual == tablero[fila+2][col+2] &&
                            actual == tablero[fila+3][col+3]) begin
                            hay_ganador = 1;
                            jugador_ganador = actual;
                            disable all_checks;
                        end
                    end

                    // Diagonal ↙
                    if (fila <= 2 && col >= 3) begin
                        if (actual == tablero[fila+1][col-1] &&
                            actual == tablero[fila+2][col-2] &&
                            actual == tablero[fila+3][col-3]) begin
                            hay_ganador = 1;
                            jugador_ganador = actual;
                            disable all_checks;
                        end
                    end

                end
            end
        end
    end

endmodule