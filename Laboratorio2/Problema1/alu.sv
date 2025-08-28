module ALU #(parameter int N=4) (
  input  logic [N-1:0] A, B,
  input  logic [3:0]   OP,     // 0:+ 1:- 2:* 3:/ 4:% 5:AND 6:OR 7:XOR 8:SHL 9:SHR
  output logic [N-1:0] Y,
  output logic         Nf, Zf, Cf, Vf
);
  // -------- + y - estructurales
  logic [N-1:0] addR, subR;
  logic addC, subC;
  addsub #(N) u_add(.A(A), .B(B), .sub(1'b0), .R(addR), .Cout(addC));
  addsub #(N) u_sub(.A(A), .B(B), .sub(1'b1), .R(subR), .Cout(subC)); // subC=~borrow

  // -------- multiplicación desde básicos
  logic [7:0] mulP;
  mul4x4 u_mul(.A(A[3:0]), .B(B[3:0]), .P(mulP));

  // -------- otras operaciones
  logic [N-1:0] divR;
  logic [N-1:0] modR;
  logic [N-1:0] logicR;

  // división / módulo (permitidos por enunciado)
  assign divR = (B==0) ? '0 : (A / B);
  assign modR = (B==0) ? '0 : (A % B);

  // lógicas / shifts
  always_comb begin
    unique case (OP)
      4'd5: logicR = (A & B);   // AND
      4'd6: logicR = (A | B);   // OR
      4'd7: logicR = (A ^ B);   // XOR
      4'd8: logicR = (A << 1);  // SHL 1
      4'd9: logicR = (A >> 1);  // SHR 1
      default: logicR = '0;
    endcase
  end

  // -------- MUX del resultado
  always_comb begin
    unique case (OP)
      4'd0: Y = addR;                 // +
      4'd1: Y = subR;                 // -
      4'd2: Y = mulP[N-1:0];          // *
      4'd3: Y = divR;                 // /
      4'd4: Y = modR;                 // %
      4'd5,4'd6,4'd7,4'd8,4'd9: Y = logicR;
      default: Y = '0;
    endcase
  end

  // -------- banderas
  assign Nf = Y[N-1];          // Negativo
  assign Zf = (Y == '0);       // Cero
  assign Cf = (OP==4'd0) ? addC :
              (OP==4'd1) ? ~subC : 1'b0;  // Carry / ~Borrow

  wire Vadd = ( A[N-1] &  B[N-1] & ~addR[N-1]) | (~A[N-1] & ~B[N-1] &  addR[N-1]);
  wire Vsub = ( A[N-1] ^  B[N-1]) & (subR[N-1] ^ A[N-1]);
  assign Vf = (OP==4'd0) ? Vadd :
              (OP==4'd1) ? Vsub :
              (OP==4'd2) ? (|mulP[7:N]) : 1'b0; // overflow si parte alta ≠ 0
endmodule
