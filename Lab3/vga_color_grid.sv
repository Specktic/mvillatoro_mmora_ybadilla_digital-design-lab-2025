module vga_color_grid (
    input  logic clk_25mhz,
    input  logic [9:0] h_count,
    input  logic [9:0] v_count,
    input  logic video_on,
    input  logic listo,               // Señal: ya se hizo la primera jugada
    input  logic jugador_inicial,    // 0 = FPGA, 1 = Arduino
    input  logic hay_ganador,
    input  logic [1:0] fila_ganadora [3:0],
    input  logic [2:0] col_ganadora [3:0],
    input  logic [1:0] jugador_ganador,
    input  logic [1:0] tablero [0:5][0:6],
	 
	 input logic [2:0] ultima_col,
    input logic [2:0] ultima_fila,
    input logic nueva_jugada_activa,  // 1 si estamos mostrando la animación
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue
);

    localparam CELL_WIDTH  = 91;
    localparam CELL_HEIGHT = 80;

    logic [2:0] col;
    logic [2:0] row;
    assign col = h_count / CELL_WIDTH;
    assign row = v_count / CELL_HEIGHT;

    logic signed [10:0] rel_x;
    logic signed [10:0] rel_y;
    logic [20:0] dist_sq;
    assign rel_x = h_count % CELL_WIDTH - CELL_WIDTH / 2;
    assign rel_y = v_count % CELL_HEIGHT - CELL_HEIGHT / 2;
    assign dist_sq = rel_x * rel_x + rel_y * rel_y;

	 //Borde para la celda y que se vea mas bonito 
	 logic borde_celda;
    assign borde_celda = (h_count % CELL_WIDTH < 2 || h_count % CELL_WIDTH > CELL_WIDTH - 3 ||
                      v_count % CELL_HEIGHT < 2 || v_count % CELL_HEIGHT > CELL_HEIGHT - 3);
	 
    // Parpadeo lento con base en el clock
    logic [25:0] parpadeo_contador;
    logic parpadear;
    always_ff @(posedge clk_25mhz) begin
        parpadeo_contador <= parpadeo_contador + 1;
    end
    assign parpadear = parpadeo_contador[25];

    // Determinar si la celda es parte de la jugada ganadora
    logic es_ganadora;
    always_comb begin
        es_ganadora = 0;
        for (int i = 0; i < 4; i++) begin
            if (fila_ganadora[i] == row && col_ganadora[i] == col)
                es_ganadora = 1;
        end
    end

    always_comb begin
        // Fondo por defecto
        red   = 0;
        green = 0;
        blue  = 0;

        if (!video_on) begin
            red = 0; green = 0; blue = 0;

        end else if (!listo) begin
            // Pantalla inicial: según quién inicia
            if (jugador_inicial == 1'b0) begin
                red = 0; green = 0; blue = 255;  // Azul = FPGA
            end else begin
                red = 255; green = 0; blue = 0;  // Rojo = Arduino
            end

        end else if (hay_ganador) begin
            // Fondo especial según ganador
            if (jugador_ganador == 2'b01) begin // GANÓ J1 (FPGA)
                red = 0; green = 255; blue = 0; // Verde
            end else if (jugador_ganador == 2'b10) begin // GANÓ J2 (Arduino)
                red = 255; green = 128; blue = 0; // Naranja
            end else begin
                red = 255; green = 255; blue = 0; // Empate o error: amarillo
            end

				
								// Mostrar número de columna (fila inferior)
				if (v_count >= 480 && v_count < 500) begin
					 case (col)
						  3'd0: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 1
						  3'd1: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 2
						  3'd2: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 3
						  3'd3: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 4
						  3'd4: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 5
						  3'd5: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 6
						  3'd6: if (h_count % CELL_WIDTH > 30 && h_count % CELL_WIDTH < 60) begin red = 255; green = 255; blue = 255; end // 7
					 endcase
				end

				
				
				
				
				
				
				
				
				
				
				
				
				
				
            // Texto: "PRESIONE KEY0 PARA REINICIAR" (parpadeante)
            if (parpadear && (v_count >= 145 && v_count <= 155)) begin
                if ((h_count >= 270 && h_count <= 275) ||   // P
                    (h_count >= 280 && h_count <= 285) ||   // R
                    (h_count >= 290 && h_count <= 295) ||   // E
                    (h_count >= 300 && h_count <= 305) ||   // S
                    (h_count >= 310 && h_count <= 315) ||   // I
                    (h_count >= 320 && h_count <= 325) ||   // O
                    (h_count >= 330 && h_count <= 335) ||   // N
                    (h_count >= 340 && h_count <= 345) ||   // E
                    (h_count >= 355 && h_count <= 360) ||   // K
                    (h_count >= 365 && h_count <= 370) ||   // E
                    (h_count >= 375 && h_count <= 380) ||   // Y
                    (h_count >= 385 && h_count <= 390) ||   // 0
                    (h_count >= 395 && h_count <= 400) ||   // P
                    (h_count >= 405 && h_count <= 410) ||   // A
                    (h_count >= 415 && h_count <= 420) ||   // R
                    (h_count >= 425 && h_count <= 430) ||   // A
                    (h_count >= 435 && h_count <= 440)) begin // Final
                    red = 255; green = 255; blue = 255; // Blanco
                end
            end

        end else begin
            // Dibujar tablero
            if (row < 6 && col < 7) begin
						if (borde_celda) begin
							 red = 50; green = 50; blue = 50; // Borde gris oscuro
						end else begin
                    case (tablero[row][col])
                        2'b01: begin // Jugador 1 (azul)
                            red   = (dist_sq < 1600) ? 0 : 64;
                            green = 0;
                            blue  = (dist_sq < 1600) ? 255 : 64;
                        end
                        2'b10: begin // Jugador 2 (rojo)
                            red   = (dist_sq < 1600) ? 255 : 64;
                            green = 0;
                            blue  = 0;
                        end
                        default: begin // Casilla vacía
                            red   = 255;
                            green = 255;
                            blue  = 255;
                        end
                    endcase
                end
            end else begin
				
				// Efecto visual al colocar una ficha nueva
				if (nueva_jugada_activa && row == ultima_fila && col == ultima_col) begin
					 if (parpadear) begin
						  red   = 255;
						  green = 255;
						  blue  = 0; // Amarillo brillante
					 end
				end

				
				
                // Fuera del tablero
                red = 128; green = 128; blue = 128;
            end
        end
    end
endmodule
