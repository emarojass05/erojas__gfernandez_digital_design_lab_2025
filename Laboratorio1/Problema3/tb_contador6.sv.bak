module tb_contador6;

    reg clk;
    reg reset_btn;
    reg enable_btn;
    reg load_en_btn;
    reg [5:0] load_sw;
    wire [6:0] hex0, hex1;

    // Instanciación
    contador6bits uut (
        .clk(clk),
        .reset_btn(reset_btn),
        .enable_btn(enable_btn),
        .load_en_btn(load_en_btn),
        .load_sw(load_sw),
        .hex0(hex0),
        .hex1(hex1)
    );

    // Generación de reloj
    initial clk = 0;
    always #5 clk = ~clk; // periodo 10 unidades

    initial begin
        // Inicialización
        reset_btn = 1; enable_btn = 0; load_en_btn = 0; load_sw = 6'b0;
        #10 reset_btn = 0;

        // Cargar valor inicial 10
        load_sw = 6'd10; load_en_btn = 1;
        #10 load_en_btn = 0;

        // Incrementar 20 ciclos
        enable_btn = 1;
        #200 enable_btn = 0;

        $finish;
    end

    // Monitor de salida
    always @(posedge clk) begin
        $display("Time=%0t | q=%d | hex1=%b hex0=%b", $time, {hex1, hex0}, hex1, hex0);
    end

endmodule
