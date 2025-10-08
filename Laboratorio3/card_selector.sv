// ============================================================
// card_selector.sv
// Detecta pares correctos e incorrectos y guarda solo si coinciden
// (filas independientes: superior e inferior).
// Ahora genera dos señales:
//  - valid_pair: 1 si las cartas coinciden.
//  - invalid_pair: 1 si NO coinciden.
// ============================================================

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
  output logic        invalid_pair       // 🔹 nueva salida
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
      invalid_pair    <= 0;  // 🔹 reset nuevo
    end 
    else begin
      row_sel <= sw[8];
      new_sel = sw[7:0];
      count = 0; i1 = -1; i2 = -1;

      // Contar cuántas cartas están seleccionadas
      for (int i = 0; i < 8; i++) begin
        if (new_sel[i]) begin
          count++;
          if (i1 == -1) i1 = i; else i2 = i;
        end
      end

      // Guarda selección según fila actual
      if (count <= 2) begin
        if (row_sel)
          selected_top <= new_sel;
        else
          selected_bottom <= new_sel;
      end

      // Reiniciar las señales por defecto
      valid_pair   <= 1'b0;
      invalid_pair <= 1'b0;

      // Verifica si hay dos cartas seleccionadas
      if (store_btn && count == 2 && i1 >= 0 && i2 >= 0) begin
        if (i1/2 == i2/2) begin
          // ✅ Par correcto
          if (row_sel) begin
            stored_top[i1] <= 1;
            stored_top[i2] <= 1;
          end else begin
            stored_bottom[i1] <= 1;
            stored_bottom[i2] <= 1;
          end
          valid_pair <= 1'b1;
        end 
        else begin
          // ❌ Par incorrecto
          invalid_pair <= 1'b1;
        end
      end
    end
  end
endmodule
