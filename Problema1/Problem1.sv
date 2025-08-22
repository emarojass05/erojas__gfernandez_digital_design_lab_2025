module Problem1(
    input  logic a, b, c, d,       // Entradas binarias desde switches SW0–SW3
    output logic a_seg, b_seg, c_seg, d_seg, e_seg, f_seg, g_seg // Salidas 7 segmentos
);

logic [3:0] bin;
logic [3:0] gray;

// Paso 1: combinar entradas
assign bin = {d, c, b, a}; // d=MSB, a=LSB

// Paso 2: convertir binario a Gray
assign gray[3] = bin[3];
assign gray[2] = bin[3] ^ bin[2];
assign gray[1] = bin[2] ^ bin[1];
assign gray[0] = bin[1] ^ bin[0];

// Paso 3: decodificar Gray a 7 segmentos para mostrar su valor hexadecimal
// NOTA: cada expresión es combinacional y evita el uso de 'case'

// Segmento a (superior)
assign a_seg = (~gray[3]&~gray[2]&~gray[1]& gray[0]) |
               (~gray[3]& gray[2]&~gray[1]&~gray[0]) |
               ( gray[3]& gray[2]&~gray[1]& gray[0]) |
               ( gray[3]&~gray[2]& gray[1]& gray[0]);

// Segmento b (superior derecho)
assign b_seg = (~gray[3]& gray[2]&~gray[1]& gray[0]) |
               (~gray[3]& gray[2]& gray[1]&~gray[0]) |
               ( gray[3]& gray[2]&~gray[1]&~gray[0]) |
               ( gray[3]& gray[1]& gray[0]);

// Segmento c (inferior derecho)
assign c_seg = (~gray[3]&~gray[2]& gray[1]&~gray[0]) |
               ( gray[3]& gray[2]&~gray[1]&~gray[0]) |
               ( gray[3]& gray[2]& gray[1]);

// Segmento d (inferior)
assign d_seg = (~gray[3]& gray[2]&~gray[1]&~gray[0]) |
               (~gray[3]&~gray[2]& gray[1]& gray[0]) |
               ( gray[2]& gray[1]& gray[0]) |
               ( gray[3]&~gray[2]&~gray[1]& gray[0]);

// Segmento e (inferior izquierdo)
assign e_seg = (~gray[3]& gray[0]) |
               (~gray[3]& gray[2]&~gray[1]) |
               (~gray[2]&~gray[1]& gray[0]) |
               ( gray[3]&~gray[2]&~gray[1]);

// Segmento f (superior izquierdo)
assign f_seg = (~gray[3]&~gray[2]& gray[0]) |
               (~gray[3]&~gray[2]& gray[1]) |
               (~gray[3]& gray[1]& gray[0]) |
               ( gray[3]& gray[2]&~gray[1]& gray[0]);

// Segmento g (central)
assign g_seg = (~gray[3]&~gray[2]&~gray[1]) |
               (~gray[3]& gray[2]& gray[1]& gray[0]) |
               ( gray[3]& gray[2]&~gray[1]&~gray[0]);

endmodule
