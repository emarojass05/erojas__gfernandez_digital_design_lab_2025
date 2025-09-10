// alu_stage.sv
`timescale 1ns/1ps

module alu_stage #(
  parameter int N = 4
)(
  input  logic          clk,
  input  logic          rst_n,   // activo-bajo
  input  logic          load,    // carga paralela desde inputs A_in,B_in cuando load=1
  input  logic [N-1:0]  A_in,
  input  logic [N-1:0]  B_in,
  input  logic [3:0]    OP_in,   // opcode de entrada (usa el OP definido en ALU)
  output logic [N-1:0]  Y,
  output logic          Nf, Zf, Cf, Vf
);

  // Instanciar registros frontales (registro de entrada)
  logic [N-1:0] A_reg, B_reg;
  logic [3:0]   OP_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      A_reg <= '0;
      B_reg <= '0;
      OP_reg <= '0;
    end else begin
      if (load) begin
        A_reg <= A_in;
        B_reg <= B_in;
        OP_reg <= OP_in;
      end else begin
        // Si no cargamos, mantener los valores (puedes diseñar un shift si quieres medir otra cosa)
        A_reg <= A_reg;
        B_reg <= B_reg;
        OP_reg <= OP_reg;
      end
    end
  end

  // SALIDA de la lógica combinacional: ALU
  logic [N-1:0] alu_Y;
  logic         alu_Nf, alu_Zf, alu_Cf, alu_Vf;

  // Instanciar tu ALU parametrizable (asegúrate de compilar con este archivo)
  ALU #(N) u_alu (
    .A(A_reg), .B(B_reg), .OP(OP_reg),
    .Y(alu_Y), .Nf(alu_Nf), .Zf(alu_Zf), .Cf(alu_Cf), .Vf(alu_Vf)
  );

  // Registro tras la lógica (registro de captura)
  logic [N-1:0] Y_reg;
  logic         Nf_reg, Zf_reg, Cf_reg, Vf_reg;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      Y_reg <= '0;
      Nf_reg <= 0; Zf_reg <= 0; Cf_reg <= 0; Vf_reg <= 0;
    end else begin
      // captura en flops el resultado combinacional
      Y_reg <= alu_Y;
      Nf_reg <= alu_Nf;
      Zf_reg <= alu_Zf;
      Cf_reg <= alu_Cf;
      Vf_reg <= alu_Vf;
    end
  end

  // Salidas top
  assign Y = Y_reg;
  assign Nf = Nf_reg;
  assign Zf = Zf_reg;
  assign Cf = Cf_reg;
  assign Vf = Vf_reg;

endmodule
