module tablero (
    input logic clk,
    input logic reset,
    input logic escribir,
    input logic [2:0] columna,
    input logic [1:0] jugador,  // 1 o 2
    output logic lleno,
    output logic [1:0] matriz [0:5][0:6]  // Para VGA o revisión externa
);

    logic [1:0] casillas [0:5][0:6]; // 6 filas x 7 columnas

    // Reset de la matriz sin usar foreach
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 6; i = i + 1) begin
                for (int j = 0; j < 7; j = j + 1) begin
                    casillas[i][j] <= 2'b00;
                end
            end
        end else if (escribir) begin
            // Escribe ficha desde abajo hacia arriba
            for (int i = 5; i >= 0; i = i - 1) begin
                if (casillas[i][columna] == 2'b00) begin
                    casillas[i][columna] <= jugador;
                    break;
                end
            end
        end
    end

    // Verifica si la columna está llena (si la fila 0 ya está ocupada)
    assign lleno = (casillas[0][columna] != 2'b00);
    assign matriz = casillas;

endmodule

