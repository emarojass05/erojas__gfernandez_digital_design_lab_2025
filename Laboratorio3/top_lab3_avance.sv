

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

  // ===== Entradas básicas =====
  logic rst_manual, start_btn;
  logic store_btn, store_btn_manual;

  assign rst_manual      = ~KEY[1];
  assign start_btn       = ~KEY[0];
  assign store_btn_manual = ~KEY[2];

  // Simula botón automático al terminar el tiempo
  logic timeout;
  assign store_btn = store_btn_manual | timeout;

  // ===== Tick 1Hz =====
  logic tick_1s;
  tick_1hz #(.SYS_CLK_HZ(50_000_000)) u_tick(
    .clk(clk),
    .rst(rst_manual),
    .tick_1s(tick_1s)
  );

  // ===== Señales FSM =====
  logic enable_input, enable_counter, reset_counter;
  logic change_turn, black_screen, game_over;

  // ===== Contador 15s =====
  logic [3:0] tens, units;
  counter_15s u_cnt(
    .clk(clk),
    .rst(rst_manual | reset_counter),
    .tick_1s(tick_1s),
    .start(enable_counter),
    .timeout(timeout),
    .tens(tens),
    .units(units)
  );

  // ===== Selector de cartas =====
  logic [7:0] selected_top, selected_bottom;
  logic [7:0] stored_top, stored_bottom;
  logic row_sel;
  logic valid_pair_raw, invalid_pair_raw;

  // ===== Auto-selección =====
  logic [9:0] sw_auto;    
  logic [9:0] sw_final;   

  auto_selector u_auto_sel (
    .clk(clk),
    .rst(rst_manual),
    .enable_auto(timeout),
    .valid_pair(valid_pulse),
    .stored_top(stored_top),
    .stored_bottom(stored_bottom),
    .sw_auto(sw_auto)
  );

  // Combinar switches reales + automáticos
  assign sw_final[8]   = SW[8];             // fila manual
  assign sw_final[7:0] = SW[7:0] | sw_auto[7:0];
  assign sw_final[9]   = 1'b0;              // no usado

  card_selector u_sel(
    .clk(clk),
    .rst(rst_manual),
    .store_btn(store_btn),
    .sw(sw_final),
    .selected_top(selected_top),
    .selected_bottom(selected_bottom),
    .stored_top(stored_top),
    .stored_bottom(stored_bottom),
    .row_sel(row_sel),
    .valid_pair(valid_pair_raw),
    .invalid_pair(invalid_pair_raw)
  );

  // ===== Sincronización de pulsos =====
  logic valid_d, invalid_d;
  logic valid_pulse, invalid_pulse;

  always_ff @(posedge clk or posedge rst_manual) begin
    if (rst_manual) begin
      valid_d   <= 0;
      invalid_d <= 0;
    end else begin
      valid_d   <= valid_pair_raw;
      invalid_d <= invalid_pair_raw;
    end
  end

  assign valid_pulse   = valid_pair_raw & ~valid_d;
  assign invalid_pulse = invalid_pair_raw & ~invalid_d;

  // ===== FSM principal =====
  logic all_pairs_done;
  assign all_pairs_done = (&stored_top) && (&stored_bottom);

  fsm_game u_fsm(
    .clk(clk),
    .rst(rst_manual),
    .start_btn(start_btn),
    .timeout(timeout),
    .valid_pair(valid_pulse),
    .invalid_pair(invalid_pulse),
    .all_pairs_done(all_pairs_done),
    .enable_input(enable_input),
    .enable_counter(enable_counter),
    .reset_counter(reset_counter),
    .change_turn(change_turn),
    .black_screen(black_screen),
    .game_over(game_over)
  );

  // ===== Turnos =====
  logic turn;
  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual)
      turn <= 1'b0;
    else if (change_turn)
      turn <= ~turn;

  // ===== Puntajes =====
  logic [3:0] score_p1, score_p2;
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

  // ===== VGA clock =====
  logic vgaclk;
  gen_pixclk #(.SYS_CLK_HZ(50_000_000), .PIX_CLK_HZ(25_000_000)) u_pix(
    .clk(clk),
    .rst(rst_manual),
    .clk_pix(vgaclk)
  );
  assign vga_clk = vgaclk;
  assign vga_sync_n = 1'b1;

  // ===== Control VGA =====
  logic [9:0] x, y;
  logic visible;
  vga_timing_640x480 u_ctrl(
    .vgaclk(vgaclk),
    .rst(rst_manual),
    .hsync(hsync),
    .vsync(vsync),
    .visible(visible),
    .x(x),
    .y(y)
  );
  assign vga_blank_n = visible;

  // ===== Video Generator =====
  videoGen u_vid(
    .x(x),
    .y(y),
    .visible(visible),
    .timeout(black_screen),
    .selected_top(selected_top),
    .selected_bottom(selected_bottom),
    .stored_top(stored_top),
    .stored_bottom(stored_bottom),
    .row_sel(row_sel),
    .turn(turn),
    .flash(valid_pulse),
    .game_over(game_over),
    .score_p1(score_p1),
    .score_p2(score_p2),
    .r(vga_r),
    .g(vga_g),
    .b(vga_b)
  );

  // ===== Displays 7 segmentos =====
  hex7seg u_hex_units (.bcd(units), .seg(HEX0));
  hex7seg u_hex_tens  (.bcd(tens),  .seg(HEX1));
  hex7seg u_hex_p1    (.bcd(score_p1), .seg(HEX2));
  hex7seg u_hex_p2    (.bcd(score_p2), .seg(HEX3));

endmodule
