module contador6bits(
    input clk,             // reloj físico de la FPGA
    input reset_btn,       // botón de reset asincrónico
    input load_en_btn,     // botón para cargar valor inicial
    input enable_btn,      // botón para incrementar
    input [5:0] load_sw,   // switches para valor inicial
    output [6:0] hex0,     // display unidades (bits [3:0])
    output [6:0] hex1      // display decenas (bits [5:4])
);

    reg [5:0] q;

    // --- Pulso de 1 ciclo para load ---
    reg load_prev;
    wire load_pulse;
    always @(posedge clk) begin
        load_prev <= load_en_btn;
    end
    assign load_pulse = load_en_btn & ~load_prev;

    // --- Pulso de 1 ciclo para enable ---
    reg enable_prev;
    wire enable_pulse;
    always @(posedge clk) begin
        enable_prev <= enable_btn;
    end
    assign enable_pulse = enable_btn & ~enable_prev;

    // --- Contador con reset asincrónico ---
    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn)
            q <= 6'b0;
        else if (load_pulse)
            q <= load_sw;
        else if (enable_pulse)
            q <= q + 1;
    end

    // --- Decodificación de 7 segmentos ---
    bin2hex dec0 (.bin(q[3:0]), .hex(hex0));               // unidades
    bin2hex dec1 (.bin({4'b00, q[5:4]}), .hex(hex1));      // decenas reducidas

endmodule
