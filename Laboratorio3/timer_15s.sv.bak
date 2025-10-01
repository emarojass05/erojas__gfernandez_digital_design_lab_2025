// timer_15s.sv — 50 MHz -> 1 Hz interno, cuenta 0..15 con start/clear
module timer_15s(
  input  logic clk50,
  input  logic rst_n,
  input  logic start,      // 1: habilita conteo por segundos
  input  logic clear,      // 1: reinicia a 0
  output logic [3:0] sec,  // 0..15
  output logic done        // 1 cuando llega a 15
);
  // Divisor a 1 Hz
  localparam int CNT_MAX = 50_000_000-1;
  logic [25:0] div_cnt;
  logic tick_1hz;

  always_ff @(posedge clk50 or negedge rst_n) begin
    if (!rst_n) begin div_cnt<=0; tick_1hz<=0; end
    else if (div_cnt==CNT_MAX) begin div_cnt<=0; tick_1hz<=1; end
    else begin div_cnt<=div_cnt+1; tick_1hz<=0; end
  end

  // Contador 0..15
  always_ff @(posedge clk50 or negedge rst_n) begin
    if (!rst_n) begin sec<=4'd0; done<=1'b0; end
    else if (clear) begin sec<=4'd0; done<=1'b0; end
    else if (start && tick_1hz && !done) begin
      if (sec==4'd15) begin done<=1'b1; end
      else            begin sec<=sec+4'd1; end
    end
  end
endmodule
