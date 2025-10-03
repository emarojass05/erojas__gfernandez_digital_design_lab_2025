// counter_15s.sv — cuenta regresiva de 15 segundos, salida BCD
// Controlado por FSM, con reset en KEY0

module counter_15s(
    input  logic clk,          // clock del sistema (50 MHz)
    input  logic rst,          // reset activo en alto (KEY0)
    input  logic tick_1s,      // pulso de 1 Hz proveniente de tick_1hz
    input  logic start,        // habilitado por FSM
    output logic timeout,      // llega a 0 → 1
    output logic [3:0] tens,   // decenas en BCD
    output logic [3:0] units   // unidades en BCD
);

    // contador principal (valor en segundos)
    logic [4:0] val;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            val     <= 15;   // reset → vuelve a 15
            timeout <= 0;
        end 
        else if (start && tick_1s) begin
            if (val > 0) begin
                val <= val - 1;
            end else begin
                timeout <= 1; // se acabó el tiempo
            end
        end
    end

    // convertir a BCD
    always_comb begin
        tens  = (val >= 10) ? 1 : 0;
        units = (val >= 10) ? (val - 10) : val;
    end

endmodule
