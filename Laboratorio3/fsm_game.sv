// ============================================================
// fsm_game.sv — FSM principal del juego de memoria digital
// ------------------------------------------------------------
// Controla el flujo del juego:
// - Turnos
// - Reinicio de contador
// - Reacción ante timeout o acierto
// ============================================================

module fsm_game (
  input  logic clk,
  input  logic rst,
  input  logic start_btn,         // KEY0
  input  logic timeout,           // del contador (cuando llega a 0)
  input  logic valid_pair,        // pulso limpio al acertar
  input  logic all_pairs_done,    // fin del juego
  output logic enable_input,      // habilita switches
  output logic enable_counter,    // permite conteo
  output logic reset_counter,     // reinicia contador (a 15s)
  output logic change_turn,       // alterna jugador
  output logic black_screen,      // pantalla apagada en reset
  output logic game_over          // fin del juego
);

  typedef enum logic [2:0] {
    INIT,          // estado inicial (pantalla negra)
    WAIT_START,    // espera inicio
    TURN_ACTIVE,   // turno activo del jugador
    CHECK_PAIR,    // verificar par
    AUTO_MOVE,     // timeout o sin acción
    WIN            // victoria
  } state_t;

  state_t state, next;

  // ====== Estado actual ======
  always_ff @(posedge clk or posedge rst)
    if (rst)
      state <= INIT;
    else
      state <= next;

  // ====== Lógica de transición y salidas ======
  always_comb begin
    // Valores por defecto
    next = state;
    enable_input   = 0;
    enable_counter = 0;
    reset_counter  = 0;
    change_turn    = 0;
    black_screen   = 0;
    game_over      = 0;

    case (state)
      // ---------- INICIO ----------
      INIT: begin
        black_screen = 1;
        next = WAIT_START;
      end

      // ---------- ESPERA INICIO ----------
      WAIT_START: begin
        if (start_btn)
          next = TURN_ACTIVE;
      end

      // ---------- TURNO ACTIVO ----------
      TURN_ACTIVE: begin
        enable_input   = 1;
        enable_counter = 1;

        // ✅ Si acierta: reinicia contador, pero mantiene turno
        if (valid_pair)
          next = CHECK_PAIR;
        // ❌ Si llega a 0: cambia turno y reinicia
        else if (timeout)
          next = AUTO_MOVE;
      end

      // ---------- CHECK PAR ----------
      CHECK_PAIR: begin
        enable_input   = 0;
        enable_counter = 1;     // sigue contando después
        reset_counter  = 1;     // vuelve a 15 s
        change_turn    = 0;     // mantiene el turno
        next = TURN_ACTIVE;     // sigue en su turno
      end

      // ---------- AUTO MOVE ----------
      AUTO_MOVE: begin
        enable_input   = 0;
        reset_counter  = 1;     // reinicia contador
        change_turn    = 1;     // cambia turno
        next = TURN_ACTIVE;
      end

      // ---------- WIN ----------
      WIN: begin
        game_over = 1;
        if (rst)
          next = INIT;
      end

      default: next = INIT;
    endcase

    // Si se completaron todas las cartas → victoria
    if (all_pairs_done)
      next = WIN;
  end

endmodule
