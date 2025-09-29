// videoGen.sv — Renderiza tablero 4x4 y apaga la pantalla al terminar el tiempo

module videoGen(
    input  logic [9:0] x,
    input  logic [9:0] y,
    input  logic       visible,
    input  logic       timeout,       // cuando llega a 0 → pantalla negra
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
    logic [3:0] col, row;
    logic in_board;

    always_comb begin
        // Fondo negro por defecto
        r = 8'd0;
        g = 8'd0;
        b = 8'd0;

        dx = 10'd0;
        dy = 10'd0;
        lx = 10'd0;
        ly = 10'd0;
        col = 4'd0;
        row = 4'd0;
        in_board = 1'b0;

        // Si timeout → pantalla negra
        if (visible && !timeout) begin
            // --- Cartas ---
            dx = x - BOARD_X0;
            dy = y - BOARD_Y0;

            in_board = (dx < TOTAL_W) && (dy < TOTAL_H);

            if (in_board) begin
                col = dx / (CARD_W + GAP_X);
                row = dy / (CARD_H + GAP_Y);

                lx = dx % (CARD_W + GAP_X);
                ly = dy % (CARD_H + GAP_Y);

                if (lx < CARD_W && ly < CARD_H) begin
                    if (lx < 4 || lx >= CARD_W-4 || ly < 4 || ly >= CARD_H-4) begin
                        r = 8'd0; g = 8'd0; b = 8'd0;   // borde negro
                    end else begin
                        r = 8'd255; g = 8'd255; b = 8'd255; // carta blanca
                    end
                end
            end
        end
    end

endmodule
