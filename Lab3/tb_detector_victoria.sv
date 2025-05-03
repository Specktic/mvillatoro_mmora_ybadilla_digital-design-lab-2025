`timescale 1ns / 1ps

module tb_detector_victoria;

    logic [1:0] tablero [0:5][0:6];
    logic hay_ganador;
    logic [1:0] jugador_ganador;

    // Instancia del módulo
    detector_victoria dut (
        .tablero(tablero),
        .hay_ganador(hay_ganador),
        .jugador_ganador(jugador_ganador)
    );

    initial begin
        $display("\n== Prueba aislada del detector de victoria ==\n");

        // CASO 1: Empate - sin ganador
        tablero = '{
            '{1,2,1,2,1,2,1},
            '{2,1,2,1,2,1,2},
            '{1,2,1,2,1,2,1},
            '{1,2,1,2,1,2,1},
            '{2,1,2,1,2,1,2},
            '{2,1,2,1,2,1,2}
        };

        #10;
        if (!hay_ganador)
            $display("✔ Empate correctamente detectado (sin ganador)");
        else
            $display("✘ ERROR: Ganador detectado cuando no debería (jugador %0d)", jugador_ganador);

        // CASO 2: Victoria horizontal por jugador 1
        tablero = '{
            '{1,1,1,1,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };

        #10;
        if (hay_ganador && jugador_ganador == 1)
            $display("✔ Victoria horizontal detectada correctamente para jugador 1");
        else
            $display("✘ ERROR: No se detectó victoria horizontal como se esperaba");

        // CASO 3: Victoria vertical por jugador 2
        tablero = '{
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };

        #10;
        if (hay_ganador && jugador_ganador == 2)
            $display("✔ Victoria vertical detectada correctamente para jugador 2");
        else
            $display("✘ ERROR: No se detectó victoria vertical como se esperaba");

        // CASO 4: Victoria diagonal ↘ por jugador 1
        tablero = '{
            '{1,0,0,0,0,0,0},
            '{0,1,0,0,0,0,0},
            '{0,0,1,0,0,0,0},
            '{0,0,0,1,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };

        #10;
        if (hay_ganador && jugador_ganador == 1)
            $display("✔ Victoria diagonal ↘ detectada correctamente para jugador 1");
        else
            $display("✘ ERROR: No se detectó victoria diagonal ↘ como se esperaba");

        // CASO 5: Victoria diagonal ↙ por jugador 2
        tablero = '{
            '{0,0,0,2,0,0,0},
            '{0,0,2,0,0,0,0},
            '{0,2,0,0,0,0,0},
            '{2,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };

        #10;
        if (hay_ganador && jugador_ganador == 2)
            $display("✔ Victoria diagonal ↙ detectada correctamente para jugador 2");
        else
            $display("✘ ERROR: No se detectó victoria diagonal ↙ como se esperaba");

        $stop;
    end
endmodule
