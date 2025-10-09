// ============================================================
// card_selector.sv — Maneja selección de cartas (manual o automática)
// ------------------------------------------------------------
//  Permite seleccionar cartas manualmente (switches)
//  O bien automáticamente (timeout)
//  Muestra carta seleccionada (azul) hasta emparejarla o cambio de turno
//  Ignora las que ya están almacenadas (verdes)
// ============================================================

module card_selector(
  input  logic        clk,
  input  logic        rst,
  input  logic        store_btn,
  input  logic [9:0]  sw,
  output logic [7:0]  selected_top,
  output logic [7:0]  selected_bottom,
  output logic [7:0]  stored_top,
  output logic [7:0]  stored_bottom,
  output logic        row_sel,
  output logic        valid_pair,
  output logic        invalid_pair
);

  logic [7:0] new_sel;
  integer count, i1, i2;

  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      selected_top    <= 0;
      selected_bottom <= 0;
      stored_top      <= 0;
      stored_bottom   <= 0;
      row_sel         <= 0;
      valid_pair      <= 0;
      invalid_pair    <= 0;
    end 
    else begin
      row_sel <= sw[8];
      new_sel = sw[7:0];

      valid_pair   <= 0;
      invalid_pair <= 0;

      // Contar bits activos
      count = 0; i1 = -1; i2 = -1;
      for (int i = 0; i < 8; i++) begin
        if (new_sel[i]) begin
          count++;
          if (i1 == -1) i1 = i; else i2 = i;
        end
      end

      // Mostrar visualmente la carta seleccionada (manual o automática)
      if (count >= 1) begin
        if (row_sel)
          selected_top <= (new_sel & ~stored_top);
        else
          selected_bottom <= (new_sel & ~stored_bottom);
      end

      // Detectar par cuando se presiona store_btn
      if (store_btn && count == 2 && i1 >= 0 && i2 >= 0) begin
        if ((i1 / 2) == (i2 / 2)) begin
          // Par correcto
          if (row_sel) begin
            stored_top[i1] <= 1;
            stored_top[i2] <= 1;
          end else begin
            stored_bottom[i1] <= 1;
            stored_bottom[i2] <= 1;
          end
          valid_pair <= 1;
        end else begin
          // Par incorrecto
          invalid_pair <= 1;
        end
      end

      // Si se falla, limpiar solo la fila actual
      if (invalid_pair) begin
        if (row_sel)
          selected_top <= 0;
        else
          selected_bottom <= 0;
      end
    end
  end
endmodule
