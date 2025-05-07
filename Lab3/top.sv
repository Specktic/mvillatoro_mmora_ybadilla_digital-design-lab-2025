module top (
    input  logic clk_50,
    input  logic reset,
    input  logic [6:0] SW,
    input  logic [0:0] KEY,
    input  logic boton_elegir,
    input  logic iniciar_juego,
    input  logic movimiento,
    output logic tiempo_agotado,
    output logic [4:0] led,
    output logic hsync,
    output logic vsync,
    output logic blank_b,
    output logic sync_b,
    output logic vga_clk,
    output logic [7:0] red, green, blue,
    output logic [6:0] HEX0, HEX1   
);

    logic clk_25;
    logic pll_locked;
    logic clk_1hz;
    logic pll_locked_1hz;

    logic place_en;
    logic [41:0] red_map, yellow_map;
    logic valid_move;
    logic [9:0] pixel_x, pixel_y;
    logic video_on;

    logic is_red;
    logic jugador_inicial;
    logic listo;
    logic place_pulse;
    logic auto_jugar_pulse;
    logic auto_jugar;
    logic activar_auto;

    logic [3:0] segundos; 
    logic [6:0] seg_unidades, seg_decenas;
	 logic auto_jugar_continuo;

    assign place_en = ~KEY[0];
    assign activar_auto = 1'b1;

    clock_pll pll_inst(
        .refclk(clk_50),
        .rst(reset),
        .outclk_0(clk_25),
        .locked(pll_locked)
    );
    assign vga_clk = clk_25;

    clk_1Hz reloj_lento (
        .refclk(clk_50),
        .rst(reset),
        .outclk_0(clk_1hz),
        .locked(pll_locked_1hz)
    );

    seleccionar_jugador_inicial selector (
        .clk(clk_25),
        .reset(reset),
        .boton_elegir(boton_elegir),
        .iniciar_juego(iniciar_juego),
        .jugador_inicial(jugador_inicial),
        .listo(listo)
    );

    turno_jugador turno (
        .clk(clk_25),
        .reset(reset),
        .listo(listo),
        .jugador_inicial(jugador_inicial),
        .ficha_colocada(valid_move),
        .is_red(is_red)
    );

    place_piece pieza (
        .clk(clk_25),
        .reset(reset),
        .col_switch(SW),
        .is_red(is_red),
        .place_en(place_pulse),
        .auto_jugar(auto_jugar),
        .activar_auto(activar_auto),
        .red_player(red_map),
        .yellow_player(yellow_map),
        .valid_move(valid_move)
    );

    vga_controller vga_ctrl (
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

    vga_grid grid (
        .clk(clk_25),
        .reset(reset),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .red_player(red_map),
        .yellow_player(yellow_map),
        .is_red_turn(is_red),
        .video_on(video_on),
        .red(red),
        .green(green),
        .blue(blue)
    );

    assign led = {
        3'b000,
        auto_jugar,
        is_red,
        listo,
        jugador_inicial,
        place_en
    };

    flanco_bajada antirrebote (
        .clk(clk_25),
        .signal_in(KEY[0]),
        .pulso(place_pulse)
    );

	Temporizador_10s temporizador_inst (
		 .clk(clk_25),
		 .reset(reset),
		 .movimiento(valid_move),
		 .tiempo_agotado(auto_jugar_continuo)
	);

	contador_10s temporizador_visual (
		 .clk_1hz(clk_1hz),
		 .reset(reset),
		 .enable(~valid_move),
		 .reset_contador(valid_move),  // <- ¡nueva conexión!
		 .tiempo_agotado(tiempo_agotado),
		 .display_decenas(display_decenas),
		 .display_unidades(display_unidades)
	);

    decodificador_7seg decod_unidades (
        .bcd(segundos % 10),
        .segmentos(seg_unidades)
    );

    decodificador_7seg decod_decenas (
        .bcd(segundos / 10),
        .segmentos(seg_decenas)
    );
	
	
	flanco_subida pulso_auto (
		 .clk(clk_25),
		 .signal_in(auto_jugar_continuo),
		 .pulso(auto_jugar) // este se conecta a place_piece
	);
	
	fsm_control_juego fsm (
		 .clk(clk_25),
		 .reset(reset),
		 .listo(listo),
		 .place_en(place_pulse),
		 .auto_jugar(auto_jugar),
		 .valid_move(valid_move),
		 .enable_placer(place_en_habilitado),
		 .enable_auto(auto_jugar_habilitado),
		 .enable_timer(timer_enable)
	);

    assign HEX0 = ~seg_unidades;
    assign HEX1 = ~seg_decenas;

endmodule


