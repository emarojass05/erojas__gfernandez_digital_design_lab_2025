`timescale 1ns/1ps

module fsm_tb;

  // Señales de prueba
  logic clk;
  logic rst;
  logic startSW;
  logic timeout;
  logic fsm_start;
  logic black_screen;
  logic [4:0] state_out;

  // Señales del contador
  logic [3:0] tens, units;
  logic tick_1s;

  // ====== Generador de clock ======
  initial clk = 0;
  always #10 clk = ~clk; // periodo 20ns → 50 MHz

  // ====== DUT: FSM ======
  fsm uut_fsm (
    .clk        (clk),
    .rst        (rst),
    .startSW    (startSW),
    .timeout    (timeout),
    .fsm_start  (fsm_start),
    .black_screen(black_screen),
    .state_out  (state_out)
  );

  // ====== DUT: Tick de 1 Hz (simulación más rápido) ======
  tick_1hz #(
    .SYS_CLK_HZ(100)   // ⚡ reducimos para simular rápido
  ) u_tick (
    .clk    (clk),
    .rst    (rst),
    .tick_1s(tick_1s)
  );

  // ====== DUT: Contador ======
  counter_15s uut_cnt (
    .clk    (clk),
    .rst    (rst),
    .tick_1s(tick_1s),
    .start  (fsm_start),
    .timeout(timeout),
    .tens   (tens),
    .units  (units)
  );

  // ====== Estímulos ======
  initial begin
    $display("==== INICIO DE SIMULACION ====");
    $monitor("t=%0t | rst=%0b startSW=%0b | FSM state=%0d fsm_start=%0b black_screen=%0b | contador=%0d%d timeout=%0b",
             $time, rst, startSW, state_out, fsm_start, black_screen, tens, units, timeout);

    // Reset inicial
    rst = 1;
    startSW = 0;
    #50;
    rst = 0;

    // Simular arranque con SW
    #50 startSW = 1;
    #100 startSW = 0;

    // Dejar correr para que baje el contador
    #2000;

    // Forzar timeout
    #1000;

    $display("==== FIN DE SIMULACION ====");
    $stop;
  end

endmodule
