module flanco_bajada (
    input  logic clk,
    input  logic signal_in,
    output logic pulso
);
    logic prev;

    always_ff @(posedge clk) begin
        prev <= signal_in;
    end

    assign pulso = (prev == 1'b1 && signal_in == 1'b0);
endmodule