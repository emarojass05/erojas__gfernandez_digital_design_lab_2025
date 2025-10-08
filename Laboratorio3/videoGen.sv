// videoGen.sv — Renderiza tablero con color cian en cartas auto-seleccionadas (sin latches)
module videoGen(
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic       visible,
    input  logic       timeout,
    input  logic [7:0] selected_top,
    input  logic [7:0] selected_bottom,
    input  logic [7:0] stored_top,
    input  logic [7:0] stored_bottom,
    input  logic       row_sel,
    input  logic       turn,
    input  logic       flash,
    input  logic       game_over,
    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);

    // === Parámetros del tablero ===
    localparam CARD_W    = 80;
    localparam CARD_H    = 100;
    localparam GRID_COLS = 4;
    localparam GRID_ROWS = 4;
    localparam GAP_X     = 20;
    localparam GAP_Y     = 20;

    localparam TOTAL_W = GRID_COLS*CARD_W + (GRID_COLS-1)*GAP_X;
    localparam TOTAL_H = GRID_ROWS*CARD_H + (GRID_ROWS-1)*GAP_Y;
    localparam BOARD_X0 = (640 - TOTAL_W)/2;
    localparam BOARD_Y0 = (480 - TOTAL_H)/2;

    // === Señales internas ===
    logic [9:0] dx, dy, lx, ly;
    logic [3:0] col, row, card_id;
    logic in_board;
    logic pattern;
    logic selected_now;
    logic stored_now;
    logic [23:0] color;

    always_comb begin
        // Valores por defecto (para evitar latches)
        r = 8'd0;
        g = 8'd0;
        b = 8'd0;
        color = 24'h000000;
        dx = x - BOARD_X0;
        dy = y - BOARD_Y0;
        col = 4'd0;
        row = 4'd0;
        lx  = 10'd0;
        ly  = 10'd0;
        card_id = 4'd0;
        in_board = 1'b0;
        pattern = 1'b0;
        selected_now = 1'b0;
        stored_now = 1'b0;

        // Dibujo
        in_board = (visible && !timeout && dx < TOTAL_W && dy < TOTAL_H);

        if (game_over) begin
            // Pantalla final según jugador
            color = (turn) ? 24'hFF0000 : 24'h0000FF;
        end
        else if (in_board) begin
            col = dx / (CARD_W + GAP_X);
            row = dy / (CARD_H + GAP_Y);
            lx  = dx % (CARD_W + GAP_X);
            ly  = dy % (CARD_H + GAP_Y);
            card_id = row * GRID_COLS + col;

            // === Patrones por par ===
            unique case (card_id)
                0, 1:    pattern = ((lx ^ ly) & 8'h08);
                2, 3:    pattern = ((lx + ly) % 20 < 10);
                4, 5:    pattern = (((lx / 10) + (ly / 10)) % 2);
                6, 7:    pattern = ((lx > ly) && ((lx - ly) < 20));
                8, 9:    pattern = (((lx * ly) % 50) < 25);
                10, 11:  pattern = (lx[3] ^ ly[3]);
                12, 13:  pattern = (((lx + 2*ly) % 30) < 15);
                14, 15:  pattern = (lx[2] ^ ly[4]);
                default: pattern = 1'b0;
            endcase

            // === Selección y almacenado ===
            if (row < 2) begin
                selected_now = selected_top[col + 4*row];
                stored_now   = stored_top[col + 4*row];
            end else begin
                selected_now = selected_bottom[col + 4*(row-2)];
                stored_now   = stored_bottom[col + 4*(row-2)];
            end

            // === Color final de la carta ===
            if (lx < 4 || lx >= CARD_W-4 || ly < 4 || ly >= CARD_H-4)
                color = 24'h000000; // borde
            else if (flash && stored_now)
                color = 24'h00FF00; // parpadeo verde
            else if (stored_now)
                color = 24'h009900; // verde fijo
            else if (selected_now && timeout)
                color = 24'h00FFFF; // cian (auto-selección)
            else if (selected_now)
                color = 24'h0000FF; // azul selección
            else if (pattern)
                color = 24'hFFFFFF; // patrón blanco
            else
                color = 24'h606060; // gris oscuro
        end
        else begin
            // Fondo según jugador activo
            color = (turn) ? 24'h200000 : 24'h001020;
        end

        // Separar canales RGB finales
        r = color[23:16];
        g = color[15:8];
        b = color[7:0];
    end
endmodule
