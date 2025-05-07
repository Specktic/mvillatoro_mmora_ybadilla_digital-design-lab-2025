module place_piece (
    input logic clk,             // Reloj
    input logic reset,           // Reset activo en alto
    input logic [6:0] col_switch, // Interruptores para seleccionar columnas (SW[6:0])
    input logic is_red,          // 1 si es ficha roja, 0 si es amarilla
    input logic place_en,        // Señal habilitadora para colocar una ficha
    output logic [41:0] red_player,    // Salida para las posiciones de fichas rojas
    output logic [41:0] yellow_player, // Salida para las posiciones de fichas amarillas
    output logic valid_move       // Indica si la ficha fue colocada exitosamente
);

    // Parámetros del tablero
    localparam ROWS = 6;
    localparam COLS = 7;

    // Registro interno para almacenar el estado del tablero
    logic [41:0] red_reg;
    logic [41:0] yellow_reg;

    // Índice calculado a partir de fila y columna
    logic [5:0] position;
    logic [2:0] selected_col;
    logic [2:0] available_row; // Fila más baja disponible en la columna seleccionada

    // Señal para verificar si la columna es válida
    logic valid_col;
    logic cell_occupied;

    // Determinar la columna seleccionada a partir de los switches
    always_comb begin
        valid_col = 1'b0;
        selected_col = 3'b111; // Valor inválido por defecto

        // Verificar cuál columna está seleccionada
        for (int i = 0; i < COLS; i = i + 1) begin
            if (col_switch[i]) begin
                if (valid_col) begin
                    // Más de un switch activo: movimiento inválido
                    valid_col = 1'b0;
                    selected_col = 3'b111;
                end else begin
                    valid_col = 1'b1;
                    selected_col = i[2:0];
                end
            end
        end
    end

    // Buscar la fila más baja disponible en la columna seleccionada
    always_comb begin
        available_row = 3'b111; // Valor inválido por defecto (indica columna llena)
        if (valid_col) begin
            for (int i = ROWS-1; i >= 0; i = i - 1) begin
                position = i * COLS + selected_col; // Calcula la posición en el registro
                if (!red_reg[position] && !yellow_reg[position]) begin
                    available_row = i[2:0]; // Encuentra la fila disponible
                    break; // Detiene la búsqueda
                end
            end
        end
        cell_occupied = (available_row == 3'b111); // Si no se encontró fila, la columna está llena
    end

    // Lógica para colocar la ficha
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            red_reg <= 42'b0;   // Reinicia el tablero para fichas rojas
            yellow_reg <= 42'b0; // Reinicia el tablero para fichas amarillas
            valid_move <= 1'b0; // Reinicia la señal de movimiento válido
        end else if (place_en && valid_col && !cell_occupied) begin
            position = available_row * COLS + selected_col; // Calcula la posición final
            if (is_red) begin
                red_reg[position] <= 1'b1;      // Coloca la ficha roja
            end else begin
                yellow_reg[position] <= 1'b1;   // Coloca la ficha amarilla
            end
            valid_move <= 1'b1;                 // Indica que el movimiento fue válido
        end else begin
            valid_move <= 1'b0; // Movimiento inválido (columna llena o señal inhabilitada)
        end
    end

    // Conectar registros internos a las salidas
    assign red_player = red_reg;
    assign yellow_player = yellow_reg;

endmodule