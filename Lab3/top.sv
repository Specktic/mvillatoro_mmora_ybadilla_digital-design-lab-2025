// modulo principal que utiliza clock_pll para dividir reloj, vga_controller y vga_grid para manejo de se;ales
// y mostrar el tablero de juego
module top (
    input  logic clk_50,  // Clock de 50MHz
    input  logic reset,   // Reset activo en high
    output logic h_sync,  // Salida sync horizontal
    output logic v_sync,  // Salida sync vertical
	 output logic blank_b,     // Señal para forzar negro fuera del área visible
    output logic sync_b,      // Señal de sincronización combinada (VGA_SYNC_N)
    output logic [7:0] red, green, blue, //Canales VGA
	 output logic vga_clk, // Señal del clock VGA (25.175 MHz),
	 input logic check,
	 input logic [5:0] red_player,  // jugador rojo
    input logic [5:0] blue_player, // jugador azul
	 //pruebas con leds
    output logic [7:0] led,  // LEDs para mostrar el contador
    output logic test_led  // LED de prueba para clk_25
);

	 logic [9:0] h_count, v_count;  // Coordenadas de pixeles en la pantalla
	 
	 //clock de 50 a 25 (MHz)
	 logic clk_25;
	 logic pll_locked;
	 
	 logic video_on;
	 
	 // Señal para el contador de frecuencia
    logic [31:0] freq_counter;
	 
	 //instancia del pll
	 clock_pll pll_inst(
			.refclk   (clk_50), // Reloj 50 MHz
			.rst      (reset),    
			.outclk_0 (clk_25), // Salida reloj 25 MHz
			.locked   (pll_locked)  // Señal PLL estable -> se puede usar 
	 );
	 
	 assign vga_clk = clk_25;
	 
	 initial begin
		 $display("Clock 50 MHz: %0d", clk_50);
       $display("Clock 25 MHz: %0d", clk_25);
	 end
	 

    // Instancia controlador vga
	 
    vga_controller controller(
		  .clk(clk_25),
        .reset(~pll_locked),
		  .hsync(h_sync),
		  .vsync(v_sync),
		  .blank_b(blank_b),   
        .sync_b(sync_b),
		  .video_on(video_on),
		  .pixel_x(h_count),
        .pixel_y(v_count)
    );
	 
	 // Instancia del grid, tablero de connect4
	 
	 vga_grid tablero(
		  .clk(clk_25),
		  .reset(reset),
		  .pixel_x(h_count),
		  .pixel_y(v_count),
		  .red_player(red_player),
		  .blue_player(blue_player),
		  .check(check),
		  .video_on(video_on),
		  .red(red),
		  .green(green),
		  .blue(blue)
	 );
		
	 // LEDs de prueba
    always_ff @(posedge clk_25 or posedge reset) begin
        if (reset) begin
            freq_counter <= 32'b0; // Reinicia el contador de frecuencia
            led <= 8'b0;          // Reinicia los LEDs
            test_led <= 1'b0;     // Apaga el LED de prueba
        end else begin
            freq_counter <= freq_counter + 1'b1;
            if (freq_counter == 32'd25000000) begin // Cada segundo (25 MHz)
                freq_counter <= 32'b0;
                led <= led + 1;  // Incrementa los LEDs
                test_led <= ~test_led; // Toggle del LED de prueba
            end
        end
    end

endmodule
