module clock_divider_25MHz (
    input  logic clk_50MHz,
    input  logic reset,
    output logic clk_25MHz
);

    logic toggle;

    always_ff @(posedge clk_50MHz or posedge reset) begin
        if (reset)
            toggle <= 1'b0;
        else
            toggle <= ~toggle;
    end

    assign clk_25MHz = toggle;

endmodule
