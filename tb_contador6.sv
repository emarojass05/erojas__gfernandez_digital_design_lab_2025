`timescale 1ns/1ps

module tb_contador6;

    reg clk;
    reg reset_btn;
    reg load_en_btn;
    reg enable_btn;
    reg [5:0] load_sw;
    wire [6:0] hex0;
    wire [6:0] hex1;

    // Instancia del contador
    contador6bits uut (
        .clk(clk),
        .reset_btn(reset_btn),
        .load_en_btn(load_en_btn),
        .enable_btn(enable_btn),
        .load_sw(load_sw),
        .hex0(hex0),
        .hex1(hex1)
    );

    // Generador de reloj
    initial clk = 0;
    always #5 clk = ~clk; // periodo de 10ns (100 MHz)

    initial begin
        // Inicialización
        reset_btn = 0; load_en_btn = 0; enable_btn = 0; load_sw = 6'b000011;
        #10;

        // Reset asincrónico
        reset_btn = 1;
        #10;
        reset_btn = 0;

        // Cargar valor inicial
        load_en_btn = 1;
        #10;
        load_en_btn = 0;

        // Incrementar varias veces
        repeat (5) begin
            enable_btn = 1;
            #10;
            enable_btn = 0;
            #10;
        end

        // Terminar simulación
        #50 $finish;
    end

endmodule
