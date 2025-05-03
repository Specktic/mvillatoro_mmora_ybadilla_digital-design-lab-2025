module generador_aleatorio (
    input logic clk,
    input logic reset,
    input logic enable,
    output logic [2:0] columna_aleatoria
);

    logic [2:0] contador;

    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            contador <= 3'b000;
        else if (enable)
            contador <= contador + 1;
    end

    assign columna_aleatoria = contador; // Se puede aplicar máscara si se requiere

endmodule
