module Restador_Parametrizable_Testbench;
    parameter N = 6;
    logic clk, reset, boton;
    logic [N-1:0] valor_inicial;
    logic [N-1:0] resultado;

    Restador_Parametrizable #(N) uut (
        .clk(clk),
        .reset(reset),
        .boton(boton),
        .valor_inicial(valor_inicial),
        .R(resultado)
    );

    always #5 clk = ~clk; // Generación del reloj

    initial begin
        $display("Inicio de pruebas");
        clk = 0;
        reset = 1;
        valor_inicial = 6'b111111; // Valor inicial de prueba
        #10 reset = 0;
        boton = 1;
        #10 boton = 0;
        #10 boton = 1;
        #10 $stop;
    end
endmodule