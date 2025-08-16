module Problem1(
    input  logic a, b, c, d,   // Entradas binarias (mapearás a switches)
    output logic w, x, y, z    // Salidas Gray (mapearás a LEDs)
);

logic [3:0] bin;
logic [3:0] gray;

// Combinar entradas en un vector
assign bin = {a, b, c, d};

// Lógica de conversión binario a Gray
assign gray[3] = bin[3];
assign gray[2] = bin[3] ^ bin[2];
assign gray[1] = bin[2] ^ bin[1];
assign gray[0] = bin[1] ^ bin[0];

// Mapear la salida a cada LED
assign w = gray[3];
assign x = gray[2];
assign y = gray[1];
assign z = gray[0];

endmodule
