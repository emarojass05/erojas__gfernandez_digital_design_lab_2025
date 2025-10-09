// ============================================================
// auto_selector.sv — Selección automática de cartas (superior o inferior)
// ------------------------------------------------------------
// • Selecciona aleatoriamente una carta NO resuelta
// • Decide aleatoriamente si será de la fila superior o inferior
// • Mantiene la carta visible hasta que se forma un nuevo par
//   o la carta queda guardada en stored_* (match).
// ============================================================

module auto_selector(
  input  logic        clk,
  input  logic        rst,
  input  logic        enable_auto,      // pulso desde timeout (1 ciclo)
  input  logic [7:0]  stored_top,       // cartas ya hechas par (fila superior)
  input  logic [7:0]  stored_bottom,    // cartas ya hechas par (fila inferior)
  output logic [9:0]  sw_auto           // salida simulada de switches
);

  // ===== Estados internos =====
  logic [7:0] selected_mask;
  logic [2:0] rand_val;
  logic [15:0] lfsr;
  logic        row_sel_rand;  // 0 = inferior, 1 = superior

  // ===== Generador pseudoaleatorio simple (LFSR) =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      lfsr <= 16'hACE1;  // semilla inicial
    else
      lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
  end

  // ===== Selección automática =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      selected_mask <= 8'd0;
      sw_auto       <= 10'd0;
      row_sel_rand  <= 1'b0;
    end else begin
      // 🔹 Si hay timeout, generar nueva carta aleatoria
      if (enable_auto) begin
        rand_val = lfsr[2:0];
        row_sel_rand = lfsr[3]; // bit pseudoaleatorio para elegir fila

        // Seleccionar carta según fila elegida
        if (row_sel_rand) begin
          // === Fila superior ===
          for (int i = 0; i < 8; i++) begin
            if (stored_top[rand_val] == 1'b0)
              break;
            else
              rand_val = (rand_val + 1) % 8;
          end
        end else begin
          // === Fila inferior ===
          for (int i = 0; i < 8; i++) begin
            if (stored_bottom[rand_val] == 1'b0)
              break;
            else
              rand_val = (rand_val + 1) % 8;
          end
        end

        // Guarda nueva carta seleccionada
        selected_mask <= 8'b1 << rand_val;
      end

      // 🔹 Limpieza automática cuando la carta se convierte en par
      // (esto evita que se mantenga en 1 tras hacer match)
      if (row_sel_rand) begin
        if ((stored_top & selected_mask) != 0)
          selected_mask <= 8'd0;
      end else begin
        if ((stored_bottom & selected_mask) != 0)
          selected_mask <= 8'd0;
      end

      // ===== Salida combinada =====
      sw_auto[7:0] <= selected_mask;   // carta elegida
      sw_auto[8]   <= row_sel_rand;    // fila seleccionada aleatoriamente
      sw_auto[9]   <= 1'b0;            // no usado
    end
  end

endmodule
