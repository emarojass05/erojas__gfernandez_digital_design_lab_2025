// ============================================================
// videoGen.sv
// Renderiza tablero 4x4 con 8 patrones, selección y colores.
// Versión 100% combinacional (sin latches).
// ============================================================

module videoGen(
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic       visible,
    input  logic       timeout,           // pantalla negra solo al inicio
    input  logic [7:0] selected_top,      // cartas seleccionadas (fila superior)
    input  logic [7:0] selected_bottom,   // cartas seleccionadas (fila inferior)
    input  logic [7:0] stored_top,        // cartas guardadas (pares correctos)
    input  logic [7:0] stored_bottom,     // cartas guardadas (pares correctos)
    input  logic       row_sel,           // 1=arriba, 0=abajo
    input  logic       turn,              // jugador actual
    input  logic       flash,             // parpadeo al acertar
    input  logic       game_over,         // todas las cartas encontradas
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

    localparam TOTAL_W = GRID_COLS * CARD_W + (GRID_COLS - 1) * GAP_X;
    localparam TOTAL_H = GRID_ROWS * CARD_H + (GRID_ROWS - 1) * GAP_Y;
    localparam BOARD_X0 = (640 - TOTAL_W) / 2;
    localparam BOARD_Y0 = (480 - TOTAL_H) / 2;

    // === Señales internas ===
    logic [9:0] dx, dy, lx, ly;
    logic [3:0] col, row, card_id;
    logic in_board, pattern, selected_now, stored_now;

    always_comb begin
        // =================== Valores por defecto ===================
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
        pattern = 1'b0;
        selected_now = 1'b0;
        stored_now = 1'b0;
        in_board = 1'b0;

        // =================== Lógica principal ===================
        if (!visible || timeout) begin
            // Pantalla negra (inicio o reinicio)
            {r,g,b} = 24'h000000;
        end 
        else begin
            // Calcular posición relativa
            dx = x - BOARD_X0;
            dy = y - BOARD_Y0;
            in_board = (dx < TOTAL_W) && (dy < TOTAL_H);

            if (in_board) begin
                col = dx / (CARD_W + GAP_X);
                row = dy / (CARD_H + GAP_Y);
                lx  = dx % (CARD_W + GAP_X);
                ly  = dy % (CARD_H + GAP_Y);
                card_id = row * GRID_COLS + col;

                // --- Patrones por carta (pares iguales) ---
                pattern = 1'b0;
                if (card_id < 2)        pattern = ((lx ^ ly) & 8'h08);
                else if (card_id < 4)   pattern = ((lx + ly) % 20 < 10);
                else if (card_id < 6)   pattern = (((lx / 10) + (ly / 10)) % 2);
                else if (card_id < 8)   pattern = ((lx > ly) && ((lx - ly) < 20));
                else if (card_id < 10)  pattern = (((lx * ly) % 50) < 25);
                else if (card_id < 12)  pattern = (lx[3] ^ ly[3]);
                else if (card_id < 14)  pattern = (((lx + 2*ly) % 30) < 15);
                else                    pattern = (lx[2] ^ ly[4]);

                // --- Selección y almacenamiento ---
                if (row < 2) begin
                    selected_now = selected_top[col + 4*row];
                    stored_now   = stored_top[col + 4*row];
                end else begin
                    selected_now = selected_bottom[col + 4*(row-2)];
                    stored_now   = stored_bottom[col + 4*(row-2)];
                end

                // --- Dibujo de la carta ---
                if (lx < 4 || lx >= CARD_W-4 || ly < 4 || ly >= CARD_H-4)
                    {r,g,b} = 24'h000000;          // borde negro
                else if (flash && stored_now)
                    {r,g,b} = 24'h00FF00;          // par recién acertado
                else if (stored_now)
                    {r,g,b} = 24'h008000;          // par correcto fijo
                else if (selected_now)
                    {r,g,b} = 24'h0000FF;          // carta seleccionada
                else if (pattern)
                    {r,g,b} = 24'hFFFFFF;          // patrón blanco
                else
                    {r,g,b} = 24'h404040;          // fondo gris oscuro
            end 
            else begin
                // Zona fuera del tablero
                if (turn == 1'b0)
                    {r,g,b} = 24'h000030;          // azul tenue jugador 1
                else
                    {r,g,b} = 24'h300000;          // rojo tenue jugador 2
            end

            // --- Pantalla final ---
            if (game_over)
                {r,g,b} = 24'h00FFFF;              // cian: fin del juego
        end
    end
endmodule
