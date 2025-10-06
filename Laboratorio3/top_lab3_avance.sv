// top_lab3_avance.sv — Juego de memoria completo con turnos, puntajes y delay visual al acertar
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

  // ====== Señales ======
  logic rst_manual, start_btn, start_d, start_pulse;
  logic timeout;
  assign rst_manual = ~KEY[1];
  assign start_btn  = ~KEY[0];

  // ====== Detector de flanco en KEY0 ======
  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual) start_d <= 0;
    else            start_d <= start_btn;

  assign start_pulse = start_btn & ~start_d;

  // ====== Tick de 1 Hz ======
  logic tick_1s;
  tick_1hz #(.SYS_CLK_HZ(50_000_000)) u_tick(
    .clk(clk), .rst(rst_manual), .tick_1s(tick_1s)
  );

  // ====== Contador de 15 s ======
  logic [3:0] tens, units;
  counter_15s u_cnt(
    .clk(clk), .rst(rst_manual),
    .tick_1s(tick_1s),
    .start(start_pulse),
    .timeout(timeout),
    .tens(tens), .units(units)
  );

  // ====== Turnos ======
  logic turn;
  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual) turn <= 1'b0;
    else if (timeout) turn <= ~turn; // alterna jugadores

  // ====== Resets ======
  logic rst_turn;
  assign rst_turn = timeout;      // limpia tablero
  logic rst_global;
  assign rst_global = rst_manual; // solo KEY1 reinicia todo

  // ====== VGA Clock ======
  logic vgaclk;
  gen_pixclk #(.SYS_CLK_HZ(50_000_000), .PIX_CLK_HZ(25_000_000)) u_pix(
    .clk(clk), .rst(rst_manual), .clk_pix(vgaclk)
  );
  assign vga_clk = vgaclk;
  assign vga_sync_n = 1'b1;

  // ====== Control VGA ======
  logic [9:0] x, y;
  logic visible;
  vga_timing_640x480 u_ctrl(
    .vgaclk(vgaclk), .rst(rst_turn),
    .hsync(hsync), .vsync(vsync),
    .visible(visible), .x(x), .y(y)
  );
  assign vga_blank_n = visible;

  // ====== FSM ======
  logic fsm_start, black_screen;
  fsm u_fsm(
    .clk(clk), .rst(rst_turn),
    .startSW(SW[0]), .timeout(timeout),
    .fsm_start(fsm_start), .black_screen(black_screen)
  );

  // ====== Selector de cartas ======
  logic [7:0] selected_cards, stored_cards;
  logic row_sel, valid_pair;
  card_selector u_sel(
    .clk(clk), .rst(rst_turn),
    .store_btn(~KEY[2]),
    .sw(SW),
    .selected_cards(selected_cards),
    .stored_cards(stored_cards),
    .row_sel(row_sel),
    .valid_pair(valid_pair)
  );

  // ====== Puntajes ======
  logic [3:0] score_p1, score_p2;
  logic valid_d, valid_pulse;

  // Flanco de valid_pair (solo un pulso por acierto)
  always_ff @(posedge clk or posedge rst_manual)
    if (rst_manual) valid_d <= 1'b0;
    else            valid_d <= valid_pair;

  assign valid_pulse = valid_pair & ~valid_d;

  // Puntajes
  always_ff @(posedge clk or posedge rst_manual) begin
    if (rst_manual) begin
      score_p1 <= 4'd0;
      score_p2 <= 4'd0;
    end else if (valid_pulse) begin
      if (turn == 1'b0 && score_p1 < 9)
        score_p1 <= score_p1 + 1;
      else if (turn == 1'b1 && score_p2 < 9)
        score_p2 <= score_p2 + 1;
    end
  end

  // ====== Delay visual (flash de 0.5 s al acertar) ======
  logic [25:0] flash_cnt;
  logic flash_active;

  always_ff @(posedge clk or posedge rst_manual) begin
    if (rst_manual) begin
      flash_cnt    <= 0;
      flash_active <= 0;
    end else if (valid_pulse) begin
      flash_cnt    <= 25_000_000; // 0.5 s a 50 MHz
      flash_active <= 1'b1;
    end else if (flash_cnt > 0) begin
      flash_cnt <= flash_cnt - 1;
      if (flash_cnt == 1)
        flash_active <= 0;
    end
  end

  // ====== Video Generator ======
  videoGen u_vid(
    .x(x),
    .y(y),
    .visible(visible),
    .timeout(black_screen | rst_turn),
    .selected_cards(selected_cards),
    .stored_cards(stored_cards),
    .row_sel(row_sel),
    .turn(turn),
    .flash(flash_active),      // nuevo: parpadeo visual
    .r(vga_r),
    .g(vga_g),
    .b(vga_b)
  );

  // ====== Displays ======
  hex7seg u_hex_units(.bcd(units), .seg(HEX0));
  hex7seg u_hex_tens (.bcd(tens), .seg(HEX1));
  hex7seg u_hex_p1   (.bcd(score_p1), .seg(HEX2));
  hex7seg u_hex_p2   (.bcd(score_p2), .seg(HEX3));

endmodule
