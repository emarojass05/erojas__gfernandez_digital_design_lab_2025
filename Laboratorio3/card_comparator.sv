// card_comparator.sv — Compara las dos cartas seleccionadas y guarda pares correctos
module card_comparator(
    input  logic        clk,
    input  logic        rst,
    input  logic        compare_pulse,       // KEY2
    input  logic [7:0]  selected_cards,      // cartas azules
    input  logic [7:0]  stored_cards,        // cartas verdes actuales
    output logic [7:0]  updated_stored_cards,// nuevo estado de almacenadas
    output logic        match,               // 1 si hubo coincidencia
    output logic        reset_selection      // 1 si no coincidieron
);

    // Variables internas
    integer i;
    logic [2:0] first_idx, second_idx;
    logic found_first, found_second;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_stored_cards <= 8'd0;
            match                <= 1'b0;
            reset_selection      <= 1'b0;
        end else begin
            match           <= 1'b0;
            reset_selection <= 1'b0;
            updated_stored_cards <= stored_cards;

            if (compare_pulse) begin
                // Buscar las 2 cartas seleccionadas
                found_first  = 1'b0;
                found_second = 1'b0;

                for (i = 0; i < 8; i = i + 1) begin
                    if (selected_cards[i]) begin
                        if (!found_first) begin
                            first_idx  = i[2:0];
                            found_first = 1'b1;
                        end else if (!found_second) begin
                            second_idx  = i[2:0];
                            found_second = 1'b1;
                        end
                    end
                end

                // Si hay exactamente 2 seleccionadas
                if (found_first && found_second) begin
                    // Comparar si pertenecen al mismo par (0-1, 2-3, 4-5, 6-7)
                    if ((first_idx/2) == (second_idx/2)) begin
                        match <= 1'b1;
                        updated_stored_cards[first_idx]  <= 1'b1;
                        updated_stored_cards[second_idx] <= 1'b1;
                    end else begin
                        reset_selection <= 1'b1;
                    end
                end
            end
        end
    end

endmodule
