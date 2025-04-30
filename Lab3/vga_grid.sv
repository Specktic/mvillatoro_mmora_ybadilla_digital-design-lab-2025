//Modulo para dibujar el grid del juego, los 640x480 se dividen en 6 filas y 7 columnas
module vga_grid (
    input  logic [9:0] h_count,
    input  logic [9:0] v_count,
    input  logic video_on,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

    // Tamaño de las celdas
    localparam CELL_WIDTH  = 91;
    localparam CELL_HEIGHT = 80;

    // Ancho de la línea de separación entre celdas
    localparam LINE_THICKNESS = 2;

    // Calculamos en qué fila y columna estamos
    logic [2:0] col;
    logic [2:0] row;

    assign col = h_count / CELL_WIDTH;
    assign row = v_count / CELL_HEIGHT;

    logic is_line;

    always_comb begin
        if (!video_on) begin
            // background pantalla negra
            red   = 8'd0;
            green = 8'd0;
            blue  = 8'd0;
        end else begin
            // borde de una celda (para dibujar las lineas del grid)
            if ((h_count % CELL_WIDTH < LINE_THICKNESS) || 
                (v_count % CELL_HEIGHT < LINE_THICKNESS)) begin
                // Dibujar linea de celda black
                red   = 8'd0;
                green = 8'd0;
                blue  = 8'd0;
            end else begin
                // Fondo del tablero blue
                red   = 8'd50;
                green = 8'd80;
                blue  = 8'd200;
            end
        end
    end

endmodule
