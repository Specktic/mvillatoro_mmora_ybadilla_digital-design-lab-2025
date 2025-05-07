module top (
    input  logic clk_50,       // Clock de 50MHz
    input  logic reset,        // Reset activo en alto
    input  logic [6:0] SW,     // Interruptores (SW[6:0])
    input  logic [0:0] KEY,    // Botón (KEY[0])
    output logic [7:0] led,    // LEDs para depuración
    output logic hsync,        // Señal de sincronización horizontal VGA
    output logic vsync,        // Señal de sincronización vertical VGA
    output logic blank_b,      // Señal para forzar negro fuera del área visible
    output logic sync_b,       // Señal combinada de sincronización
    output logic [7:0] red, green, blue // Canales VGA
);

    // Señales intermedias
    logic clk_25, place_en, is_red;
    logic [41:0] red_player, yellow_player;
    logic valid_move;
    logic [9:0] pixel_x, pixel_y;
    logic video_on;

    // Instancia del PLL para generar el reloj de 25 MHz
    clock_pll pll_inst (
        .refclk(clk_50),
        .rst(reset),
        .outclk_0(clk_25)
    );

    // Asignación de señales desde los interruptores
    assign place_en = ~KEY[0]; // El botón KEY[0] es activo en bajo
    assign is_red = SW[6];     // SW[6] para seleccionar el color

    // Instancia del módulo place_piece
    place_piece place_piece_inst (
        .clk(clk_25),
        .reset(reset),
        .col_switch(SW[5:0]), // SW[5:0] para seleccionar la columna
        .is_red(is_red),
        .place_en(place_en),
        .red_player(red_player),
        .yellow_player(yellow_player),
        .valid_move(valid_move)
    );

    // Instancia del controlador VGA
    vga_controller vga_controller_inst (
        .clk(clk_25),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .blank_b(blank_b),
        .sync_b(sync_b),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    // Instancia del módulo que renderiza el tablero (vga_grid)
    vga_grid vga_grid_inst (
        .clk(clk_25),
        .reset(reset),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .red_player(red_player),
        .yellow_player(yellow_player),
        .video_on(video_on),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // LEDs para depuración
    assign led[0] = valid_move; // LED indica si el movimiento fue válido
    assign led[1] = place_en;   // LED indica si place_en está activo
    assign led[7:2] = 6'b0;     // Otros LEDs apagados

endmodule