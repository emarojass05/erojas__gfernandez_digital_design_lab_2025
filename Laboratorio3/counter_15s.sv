

module counter_15s(
  input  logic clk,
  input  logic rst,
  input  logic tick_1s,
  input  logic start,
  output logic timeout,
  output logic [3:0] tens,
  output logic [3:0] units
);

  integer count;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      count   <= 15;
      timeout <= 1'b0;
    end 
    else if (tick_1s && start) begin
      if (count > 0) begin
        count   <= count - 1;
        timeout <= 1'b0;
      end 
      else begin
        timeout <= 1'b1;
        count   <= 0;
      end
    end
  end

  assign tens  = count / 10;
  assign units = count % 10;

endmodule
