// top.sv 

module top (
    input logic clk,
    input logic KEY0,
    input logic KEY1,           // Botón para confirmar jugada jugador 1
    input logic [2:0] SW,       // Switches para seleccionar columna
    input logic clk_25mhz,      // Clock para VGA
	 
	 input logic [2:0] COL_ARDUINO,     // columna enviada por el Arduino
    input logic ARDUINO_VALIDA_JUGADA, // señal de validación de jugada Arduino Jugador 2 

    output logic [6:0] HEX0,
    output logic hay_ganador,
    output logic hsync,
    output logic vsync,
    output logic [7:0] red,
    output logic [7:0] green,
    output logic [7:0] blue

);

    // Reset activo bajo
    wire reset = ~KEY0;
    wire confirmar_jugada = ~KEY1;

    // Interna para VGA (no como output directo)
    logic [1:0] tablero_matriz [0:5][0:6];

    // Señales
    logic [3:0] segundos_restantes;
    logic [6:0] segmentos;
    logic tiempo_agotado;
    logic cambiar_turno;
    logic escribir_tablero;
    logic columna_llena;
    logic revisar_ganador;
    logic [1:0] jugador_ganador;
    logic [2:0] columna_actual;

	 logic listo_inicializador;
	 logic jugador_inicial;
    logic [2:0] columna_aleatoria;
    logic jugada_valida;
	 logic jugador_actual; // 1 bit

    // FSM Instancia
    logic enable_timer;
    logic reset_timer;

			fsm_connect4 fsm (
				 .clk(clk),
				 .reset(reset),
				 .jugada_fpga_valida(jugador_actual == 0 ? jugada_valida : 0),
				 .jugada_arduino_valida(jugador_actual == 1 ? jugada_valida : 0),
				 .tiempo_agotado(tiempo_agotado),
				 .juego_terminado(juego_terminado),

				 .listo(listo_inicializador),          
				 .jugador_inicial(jugador_inicial),     

				 .estado_actual(estado_actual),
				 .enable_timer(enable_timer),
				 .reset_timer(reset_timer),
				 .escribir_tablero(escribir_tablero),
				 .revisar_ganador(revisar_ganador),
				 .mostrar_ganador(mostrar_ganador),
				 .cambiar_turno(cambiar_turno)
			);
	 
	 
		 
	  // Selección de jugada según jugador
		always_comb begin
			 jugada_valida = 1'b0;
			 columna_actual = 3'b000;

			 if (jugador_actual == 1'b0) begin
				  // Turno de la FPGA
				  if (tiempo_agotado) begin
						columna_actual = columna_aleatoria;
						jugada_valida = 1'b1;  // jugada automática
				  end else begin
						columna_actual = SW;
						jugada_valida = ~KEY1;
				  end
			 end else begin
				  // Turno del Arduino
				  if (tiempo_agotado) begin
						columna_actual = columna_aleatoria;
						jugada_valida = 1'b1;  // jugada automática
				  end else begin
						columna_actual = COL_ARDUINO;
						jugada_valida = ARDUINO_VALIDA_JUGADA;
				  end
			 end
		end



	 
	 // Generador aleatorio 
		generador_aleatorio generador (
			 .clk(clk),
			 .reset(reset),
			 .enable(tiempo_agotado),             
			 .columna_aleatoria(columna_aleatoria)
		);
		 
	 
	 
	 
    // Temporizador
    temporizador_10s timer (
        .clk(clk),
        .reset(reset_timer | reset),
        .enable(enable_timer),
        .tiempo_agotado(tiempo_agotado),
        .segundos_restantes(segundos_restantes)
    );

    // Display 7 segmentos
    decodificador_7seg display (
        .digito(segundos_restantes),
        .segmentos(segmentos)
    );
    assign HEX0 = ~segmentos;

    // Tablero
    tablero tablero_inst (
        .clk(clk),
        .reset(reset),
        .escribir(escribir_tablero),
        .columna(columna_actual),
        .jugador(jugador_actual),
        .lleno(columna_llena),
        .matriz(tablero_matriz)
    );

    // Detector de victoria
    detector_victoria detector (
        .tablero(tablero_matriz),
        .hay_ganador(hay_ganador),
        .jugador_ganador(jugador_ganador)
    );

    // Controlador VGA
    vga_controller vga (
        .clk_25mhz(clk_25mhz),
        .reset(reset),
        .tablero(tablero_matriz),
        .h_sync(hsync),
        .v_sync(vsync),
        .red(red),
        .green(green),
        .blue(blue)
    );
	 
	// Instancia Controlar Jugador 
	 control_jugador jugador_ctrl (
		 .clk(clk),
		 .reset(reset),
		 .cambiar_turno(cambiar_turno),
		 .jugador_inicial(jugador_inicial),
		 .listo(listo_inicializador),
		 .jugador_actual(jugador_actual)
	);
	
	
	
		// Inicializador de juego 
	// -----------------
	inicializador_juego init (
		 .clk(clk),
		 .reset(reset),
		 .start_inicial(1'b1),  // siempre activo tras reset
		 .valor_aleatorio(valor_aleatorio),
		 .jugador_inicial(jugador_inicial),
		 .listo(listo_inicializador)
	);
	


endmodule
