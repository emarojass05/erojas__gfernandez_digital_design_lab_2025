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
    input  logic [3:0] score_p1,
    input  logic [3:0] score_p2,
    output logic [7:0] r,
    output logic [7:0] g,
    output logic [7:0] b
);

    // ============================================================
    // Parámetros del tablero
    // ============================================================
    localparam CARD_W = 80;
    localparam CARD_H = 100;
    localparam GRID_COLS = 4;
    localparam GRID_ROWS = 4;
    localparam GAP_X = 20;
    localparam GAP_Y = 20;
    localparam TOTAL_W = GRID_COLS * CARD_W + (GRID_COLS - 1) * GAP_X;
    localparam TOTAL_H = GRID_ROWS * CARD_H + (GRID_ROWS - 1) * GAP_Y;
    localparam BOARD_X0 = (640 - TOTAL_W) / 2;
    localparam BOARD_Y0 = (480 - TOTAL_H) / 2;

    // ============================================================
    // Parámetros del texto
    // ============================================================
    localparam SCALE = 4;
    localparam CHAR_W = 8 * SCALE;
    localparam CHAR_H = 8 * SCALE;
    localparam MSG_LEN = 7;
    localparam BASE_X1 = 320 - (MSG_LEN * CHAR_W / 2);
    localparam BASE_Y1 = 180;
    localparam BASE_X2 = 320 - (MSG_LEN * CHAR_W / 2);
    localparam BASE_Y2 = 230;

    // ============================================================
    //  Mapa de mezcla de patrones (no altera lógica)
    // ============================================================
    logic [3:0] card_map [0:15];
    initial begin
         card_map[0]  = 3'd0;
			card_map[1]  = 3'd1;
			card_map[2]  = 3'd2;
			card_map[3]  = 3'd3;
			card_map[4]  = 3'd3;
			card_map[5]  = 3'd0;
			card_map[6]  = 3'd1;
			card_map[7]  = 3'd2;
			
			
			card_map[8]  = 3'd4;
			card_map[9]  = 3'd5;
			card_map[10] = 3'd6;
			card_map[11] = 3'd4;
			card_map[12] = 3'd5;
			card_map[13] = 3'd6;
			card_map[14] = 3'd7;
			card_map[15] = 3'd7;
			
			
			
    end

    // ============================================================
    // Señales internas
    // ============================================================
    logic [9:0] dx, dy, lx, ly;
    logic [3:0] col, row, card_id;
    logic in_board, pattern, selected_now, stored_now;
    logic [7:0] total_pairs; // mostrará puntaje del ganador
    logic [2:0] font_row_index;
    logic [7:0] char_code, font_row;
    logic pixel_on;
    logic [9:0] rel_x, rel_y, rel_x2;
    logic [2:0] bit_index;
    integer y_scaled, x_scaled, x2_scaled;
    integer idx, idx2;

    // ============================================================
    // Fuente de texto 8×8
    // ============================================================
    textROM fontROM(
        .char_code(char_code),
        .row(font_row_index),
        .bits(font_row)
    );

    // ============================================================
    // Mensajes predefinidos
    // ============================================================
    logic [7:0] msg_j1 [0:6];
    logic [7:0] msg_j2 [0:6];
    logic [7:0] msg_empate [0:6];
    logic [7:0] msg_pares [0:5];

    initial begin
        msg_j1[0]="J"; msg_j1[1]="1"; msg_j1[2]=" "; msg_j1[3]="G"; msg_j1[4]="A"; msg_j1[5]="N"; msg_j1[6]="A";
        msg_j2[0]="J"; msg_j2[1]="2"; msg_j2[2]=" "; msg_j2[3]="G"; msg_j2[4]="A"; msg_j2[5]="N"; msg_j2[6]="A";
        msg_empate[0]="E"; msg_empate[1]="M"; msg_empate[2]="P"; msg_empate[3]="A"; msg_empate[4]="T"; msg_empate[5]="E"; msg_empate[6]=" ";
        msg_pares[0]="C"; msg_pares[1]="O"; msg_pares[2]="N"; msg_pares[3]=" "; msg_pares[4]="P"; msg_pares[5]="S";
    end

    // ============================================================
    // Lógica VGA combinacional
    // ============================================================
    always_comb begin
        // ===== Inicialización total (evita latches) =====
        {r,g,b}        = 24'h000000;
        dx             = x - BOARD_X0;
        dy             = y - BOARD_Y0;
        lx             = 0;
        ly             = 0;
        col            = 0;
        row            = 0;
        card_id        = 0;
        pattern        = 1'b0;
        in_board       = 1'b0;
        selected_now   = 1'b0;
        stored_now     = 1'b0;
        pixel_on       = 1'b0;
        char_code      = 8'd32;
        total_pairs    = 8'd0;
        rel_x          = 10'd0;
        rel_y          = 10'd0;
        rel_x2         = 10'd0;
        y_scaled       = 0;
        x_scaled       = 0;
        x2_scaled      = 0;
        idx            = 0;
        idx2           = 0;
        font_row_index = 3'd0;
        bit_index      = 3'd0;

        // ====================================================
        // Comienzo de la lógica VGA
        // ====================================================

        // ===== Pantalla negra =====
        if (!visible || timeout) begin
            {r,g,b} = 24'h000000;
        end

        // ===== Pantalla final =====
        else if (game_over) begin
            // Fondo y puntaje según ganador
            if (score_p1 > score_p2) begin
                {r,g,b} = 24'h000070;   // Azul
                total_pairs = score_p1;
            end else if (score_p2 > score_p1) begin
                {r,g,b} = 24'h700000;   // Rojo
                total_pairs = score_p2;
            end else begin
                {r,g,b} = 24'h007000;   // Verde (empate)
                total_pairs = 0;
            end

            // ---- Línea 1: “J1 GANA”, “J2 GANA” o “EMPATE” ----
            if (y >= BASE_Y1 && y < BASE_Y1 + CHAR_H) begin
                rel_x = x - BASE_X1;
                rel_y = y - BASE_Y1;

                if (rel_x < (MSG_LEN * CHAR_W)) begin
                    idx = rel_x / CHAR_W;
                    if (idx < MSG_LEN) begin
                        if (score_p1 > score_p2)
                            char_code = msg_j1[idx];
                        else if (score_p2 > score_p1)
                            char_code = msg_j2[idx];
                        else
                            char_code = msg_empate[idx];
                    end
                end

                y_scaled = rel_y / SCALE;
                x_scaled = rel_x / SCALE;
                font_row_index = y_scaled[2:0];
                bit_index = 7 - x_scaled[2:0];
                pixel_on = font_row[bit_index];
                if (pixel_on)
                    {r,g,b} = 24'hFFFFFF;
            end

            // ---- Línea 2: “CON PS X” ----
            else if (y >= BASE_Y2 && y < BASE_Y2 + CHAR_H) begin
                rel_x2 = x - BASE_X2;
                rel_y  = y - BASE_Y2;

                if (rel_x2 < (MSG_LEN * CHAR_W)) begin
                    idx2 = rel_x2 / CHAR_W;
                    if (idx2 < 6)
                        char_code = msg_pares[idx2];
                    else if (idx2 == 6)
                        char_code = 8'd48 + total_pairs;
                end

                y_scaled = rel_y / SCALE;
                x2_scaled = rel_x2 / SCALE;
                font_row_index = y_scaled[2:0];
                bit_index = 7 - x2_scaled[2:0];
                pixel_on = font_row[bit_index];
                if (pixel_on)
                    {r,g,b} = 24'hFFFFFF;
            end
        end

        // ===== Tablero de juego =====
        else begin
            in_board = (dx < TOTAL_W) && (dy < TOTAL_H);
            if (in_board) begin
                col = dx / (CARD_W + GAP_X);
                row = dy / (CARD_H + GAP_Y);
                lx  = dx % (CARD_W + GAP_X);
                ly  = dy % (CARD_H + GAP_Y);
                card_id = row * GRID_COLS + col;

                // ====================================================
                // 🔀 Patrones con mezcla visual de cartas
                // ====================================================
                pattern = 1'b0;
                unique case (card_map[card_id])
                    0: pattern = ((lx ^ ly) & 8'h08);
                    1: pattern = ((lx + ly) % 20 < 10);
                    2: pattern = (((lx / 10) + (ly / 10)) % 2);
                    3: pattern = ((lx > ly) && ((lx - ly) < 20));
                    4: pattern = (((lx * ly) % 50) < 25);
                    5: pattern = (lx[3] ^ ly[3]);
                    6: pattern = (((lx + 2*ly) % 30) < 15);
                    7: pattern = (lx[2] ^ ly[4]);
                endcase
                // ====================================================

                // Estado de carta actual
                if (row < 2) begin
                    selected_now = selected_top[col + 4*row];
                    stored_now   = stored_top[col + 4*row];
                end else begin
                    selected_now = selected_bottom[col + 4*(row-2)];
                    stored_now   = stored_bottom[col + 4*(row-2)];
                end

                // Colores finales
                if (lx < 4 || lx >= CARD_W-4 || ly < 4 || ly >= CARD_H-4)
                    {r,g,b} = 24'h000000;
                else if (flash && stored_now)
                    {r,g,b} = 24'h00FF00;
                else if (stored_now)
                    {r,g,b} = 24'h008000;
                else if (selected_now)
                    {r,g,b} = 24'h0000FF;
                else if (pattern)
                    {r,g,b} = 24'hFFFFFF;
                else
                    {r,g,b} = 24'h404040;
            end
            else begin
                // Fondo según turno
                {r,g,b} = (turn==0) ? 24'h000030 : 24'h300000;
            end
        end
    end
endmodule
