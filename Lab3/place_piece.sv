module place_piece (
    input  logic clk,
    input  logic reset,
    input  logic [6:0] col_switch,     // Un solo switch activo a la vez
    input  logic is_red,               // Turno del jugador: 1 = rojo, 0 = amarillo
    input  logic place_en,             // Pulso para colocar ficha (manual)
    input  logic auto_jugar,           // Señal de tiempo agotado (debe ser un pulso de 1 ciclo)
    input  logic activar_auto,         // Si se permite la jugada automática
    output logic [41:0] red_player,
    output logic [41:0] yellow_player,
    output logic valid_move
);

    localparam ROWS = 6;
    localparam COLS = 7;

    logic [41:0] red_reg, yellow_reg;
    logic [2:0] selected_col;
    logic [2:0] available_row;
    logic valid_col;
    logic [5:0] position;
    logic cell_occupied;

    // Detectar qué columna fue seleccionada (solo un switch activo)
    always_comb begin
        valid_col = 1'b0;
        selected_col = 3'b111;

        for (int i = 0; i < COLS; i++) begin
            if (col_switch[i]) begin
                if (valid_col)
                    valid_col = 1'b0; // error si más de uno activo
                else begin
                    valid_col = 1'b1;
                    selected_col = i[2:0];
                end
            end
        end
    end

    // Buscar fila más baja libre en la columna
    function automatic logic [2:0] buscar_fila (
        input logic [2:0] col,
        input logic [41:0] red_map,
        input logic [41:0] yellow_map,
        output logic ocupado
    );
        logic [2:0] fila_libre = 3'b111;
        ocupado = 1'b1;
        for (int fila = ROWS-1; fila >= 0; fila--) begin
            int pos = fila * COLS + col;
            if (!red_map[pos] && !yellow_map[pos]) begin
                fila_libre = fila[2:0];
                ocupado = 1'b0;
                break;
            end
        end
        return fila_libre;
    endfunction

    // Buscar columna disponible automática (primera que esté libre)
    function automatic logic [2:0] buscar_columna_auto (
        input logic [41:0] red_map,
        input logic [41:0] yellow_map,
        output logic encontrada,
        output logic [2:0] fila_resultado
    );
        encontrada = 0;
        fila_resultado = 3'b111;

        for (int col = 0; col < COLS; col++) begin
            for (int fila = ROWS-1; fila >= 0; fila--) begin
                int pos = fila * COLS + col;
                if (!red_map[pos] && !yellow_map[pos]) begin
                    fila_resultado = fila[2:0];
                    encontrada = 1;
                    return col[2:0];
                end
            end
        end
        return 3'b111;
    endfunction

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            red_reg <= 42'b0;
            yellow_reg <= 42'b0;
            valid_move <= 1'b0;
        end else begin
            logic ocupado;
            logic encontrada;
            logic [2:0] fila;
            logic [2:0] col;
            valid_move <= 1'b0;

            if (place_en && valid_col) begin
                fila = buscar_fila(selected_col, red_reg, yellow_reg, ocupado);
                col = selected_col;

                if (!ocupado) begin
                    position = fila * COLS + col;
                    if (is_red)
                        red_reg[position] <= 1'b1;
                    else
                        yellow_reg[position] <= 1'b1;
                    valid_move <= 1'b1;
                end
            end else if (auto_jugar && activar_auto) begin
                col = buscar_columna_auto(red_reg, yellow_reg, encontrada, fila);
                if (encontrada) begin
                    position = fila * COLS + col;
                    if (is_red)
                        red_reg[position] <= 1'b1;
                    else
                        yellow_reg[position] <= 1'b1;
                    valid_move <= 1'b1;
                end
            end
        end
    end

    assign red_player = red_reg;
    assign yellow_player = yellow_reg;

endmodule

