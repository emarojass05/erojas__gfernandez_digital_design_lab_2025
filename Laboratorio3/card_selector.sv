

module card_selector(
  input  logic        clk,
  input  logic        rst,
  input  logic        store_btn,
  input  logic [9:0]  sw,
  output logic [7:0]  selected_top,      // filas 0–1
  output logic [7:0]  selected_bottom,   // filas 2–3
  output logic [7:0]  stored_top,
  output logic [7:0]  stored_bottom,
  output logic        row_sel,
  output logic        valid_pair,
  output logic        invalid_pair
);

  logic [7:0] new_sel;
  integer count, i1, i2;

  //  Mapa lógico idéntico al usado en videoGen (define qué patrón tiene cada carta)
  logic [3:0] card_map [0:15];
  initial begin
     card_map[0]  = 3'd0;
    card_map[1]  = 3'd1;
    card_map[2]  = 3'd2;
    card_map[3]  = 3'd3;
    card_map[4]  = 3'd3;
    card_map[5]  = 3'd0;
    card_map[6]  = 3'd1;
    card_map[7]  = 3'd2;

    card_map[8]  = 3'd4;
    card_map[9]  = 3'd5;
    card_map[10] = 3'd6;
    card_map[11] = 3'd4;
    card_map[12] = 3'd5;
    card_map[13] = 3'd6;
    card_map[14] = 3'd7;
    card_map[15] = 3'd7;
  end

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      selected_top    <= 0;
      selected_bottom <= 0;
      stored_top      <= 0;
      stored_bottom   <= 0;
      row_sel         <= 0;
      valid_pair      <= 0;
      invalid_pair    <= 0;
    end else begin
      row_sel <= sw[8];
      new_sel = sw[7:0];
      count = 0; i1 = -1; i2 = -1;

      for (int i = 0; i < 8; i++) begin
        if (new_sel[i]) begin
          count++;
          if (i1 == -1) i1 = i; else i2 = i;
        end
      end

      // Guarda selección según fila
      if (count <= 2) begin
        if (row_sel)
          selected_top <= new_sel;
        else
          selected_bottom <= new_sel;
      end

      // Comparar patrones reales (según card_map) entre cartas seleccionadas
      valid_pair   <= 1'b0;
      invalid_pair <= 1'b0;

      if (store_btn && count == 2 && i1 >= 0 && i2 >= 0) begin
        // 🔧 Declaración separada de la asignación
        int global_idx1;
        int global_idx2;

        global_idx1 = (row_sel ? i1 : (i1 + 8));
        global_idx2 = (row_sel ? i2 : (i2 + 8));

        if (card_map[global_idx1] == card_map[global_idx2]) begin
          valid_pair <= 1'b1;
          if (row_sel) begin
            stored_top[i1] <= 1;
            stored_top[i2] <= 1;
          end else begin
            stored_bottom[i1] <= 1;
            stored_bottom[i2] <= 1;
          end
        end else begin
          invalid_pair <= 1'b1;
        end
      end
    end
  end
endmodule
