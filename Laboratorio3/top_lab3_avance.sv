// top_lab3_avance.sv — Top con VGA + contador + FSM (solo para visualizar) + HEX display

module top_lab3_avance(
  input  logic        clk,          // clock 50 MHz
  input  logic [9:0]  SW,           // switches (SW0 inicia contador)
  input  logic [3:0]  KEY,          // botones (KEY0 = reset)
  output logic        hsync,
  output logic        vsync,
  output logic        vga_clk,
  output logic        vga_blank_n,
  output logic        vga_sync_n,
  output logic [7:0]  vga_r,
  output logic [7:0]  vga_g,
  output logic [7:0]  vga_b,
  output logic [6:0]  HEX0,         // display unidades
  output logic [6:0]  HEX1          // display decenas
);

  // ===== Reset global =====
  logic rst;
  assign rst = ~KEY[0];   // KEY0 presionado → rst=1

  // ===== Pixel clock =====
  logic vgaclk;
  gen_pixclk #(
    .SYS_CLK_HZ(50_000_000),
    .PIX_CLK_HZ(25_000_000)
  ) u_pix (
    .clk    (clk),
    .rst    (rst),
    .clk_pix(vgaclk)
  );

  assign vga_clk    = vgaclk;
  assign vga_sync_n = 1'b1;

  // ===== Controlador VGA =====
  logic [9:0] x, y;
  logic       visible;

  vga_timing_640x480 u_ctrl(
    .vgaclk (vgaclk),
    .rst    (rst),
    .hsync  (hsync),
    .vsync  (vsync),
    .visible(visible),
    .x      (x),
    .y      (y)
  );

  assign vga_blank_n = visible;

  // ===== Tick 1 Hz =====
  logic tick_1s;
  tick_1hz #(
    .SYS_CLK_HZ(50_000_000)
  ) u_tick (
    .clk   (clk),
    .rst   (rst),
    .tick_1s(tick_1s)
  );

  // ===== Señales FSM (solo para visualizar estados) =====
  logic fsm_start;
  logic black_screen;
  logic timeout;

  fsm u_fsm (
    .clk         (clk),
    .rst         (rst),
    .startSW     (SW[0]),      // conectado, pero no usado en lógica
    .timeout     (timeout),    // conectado, pero no usado en lógica
    .fsm_start   (fsm_start),  // no afecta
    .black_screen(black_screen),// no afecta
    .state_out   ()            // no necesitamos observarlo en top
  );

  // ===== Contador 15s =====
  logic [3:0] tens, units;

  counter_15s u_cnt (
    .clk    (clk),
    .rst    (rst),
    .tick_1s(tick_1s),
    .start  (SW[0]),    // 🔑 volvemos al switch directamente
    .timeout(timeout),
    .tens   (tens),
    .units  (units)
  );

  // ===== Video VGA =====
  videoGen u_vid(
    .x(x),
    .y(y),
    .visible(visible),
    .timeout(timeout),   // sigue apagando pantalla en 0
    .r(vga_r),
    .g(vga_g),
    .b(vga_b)
  );

  // ===== HEX displays =====
  hex7seg u_hex_units (
    .bcd(units),
    .seg(HEX0)
  );

  hex7seg u_hex_tens (
    .bcd(tens),
    .seg(HEX1)
  );

endmodule
