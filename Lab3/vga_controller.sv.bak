// modulo principal que utiliza sync_vga y vga_grid 
module vga_controller (
    input  logic clk_25mhz,    // Clock de 25 MHz
    input  logic reset,        // Reset activo en high

    output logic h_sync,       // Salida sync horizontal
    output logic v_sync,       // Salida sync vertical
	 //Canales VGA
    output logic [7:0] red,    // Canal rojo VGA
    output logic [7:0] green,  // Canal verde VGA
    output logic [7:0] blue    // Canal azul VGA
);

    // Señales internas
    logic [9:0] h_count, v_count;
    logic video_on;

    // Se instancian los modulos
	 
	 //sync de señales
    vga_sync sync_inst (
        .clk(clk_25mhz),
        .reset(reset),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on),
        .h_count(h_count),
        .v_count(v_count)
    );

    // grid connect4
    vga_color_grid color_inst (
        .h_count(h_count),
        .v_count(v_count),
        .video_on(video_on),
        .red(red),
        .green(green),
        .blue(blue)
    );

endmodule
