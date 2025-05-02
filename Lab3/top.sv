// modulo principal que utiliza sync_vga y vga_grid 
module top (
    input  logic clk_50,  // Clock de 25 MHz
    input  logic reset,   // Reset activo en high
    output logic h_sync,  // Salida sync horizontal
    output logic v_sync,  // Salida sync vertical
	 //Canales VGA
    output logic [7:0] red, green, blue    
);
	 
	 //clock de 50 a 25 (MHz)
	 logic clk_25;
	 logic pll_locked;
	 
	 //instancia del pll
	 clock_pll pll_inst(
			.refclk   (clk_50), // Reloj 50 MHz
			.rst      (reset),    
			.outclk_0 (clk_25), // Salida reloj 25 MHz
			.locked   (pll_locked)  // Señal PLL estable -> se puede usar 
	 );

    // Se instancian los modulos
	 
    vga_controller controller(
		  .clk_25mhz(clk_25),
        .reset(~pll_locked),
		  .h_sync(h_sync),
		  .v_sync(v_sync),
        .red(red),
        .green(green),
        .blue(blue)
    );

endmodule
