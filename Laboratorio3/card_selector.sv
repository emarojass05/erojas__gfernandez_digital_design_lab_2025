// card_selector.sv — Selección de cartas con 10 switches
// SW0: elige filas de arriba (1) o filas de abajo (0)
// SW1–SW8: seleccionan 8 cartas de esa mitad (one-hot)

module card_selector(
    input  logic       sw_row,       // 0 = filas de abajo, 1 = filas de arriba
    input  logic [8:1] sw_cards,     // 8 switches → seleccionan una carta
    output logic [15:0] selected     // vector de 16 cartas
);

    always_comb begin
        selected = 16'b0;

        // Mitad superior (cartas 0–7)
        if (sw_row) begin
            case (sw_cards)
                8'b0000_0001: selected[0] = 1;
                8'b0000_0010: selected[1] = 1;
                8'b0000_0100: selected[2] = 1;
                8'b0000_1000: selected[3] = 1;
                8'b0001_0000: selected[4] = 1;
                8'b0010_0000: selected[5] = 1;
                8'b0100_0000: selected[6] = 1;
                8'b1000_0000: selected[7] = 1;
                default: selected = 16'b0;
            endcase
        end
        // Mitad inferior (cartas 8–15)
        else begin
            case (sw_cards)
                8'b0000_0001: selected[8]  = 1;
                8'b0000_0010: selected[9]  = 1;
                8'b0000_0100: selected[10] = 1;
                8'b0000_1000: selected[11] = 1;
                8'b0001_0000: selected[12] = 1;
                8'b0010_0000: selected[13] = 1;
                8'b0100_0000: selected[14] = 1;
                8'b1000_0000: selected[15] = 1;
                default: selected = 16'b0;
            endcase
        end
    end

endmodule
