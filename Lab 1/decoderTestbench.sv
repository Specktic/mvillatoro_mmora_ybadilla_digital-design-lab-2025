/*Testbench*/

module binaryToBCD_tb();
    logic [3:0] bin;         // Entrada binaria de prueba
    logic [3:0] decenas;     // Salida esperada - Decenas
    logic [3:0] unidades;    // Salida esperada - Unidades

    // Instanciamos el módulo a probar
    binaryToBCD uut (
        .bin(bin),
        .decenas(decenas),
        .unidades(unidades)
    );

    initial begin
        $display("Prueba de decodificador de Binario a BCD");
        $display("Binario | Decenas | Unidades");
        
        for (int i = 0; i < 16; i++) begin
            bin = i; // Se asigna el valor de prueba
            #10; // Esperamos para evaluar la salida
            
            // Imprimimos el resultado
            $display("   %b   |   %b   |   %b   ", bin, decenas, unidades);
        end

        $finish;
    end
endmodule
