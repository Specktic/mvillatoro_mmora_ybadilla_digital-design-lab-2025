module detector_victoria (
    input  logic [1:0] tablero [0:5][0:6],
    output logic       hay_ganador,
    output logic [1:0] jugador_ganador,
    output logic [2:0] fila_ganadora [0:3],
    output logic [2:0] col_ganadora [0:3]
);

    logic [1:0] actual;

    always_comb begin : all_checks
        hay_ganador     = 0;
        jugador_ganador = 0;

        // Coordenadas por defecto
        for (int i = 0; i < 4; i++) begin
            fila_ganadora[i] = 3'd0;
            col_ganadora[i]  = 3'd0;
        end

        // Verificación de líneas ganadoras
        for (int fila = 0; fila < 6; fila++) begin
            for (int col = 0; col < 7; col++) begin
                actual = tablero[fila][col];
                if (actual != 0) begin

                    // Horizontal →
                    if (col + 3 < 7 &&
                        actual == tablero[fila][col+1] &&
                        actual == tablero[fila][col+2] &&
                        actual == tablero[fila][col+3]) begin

                        hay_ganador     = 1;
                        jugador_ganador = actual;
                        for (int i = 0; i < 4; i++) begin
                            fila_ganadora[i] = fila;
								col_ganadora[i] = col[2:0] + i[2:0];
                        end
                        disable all_checks;
                    end

                    // Vertical ↓
                    if (fila + 3 < 6 &&
                        actual == tablero[fila+1][col] &&
                        actual == tablero[fila+2][col] &&
                        actual == tablero[fila+3][col]) begin

                        hay_ganador     = 1;
                        jugador_ganador = actual;
                        for (int i = 0; i < 4; i++) begin
                            fila_ganadora[i] = fila + i;
                            col_ganadora[i]  = col;
                        end
                        disable all_checks;
                    end

                    // Diagonal ↘
                    if (fila + 3 < 6 && col + 3 < 7 &&
                        actual == tablero[fila+1][col+1] &&
                        actual == tablero[fila+2][col+2] &&
                        actual == tablero[fila+3][col+3]) begin

                        hay_ganador     = 1;
                        jugador_ganador = actual;
                        for (int i = 0; i < 4; i++) begin
                            fila_ganadora[i] = fila + i;
                            col_ganadora[i]  = col + i;
                        end
                        disable all_checks;
                    end

                    // Diagonal ↙
						 if (fila + 3 < 6 && col >= 3 &&
                        actual == tablero[fila+1][col-1] &&
                        actual == tablero[fila+2][col-2] &&
                        actual == tablero[fila+3][col-3]) begin

                        hay_ganador     = 1;
                        jugador_ganador = actual;
                        for (int i = 0; i < 4; i++) begin
                            fila_ganadora[i] = fila + i;
                            col_ganadora[i]  = col - i;
                        end
                        disable all_checks;
                    end

                end
            end
        end

        // Verificación de empate
        if (!hay_ganador) begin
            logic lleno = 1;
            for (int fila = 0; fila < 6; fila++) begin
                for (int col = 0; col < 7; col++) begin
                    if (tablero[fila][col] == 2'b00)
                        lleno = 0;
                end
            end

            if (lleno) begin
                hay_ganador     = 1;
                jugador_ganador = 2'b11; // Código para empate
            end
        end
    end
endmodule
