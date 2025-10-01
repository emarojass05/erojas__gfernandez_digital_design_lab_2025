// top_fpga_barras.sv — Test VGA mínimo con barras de color
// Genera 640x480 @60Hz y muestra 3 franjas verticales: Rojo, Verde y Azul

module top_fpga_barras(
  input  logic CLOCK_50,       // Reloj base de la DE10
  input  logic [0:0] SW,       // SW0 = reset general (opcional)
  output logic VGA_HS, VGA_VS,
  output logic [7:0] VGA_R, VGA_G, VGA_B
);

  // Reset activo bajo
  logic rst_n;
  assign rst_n = SW[0];

  // Clock VGA desde IP videovga (25.175 MHz ideal, 25 MHz aprox)
  logic clk_vga;
  videovga u_pll (
    .ref_clk_clk        (CLOCK_50),
    .ref_reset_reset    (1'b0),   // forzar sin reset para que siempre arranque
    .vga_clk_clk        (clk_vga),
    .reset_source_reset ()
  );

  // --- Parámetros 640x480 @ 60Hz ---
  localparam H_VISIBLE=640, H_FP=16, H_SYNC=96, H_BP=48, H_TOTAL=800;
  localparam V_VISIBLE=480, V_FP=10, V_SYNC=2, V_BP=33, V_TOTAL=525;

  logic [9:0] hcnt, vcnt;

  // Contadores horizontales y verticales
  always_ff @(posedge clk_vga or negedge rst_n) begin
    if (!rst_n) begin
      hcnt <= 0; vcnt <= 0;
    end else begin
      if (hcnt == H_TOTAL-1) begin
        hcnt <= 0;
        vcnt <= (vcnt == V_TOTAL-1) ? 0 : vcnt+1;
      end else begin
        hcnt <= hcnt + 1;
      end
    end
  end

  // Señales de sincronismo
  assign VGA_HS = ~((hcnt >= H_VISIBLE+H_FP) && (hcnt < H_VISIBLE+H_FP+H_SYNC));
  assign VGA_VS = ~((vcnt >= V_VISIBLE+V_FP) && (vcnt < V_VISIBLE+V_FP+V_SYNC));

  // Área visible
  wire visible = (hcnt < H_VISIBLE) && (vcnt < V_VISIBLE);

  // --- Generación de barras de colores ---
  always_comb begin
    if (!visible) begin
      VGA_R = 8'h00; VGA_G = 8'h00; VGA_B = 8'h00;  // negro fuera del área visible
    end else if (hcnt < 213) begin
      VGA_R = 8'hFF; VGA_G = 8'h00; VGA_B = 8'h00;  // Rojo
    end else if (hcnt < 426) begin
      VGA_R = 8'h00; VGA_G = 8'hFF; VGA_B = 8'h00;  // Verde
    end else begin
      VGA_R = 8'h00; VGA_G = 8'h00; VGA_B = 8'hFF;  // Azul
    end
  end

endmodule
