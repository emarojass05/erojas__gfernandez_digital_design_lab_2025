// videoGen.sv — Renderiza tablero 4x4 con 8 patrones y efectos visuales
// Sin inferencia de latches (100% combinacional)

module videoGen(
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic       visible,
    input  logic       timeout,           // pantalla negra cuando llega a 0
    input  logic [7:0] selected_cards,    // cartas seleccionadas
    input  logic [7:0] stored_cards,      // cartas guardadas (pares correctos)
    input  logic       row_sel,           // 1=arriba, 0=abajo
    input  logic       turn,              // 0=jugador1, 1=jugador2
    input  logic       flash,             // parpadeo verde tras acierto
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
    logic pattern, selected_now, stored_now;

    always_comb begin
        // =================== Valores por defecto ===================
        r = 8'd0;
        g = 8'd0;
        b = 8'd0;

        dx = x - BOARD_X0;
        dy = y - BOARD_Y0;
        col = 4'd0;
        row = 4'd0;
        lx  = 10'd0;
        ly  = 10'd0;
        card_id = 4'd0;
        pattern = 1'b0;
        selected_now = 1'b0;
        stored_now = 1'b0;
        in_board = (visible && !timeout && dx < TOTAL_W && dy < TOTAL_H);

        // =================== Dibujo ===================
        if (in_board) begin
            col = dx / (CARD_W + GAP_X);
            row = dy / (CARD_H + GAP_Y);
            lx  = dx % (CARD_W + GAP_X);
            ly  = dy % (CARD_H + GAP_Y);
            card_id = row * GRID_COLS + col;

            if (lx < CARD_W && ly < CARD_H) begin
                // ===== Patrones =====
                case (card_id)
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

                // ===== Selección activa =====
                if (row_sel) begin
                    if (row == 0 || row == 1)
                        selected_now = selected_cards[col + 4*row];
                end else begin
                    if (row == 2 || row == 3)
                        selected_now = selected_cards[col + 4*(row-2)];
                end

                // ===== Cartas guardadas =====
                if (row_sel) begin
                    if (row == 0 || row == 1)
                        stored_now = stored_cards[col + 4*row];
                end else begin
                    if (row == 2 || row == 3)
                        stored_now = stored_cards[col + 4*(row-2)];
                end

                // ===== Color final =====
                if (lx < 4 || lx >= CARD_W-4 || ly < 4 || ly >= CARD_H-4)
                    {r,g,b} = 24'h000000; // borde
                else if (flash && stored_now)
                    {r,g,b} = 24'h00FF00; // parpadeo verde
                else if (stored_now)
                    {r,g,b} = 24'h009900; // verde fijo (par correcto)
                else if (selected_now)
                    {r,g,b} = 24'h0000FF; // azul (seleccionada)
                else if (pattern)
                    {r,g,b} = 24'hFFFFFF; // patrón blanco
                else
                    {r,g,b} = 24'h606060; // gris oscuro
            end
        end else begin
            // Fondo según turno
            if (turn == 1'b0)
                {r,g,b} = 24'h001020; // azul tenue para jugador 1
            else
                {r,g,b} = 24'h200000; // rojo tenue para jugador 2
        end
    end
endmodule
