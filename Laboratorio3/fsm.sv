// fsm.sv — Máquina de estados con 16 estados Q1..Q16
module fsm (
    input  logic clk,
    input  logic rst,
    input  logic startSW,
    input  logic timeout,
    output logic fsm_start,
    output logic black_screen,
    output logic [4:0] state_out   // 🔹 salida binaria para debug
);

    // --- Definición de estados ---
    typedef enum logic [4:0] {
        Q1  = 5'd1,  Q2  = 5'd2,  Q3  = 5'd3,  Q4  = 5'd4,
        Q5  = 5'd5,  Q6  = 5'd6,  Q7  = 5'd7,  Q8  = 5'd8,
        Q9  = 5'd9,  Q10 = 5'd10, Q11 = 5'd11, Q12 = 5'd12,
        Q13 = 5'd13, Q14 = 5'd14, Q15 = 5'd15, Q16 = 5'd16
    } state_t;

    state_t state, next_state;

    // --- Estado actual ---
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            state <= Q1;
        else
            state <= next_state;
    end

    // --- Lógica de transición ---
    always_comb begin
        next_state   = state;
        fsm_start    = 1'b0;
        black_screen = 1'b0;

        unique case (state)
            Q1: if (startSW) next_state = Q2;
            Q2: next_state = Q3;
            Q3: next_state = Q4;
            Q4: next_state = Q5;
            Q5: next_state = Q6;

            Q6: next_state = Q14;    // 🔹 agregado
            Q14: next_state = Q7;

            Q7: next_state = Q8;
            Q8: next_state = Q9;
            Q9: next_state = Q10;
            Q10: next_state = Q11;

            Q11: next_state = Q12;   // 🔹 bifurcación (ejemplo simplificado)
            Q12: next_state = Q15;
            Q13: next_state = Q15;

            Q15: next_state = timeout ? Q16 : Q1;
            Q16: next_state = Q1;

            default: next_state = Q1;
        endcase
    end

    // --- Señales de salida ---
    assign state_out = state;   // 🔹 salida binaria para debug

endmodule
