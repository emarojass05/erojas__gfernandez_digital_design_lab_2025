// Multiplicador 4x4 por productos parciales

// mul4x4.sv  (sin inits en la declaración; todo combinacional)
module mul4x4(
  input  logic [3:0] A, B,
  output logic [7:0] P
);
  // Productos parciales (declarar y asignar aparte)
  logic [3:0] p0, p1, p2, p3;
  assign p0 = A & {4{B[0]}};
  assign p1 = A & {4{B[1]}};
  assign p2 = A & {4{B[2]}};
  assign p3 = A & {4{B[3]}};

  // Sumas desplazadas con adders en cascada (todo combinacional)
  logic [4:0] s1; logic c1;
  addsub #(5) add1(
    .A   ({1'b0, p0}),          // 5 bits
    .B   ({p1,   1'b0}),        // 5 bits
    .sub (1'b0),
    .R   (s1),
    .Cout(c1)
  );

  logic [5:0] s2; logic c2;
  addsub #(6) add2(
    .A   ({1'b0, s1}),          // 6 bits
    .B   ({p2,   2'b00}),       // 6 bits
    .sub (1'b0),
    .R   (s2),
    .Cout(c2)
  );

  logic [6:0] s3; logic c3;
  addsub #(7) add3(
    .A   ({1'b0, s2}),          // 7 bits
    .B   ({p3,   3'b000}),      // 7 bits
    .sub (1'b0),
    .R   (s3),
    .Cout(c3)
  );

  // Producto final de 8 bits
  assign P = {c3, s3};
endmodule
