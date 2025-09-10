`timescale 1ns/1ps

// Si quieres ejecutar el mismo TB para varios anchos desde el simulador,
// invoca el simulador con +define+WIDTH=4 (por ejemplo). Si no se define,
// usa N_DEFAULT.
`ifdef WIDTH
  localparam int N = `WIDTH;
`else
  localparam int N = 4;
`endif

module tb_alu;
  // Códigos de operación
  localparam [3:0] OP_ADD=4'd0, OP_SUB=4'd1, OP_MUL=4'd2, OP_DIV=4'd3, OP_MOD=4'd4,
                   OP_AND=4'd5, OP_OR =4'd6, OP_XOR=4'd7, OP_SHL=4'd8, OP_SHR=4'd9;

  // Clock period que usaremos para captura funcional (ns). 
  // NOTA: para medir frecuencia real usar TimeQuest después de síntesis/P&R.
  real clk_period = 20.0; // 20 ns => 50 MHz (valor inicial para simulación funcional)

  logic clk;
  initial clk = 0;
  always #(clk_period/2.0) clk = ~clk;

  // Entradas / registros (Rin)
  logic [N-1:0] rin_A, rin_B;
  logic [3:0]   rin_OP;

  // Registros (Rin) se cargan en posedge
  always_ff @(posedge clk) begin
    // Rin actualizan desde stimuli (se asignan en task vectores)
    // aqui quedan para modelar registro de borde de entrada (lado izquierdo)
  end

  // Señales combinacionales conectadas a ALU (salida de los registros Rin)
  logic [N-1:0] A_reg, B_reg;
  logic [3:0]   OP_reg;

  // registers that model the "parallel-load" register before the combinational ALU
  always_ff @(posedge clk) begin
    A_reg <= rin_A;
    B_reg <= rin_B;
    OP_reg <= rin_OP;
  end

  // ALU instancia (combinacional)
  logic [N-1:0] combY;
  logic Nf, Zf, Cf, Vf;

  // Instancia la ALU parametrizada
  ALU #(N) dut (
    .A(A_reg), .B(B_reg), .OP(OP_reg),
    .Y(combY), .Nf(Nf), .Zf(Zf), .Cf(Cf), .Vf(Vf)
  );

  // Registro de salida (Rout) que captura la salida combinacional en el siguiente posedge
  logic [N-1:0] rout_Y;
  always_ff @(posedge clk) begin
    rout_Y <= combY;
  end

  // Stimulus generator: aplica vectores a rin_* en flancos para excitar la ruta
  task automatic apply_vector(input [3:0] op, input [N-1:0] a, input [N-1:0] b);
    begin
      // Asignamos a las señales que se cargarán en el siguiente posedge
      rin_OP = op;
      rin_A  = a;
      rin_B  = b;
      // Esperamos un ciclo para que los registros Rin carguen y la combinacional calcule
      @(posedge clk);
      // Esperamos otro flanco para que Rout capture combY
      @(posedge clk);
    end
  endtask

  // Checker para comparar resultado esperado (modelado funcionalmente) con lo capturado
  function automatic [N-1:0] expected_result(input [3:0] op, input [N-1:0] a, input [N-1:0] b);
    begin
      case (op)
        OP_ADD: expected_result = (a + b) & ({N{1'b1}});
        OP_SUB: expected_result = (a - b) & ({N{1'b1}});
        OP_MUL: expected_result = (a * b) & ({N{1'b1}});
        OP_DIV: expected_result = (b==0) ? {N{1'b0}} : (a / b);
        OP_MOD: expected_result = (b==0) ? {N{1'b0}} : (a % b);
        OP_AND: expected_result = a & b;
        OP_OR : expected_result = a | b;
        OP_XOR: expected_result = a ^ b;
        OP_SHL: expected_result = (a << 1) & ({N{1'b1}});
        OP_SHR: expected_result = (a >> 1);
        default: expected_result = {N{1'b0}};
      endcase
    end
  endfunction

  // Test sequence
  initial begin
    // Dump waves
    $display("TB: WIDTH = %0d bits", N);
    $dumpfile($sformatf("tb_alu_%0d.vcd", N));
    $dumpvars(0, tb_alu);

    // Inicial valores
    rin_A = '0; rin_B = '0; rin_OP = '0;
    // Two clock cycles warm-up
    repeat (2) @(posedge clk);

    // Vectores representativos (puedes extenderlos o randomizar)
    apply_vector(OP_ADD,  $unsigned('d3), $unsigned('d5));
    if (rout_Y !== expected_result(OP_ADD, 4'd3,4'd5)) begin
      $error("Mismatch ADD: got %0d expected %0d", rout_Y, expected_result(OP_ADD, 4'd3,4'd5));
    end

    apply_vector(OP_SUB, $unsigned('d9), $unsigned('d2));
    apply_vector(OP_MUL, $unsigned('d3), $unsigned('d4));
    apply_vector(OP_MUL, $unsigned('d7), $unsigned('d7));
    apply_vector(OP_DIV, $unsigned('d8), $unsigned('d2));
    apply_vector(OP_MOD, $unsigned('d9), $unsigned('d4));
    apply_vector(OP_AND, $unsigned(4'hA), $unsigned(4'h5));
    apply_vector(OP_OR,  $unsigned(4'hA), $unsigned(4'h5));
    apply_vector(OP_XOR, $unsigned(4'hA), $unsigned(4'h5));
    apply_vector(OP_SHL, $unsigned(4'h3), $unsigned('0));
    apply_vector(OP_SHR, $unsigned(4'h8), $unsigned('0));

    $display("Simulación funcional OK para N=%0d", N);
    #10;
    $finish;
  end

endmodule
