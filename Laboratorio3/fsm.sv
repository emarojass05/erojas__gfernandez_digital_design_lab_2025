/*
============================================================
 fsm.sv — Máquina de estados de 16 estados (Q1–Q16)
 Controla inicio del contador, pantalla y flujo del juego de memoria
 ------------------------------------------------------------
 ⚠️ Este módulo ha sido comentado intencionalmente.
 Ya no se usa en el diseño final. La FSM activa es "fsm_game.sv".
 Se conserva solo como referencia histórica.
============================================================

module fsm(
     input  logic clk,
     input  logic rst,          // reset activo alto (KEY0)
     input  logic startSW,      // SW0 inicia el juego
     input  logic timeout,      // viene del contador
     output logic fsm_start,    // habilita el contador
     output logic black_screen, // apaga pantalla
     output logic show_all,     // mostrar todas las cartas
     output logic hide_cards,   // ocultar cartas
     output logic sel_enable,   // habilitar selección
     output logic [4:0] state_out // debug para viewer
);

     typedef enum logic [4:0] {
          Q1  = 5'd0,  Q2  = 5'd1,  Q3  = 5'd2,  Q4  = 5'd3,
          Q5  = 5'd4,  Q6  = 5'd5,  Q7  = 5'd6,  Q8  = 5'd7,
          Q9  = 5'd8,  Q10 = 5'd9,  Q11 = 5'd10, Q12 = 5'd11,
          Q13 = 5'd12, Q14 = 5'd13, Q15 = 5'd14, Q16 = 5'd15
     } state_t;

     state_t state, next_state;

     // Registro de estado
     always_ff @(posedge clk or posedge rst) begin
          if (rst)
               state <= Q1;
          else
               state <= next_state;
     end

     // Transiciones
     always_comb begin
          next_state = state;

          unique case (state)
               Q1:  if (startSW) next_state = Q2;
               Q2:  next_state = Q3; // mostrar todas
               Q3:  next_state = Q4; // ocultar
               Q4:  next_state = Q5; // selección carta1
               Q5:  next_state = Q6;
               Q6:  next_state = Q7; // selección carta2
               Q7:  next_state = Q8;
               Q8:  next_state = Q9; // comparar
               Q9:  next_state = Q10;
               Q10: next_state = Q11;
               Q11: next_state = Q12; // victoria
               Q12: next_state = Q16;
               Q13: next_state = Q14; // derrota
               Q14: next_state = Q15;
               Q15: next_state = Q16;
               Q16: next_state = Q1;
          endcase
     end

     // Salidas
     always_comb begin
          // default
          fsm_start    = 1'b0;
          black_screen = 1'b0;
          show_all     = 1'b0;
          hide_cards   = 1'b0;
          sel_enable   = 1'b0;

          case (state)
               Q2: show_all   = 1'b1; // mostrar todas
               Q3: hide_cards = 1'b1; // ocultar todas
               Q4, Q5, Q6, Q7, Q8: sel_enable = 1'b1; // habilitar selección
               Q15, Q16: black_screen = 1'b1; // derrota o final → pantalla apagada
          endcase

          if (state != Q1)
               fsm_start = 1'b1; // arranca contador en cuanto inicia juego
     end

     assign state_out = state;

endmodule
*/
