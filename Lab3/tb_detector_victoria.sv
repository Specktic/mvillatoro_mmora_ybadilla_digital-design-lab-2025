`timescale 1ns / 1ps

module tb_detector_victoria;

    logic [1:0] tablero [0:5][0:6];
    logic hay_ganador;
    logic [1:0] jugador_ganador;
    logic [2:0] fila_ganadora [0:3];
    logic [2:0] col_ganadora [0:3];

    // Instancia del detector
    detector_victoria dut (
        .tablero(tablero),
        .hay_ganador(hay_ganador),
        .jugador_ganador(jugador_ganador),
        .fila_ganadora(fila_ganadora),
        .col_ganadora(col_ganadora)
    );

    initial begin
        $display("\n== Prueba del detector de victoria ==\n");

        // CASO: Victoria horizontal jugador 1
        tablero = '{
            '{1,1,1,1,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };
        #10;
        assert(hay_ganador && jugador_ganador == 1) else $fatal("ERROR: No se detectó victoria horizontal J1");
        assert(fila_ganadora[0] == 0 && col_ganadora[0] == 0) else $fatal("ERROR coord 0");
        assert(fila_ganadora[3] == 0 && col_ganadora[3] == 3) else $fatal("ERROR coord 3");

        // CASO: Victoria vertical jugador 2
        tablero = '{
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,2,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };
        #10;
        assert(hay_ganador && jugador_ganador == 2) else $fatal("ERROR: No se detectó victoria vertical J2");
        assert(fila_ganadora[0] == 0 && col_ganadora[0] == 4) else $fatal("ERROR coord vertical 0");
        assert(fila_ganadora[3] == 3 && col_ganadora[3] == 4) else $fatal("ERROR coord vertical 3");

        // CASO: Diagonal ↘ jugador 1
        tablero = '{
            '{1,0,0,0,0,0,0},
            '{0,1,0,0,0,0,0},
            '{0,0,1,0,0,0,0},
            '{0,0,0,1,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };
        #10;
        assert(hay_ganador && jugador_ganador == 1) else $fatal("ERROR: No se detectó diagonal ↘");
        assert(fila_ganadora[0] == 0 && col_ganadora[0] == 0);
        assert(fila_ganadora[3] == 3 && col_ganadora[3] == 3);

        // CASO: Diagonal ↙ jugador 2
        tablero = '{
            '{0,0,0,2,0,0,0},
            '{0,0,2,0,0,0,0},
            '{0,2,0,0,0,0,0},
            '{2,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0},
            '{0,0,0,0,0,0,0}
        };
        #10;
        assert(hay_ganador && jugador_ganador == 2) else $fatal("ERROR: No se detectó diagonal ↙");
        assert(fila_ganadora[0] == 0 && col_ganadora[0] == 3);
        assert(fila_ganadora[3] == 3 && col_ganadora[3] == 0);

        // CASO: Empate
        tablero = '{
            '{1,2,1,2,1,2,1},
            '{2,1,2,1,2,1,2},
            '{1,2,1,2,1,2,1},
            '{2,1,2,1,2,1,2},
            '{1,2,1,2,1,2,1},
            '{2,1,2,1,2,1,2}
        };
        #10;
        assert(hay_ganador && jugador_ganador == 2'b11) else $fatal("ERROR: No se detectó empate");

        $display("\n✅ Todas las pruebas pasaron correctamente\n");
        $finish;
    end

endmodule

