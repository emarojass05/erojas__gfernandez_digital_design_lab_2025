// top_fpga.sv — integra VGA + timer 15s + FSM genérica
module top_fpga(
  input  logic CLOCK_50,
  input  logic [1:0] KEY,       // KEY0 reset (activo-bajo), KEY1 start (activo-bajo)
  output logic VGA_HS, VGA_VS,
  output logic [3:0] VGA_R, VGA_G, VGA_B,
  output logic [3:0] LEDR
);
  logic rst_n = KEY[0]; // no presionado = 1

  // Sincronizador de botón start (KEY1 es activo-bajo en la placa)
  logic start_raw, start_q1, start_q2;
  assign start_raw = ~KEY[1]; // presionar -> 1
  always_ff @(posedge CLOCK_50 or negedge rst_n) begin
    if (!rst_n) begin start_q1<=1'b0; start_q2<=1'b0; end
    else begin       start_q1<=start_raw; start_q2<=start_q1; end
  end
  wire start_btn = start_q2 & ~start_q1; // flanco ascendente

  // Timer 15 s
  logic [3:0] sec;
  logic t_done, t_start, t_clear;

  timer_15s u_t15(
    .clk50 (CLOCK_50),
    .rst_n (rst_n),
    .start (t_start),
    .clear (t_clear),
    .sec   (sec),
    .done  (t_done)
  );

  // FSM de juego
  logic show_cards, in_timeup;
  game_fsm u_fsm(
    .clk       (CLOCK_50),
    .rst_n     (rst_n),
    .start_btn (start_btn),
    .t_done    (t_done),
    .show_cards(show_cards),
    .t_start   (t_start),
    .t_clear   (t_clear),
    .in_timeup (in_timeup)
  );

  // VGA
  vga u_vga(
    .CLOCK_50 (CLOCK_50),
    .rst_n    (rst_n),
    .show_cards(show_cards),
    .VGA_HS   (VGA_HS),
    .VGA_VS   (VGA_VS),
    .VGA_R    (VGA_R),
    .VGA_G    (VGA_G),
    .VGA_B    (VGA_B)
  );

  // LEDs de estado básicos
  // LEDR[0] = done 15s, LEDR[1] = timeup, LEDR[3:2] libres
  assign LEDR[0] = t_done;
  assign LEDR[1] = in_timeup;
  assign LEDR[3:2] = 2'b00;
endmodule
