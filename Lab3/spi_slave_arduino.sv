module spi_slave_arduino (
    input logic clk,                // FPGA system clock
    input logic reset,             // Active-high synchronous reset
    input logic sck,               // SPI Clock from Arduino
    input logic ss,                // Slave Select (active low)
    input logic mosi,              // Master Out, Slave In (Arduino → FPGA)

    output logic [2:0] col_arduino,       // Selected column (0–6)
    output logic arduino_valida_jugada   // 1-cycle pulse on new command
);

    logic [7:0] shift_reg;
    logic [2:0] bit_count;
    logic sck_prev;

    logic sck_rising_edge;
    logic ss_active;

    // Rising edge detection for SCK (sample on rising edge)
    always_ff @(posedge clk) begin
        sck_prev <= sck;
    end

    assign sck_rising_edge = (sck == 1'b1 && sck_prev == 1'b0);
    assign ss_active = (ss == 1'b0);  // Active low

    // Shift in bits on SCK rising edge when SS is low
    always_ff @(posedge clk) begin
        if (reset || !ss_active) begin
            shift_reg <= 8'b0;
            bit_count <= 0;
            arduino_valida_jugada <= 0;
        end else if (sck_rising_edge) begin
            shift_reg <= {shift_reg[6:0], mosi};  // Shift left
            bit_count <= bit_count + 1;

            if (bit_count == 7) begin
                // 8th bit just arrived, latch data
                col_arduino <= shift_reg[2:0];     // Bits [2:0] = column
                arduino_valida_jugada <= 1;        // Pulse HIGH
            end else begin
                arduino_valida_jugada <= 0;
            end
        end else begin
            arduino_valida_jugada <= 0;  // Keep pulse short
        end
    end

endmodule
