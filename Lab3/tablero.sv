module tablero (
    input logic clk,
    input logic reset,
    input logic escribir,
    input logic [2:0] columna,
    input logic [1:0] jugador,  // 1 o 2
    output logic lleno,
    output logic [1:0] matriz [0:5][0:6],  // Para VGA o revisión externa
    output logic [2:0] ultima_fila,
    output logic [2:0] ultima_col,
    output logic nueva_jugada_activa
);

    logic [1:0] casillas [0:5][0:6]; // 6 filas x 7 columnas
    logic pulso_jugada;

    // Reset de la matriz sin usar foreach
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            for (int i = 0; i < 6; i = i + 1) begin
                for (int j = 0; j < 7; j = j + 1) begin
                    casillas[i][j] <= 2'b00;
                end
            end
            ultima_fila <= 3'd0;
            ultima_col  <= 3'd0;
            pulso_jugada <= 0;
        end else if (escribir) begin
            for (int i = 5; i >= 0; i = i - 1) begin
                if (casillas[i][columna] == 2'b00) begin
                    casillas[i][columna] <= jugador;
                    ultima_fila <= i;
                    ultima_col  <= columna;
                    pulso_jugada <= 1;
                    break;
                end
            end
        end else begin
            pulso_jugada <= 0;
        end
    end

    // Verifica si la columna está llena (si la fila 0 ya está ocupada)
    assign lleno = (casillas[0][columna] != 2'b00);
    assign matriz = casillas;
    assign nueva_jugada_activa = pulso_jugada;

endmodule