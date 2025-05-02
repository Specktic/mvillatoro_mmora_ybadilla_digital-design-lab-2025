`timescale 1ns/1ps

module vga_controller_tb;

    // Señales internas
    logic clk_50;
    logic reset;

    logic [7:0] red, green, blue;
    logic h_sync, v_sync;

    // Simulador de reloj: 50 MHz (20 ns periodo)
    initial clk_50 = 0;
    always #10 clk_50 = ~clk_50;

    // Reset inicial
    initial begin
        reset = 1;
        #100;
        reset = 0;
    end

    // Instancia del modulo top
    top dut (
        .clk_50(clk_50),
        .reset(reset),
        .red(red),
        .green(green),
        .blue(blue),
        .h_sync(h_sync),
        .v_sync(v_sync)
    );

    // Tiempo total de simulación
    initial begin
        #1000000;  // 1 ms
        $display("Fin de simulacion");
        $stop;
    end

endmodule
