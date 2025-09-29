// vga_timing_640x480.sv — 640x480@60Hz (25.175 MHz)
// HS/VS activos en bajo, visible=1 dentro de área activa

module vga_timing_640x480 #(
  parameter logic [9:0] HACTIVE = 10'd640,
  parameter logic [9:0] HFP     = 10'd16,
  parameter logic [9:0] HSYN    = 10'd96,
  parameter logic [9:0] HBP     = 10'd48,
  parameter logic [9:0] HMAX    = HACTIVE + HFP + HSYN + HBP, // 800

  parameter logic [9:0] VACTIVE = 10'd480,
  parameter logic [9:0] VFP     = 10'd10,
  parameter logic [9:0] VSYN    = 10'd2,
  parameter logic [9:0] VBP     = 10'd33,
  parameter logic [9:0] VMAX    = VACTIVE + VFP + VSYN + VBP  // 525
)(
  input  logic       vgaclk,
  input  logic       rst,
  output logic       hsync,
  output logic       vsync,
  output logic       visible,
  output logic [9:0] x,
  output logic [9:0] y
);

  logic [9:0] hcnt, vcnt;

  always_ff @(posedge vgaclk) begin
    if (rst) begin
      hcnt <= 10'd0;
      vcnt <= 10'd0;
    end else begin
      if (hcnt == HMAX-1) begin
        hcnt <= 10'd0;
        vcnt <= (vcnt == VMAX-1) ? 10'd0 : (vcnt + 10'd1);
      end else begin
        hcnt <= hcnt + 10'd1;
      end
    end
  end

  // HS/VS activos en bajo
  assign hsync   = ~((hcnt >= (HACTIVE+HFP)) && (hcnt < (HACTIVE+HFP+HSYN)));
  assign vsync   = ~((vcnt >= (VACTIVE+VFP)) && (vcnt < (VACTIVE+VFP+VSYN)));

  // Área visible
  assign visible = (hcnt < HACTIVE) && (vcnt < VACTIVE);

  // Coordenadas visibles
  assign x = hcnt;
  assign y = vcnt;

endmodule
