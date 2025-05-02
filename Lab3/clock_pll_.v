module clock_pll_ (
    input wire refclk,
    input wire rst,
    output wire outclk_0,
    output wire locked
);

    assign outclk_0 = refclk; // No se divide, solo pasa el clock para simular
    assign locked = 1'b1;     // Siempre "estable"

endmodule