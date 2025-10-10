

module vga_timing_640x480 #(
  parameter logic [9:0] HACTIVE = 10'd640,
  parameter logic [9:0] HFP     = 10'd16,
  parameter logic [9:0] HSYN    = 10'd96,
  parameter logic [9:0] HBP     = 10'd48,
  parameter logic [9:0] HMAX    = HACTIVE + HFP + HSYN + HBP, 

  parameter logic [9:0] VACTIVE = 10'd480,
  parameter logic [9:0] VFP     = 10'd10,
  parameter logic [9:0] VSYN    = 10'd2,
  parameter logic [9:0] VBP     = 10'd33,
  parameter logic [9:0] VMAX    = VACTIVE + VFP + VSYN + VBP  
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

  
  assign hsync   = ~((hcnt >= (HACTIVE+HFP)) && (hcnt < (HACTIVE+HFP+HSYN)));
  assign vsync   = ~((vcnt >= (VACTIVE+VFP)) && (vcnt < (VACTIVE+VFP+VSYN)));

  assign visible = (hcnt < HACTIVE) && (vcnt < VACTIVE);

  
  assign x = hcnt;
  assign y = vcnt;

endmodule
