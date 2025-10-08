// ============================================================
// textROM.sv — ROM de fuente 8x8 para texto VGA
// ------------------------------------------------------------
// Entrada: código ASCII (char_code) y fila (row 0–7)
// Salida: bits[7:0] = píxeles de la fila (1=blanco, 0=fondo)
// ============================================================

module textROM(
    input  logic [7:0] char_code,  // código ASCII
    input  logic [2:0] row,        // fila 0-7 del carácter
    output logic [7:0] bits        // patrón de 8 píxeles
);

    always_comb begin
        case (char_code)

            // ===== Espacio =====
            8'd32: case (row)
                0,1,2,3,4,5,6,7: bits = 8'b00000000;
            endcase

            // ===== Números 0-9 =====
            8'd48: case (row) // 0
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b01101110;
                3: bits=8'b01110110;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd49: case (row)
                0: bits=8'b00011000;
                1: bits=8'b00111000;
                2: bits=8'b00011000;
                3: bits=8'b00011000;
                4: bits=8'b00011000;
                5: bits=8'b00011000;
                6: bits=8'b01111110;
                7: bits=8'b00000000;
            endcase
            8'd50: case (row)
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b00000110;
                3: bits=8'b00011100;
                4: bits=8'b00110000;
                5: bits=8'b01100000;
                6: bits=8'b01111110;
                7: bits=8'b00000000;
            endcase
            8'd51: case (row)
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b00000110;
                3: bits=8'b00011100;
                4: bits=8'b00000110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd52: case (row)
                0: bits=8'b00001100;
                1: bits=8'b00011100;
                2: bits=8'b00101100;
                3: bits=8'b01001100;
                4: bits=8'b01111110;
                5: bits=8'b00001100;
                6: bits=8'b00001100;
                7: bits=8'b00000000;
            endcase
            8'd53: case (row)
                0: bits=8'b01111110;
                1: bits=8'b01100000;
                2: bits=8'b01111100;
                3: bits=8'b00000110;
                4: bits=8'b00000110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd54: case (row)
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b01100000;
                3: bits=8'b01111100;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd55: case (row)
                0: bits=8'b01111110;
                1: bits=8'b01100110;
                2: bits=8'b00001100;
                3: bits=8'b00011000;
                4: bits=8'b00110000;
                5: bits=8'b00110000;
                6: bits=8'b00110000;
                7: bits=8'b00000000;
            endcase
            8'd56: case (row)
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b01100110;
                3: bits=8'b00111100;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd57: case (row)
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b01100110;
                3: bits=8'b00111110;
                4: bits=8'b00000110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase

            // ===== Letras usadas =====
            8'd65: case (row) // A
                0: bits=8'b00011000;
                1: bits=8'b00111100;
                2: bits=8'b01100110;
                3: bits=8'b01111110;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b01100110;
                7: bits=8'b00000000;
            endcase
            8'd69: case (row) // E
                0: bits=8'b01111110;
                1: bits=8'b01100000;
                2: bits=8'b01111100;
                3: bits=8'b01100000;
                4: bits=8'b01100000;
                5: bits=8'b01100000;
                6: bits=8'b01111110;
                7: bits=8'b00000000;
            endcase
            8'd71: case (row) // G
                0: bits=8'b00111110;
                1: bits=8'b01100000;
                2: bits=8'b01101110;
                3: bits=8'b01100110;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b00111110;
                7: bits=8'b00000000;
            endcase
            8'd74: case (row) // J
                0: bits=8'b00011110;
                1: bits=8'b00000110;
                2: bits=8'b00000110;
                3: bits=8'b00000110;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd76: case (row) // L
                0: bits=8'b01100000;
                1: bits=8'b01100000;
                2: bits=8'b01100000;
                3: bits=8'b01100000;
                4: bits=8'b01100000;
                5: bits=8'b01100000;
                6: bits=8'b01111110;
                7: bits=8'b00000000;
            endcase
            8'd77: case (row) // M
                0: bits=8'b01100110;
                1: bits=8'b01111110;
                2: bits=8'b01111110;
                3: bits=8'b01100110;
                4: bits=8'b01100110;
                5: bits=8'b01100110;
                6: bits=8'b01100110;
                7: bits=8'b00000000;
            endcase
            8'd78: case (row) // N
                0: bits=8'b01100110;
                1: bits=8'b01100110;
                2: bits=8'b01110110;
                3: bits=8'b01111110;
                4: bits=8'b01101110;
                5: bits=8'b01100110;
                6: bits=8'b01100110;
                7: bits=8'b00000000;
            endcase
            8'd80: case (row) // P
                0: bits=8'b01111100;
                1: bits=8'b01100110;
                2: bits=8'b01100110;
                3: bits=8'b01111100;
                4: bits=8'b01100000;
                5: bits=8'b01100000;
                6: bits=8'b01100000;
                7: bits=8'b00000000;
            endcase
            8'd82: case (row) // R
                0: bits=8'b01111100;
                1: bits=8'b01100110;
                2: bits=8'b01100110;
                3: bits=8'b01111100;
                4: bits=8'b01101100;
                5: bits=8'b01100110;
                6: bits=8'b01100110;
                7: bits=8'b00000000;
            endcase
            8'd83: case (row) // S
                0: bits=8'b00111100;
                1: bits=8'b01100110;
                2: bits=8'b01100000;
                3: bits=8'b00111100;
                4: bits=8'b00000110;
                5: bits=8'b01100110;
                6: bits=8'b00111100;
                7: bits=8'b00000000;
            endcase
            8'd84: case (row) // T
                0: bits=8'b01111110;
                1: bits=8'b00011000;
                2: bits=8'b00011000;
                3: bits=8'b00011000;
                4: bits=8'b00011000;
                5: bits=8'b00011000;
                6: bits=8'b00011000;
                7: bits=8'b00000000;
            endcase

            default: bits = 8'b00000000;
        endcase
    end
endmodule
