// vga.sv — VGA 640x480@60 + tablero con cartas
module vga(
  input  logic CLOCK_50,      // 50 MHz
  input  logic rst_n,         // reset activo-bajo
  input  logic show_cards,    // 1: pintar cartas; 0: solo fondo
  output logic VGA_HS, VGA_VS,
  output logic [3:0] VGA_R, VGA_G, VGA_B
);
  // --- Divisor 50 MHz -> 25 MHz (pixel clock) ---
  logic pclk25;
  always_ff @(posedge CLOCK_50 or negedge rst_n) begin
    if (!rst_n) pclk25 <= 1'b0;
    else        pclk25 <= ~pclk25;
  end

  // --- Timing 640x480@60 ---
  localparam H_VISIBLE=640, H_FP=16, H_SYNC=96, H_BP=48, H_TOTAL=800;
  localparam V_VISIBLE=480, V_FP=10, V_SYNC=2,  V_BP=33, V_TOTAL=525;

  logic [9:0] hcnt, vcnt;
  always_ff @(posedge pclk25 or negedge rst_n) begin
    if (!rst_n) begin hcnt<=10'd0; vcnt<=10'd0; end
    else begin
      if (hcnt == H_TOTAL-1) begin
        hcnt <= 10'd0;
        vcnt <= (vcnt == V_TOTAL-1) ? 10'd0 : vcnt + 10'd1;
      end else begin
        hcnt <= hcnt + 10'd1;
      end
    end
  end

  assign VGA_HS = ~((hcnt >= H_VISIBLE+H_FP) && (hcnt < H_VISIBLE+H_FP+H_SYNC));
  assign VGA_VS = ~((vcnt >= V_VISIBLE+V_FP) && (vcnt < V_VISIBLE+V_FP+V_SYNC));

  logic visible; assign visible = (hcnt < H_VISIBLE) && (vcnt < V_VISIBLE);
  logic [9:0] x, y; assign x = hcnt; assign y = vcnt;

  // --- Dibujo: fondo + 6 cartas rectangulares ---
  function automatic bit in_rect(input int xi, yi, w, h);
    return (x>=xi && x<xi+w && y>=yi && y<yi+h);
  endfunction

  bit c1 = in_rect( 20,  20, 160, 200);
  bit c2 = in_rect(240,  20, 160, 200);
  bit c3 = in_rect(460,  20, 160, 200);
  bit c4 = in_rect( 20, 260, 160, 200);
  bit c5 = in_rect(240, 260, 160, 200);
  bit c6 = in_rect(460, 260, 160, 200);

  // Colores (4 bits por canal)
  logic [3:0] Rbg=4'h1, Gbg=4'h2, Bbg=4'h3; // fondo
  logic [3:0] Rc =4'hF, Gc =4'hE, Bc =4'hD; // cartas

  always_comb begin
    if (!visible)           {VGA_R,VGA_G,VGA_B} = 12'h000;
    else                    {VGA_R,VGA_G,VGA_B} = {Rbg,Gbg,Bbg};
    if (show_cards) begin
      if (c1) {VGA_R,VGA_G,VGA_B} = {Rc,Gc,Bc};
      if (c2) {VGA_R,VGA_G,VGA_B} = {Rc,Gc,Bc};
      if (c3) {VGA_R,VGA_G,VGA_B} = {Rc,Gc,Bc};
      if (c4) {VGA_R,VGA_G,VGA_B} = {Rc,Gc,Bc};
      if (c5) {VGA_R,VGA_G,VGA_B} = {Rc,Gc,Bc};
      if (c6) {VGA_R,VGA_G,VGA_B} = {Rc,Gc,Bc};
    end
  end
endmodule
