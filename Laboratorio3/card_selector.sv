// card_selector.sv — Controla selección de cartas con reset global y limpieza completa
// SW[7:0] = cartas, SW[8] = fila (arriba/abajo)

module card_selector(
    input  logic        clk,
    input  logic        rst,             // reset global (KEY1 o timeout)
    input  logic [9:0]  sw,              // switches físicos
    output logic [7:0]  selected_cards,  // bits = cartas seleccionadas (máx 2)
    output logic        row_sel          // 1 = fila superior, 0 = fila inferior
);

    // === Temporizador de bloqueo tras reset ===
    logic [23:0] reset_delay;
    logic allow_input;

    // Variables auxiliares fuera del bloque always
    logic [7:0] new_sel;
    integer count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            reset_delay     <= 24'd0;
            allow_input     <= 1'b0;
            selected_cards  <= 8'd0;
            row_sel         <= 1'b0;
        end 
        else begin
            // Espera unos ciclos (~0.5 s a 50 MHz = 25 M ciclos)
            if (reset_delay < 24'd25_000_00) begin
                reset_delay <= reset_delay + 1;
                allow_input <= 1'b0;
            end 
            else begin
                allow_input <= 1'b1;
            end

            if (allow_input) begin
                row_sel <= sw[8];

                // Leer switches
                new_sel = sw[7:0];

                // Contar cuántos bits están activos
                count = 0;
                for (int i = 0; i < 8; i = i + 1) begin
                    if (new_sel[i]) count = count + 1;
                end

                // Si hay más de 2 bits activos, ignorar el exceso
                if (count <= 2)
                    selected_cards <= new_sel;
                else
                    selected_cards <= selected_cards; // mantiene las 2 previas
            end
        end
    end

endmodule
