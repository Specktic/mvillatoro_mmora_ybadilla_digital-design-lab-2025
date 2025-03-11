/*Testbench*/

module binaryToBCD_tb();
    logic [3:0] bin;         // Entrada binaria para prueba
    logic [3:0] decenas;     // Salida esperada => Decenas
    logic [3:0] unidades;    // Salida esperada => Unidades

    // Se instancia el modulo que se probara
    binaryToBCD uut (
        .bin(bin),
        .decenas(decenas),
        .unidades(unidades)
    );

    // Inicio de prueba
    initial begin
        //Texto a mostrar 
        $display("Prueba de decodificador de Binario a BCD");
        $display("Binario | Decenas | Unidades");
        
        //se recorren las entradas de la tabla del (0 al 15 en decimal)
        for (int i = 0; i < 16; i++) begin
            bin = i; // Se asigna el valor de prueba
            #10; // Esperamos para evaluar la salida
            
            // resultado
            $display("   %b   |   %b   |   %b   ", bin, decenas, unidades);
        end

        $finish;
    end
endmodule
