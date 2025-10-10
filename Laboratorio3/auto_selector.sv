

module auto_selector(
  input  logic        clk,
  input  logic        rst,
  input  logic        enable_auto,      // pulso de timeout (1 ciclo)
  input  logic        valid_pair,       // pulso cuando acierta
  input  logic [7:0]  stored_top,       // cartas emparejadas (fila superior)
  input  logic [7:0]  stored_bottom,    // cartas emparejadas (fila inferior)
  output logic [9:0]  sw_auto           // salida simulada (switches)
);

  // ===== Estados internos =====
  logic [7:0] selected_mask;
  logic [15:0] lfsr;
  logic [2:0] rand_val;
  logic        row_sel_rand;
  logic        prev_random;  // Detecta si hubo dos random seguidos sin acierto

  // ===== Generador pseudoaleatorio (LFSR) =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      lfsr <= 16'hACE1;
    else
      lfsr <= {lfsr[14:0], lfsr[15] ^ lfsr[13] ^ lfsr[12] ^ lfsr[10]};
  end

  // ===== Selección principal =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      selected_mask <= 8'd0;
      row_sel_rand  <= 1'b0;
      prev_random   <= 1'b0;
      sw_auto       <= 10'd0;
    end 
    else begin
      // Si hubo acierto, limpiar carta azul
      if (valid_pair) begin
        selected_mask <= 8'd0;
        prev_random   <= 1'b0;
      end

      // Si llega timeout → generar nuevo random
      else if (enable_auto) begin
        rand_val = lfsr[2:0];
        row_sel_rand = lfsr[3];

        // Si ya hubo un random anterior sin acierto, limpiar antes de nuevo intento
        if (prev_random)
          selected_mask <= 8'd0;

        // Buscar carta libre (no emparejada)
        if (row_sel_rand) begin
          for (int i = 0; i < 8; i++) begin
            if (!stored_top[rand_val]) begin
              selected_mask <= 8'b1 << rand_val;
              break;
            end
            rand_val = (rand_val + 1) % 8;
          end
        end else begin
          for (int i = 0; i < 8; i++) begin
            if (!stored_bottom[rand_val]) begin
              selected_mask <= 8'b1 << rand_val;
              break;
            end
            rand_val = (rand_val + 1) % 8;
          end
        end

        // Marcar que ya hubo un random
        prev_random <= 1'b1;
      end

      // ===== Salida sincronizada =====
      sw_auto[7:0] <= selected_mask;
      sw_auto[8]   <= row_sel_rand;  // fila elegida (1=superior, 0=inferior)
      sw_auto[9]   <= 1'b0;          // no usado
    end
  end
endmodule
