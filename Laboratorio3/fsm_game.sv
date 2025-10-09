// ============================================================
// fsm_game.sv — FSM principal del juego de memoria digital
// ------------------------------------------------------------
// Controla el flujo del juego:
// - Turnos
// - Reinicio de contador
// - Reacción ante timeout o acierto
// - Muestra carta automática 1 s antes de cambiar turno
// ============================================================

module fsm_game (
  input  logic clk,
  input  logic rst,
  input  logic start_btn,         // KEY0
  input  logic timeout,           // del contador (cuando llega a 0)
  input  logic valid_pair,        // pulso limpio al acertar
  input  logic invalid_pair,      // pulso limpio al fallar
  input  logic all_pairs_done,    // fin del juego
  output logic enable_input,      // habilita switches
  output logic enable_counter,    // permite conteo
  output logic reset_counter,     // reinicia contador (a 15s)
  output logic change_turn,       // alterna jugador
  output logic black_screen,      // pantalla apagada en reset
  output logic game_over          // fin del juego
);

  // ===== Definición de estados =====
  typedef enum logic [2:0] {
    INIT, WAIT_START, TURN_ACTIVE, CHECK_PAIR,
    AUTO_SHOW, AUTO_MOVE, WIN
  } state_t;

  state_t state, next;

  // Contador simple para mantener la carta automática visible
  logic [25:0] auto_timer; // ≈1 s a 50 MHz

  // ===== Registro de estado =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      state <= INIT;
    else
      state <= next;
  end

  // ===== Temporizador visual (mantiene carta 1 s) =====
  always_ff @(posedge clk or posedge rst) begin
    if (rst)
      auto_timer <= 0;
    else if (state == AUTO_SHOW)
      auto_timer <= auto_timer + 1;
    else
      auto_timer <= 0;
  end

  // ===== Lógica de transición y salidas =====
  always_comb begin
    // valores por defecto
    next = state;
    enable_input   = 0;
    enable_counter = 0;
    reset_counter  = 0;
    change_turn    = 0;
    black_screen   = 0;
    game_over      = 0;

    case (state)
      // ----- INICIO -----
      INIT: begin
        black_screen = 1;
        next = WAIT_START;
      end

      // ----- ESPERA DE INICIO -----
      WAIT_START: begin
        if (start_btn)
          next = TURN_ACTIVE;
      end

      // ----- TURNO ACTIVO -----
      TURN_ACTIVE: begin
        enable_input   = 1;
        enable_counter = 1;

        if (valid_pair)
          next = CHECK_PAIR;
        else if (invalid_pair)
          next = AUTO_MOVE;  // si falla cambia turno
        else if (timeout)
          next = AUTO_SHOW;  // tiempo agotado → muestra carta automática
      end

      // ----- CHECK PAIR -----
      CHECK_PAIR: begin
        reset_counter = 1;
        next = TURN_ACTIVE; // sigue el mismo jugador
      end

      // ----- AUTO SHOW -----
      AUTO_SHOW: begin
        enable_input   = 0;
        enable_counter = 0;
        if (auto_timer > 50_000_000) // ≈1 s a 50 MHz
          next = AUTO_MOVE;
      end

      // ----- AUTO MOVE -----
      AUTO_MOVE: begin
        change_turn   = 1;
        reset_counter = 1;
        next = TURN_ACTIVE;
      end

      // ----- WIN -----
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
