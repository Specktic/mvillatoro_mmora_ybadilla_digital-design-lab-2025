module vga_color_grid (
    input  logic [9:0] h_count,
    input  logic [9:0] v_count,
    input  logic video_on,
    input  logic [1:0] tablero [0:5][0:6],
	 output logic [7:0] red,
	 output logic [7:0] green,
	 output logic [7:0] blue,
);

    localparam CELL_WIDTH  = 91;
    localparam CELL_HEIGHT = 80;
    localparam LINE_THICKNESS = 2;

    logic [2:0] col;
    logic [2:0] row;
    assign col = h_count / CELL_WIDTH;
    assign row = v_count / CELL_HEIGHT;

    logic signed [10:0] rel_x;
    logic signed [10:0] rel_y;
    logic [20:0] dist_sq;

    assign rel_x = h_count % CELL_WIDTH - CELL_WIDTH / 2;
    assign rel_y = v_count % CELL_HEIGHT - CELL_HEIGHT / 2;
    assign dist_sq = rel_x * rel_x + rel_y * rel_y;

    always_comb begin
        if (!video_on) begin
            red = 0; green = 0; blue = 0;

        end else if ((h_count % CELL_WIDTH < LINE_THICKNESS) || 
                     (v_count % CELL_HEIGHT < LINE_THICKNESS)) begin
            red = 0; green = 0; blue = 0;

        end else begin
            red = 8'd50; green = 8'd80; blue = 8'd200;

            if (row < 6 && col < 7 && dist_sq < 1000) begin
                case (tablero[row][col])
                    2'b01: begin red = 8'd255; green = 8'd0;   blue = 8'd0;   end // rojo
                    2'b10: begin red = 8'd255; green = 8'd255; blue = 8'd0;   end // amarillo
                    default: ; // sin ficha
                endcase
            end
        end
    end

endmodule

