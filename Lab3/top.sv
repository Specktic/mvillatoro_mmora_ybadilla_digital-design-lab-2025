module top (
    input logic clk,
    input logic KEY0,
    input logic KEY1,
    input logic [2:0] SW,
    input logic clk_25mhz,

    input logic [2:0] COL_ARDUINO,
    input logic ARDUINO_VALIDA_JUGADA,

    output logic [6:0] HEX0,
    output logic jugador_actual,  // 0 = FPGA, 1 = Arduino
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

    // Interna para VGA
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
    logic [2:0] columna_aleatoria;
    logic jugada_valida;
    logic listo_inicializador;
    logic jugador_inicial;
    logic [3:0] valor_aleatorio;

    // FSM
    logic enable_timer;
    logic reset_timer;

    // FSM Instancia
    fsm_connect4 fsm (
        .clk(clk),
        .reset(reset),
        .jugada_fpga_valida((jugador_actual == 1'b0) ? jugada_valida : 1'b0),
        .jugada_arduino_valida((jugador_actual == 1'b1) ? jugada_valida : 1'b0),
        .tiempo_agotado(tiempo_agotado),
        .juego_terminado(hay_ganador),
        .listo(listo_inicializador),
        .jugador_inicial(jugador_inicial),
        .estado_actual(),
        .enable_timer(enable_timer),
        .reset_timer(reset_timer),
        .escribir_tablero(escribir_tablero),
        .revisar_ganador(revisar_ganador),
        .mostrar_ganador(),
        .cambiar_turno(cambiar_turno)
    );

    // Selección de jugada según jugador
    always_comb begin
        jugada_valida = 1'b0;
        columna_actual = 3'b000;

        if (jugador_actual == 1'b0) begin
            columna_actual = SW;
            jugada_valida  = confirmar_jugada;
        end else begin
            columna_actual = COL_ARDUINO;
            jugada_valida  = ARDUINO_VALIDA_JUGADA;
        end
    end

    // Generador aleatorio (para usar en jugadas automáticas e inicialización)
    generador_aleatorio generador (
        .clk(clk),
        .reset(reset),
        .enable(tiempo_agotado),             
        .columna_aleatoria(columna_aleatoria)
    );

    // Temporizador de 10 segundos
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

    // Tablero (maneja posiciones)
    tablero tablero_inst (
        .clk(clk),
        .reset(reset),
        .escribir(escribir_tablero),
        .columna(columna_actual),
        .jugador({1'b0, jugador_actual}), // convierte 1 bit a 2 bits (01 o 10)
        .lleno(columna_llena),
        .matriz(tablero_matriz)
    );

    // Detector de victoria
    detector_victoria detector (
        .tablero(tablero_matriz),
        .hay_ganador(hay_ganador),
        .jugador_ganador(jugador_ganador)
    );
	 
	 // Arduino
	 spi_slave_arduino spi_slave_inst (
    .clk(clk),
    .reset(reset),
    .sck(SCK_ARDUINO),
    .ss(SS_ARDUINO),
    .mosi(MOSI_ARDUINO),
    .col_arduino(COL_ARDUINO),
    .arduino_valida_jugada(ARDUINO_VALIDA_JUGADA)
)

    // VGA
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

    // Control de jugador (cambia de jugador con FSM)
    control_jugador jugador_ctrl (
        .clk(clk),
        .reset(reset),
        .cambiar_turno(cambiar_turno),
        .jugador_inicial(jugador_inicial),
        .listo(listo_inicializador),
        .jugador_actual(jugador_actual)
    );

    // Inicializador (elige jugador inicial de forma aleatoria)
    inicializador_juego init (
        .clk(clk),
        .reset(reset),
        .start_inicial(1'b1),  // siempre activo tras reset
        .valor_aleatorio(valor_aleatorio),
        .jugador_inicial(jugador_inicial),
        .listo(listo_inicializador)
    );


endmodule
