// ==============================================
// Contador parametrizable de N bits con HEX
// con carga de valor inicial desde switches
// Para DE1-SoC: reset en SW9, enable en KEY1, CLOCK_50 interno
// ==============================================
module contador6bits #(
    parameter N = 6   // número de bits del contador (6 para tu práctica)
)(
    input  logic CLOCK_50,     // reloj de 50 MHz de la FPGA
    input  logic [9:0] SW,     // switches
    input  logic [1:0] KEY,    // botones
    output logic [6:0] HEX0,   // display 7 segmentos (unidades)
    output logic [6:0] HEX1    // display 7 segmentos (decenas)
);

    // ========================
    // Señales asignadas
    // ========================
    wire reset_n = SW[9];      // reset asíncrono activo en 0 (SW9)
    wire enable  = ~KEY[1];    // enable con KEY1 (activo en bajo)
    wire [N-1:0] init_val = SW[N-1:0]; // valor inicial desde SW[5:0]

    // ========================
    // Divisor de frecuencia
    // ========================
    logic [23:0] div_counter;
    logic slow_clk;

    always_ff @(posedge CLOCK_50 or negedge reset_n) begin
        if (!reset_n)
            div_counter <= 0;
        else
            div_counter <= div_counter + 1;
    end

    assign slow_clk = div_counter[23];  // ~3 Hz para ver en display

    // ========================
    // Contador parametrizable
    // ========================
    logic [N-1:0] q;

    always_ff @(posedge slow_clk or negedge reset_n) begin
        if (!reset_n)
            q <= init_val;     // al reset, carga switches
        else if (enable)
            q <= q + 1;        // si enable activo, incrementa
    end

    // ========================
    // Conversión a decimal
    // ========================
    logic [3:0] unidades, decenas;
    always_comb begin
        unidades = q % 10;
        decenas  = q / 10;
    end

    // ========================
    // Decodificador a 7 segmentos
    // ========================
    function automatic [6:0] decod7seg(input [3:0] num);
        case(num)
            4'd0: decod7seg = 7'b1000000;
            4'd1: decod7seg = 7'b1111001;
            4'd2: decod7seg = 7'b0100100;
            4'd3: decod7seg = 7'b0110000;
            4'd4: decod7seg = 7'b0011001;
            4'd5: decod7seg = 7'b0010010;
            4'd6: decod7seg = 7'b0000010;
            4'd7: decod7seg = 7'b1111000;
            4'd8: decod7seg = 7'b0000000;
            4'd9: decod7seg = 7'b0010000;
            default: decod7seg = 7'b1111111; // apagado
        endcase
    endfunction

    assign HEX0 = decod7seg(unidades);
    assign HEX1 = decod7seg(decenas);

endmodule
