// Sumador/Resta ripple-carry parametrizable

module addsub #(parameter int N=4) (
  input  logic [N-1:0] A, B,
  input  logic         sub,     // 0:+ , 1:-
  output logic [N-1:0] R,
  output logic         Cout     // en resta: Cout = borrow
);
  logic [N-1:0] X;
  logic [N:0]   C;

  assign X    = B ^ {N{sub}};   // B o ~B
  assign C[0] = sub;            // +1 cuando restamos

  genvar i;
  generate
    for (i=0; i<N; i++) begin : G
      fa u_fa(.a(A[i]), .b(X[i]), .cin(C[i]), .s(R[i]), .cout(C[i+1]));
    end
  endgenerate

  assign Cout = C[N];
endmodule
