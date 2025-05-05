module spi_slave_arduino (
    input logic clk,                // FPGA system clock
    input logic reset,             // Active-high synchronous reset
    input logic sck,               // SPI Clock from Arduino
    input logic ss,                // Slave Select (active low)
    input logic mosi,              // Master Out, Slave In (Arduino → FPGA)

    output logic [2:0] col_arduino,       // Selected column (0–6)
    output logic arduino_valida_jugada   // 1-cycle pulse on new command
);