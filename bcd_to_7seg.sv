module bcd_to_7seg(
    input logic [3:0] bcd,
    output logic [6:0] display
);
	always_comb begin
		case (bcd)
			4'b0000: display = 7'b1000000;  // 0 (invertido)
			4'b0001: display = 7'b1111001;  // 1 (invertido)
			4'b0010: display = 7'b0100100;  // 2 (invertido)
			4'b0011: display = 7'b0110000;  // 3 (invertido)
			4'b0100: display = 7'b0011001;  // 4 (invertido)
			4'b0101: display = 7'b0010010;  // 5 (invertido)
			4'b0110: display = 7'b0000010;  // 6 (invertido)
			4'b0111: display = 7'b1111000;  // 7 (invertido)
			4'b1000: display = 7'b0000000;  // 8 (invertido)
			4'b1001: display = 7'b0010000;  // 9 (invertido)
			default: display = 7'b1111111;  // Apagado (invertido)
		endcase
	end

endmodule
