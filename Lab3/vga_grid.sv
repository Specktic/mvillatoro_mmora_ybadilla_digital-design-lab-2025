//Modulo para dibujar el grid del juego, los 640x480 se dividen en 6 filas y 7 columnas, logica para dibujar las fichas de cada jugador
module vga_grid (
	 input logic clk,
	 input logic reset,
	 input logic [9:0] pixel_x,  // Coordenada X del pixel actual
    input logic [9:0] pixel_y,  // Coordenada Y del pixel actual
    input logic [5:0] red_player,  // ficha roja
    input logic [5:0] yellow_player,  // ficha azul
	 input logic check,
    input  logic video_on,
	 output logic [7:0] red, green, blue
	 
);

    // Tamaño de las celdas
    localparam CELL_WIDTH  = 91; //7 -> 640
    localparam CELL_HEIGHT = 80; //6 -> 480
	 localparam int BLOCK_SIZE = 40;
    localparam int RADIUS = 20; // radio de los circulos para las fichas
	 
	 // registros para guardar los circulos de las fichas agregadas
	 logic [41:0] red_reg;
    logic [41:0] yellow_reg;
	
    // Ancho de la línea de separación entre celdas
    localparam LINE_THICKNESS = 2;

	 //Actualizar los registros para los circulos de cada jugador
	 
	 //Jugador1 -> rojo
	 
	 always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            red_reg <= 42'b0;
        end else begin
            red_reg[red_player] <= 1'b1;
        end
    end

	 
	 //Jugador2 -> azul
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            yellow_reg <= 42'b0;
        end else if (!check) begin
            yellow_reg[yellow_player] <= 1'b1;
        end
    end
	 
	 // verifica si un punto esta dentro del círculo
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
	 
	 
	 always_comb begin
        // Fondo azul para el color del tablero
        red = 8'h00;
        green = 8'h00;
        blue = 8'hFF;

        if (video_on) begin
            // Dibujar las lineas del tablero en negro
            if ((pixel_x % CELL_WIDTH < 5) || (pixel_y % CELL_HEIGHT < 5)) begin
                red = 8'h00;
                green = 8'h00;
                blue = 8'h00; // Negro -> lineas
            end

            // Dibujar fichas del jugador 1 rojas
            for (int row = 0; row < 6; row++) begin
                for (int col = 0; col < 7; col++) begin
                    if (red_reg[row * 7 + col]) begin
                        if (is_inside_circle(
                            col * CELL_WIDTH + CELL_WIDTH / 2,
                            row * CELL_HEIGHT + CELL_HEIGHT / 2,
                            RADIUS,
                            pixel_x, pixel_y
                        )) begin
                            red = 8'hFF; // Rojo
                            green = 8'h00;
                            blue = 8'h00; 
                        end
                    end
                end
            end

            // Dibujar fichas del jugador 2 azules
            for (int row = 0; row < 6; row++) begin
                for (int col = 0; col < 7; col++) begin
                    if (yellow_reg[row * 7 + col]) begin
                        if (is_inside_circle(
                            col * CELL_WIDTH + CELL_WIDTH / 2,
                            row * CELL_HEIGHT + CELL_HEIGHT / 2,
                            RADIUS,
                            pixel_x, pixel_y
                        )) begin
										//amarillo
                            red = 8'hFF; 
                            green = 8'hFF; 
                            blue = 8'h00; 
                        end
                    end
                end
            end
        end else begin
            // Fuera del area visible -> pantalla negra
            red = 8'h00;
            green = 8'h00;
            blue = 8'h00;
        end
    end
	 

endmodule
