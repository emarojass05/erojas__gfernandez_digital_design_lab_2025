// top_lab3_avance.sv — Reset global completo (KEY1 o timeout)

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
  output logic [6:0]  HEX0,
  output logic [6:0]  HEX1
);

  // ================== SEÑALES DE CONTROL ==================
  logic rst_manual, rst_timeout, rst_global;
  logic start_btn, start_d, start_pulse;
  logic timeout;

  // KEY1 = reset manual
  assign rst_manual = ~KEY[1];
  // KEY0 = botón de inicio
  assign start_btn = ~KEY[0];

  // ========= DETECTOR DE FLANCO (KEY0) =========
  always_ff @(posedge clk or posedge rst_manual) begin
    if (rst_manual)
      start_d <= 0;
    else
      start_d <= start_btn;
  end

  assign start_pulse = start_btn & ~start_d; // pulso único de inicio

  // ========= TICK DE 1Hz =========
  logic tick_1s;
  tick_1hz #(.SYS_CLK_HZ(50_000_000)) u_tick (
    .clk(clk),
    .rst(rst_global), // usa reset global
    .tick_1s(tick_1s)
  );

  // ================== CONTADOR ==================
  logic [3:0] tens, units;
  counter_15s u_cnt (
    .clk(clk),
    .rst(rst_global),
    .tick_1s(tick_1s),
    .start(start_pulse),
    .timeout(timeout),
    .tens(tens),
    .units(units)
  );

  // ================== RESET GLOBAL ==================
  // se activa por KEY1 o cuando el contador llega a 0
  assign rst_global = rst_manual | timeout;

  // ================== GENERADOR DE PIXEL CLOCK ==================
  logic vgaclk;
  gen_pixclk #(.SYS_CLK_HZ(50_000_000), .PIX_CLK_HZ(25_000_000)) u_pix (
    .clk(clk),
    .rst(rst_global),
    .clk_pix(vgaclk)
  );

  assign vga_clk    = vgaclk;
  assign vga_sync_n = 1'b1;

  // ================== CONTROL VGA ==================
  logic [9:0] x, y;
  logic visible;
  vga_timing_640x480 u_ctrl (
    .vgaclk(vgaclk),
    .rst(rst_global),
    .hsync(hsync),
    .vsync(vsync),
    .visible(visible),
    .x(x),
    .y(y)
  );
  assign vga_blank_n = visible;

  // ================== FSM PRINCIPAL ==================
  logic fsm_start, black_screen;
  fsm u_fsm (
    .clk(clk),
    .rst(rst_global),
    .startSW(SW[0]),
    .timeout(timeout),
    .fsm_start(fsm_start),
    .black_screen(black_screen)
  );

  // ================== SELECTOR DE CARTAS ==================
  logic [7:0] selected_cards;
  logic row_sel;
 card_selector u_sel (
    .clk(clk),
    .rst(rst_global),
    .sw(SW),
    .selected_cards(selected_cards),
    .row_sel(row_sel)
);

  // ================== VIDEO GENERATOR ==================
  videoGen u_vid (
    .x(x),
    .y(y),
    .visible(visible),
    .timeout(black_screen | rst_global), // <- reinicia pantalla con reset global
    .selected_cards(selected_cards),
    .row_sel(row_sel),
    .r(vga_r),
    .g(vga_g),
    .b(vga_b)
  );

  // ================== DISPLAYS HEX ==================
  hex7seg u_hex_units(.bcd(units), .seg(HEX0));
  hex7seg u_hex_tens (.bcd(tens), .seg(HEX1));

endmodule
