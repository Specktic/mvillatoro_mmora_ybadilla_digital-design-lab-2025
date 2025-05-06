`timescale 1ns/1ps

module tb_control_jugador;

    // Señales
    logic clk;
    logic reset;
    logic cambiar_turno;
    logic jugador_inicial;
    logic listo;
    logic jugador_actual;

    // Instancia del módulo
    control_jugador uut (
        .clk(clk),
        .reset(reset),
        .cambiar_turno(cambiar_turno),
        .jugador_inicial(jugador_inicial),
        .listo(listo),
        .jugador_actual(jugador_actual)
    );

    // Generador de reloj
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        $display("Inicio de testbench: control_jugador");
        $dumpfile("tb_control_jugador.vcd");
        $dumpvars(0, tb_control_jugador);

        // Inicialización
        reset = 1;
        cambiar_turno = 0;
        jugador_inicial = 1;  // Supongamos que inicia Arduino
        listo = 0;

        #20 reset = 0;

        // Activamos señal listo para cargar jugador_inicial
        #10 listo = 1;
        #10 listo = 0;

        // Esperamos y cambiamos de jugador
        #10 cambiar_turno = 1;
        #10 cambiar_turno = 0;

        // Otro cambio de turno
        #10 cambiar_turno = 1;
        #10 cambiar_turno = 0;

        // Reinicio para probar de nuevo con otro jugador inicial
        #20 reset = 1; #10 reset = 0;
        jugador_inicial = 0;  // Ahora inicia FPGA
        #10 listo = 1; #10 listo = 0;

        #20 cambiar_turno = 1;
        #10 cambiar_turno = 0;

        #20;
        $display("Fin de testbench.");
        $finish;
    end

endmodule
