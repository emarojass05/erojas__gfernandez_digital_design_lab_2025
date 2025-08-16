`timescale 1ns/1ps

module Problem11_tb;

logic a, b, c, d;            // Entradas
logic a_seg, b_seg, c_seg, d_seg, e_seg, f_seg, g_seg;  // Salidas 7 segmentos

// Instanciamos el módulo
Problema1 uut (
    .a(a), .b(b), .c(c), .d(d),
    .a_seg(a_seg), .b_seg(b_seg), .c_seg(c_seg),
    .d_seg(d_seg), .e_seg(e_seg), .f_seg(f_seg), .g_seg(g_seg)
);

initial begin
    $display("Time\tSW3 SW2 SW1 SW0 \tSeg a b c d e f g");
    $monitor("%0t\t%b  %b  %b  %b\t%b %b %b %b %b %b %b", 
              $time, d, c, b, a, a_seg, b_seg, c_seg, d_seg, e_seg, f_seg, g_seg);

    // Probar todas las combinaciones de 4 bits
    for (int i = 0; i < 16; i++) begin
        {d, c, b, a} = i;
        #10; // esperar 10 ns entre combinaciones
    end

    $finish;
end

endmodule
