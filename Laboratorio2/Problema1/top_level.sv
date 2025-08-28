module top_level(
  input  logic [9:0] SW,        // A=SW[3:0], B=SW[7:4], OP[3:2]=SW[9:8]
  input  logic [3:0] KEY,       // OP[1:0]=~KEY[1:0] (KEY activos en 0)
  output logic [6:0] HEX0,      // Y en HEX0 (activo-bajo)
  output logic [3:0] LEDR       // {N,Z,C,V}
);
  // Entradas a la ALU
  logic [3:0] A;
  logic [3:0] B;
  logic [3:0] OP;

  // Asignaciones (no en la declaración)
  assign A  = SW[3:0];
  assign B  = SW[7:4];
  assign OP = {SW[9:8], ~KEY[1], ~KEY[0]}; // 0..9

  // Salidas de la ALU
  logic [3:0] Y;
  logic Nf, Zf, Cf, Vf;

  // Instancia de la ALU
  ALU #(4) alu_i(
    .A(A), .B(B), .OP(OP),
    .Y(Y), .Nf(Nf), .Zf(Zf), .Cf(Cf), .Vf(Vf)
  );

  // Decoder 7 segmentos activo-bajo (0..F)
  function automatic logic [6:0] hex_decode(input logic [3:0] v);
    case (v)
      4'h0: hex_decode = 7'b1000000;
      4'h1: hex_decode = 7'b1111001;
      4'h2: hex_decode = 7'b0100100;
      4'h3: hex_decode = 7'b0110000;
      4'h4: hex_decode = 7'b0011001;
      4'h5: hex_decode = 7'b0010010;
      4'h6: hex_decode = 7'b0000010;
      4'h7: hex_decode = 7'b1111000;
      4'h8: hex_decode = 7'b0000000;
      4'h9: hex_decode = 7'b0010000;
      4'hA: hex_decode = 7'b0001000;
      4'hB: hex_decode = 7'b0000011;
      4'hC: hex_decode = 7'b1000110;
      4'hD: hex_decode = 7'b0100001;
      4'hE: hex_decode = 7'b0000110;
      default: hex_decode = 7'b0001110; // F
    endcase
  endfunction

  assign HEX0 = hex_decode(Y);
  assign LEDR = {Nf, Zf, Cf, Vf};
endmodule
