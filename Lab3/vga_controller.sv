// Controlador VGA principal que incluye sync y color grid
module vga_controller (
    input  logic clk_25mhz,                       // Clock de 25 MHz
    input  logic reset,                           // Reset activo en high
    input  logic [1:0] tablero [0:5][0:6],        // Tablero del juego

    output logic h_sync,                          // Señal de sincronización horizontal
    output logic v_sync,                          // Señal de sincronización vertical
    output logic [7:0] red,                       // Canal rojo VGA
    output logic [7:0] green,                     // Canal verde VGA
    output logic [7:0] blue                       // Canal azul VGA
);

    // Señales internas
    logic [9:0] h_count, v_count;
    logic video_on;

    // Instancia del generador de sincronización VGA
    sync_vga sync_inst (
        .clk(clk_25mhz),
        .reset(reset),
        .h_count(h_count),
        .v_count(v_count),
        .video_on(video_on),
        .hsync(h_sync),
        .vsync(v_sync)
    );

    // Instancia del renderizador de tablero con fichas
	vga_color_grid color_inst (
		 .h_count(h_count),
		 .v_count(v_count),
		 .video_on(video_on),
		 .tablero(tablero),
		 .red(red),
		 .green(green),
		 .blue(blue)
	);

endmodule
