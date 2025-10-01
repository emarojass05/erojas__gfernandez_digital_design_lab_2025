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

    // Instancia de la FSM
    fsm uut (
        .clk        (clk),
        .rst        (rst),
        .startSW    (startSW),
        .timeout    (timeout),
        .fsm_start  (fsm_start),
        .black_screen(black_screen),
        .state_out  (state_out)
    );

    // Generador de clock
    initial clk = 0;
    always #5 clk = ~clk;   // periodo 10 ns → 100 MHz

    // Estímulos
    initial begin
        // Inicialización
        rst      = 1;
        startSW  = 0;
        timeout  = 0;

        // Liberar reset
        #20 rst = 0;

        // Activar el switch de inicio
        #20 startSW = 1;
        #20 startSW = 0;

        // Dejar correr algunos ciclos
        #200;

        // Simular un timeout
        timeout = 1;
        #20 timeout = 0;

        // Otro ciclo de reset
        #50 rst = 1;
        #20 rst = 0;

        // Terminar simulación
        #500 $stop;
    end

endmodule
