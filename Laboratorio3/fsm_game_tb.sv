// ============================================================
// fsm_game_tb.sv — Testbench de autochequeo para FSM del juego
// Autor: Emanuel Rojas Fernández
// ============================================================

`timescale 1ns/1ps

module fsm_game_tb;

  // Señales del DUT (Device Under Test)
  logic clk, rst;
  logic start_btn;
  logic timeout;
  logic valid_pair;
  logic all_pairs_done;

  logic enable_input;
  logic enable_counter;
  logic reset_counter;
  logic change_turn;
  logic black_screen;
  logic game_over;

  // Instancia del módulo bajo prueba
  fsm_game dut (
    .clk(clk),
    .rst(rst),
    .start_btn(start_btn),
    .timeout(timeout),
    .valid_pair(valid_pair),
    .all_pairs_done(all_pairs_done),
    .enable_input(enable_input),
    .enable_counter(enable_counter),
    .reset_counter(reset_counter),
    .change_turn(change_turn),
    .black_screen(black_screen),
    .game_over(game_over)
  );

  // ============================================================
  // Generador de reloj
  // ============================================================
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // periodo de 10 ns (100 MHz)
  end

  // ============================================================
  // Tareas de estímulo
  // ============================================================

  // Reinicio
  task do_reset;
    begin
      rst = 1;
      start_btn = 0;
      timeout = 0;
      valid_pair = 0;
      all_pairs_done = 0;
      #20;
      rst = 0;
    end
  endtask

  // Simular inicio del juego
  task start_game;
    begin
      $display("🟦 Iniciando juego...");
      start_btn = 1; #10;
      start_btn = 0; #20;
    end
  endtask

  // Simular acierto
  task do_valid_pair;
    begin
      $display("🟩 Jugador acierta par -> contador se reinicia y mantiene turno");
      valid_pair = 1; #10;
      valid_pair = 0; #30;
    end
  endtask

  // Simular timeout
  task do_timeout;
    begin
      $display("🟥 Timeout -> cambia de turno");
      timeout = 1; #10;
      timeout = 0; #30;
    end
  endtask

  // Simular final del juego
  task do_game_over;
    begin
      $display("🏁 Fin del juego (todas las parejas encontradas)");
      all_pairs_done = 1; #10;
      all_pairs_done = 0;
    end
  endtask

  // ============================================================
  // Monitor automático
  // ============================================================
  always @(posedge clk) begin
    $display("[%0t ns] EN:input=%b EN:counter=%b RSTcnt=%b CHturn=%b BLK=%b OVER=%b",
              $time, enable_input, enable_counter, reset_counter, change_turn, black_screen, game_over);
  end

  // ============================================================
  // Secuencia de prueba principal
  // ============================================================
  initial begin
    $display("=======================================================");
    $display(" TESTBENCH FSM GAME — AUTOCHEQUEO ");
    $display("=======================================================");

    do_reset();
    #20;

    // Etapa de inicio
    assert (black_screen == 1'b1)
      else $error("❌ Error: no se activó pantalla negra en INIT");

    start_game();
    #40;

    // Turno activo
    assert (enable_input && enable_counter)
      else $error("❌ Error: en TURN_ACTIVE no se habilitaron entradas/contador");

    // Jugador acierta
    do_valid_pair();
    assert (!change_turn)
      else $error("❌ Error: no debería cambiar turno al acertar");
    assert (reset_counter)
      else $error("❌ Error: contador no se reinició tras acierto");

    // Timeout
    do_timeout();
    assert (change_turn)
      else $error("❌ Error: no cambió turno en timeout");

    // Fin del juego
    do_game_over();
    #20;
    assert (game_over)
      else $error("❌ Error: game_over no se activó correctamente");

    $display("✅ Todas las pruebas completadas correctamente.");
    $finish;
  end

endmodule
