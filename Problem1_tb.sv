`timescale 1ns/1ps

module Problem1_tb;

logic a, b, c, d;       // Entradas de prueba
logic w, x, y, z;       // Salidas

// Instanciamos el módulo
Problem1 uut (
    .a(a), .b(b), .c(c), .d(d),
    .w(w), .x(x), .y(y), .z(z)
);

initial begin
    $display("Time\tabcd\twxyz");
    $monitor("%0t\t%b%b%b%b\t%b%b%b%b", $time, a, b, c, d, w, x, y, z);

    // Probar todas las combinaciones de entradas
    for (int i = 0; i < 16; i++) begin
        {a, b, c, d} = i;  // Asignación directa de bits
        #10;
    end

    $finish;
end

endmodule
