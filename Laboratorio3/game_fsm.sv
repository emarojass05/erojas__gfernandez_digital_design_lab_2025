// game_fsm.sv — FSM genérica para el juego
module game_fsm(
  input  logic clk,
  input  logic rst_n,        // activo-bajo
  input  logic start_btn,    // pulso de inicio (ya sincronizado)
  input  logic t_done,       // viene de timer_15s.done
  output logic show_cards,   // 1: dibujar cartas en VGA
  output logic t_start,      // 1: habilitar conteo de 15 s
  output logic t_clear,      // 1: reiniciar timer (pulso)
  output logic in_timeup     // 1: estado de tiempo agotado
);
  typedef enum logic [1:0] {S_IDLE, S_PLAY, S_TIMEUP} state_t;
  state_t state, next;

  // Estado actual
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= S_IDLE;
    else        state <= next;
  end

  // Próximo estado + salidas (Moore)
  always_comb begin
    // defaults
    next       = state;
    show_cards = 1'b0;
    t_start    = 1'b0;
    t_clear    = 1'b0;
    in_timeup  = 1'b0;

    unique case (state)
      S_IDLE: begin
        // Espera botón; cuando inicia -> limpiar y arrancar timer
        if (start_btn) begin
          t_clear = 1'b1;
          next    = S_PLAY;
        end
      end

      S_PLAY: begin
        show_cards = 1'b1;
        t_start    = 1'b1;   // habilita contar
        if (t_done) begin
          next = S_TIMEUP;
        end
      end

      S_TIMEUP: begin
        in_timeup = 1'b1;
        // quedan a decisión del juego: volver a IDLE con otro botón,
        // por ahora, un nuevo pulso de start vuelve a empezar
        if (start_btn) begin
          t_clear = 1'b1;
          next    = S_PLAY;
        end
      end
    endcase
  end
endmodule
