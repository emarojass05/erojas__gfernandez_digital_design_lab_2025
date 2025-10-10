// Top mínimo para probar VGA en DE10-Standard
module top_vga_test(
  input  logic CLOCK_50,          // Reloj de la FPGA
  output logic VGA_HS, VGA_VS,    // Señales de sincronismo VGA
  output logic [7:0] VGA_R,       // Rojo
  output logic [7:0] VGA_G,       // Verde
  output logic [7:0] VGA_B        // Azul
);

  // --------------------------
  // PLL → genera 25 MHz
  // --------------------------
  logic clk_vga;
  videovga u_pll (
    .ref_clk_clk        (CLOCK_50),
    .ref_reset_reset    (1'b0),      // siempre habilitado
    .vga_clk_clk        (clk_vga),
    .video_in_clk_clk   (),          // no usado
    .lcd_clk_clk        (),          // no usado
    .reset_source_reset ()           // no usado
  );

  // --------------------------
  // VGA básico (rectángulo verde)
  // --------------------------
  vga u_vga(
    .clk   (clk_vga),
    .rst_n (1'b1),       // sin reset por ahora
    .hsync (VGA_HS),
    .vsync (VGA_VS),
    .r     (VGA_R),
    .g     (VGA_G),
    .b     (VGA_B)
  );

endmodule
