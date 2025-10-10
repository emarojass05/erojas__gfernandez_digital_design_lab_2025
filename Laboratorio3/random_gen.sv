
module random_gen(
  input  logic clk,
  input  logic rst,
  output logic [2:0] rand_idx
);
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      rand_idx <= 3'b101;  // semilla inicial
    else
      rand_idx <= {rand_idx[1] ^ rand_idx[2], rand_idx[0], rand_idx[2]};
  end
endmodule
