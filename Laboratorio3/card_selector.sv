// card_selector.sv — Detecta pares correctos y guarda solo si coinciden
module card_selector(
  input  logic        clk,
  input  logic        rst,
  input  logic        store_btn,
  input  logic [9:0]  sw,
  output logic [7:0]  selected_cards,
  output logic [7:0]  stored_cards,
  output logic        row_sel,
  output logic        valid_pair
);

  logic [7:0] new_sel;
  integer count, i1, i2;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      selected_cards <= 0;
      stored_cards   <= 0;
      row_sel        <= 0;
      valid_pair     <= 0;
    end else begin
      row_sel <= sw[8];
      new_sel = sw[7:0];

      // contar cartas activas
      count = 0; i1 = -1; i2 = -1;
      for (int i = 0; i < 8; i++) begin
        if (new_sel[i]) begin
          count++;
          if (i1 == -1) i1 = i; else i2 = i;
        end
      end

      if (count <= 2)
        selected_cards <= new_sel;

      // verificar par válido
      valid_pair <= 1'b0;
      if (store_btn && count == 2 && i1 >= 0 && i2 >= 0) begin
        if (i1/2 == i2/2) begin
          stored_cards[i1] <= 1;
          stored_cards[i2] <= 1;
          valid_pair <= 1'b1;
        end
      end
    end
  end
endmodule
