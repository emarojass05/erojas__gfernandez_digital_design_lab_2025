// counter_15s.sv — cuenta regresiva de 15 segundos con auto-reset
module counter_15s(
    input  logic clk,
    input  logic rst,
    input  logic tick_1s,
    input  logic start,
    output logic timeout,
    output logic [3:0] tens,
    output logic [3:0] units
);

    logic [4:0] val;
    logic active;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            val     <= 15;
            timeout <= 0;
            active  <= 0;
        end else begin
            timeout <= 0;
            if (start)
                active <= 1;
            if (active && tick_1s) begin
                if (val > 0)
                    val <= val - 1;
                else begin
                    timeout <= 1;
                    val <= 15;
                    active <= 0;
                end
            end
        end
    end

    always_comb begin
        tens  = (val >= 10) ? 1 : 0;
        units = (val >= 10) ? (val - 10) : val;
    end

endmodule
