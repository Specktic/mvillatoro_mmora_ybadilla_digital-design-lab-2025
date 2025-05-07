module flanco_subida (
    input  logic clk,
    input  logic signal_in,
    output logic pulso
);

    logic signal_reg;

    always_ff @(posedge clk) begin
        signal_reg <= signal_in;
    end

    assign pulso = (signal_in && !signal_reg);
endmodule