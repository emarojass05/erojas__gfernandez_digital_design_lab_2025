// ============================================================
// fsm_game.sv — FSM principal del juego de memoria digital
// ------------------------------------------------------------
// Controla el flujo del juego:
// - Turnos
// - Reinicio del contador
// - Reacción ante timeout, acierto o fallo
// - Pantalla final de victoria
// ============================================================

module fsm_game (
  input  logic clk,
  input  logic rst,
  input  logic start_btn,         // KEY0
  input  logic timeout,           // del contador (cuando llega a 0)
  input  logic valid_pair,        // pulso limpio al acertar
  input  logic invalid_pair,      // 🔹 nuevo: par incorrecto
  input  logic all_pairs_done,    // fin del juego
  output logic enable_input,      // habilita switches
  output logic enable_counter,    // permite conteo
  output logic reset_counter,     // reinicia contador (a 15s)
  output logic change_turn,       // alterna jugador
  output logic black_screen,      // pantalla apagada al inicio
  output logic game_over          // fin del juego
);

  // ====== Definición de estados ======
  typedef enum logic [2:0] {
    INIT,          // pantalla negra inicial
    WAIT_START,    // espera botón de inicio
    TURN_ACTIVE,   // turno activo de un jugador
    CHECK_PAIR,    // par correcto
    WRONG_PAIR,    // 🔹 par incorrecto
    AUTO_MOVE,     // cambio por timeout
    WIN            // fin del juego
  } state_t;

  state_t state, next;

  // ====== Registro de estado ======
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

        if (valid_pair)
          next = CHECK_PAIR;   // ✅ mantiene turno
        else if (invalid_pair)
          next = WRONG_PAIR;   // ❌ cambia turno
        else if (timeout)
          next = AUTO_MOVE;    // ⏱️ cambia turno por tiempo
      end

      // ---------- PAR CORRECTO ----------
      CHECK_PAIR: begin
        enable_input   = 0;
        enable_counter = 1;  // sigue contando
        reset_counter  = 1;  // vuelve a 15 s
        change_turn    = 0;  // mantiene turno
        next = TURN_ACTIVE;
      end

      // ---------- PAR INCORRECTO ----------
      WRONG_PAIR: begin
        enable_input   = 0;
        reset_counter  = 1;  // reinicia contador
        change_turn    = 1;  // cambia jugador
        next = TURN_ACTIVE;
      end

      // ---------- TIMEOUT ----------
      AUTO_MOVE: begin
        enable_input   = 0;
        reset_counter  = 1;  // reinicia contador
        change_turn    = 1;  // cambia jugador
        next = TURN_ACTIVE;
      end

      // ---------- VICTORIA ----------
      WIN: begin
        game_over = 1;       // activa pantalla de fin
        next = WIN;          // espera reset
      end

      default: next = INIT;
    endcase

    // ---------- CONDICIÓN GLOBAL DE VICTORIA ----------
    if (all_pairs_done)
      next = WIN;
  end

endmodule
