`timescale 1ns/1ps

module tb_inicializador_juego;

    // Señales
    logic clk;
    logic reset;
    logic start_inicial;
    logic [3:0] valor_aleatorio;
    logic jugador_inicial;
    logic listo;

    // Instancia del módulo
    inicializador_juego uut (
        .clk(clk),
        .reset(reset),
        .start_inicial(start_inicial),
        .valor_aleatorio(valor_aleatorio),
        .jugador_inicial(jugador_inicial),
        .listo(listo)
    );

    // Generador de reloj
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz

    // Estímulos
    initial begin
        $display("Inicio de simulación");
        $dumpfile("tb_inicializador_juego.vcd");
        $dumpvars(0, tb_inicializador_juego);

        // Inicialización
        reset = 1;
        start_inicial = 0;
        valor_aleatorio = 4'b0000;

        #20 reset = 0;

        // Simulamos que el generador aleatorio devuelve un valor con bit 0 = 1
        valor_aleatorio = 4'b1011; // Esperamos que jugador_inicial = 1

        // Activamos el inicio
        #10 start_inicial = 1;
        #10 start_inicial = 0;

        // Esperamos a que avance de estados
        #50;

        // Cambiamos el valor aleatorio y reiniciamos
        reset = 1; #10 reset = 0;
        valor_aleatorio = 4'b0110; // Ahora bit 0 = 0 -> jugador_inicial = 0
        #10 start_inicial = 1;
        #10 start_inicial = 0;

        #50;
        $display("Fin de simulación");
        $finish;
    end

endmodule
