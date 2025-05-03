`timescale 1ns / 1ps

module tb_connect4;

    logic clk;
    logic KEY0;
    logic KEY1;
    logic [2:0] SW;

    logic [6:0] HEX0;
    logic [1:0] jugador_actual;
    logic hay_ganador;

    top dut (
        .clk(clk),
        .KEY0(KEY0),
        .KEY1(KEY1),
        .SW(SW),
        .HEX0(HEX0),
        .jugador_actual(jugador_actual),
        .hay_ganador(hay_ganador)
    );

    always #10 clk = ~clk;

    task reiniciar();
        begin
            KEY0 = 0; #20; KEY0 = 1; #100;
        end
    endtask

    task jugar(input [2:0] columna);
        begin
            SW = columna;
            KEY1 = 0; #20; KEY1 = 1; #500;
        end
    endtask

    initial begin
        $display("\n== Iniciando pruebas completas de Connect 4 ==\n");
        clk = 0; KEY0 = 1; KEY1 = 1; SW = 3'd0;

        //////////////////////////////////////////////////////
        // CASO 1: Victoria horizontal jugador 1 (columnas 0–3)
        //////////////////////////////////////////////////////
        reiniciar();
        jugar(3'd0); jugar(3'd0);
        jugar(3'd1); jugar(3'd1);
        jugar(3'd2); jugar(3'd2);
        jugar(3'd3);
        #1000;
        if (hay_ganador)
            $display("✔ Victoria horizontal detectada por jugador %0d", jugador_actual);
        else
            $display("✘ ERROR: no se detectó victoria horizontal");

        //////////////////////////////////////////////////////
        // CASO 2: Victoria diagonal ↘ (0,0 → 3,3)
        //////////////////////////////////////////////////////
        reiniciar();
        jugar(0); jugar(1);
        jugar(1); jugar(2);
        jugar(2); jugar(3);
        jugar(2); jugar(3);
        jugar(3); jugar(0);
        jugar(3);
        #1000;
        if (hay_ganador)
            $display("✔ Victoria diagonal ↘ detectada por jugador %0d", jugador_actual);
        else
            $display("✘ ERROR: no se detectó victoria diagonal ↘");

        //////////////////////////////////////////////////////
        // CASO 3: Victoria diagonal ↙ (3,0 → 0,3)
        //////////////////////////////////////////////////////
        reiniciar();
        jugar(3); jugar(2);
        jugar(2); jugar(1);
        jugar(1); jugar(0);
        jugar(1); jugar(0);
        jugar(0); jugar(3);
        jugar(0);
        #1000;
        if (hay_ganador)
            $display("✔ Victoria diagonal ↙ detectada por jugador %0d", jugador_actual);
        else
            $display("✘ ERROR: no se detectó victoria diagonal ↙");

        //////////////////////////////////////////////////////
        // CASO 4: Empate sin ganador (tablero lleno sin 4 en línea)
        //////////////////////////////////////////////////////
        reiniciar();

        // Jugadas diseñadas manualmente para evitar cualquier victoria
        jugar(0); jugar(1);
        jugar(2); jugar(3);
        jugar(4); jugar(5);
        jugar(6); jugar(0);
        jugar(1); jugar(2);
        jugar(3); jugar(4);
        jugar(5); jugar(6);
        jugar(0); jugar(1);
        jugar(2); jugar(3);
        jugar(4); jugar(5);
        jugar(6); jugar(0);
        jugar(1); jugar(2);
        jugar(3); jugar(4);
        jugar(5); jugar(6);
        jugar(0); jugar(1);
        jugar(2); jugar(3);
        jugar(4); jugar(5);
        jugar(6); jugar(0);
        jugar(1); jugar(2);
        jugar(3); jugar(4);
        jugar(5); jugar(6);

        #2000;
        if (!hay_ganador)
            $display("✔ Empate correctamente detectado (sin ganador en tablero lleno)");
        else
            $display("✘ ERROR: Se detectó un ganador cuando no debería haberlo");

        $stop;
    end
endmodule
