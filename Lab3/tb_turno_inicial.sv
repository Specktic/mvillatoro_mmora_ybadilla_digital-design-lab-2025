`timescale 1ns / 1ps

module tb_turno_inicial;

    // Señales de prueba
    logic clk, reset;
    logic boton_elegir;
    logic iniciar_juego;
    logic ficha_colocada;

    logic jugador_inicial;
    logic listo;
    logic is_red;

    // Clock de prueba
    always #5 clk = ~clk;  // Clock de 10ns (100 MHz)

    // === Instanciar módulos ===
    seleccionar_jugador_inicial sel (
        .clk(clk),
        .reset(reset),
        .boton_elegir(boton_elegir),
        .iniciar_juego(iniciar_juego),
        .jugador_inicial(jugador_inicial),
        .listo(listo)
    );

    turno_jugador turno (
        .clk(clk),
        .reset(reset),
        .listo(listo),
        .jugador_inicial(jugador_inicial),
        .ficha_colocada(ficha_colocada),
        .is_red(is_red)
    );

    // === Secuencia de prueba ===
    initial begin
        $display("Inicio del testbench");
        $monitor("t=%0t | elegir=%b iniciar=%b ficha=%b | inicial=%b listo=%b | is_red=%b",
                 $time, boton_elegir, iniciar_juego, ficha_colocada, jugador_inicial, listo, is_red);

        // Inicialización
        clk = 0;
        reset = 1;
        boton_elegir = 0;
        iniciar_juego = 0;
        ficha_colocada = 0;
        #20;

        reset = 0;
        #20;

        // Alternar jugador (de rojo a amarillo)
        boton_elegir = 1; #10;
        boton_elegir = 0; #10;

        // Alternar otra vez (de amarillo a rojo)
        boton_elegir = 1; #10;
        boton_elegir = 0; #10;

        // Fijar jugador
        iniciar_juego = 1; #10;
        iniciar_juego = 0; #10;

        // Comienza turno con is_red = ? (depende de jugador_inicial)
        // Simular colocación de fichas
        repeat (4) begin
            ficha_colocada = 1; #10;
            ficha_colocada = 0; #30;
        end

        $finish;
    end

endmodule
