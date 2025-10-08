// ============================================================
// top_lab3_avance.sv
// Juego de memoria digital completo con:
// - Turnos alternos (15 s por jugador)
// - Reinicio del contador si acierta (mantiene turno)
// - Auto-selección de cartas al expirar el tiempo
// - Puntuación automática
// - VGA 640x480
// ============================================================

module top_lab3_avance(
  input  logic        clk,
  input  logic [9:0]  SW,
  input  logic [3:0]  KEY,
  output logic        hsync,
  output logic        vsync,
  output logic        vga_clk,
  output logic        vga_blank_n,
  output logic        vga_sync_n,
  output logic [7:0]  vga_r,
  output logic [7:0]  vga_g,
  output logic [7:0]  vga_b,
  output logic [6:0]  HEX0, HEX1, HEX2, HEX3
);

  // ========= Señales básicas =========
  logic rst_manual, store_btn, start_btn;
  assign rst_manual = ~KEY[1];   // reset global
  assign store_btn  = ~KEY[2];   // guardar cartas
  assign start_btn  = ~KEY[0];   // iniciar contador (solo una vez)

  logic timeout;
  logic start_d, start_pulse;

  // ========= Detector de flanco en KEY0 =========
  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual) start_d <= 0;
    else            start_d <= start_btn;

  assign start_pulse = start_btn & ~start_d;

  // ========= Tick de 1 Hz =========
  logic tick_1s;
  tick_1hz #(.SYS_CLK_HZ(50_000_000)) u_tick(
    .clk(clk), .rst(rst_manual), .tick_1s(tick_1s)
  );

  // ========= Flanco de timeout =========
  logic timeout_d, timeout_pulse;
  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual)
      timeout_d <= 1'b0;
    else
      timeout_d <= timeout;

  assign timeout_pulse = timeout & ~timeout_d;

  // ========= Turnos y reinicio de contador =========
  logic turn;
  logic reset_counter;

  always_ff @(posedge clk or posedge rst_manual) begin
    if (rst_manual) begin
      turn <= 1'b0;
      reset_counter <= 1'b0;
    end
    else begin
      // Reinicia contador si acierta (mantiene turno)
      if (valid_pulse) begin
        reset_counter <= 1'b1;
      end
      // Al expirar el tiempo: reinicia contador y cambia turno si NO acertó
      else if (timeout_pulse) begin
        reset_counter <= 1'b1;
        if (!valid_pair)
          turn <= ~turn;
      end
      else begin
        reset_counter <= 1'b0;
      end
    end
  end

  // ========= Contador de 15 s (reinicia con acierto o timeout) =========
  logic [3:0] tens, units;
  counter_15s u_cnt(
    .clk(clk),
    .rst(rst_manual | reset_counter), // reinicia en cada acierto o timeout
    .tick_1s(tick_1s),
    .start(1'b1),                     // siempre activo
    .timeout(timeout),
    .tens(tens),
    .units(units)
  );

  // ========= VGA Clock =========
  logic vgaclk;
  gen_pixclk #(.SYS_CLK_HZ(50_000_000), .PIX_CLK_HZ(25_000_000)) u_pix(
    .clk(clk), .rst(rst_manual), .clk_pix(vgaclk)
  );
  assign vga_clk = vgaclk;
  assign vga_sync_n = 1'b1;

  // ========= Control VGA =========
  logic [9:0] x, y;
  logic visible;
  vga_timing_640x480 u_ctrl(
    .vgaclk(vgaclk), .rst(rst_manual),
    .hsync(hsync), .vsync(vsync),
    .visible(visible), .x(x), .y(y)
  );
  assign vga_blank_n = visible;

  // ========= FSM =========
  logic fsm_start, black_screen;
  fsm u_fsm(
    .clk(clk), .rst(rst_manual),
    .startSW(SW[0]), .timeout(timeout),
    .fsm_start(fsm_start), .black_screen(black_screen)
  );

  // ========= Selector de cartas =========
  logic [7:0] selected_top_raw, selected_bottom_raw;
  logic [7:0] stored_top, stored_bottom;
  logic row_sel, valid_pair;

  card_selector u_sel(
    .clk(clk),
    .rst(rst_manual),
    .store_btn(store_btn),
    .sw(SW),
    .selected_top(selected_top_raw),
    .selected_bottom(selected_bottom_raw),
    .stored_top(stored_top),
    .stored_bottom(stored_bottom),
    .row_sel(row_sel),
    .valid_pair(valid_pair)
  );

  // ========= Generador pseudoaleatorio =========
  logic [2:0] rand_idx, rand_idx2;
  random_gen u_rand(
    .clk(clk),
    .rst(rst_manual),
    .rand_idx(rand_idx)
  );

  random_gen u_rand2(
    .clk(clk),
    .rst(rst_manual),
    .rand_idx(rand_idx2)
  );

  // ========= Auto-selección al expirar el tiempo =========
  logic [7:0] auto_selected_top, auto_selected_bottom;

  always_ff @(posedge clk or posedge rst_manual) begin
    int idx, idx2;
    if (rst_manual) begin
      auto_selected_top    <= 8'd0;
      auto_selected_bottom <= 8'd0;
    end 
    else begin
      auto_selected_top    <= selected_top_raw;
      auto_selected_bottom <= selected_bottom_raw;

      if (timeout_pulse && selected_top_raw == 8'd0 && selected_bottom_raw == 8'd0) begin
        logic [7:0] mask1, mask2;
        mask1 = 8'd0;
        mask2 = 8'd0;

        if (stored_top != 8'hFF) begin
          for (int i = 0; i < 8; i++) begin
            idx = (rand_idx + i) % 8;
            if (!stored_top[idx]) begin
              mask1 = (8'b1 << idx);
              break;
            end
          end
        end

        if (stored_bottom != 8'hFF) begin
          for (int j = 0; j < 8; j++) begin
            idx2 = (rand_idx2 + j) % 8;
            if (!stored_bottom[idx2]) begin
              mask2 = (8'b1 << idx2);
              break;
            end
          end
        end

        auto_selected_top    <= mask1;
        auto_selected_bottom <= mask2;
      end

      if (timeout_pulse) begin
        auto_selected_top    <= 8'd0;
        auto_selected_bottom <= 8'd0;
      end
    end
  end

  // ========= Puntajes =========
  logic [3:0] score_p1, score_p2;
  logic valid_d, valid_pulse;

  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual)
      valid_d <= 1'b0;
    else
      valid_d <= valid_pair;

  assign valid_pulse = valid_pair & ~valid_d;

  always_ff @(posedge clk or posedge rst_manual) begin
    if (rst_manual) begin
      score_p1 <= 0;
      score_p2 <= 0;
    end else if (valid_pulse) begin
      if (turn == 1'b0 && score_p1 < 9)
        score_p1 <= score_p1 + 1;
      else if (turn == 1'b1 && score_p2 < 9)
        score_p2 <= score_p2 + 1;
    end
  end

  // ========= Fin del juego =========
  logic game_over;
  assign game_over = (&stored_top) && (&stored_bottom);

  // ========= Video =========
  videoGen u_vid(
    .x(x),
    .y(y),
    .visible(visible),
    .timeout(black_screen),
    .selected_top(auto_selected_top),
    .selected_bottom(auto_selected_bottom),
    .stored_top(stored_top),
    .stored_bottom(stored_bottom),
    .row_sel(row_sel),
    .turn(turn),
    .flash(valid_pulse),
    .game_over(game_over),
    .r(vga_r),
    .g(vga_g),
    .b(vga_b)
  );

  // ========= Displays HEX =========
  hex7seg u_hex_units (.bcd(units), .seg(HEX0));
  hex7seg u_hex_tens  (.bcd(tens),  .seg(HEX1));
  hex7seg u_hex_p1    (.bcd(score_p1), .seg(HEX2));
  hex7seg u_hex_p2    (.bcd(score_p2), .seg(HEX3));

endmodule
