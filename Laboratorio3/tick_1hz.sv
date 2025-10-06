// ===========================================================
// tick_1hz.sv — Generador de pulso de 1 Hz (exacto)
// ===========================================================
module tick_1hz #(
    parameter SYS_CLK_HZ = 50_000_000   // reloj del sistema (50 MHz)
)(
    input  logic clk,
    input  logic rst,
    output logic tick_1s
);

    // Valor del contador máximo = frecuencia - 1
    localparam integer MAX_COUNT = SYS_CLK_HZ - 1;

    logic [25:0] count;   // log2(50e6) ≈ 26 bits

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            count   <= 0;
            tick_1s <= 0;
        end
        else if (count == MAX_COUNT) begin
            count   <= 0;
            tick_1s <= 1;     // pulso de un ciclo
        end
        else begin
            count   <= count + 1;
            tick_1s <= 0;
        end
    end

endmodule
