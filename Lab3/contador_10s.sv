module contador_10s (
    input  logic clk_1hz,             // Reloj de 1 Hz (desde PLL)
    input  logic reset,               // Reset global
    input  logic enable,              // Activo mientras está el turno
    input  logic reset_contador,      // Se activa con valid_move (manual o automático)
    output logic tiempo_agotado,      // 1 cuando llega a 0
    output logic [6:0] display_decenas,
    output logic [6:0] display_unidades
);

    logic [3:0] cuenta;
    logic [3:0] decenas, unidades;

    always_ff @(posedge clk_1hz or posedge reset or posedge reset_contador) begin
        if (reset || reset_contador)
            cuenta <= 4'd10;
        else if (enable && cuenta > 0)
            cuenta <= cuenta - 1;
    end

    assign tiempo_agotado = (cuenta == 0);

    always_comb begin
        if (cuenta == 10) begin
            decenas  = 4'd1;
            unidades = 4'd0;
        end else begin
            decenas  = 4'd0;
            unidades = cuenta;
        end
    end

    decodificador_7seg seg_dec (
        .bcd(decenas),
        .segmentos(display_decenas)
    );

    decodificador_7seg seg_uni (
        .bcd(unidades),
        .segmentos(display_unidades)
    );

endmodule

