// videoGen.sv — Renderiza tablero 4x4 con 8 patrones y selección azul por switch
module videoGen(
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic       visible,
    input  logic       timeout,           // cuando llega a 0 → pantalla negra
    input  logic [7:0] selected_cards,    // 8 switches para seleccionar cartas
    input  logic       row_sel,           // 1=arriba, 0=abajo
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
    logic in_board, pattern, selected_now;

    always_comb begin
        // Asignaciones por defecto (evitan latches)
        r = 8'd0;
        g = 8'd0;
        b = 8'd0;
        dx = 10'd0;
        dy = 10'd0;
        lx = 10'd0;
        ly = 10'd0;
        col = 4'd0;
        row = 4'd0;
        card_id = 4'd0;
        in_board = 1'b0;
        pattern = 1'b0;
        selected_now = 1'b0;

        // === Cálculo principal ===
        dx = x - BOARD_X0;
        dy = y - BOARD_Y0;
        in_board = (visible && !timeout && dx < TOTAL_W && dy < TOTAL_H);

        if (in_board) begin
            col = dx / (CARD_W + GAP_X);
            row = dy / (CARD_H + GAP_Y);
            lx  = dx % (CARD_W + GAP_X);
            ly  = dy % (CARD_H + GAP_Y);
            card_id = row * GRID_COLS + col;

            if (lx < CARD_W && ly < CARD_H) begin
                // --- Patrones (por par) ---
                if (card_id < 2)        pattern = ((lx ^ ly) & 8'h08);
                else if (card_id < 4)   pattern = ((lx + ly) % 20 < 10);
                else if (card_id < 6)   pattern = (((lx / 10) + (ly / 10)) % 2);
                else if (card_id < 8)   pattern = ((lx > ly) && ((lx - ly) < 20));
                else if (card_id < 10)  pattern = (((lx * ly) % 50) < 25);
                else if (card_id < 12)  pattern = ((lx[3] ^ ly[3]));
                else if (card_id < 14)  pattern = (((lx + 2*ly) % 30) < 15);
                else                    pattern = ((lx[2] ^ ly[4]));

                // --- Selección por switch ---
                if (row_sel) begin
                    if (row == 0 || row == 1)
                        selected_now = selected_cards[col + 4*row];
                end else begin
                    if (row == 2 || row == 3)
                        selected_now = selected_cards[col + 4*(row-2)];
                end

                // --- Dibujo ---
                if (lx < 4 || lx >= CARD_W-4 || ly < 4 || ly >= CARD_H-4)
                    {r,g,b} = 24'h000000; // borde
                else if (selected_now)
                    {r,g,b} = 24'h0000FF; // carta azul (seleccionada)
                else if (pattern)
                    {r,g,b} = 24'hFFFFFF; // patrón blanco
                else
                    {r,g,b} = 24'h606060; // gris oscuro
            end
        end
    end
endmodule
