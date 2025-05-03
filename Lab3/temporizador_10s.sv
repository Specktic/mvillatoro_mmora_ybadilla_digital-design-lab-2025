// temporizador_10s.sv
module temporizador_10s (
    input  logic clk,
    input  logic reset,
    input  logic enable,
    output logic tiempo_agotado,
    output logic [3:0] segundos_restantes
);

    logic [24:0] contador;
    logic [3:0]  segundos;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            contador <= 0;
            segundos <= 10;
        end else if (enable) begin
            if (contador == 25_000_000 - 1) begin  // 1 segundo si clk es de 25 MHz
                contador <= 0;
                if (segundos != 0)
                    segundos <= segundos - 1;
            end else begin
                contador <= contador + 1;
            end
        end
    end

    assign tiempo_agotado = (segundos == 0);
    assign segundos_restantes = segundos;

endmodule
