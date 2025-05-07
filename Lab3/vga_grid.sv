// Modulo para dibujar el grid del juego, los 640x480 se dividen en 6 filas y 7 columnas,
// logica para dibujar las fichas de cada jugador y mostrar de quién es el turno
module vga_grid (
    input logic clk,
    input logic reset,
    input logic [9:0] pixel_x,  // Coordenada X del pixel actual
    input logic [9:0] pixel_y,  // Coordenada Y del pixel actual
    input logic [41:0] red_player,     // Mapa completo de fichas rojas
    input logic [41:0] yellow_player,  // Mapa completo de fichas amarillas
    input logic is_red_turn,           // Señal que indica de quién es el turno actual
    input logic video_on,
    output logic [7:0] red, green, blue
);

    // Tamaño de las celdas
    localparam CELL_WIDTH  = 91; // 7 columnas -> 640 px
    localparam CELL_HEIGHT = 80; // 6 filas    -> 480 px
    localparam int RADIUS = 20;  // radio de los círculos para las fichas

    // Registros para mostrar las fichas (vienen de place_piece)
    logic [41:0] red_reg;
    logic [41:0] yellow_reg;

    // Asignación directa desde los mapas de entrada
    assign red_reg    = red_player;
    assign yellow_reg = yellow_player;

    // Ancho de la línea de separación entre celdas
    localparam LINE_THICKNESS = 2;

    // === Función: verificar si un punto está dentro del círculo ===
    function logic is_inside_circle(
        input int center_x, center_y, radius,
        input int pixel_x, pixel_y
    );
        int dx, dy;
        begin
            dx = pixel_x - center_x;
            dy = pixel_y - center_y;
            is_inside_circle = (dx*dx + dy*dy <= radius*radius);
        end
    endfunction

    // === Lógica de dibujo VGA ===
    always_comb begin
        // Fondo por defecto: azul del tablero
        red   = 8'h00;
        green = 8'h00;
        blue  = 8'hFF;

        if (video_on) begin
            // === Mostrar barra de turno en la parte superior ===
            if (pixel_y < 30) begin
                if (is_red_turn) begin
                    // Turno del jugador rojo
                    red   = 8'hFF;
                    green = 8'h00;
                    blue  = 8'h00;
                end else begin
                    // Turno del jugador amarillo
                    red   = 8'hFF;
                    green = 8'hFF;
                    blue  = 8'h00;
                end
            end
            // === Líneas de separación del tablero ===
            else if ((pixel_x % CELL_WIDTH < 5) || (pixel_y % CELL_HEIGHT < 5)) begin
                red   = 8'h00;
                green = 8'h00;
                blue  = 8'h00; // negro
            end
            else begin
                // === Dibujar fichas rojas ===
                for (int row = 0; row < 6; row++) begin
                    for (int col = 0; col < 7; col++) begin
                        if (red_reg[row * 7 + col]) begin
                            if (is_inside_circle(
                                col * CELL_WIDTH + CELL_WIDTH / 2,
                                row * CELL_HEIGHT + CELL_HEIGHT / 2,
                                RADIUS,
                                pixel_x, pixel_y
                            )) begin
                                red   = 8'hFF;
                                green = 8'h00;
                                blue  = 8'h00;
                            end
                        end
                    end
                end

                // === Dibujar fichas amarillas ===
                for (int row = 0; row < 6; row++) begin
                    for (int col = 0; col < 7; col++) begin
                        if (yellow_reg[row * 7 + col]) begin
                            if (is_inside_circle(
                                col * CELL_WIDTH + CELL_WIDTH / 2,
                                row * CELL_HEIGHT + CELL_HEIGHT / 2,
                                RADIUS,
                                pixel_x, pixel_y
                            )) begin
                                red   = 8'hFF;
                                green = 8'hFF;
                                blue  = 8'h00;
                            end
                        end
                    end
                end
            end
        end else begin
            // Fuera del área visible
            red   = 8'h00;
            green = 8'h00;
            blue  = 8'h00;
        end
    end

endmodule

