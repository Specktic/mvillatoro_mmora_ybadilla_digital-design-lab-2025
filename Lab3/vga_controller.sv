// modulo principal que utiliza sync_vga y vga_grid 
module vga_controller (
    input logic clk,         // Clock de 25 MHz generado por el clock PLL
    input logic reset,       // Reset activo en high
    output logic hsync,     // Señal de sync horizontal
    output logic vsync,     // Señal de sync vertical
	 output logic blank_b,       // Señal para forzar negro fuera del área visible
    output logic sync_b,        // Sincronización combinada de hsync y vsync
    output logic video_on,   // indicador de area visible
    output logic [9:0] pixel_x, // Coord x del pixel (0-799)
    output logic [9:0] pixel_y  // Coord y del pixel (0-524)
);

    // Parametros VGA para resolucion 640x480, freq 60Hz, clock 25 MHz
    localparam H_VISIBLE = 640;
    localparam H_FRONT   = 16;
    localparam H_SYNC    = 96;
    localparam H_BACK    = 48;
    localparam H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK - 6; // 794

    localparam V_VISIBLE = 480;
    localparam V_FRONT   = 7;
    localparam V_SYNC    = 2;
    localparam V_BACK    = 30;
    localparam V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK; // 519
	 
	 logic [9:0] h_count = 0;
    logic [9:0] v_count = 0;
	 
	 // Generar señales de sincronización
    always_comb begin
        // h_sync activa baja durante H_SYNC después del visible + front porch
        hsync = ~((h_count >= H_VISIBLE + H_FRONT) && (h_count < H_VISIBLE + H_FRONT + H_SYNC));
        vsync = ~((v_count >= V_VISIBLE + V_FRONT) && (v_count < V_VISIBLE + V_FRONT + V_SYNC));
      
		  sync_b  = hsync & vsync;
        blank_b = ~((h_count >= H_VISIBLE) && (v_count >= V_VISIBLE));
        video_on = (h_count < H_VISIBLE) && (v_count < V_VISIBLE); //ambas dentro de rango visible
        pixel_x = (h_count < H_VISIBLE) ? h_count : 0;
        pixel_y = (v_count < V_VISIBLE) ? v_count : 0;
    end

    // Contadores de pix horizontales y verticales
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1) begin
                    v_count <= 0;
                end else begin
                    v_count <= v_count + 1;
					 end
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    

endmodule
