`timescale 1ns/1ps

module tb_alu;
  localparam int N=4;

  // Códigos de operación
  localparam [3:0] OP_ADD=4'd0, OP_SUB=4'd1, OP_MUL=4'd2, OP_DIV=4'd3, OP_MOD=4'd4,
                   OP_AND=4'd5, OP_OR =4'd6, OP_XOR=4'd7, OP_SHL=4'd8, OP_SHR=4'd9;

  logic [N-1:0] A,B, Y;
  logic [3:0]   OP;
  logic Nf,Zf,Cf,Vf;

  ALU #(N) dut(.A(A), .B(B), .OP(OP), .Y(Y), .Nf(Nf), .Zf(Zf), .Cf(Cf), .Vf(Vf));

  task check(input [3:0] op, input [N-1:0] a,b, input [N-1:0] exp);
    begin
      OP=op; A=a; B=b; #1;
      if (Y !== exp) $fatal(1, "OP=%0d A=%0d B=%0d => Y=%0d != %0d", op,a,b,Y,exp);
    end
  endtask

  initial begin
    // + y -
    check(OP_ADD, 4'd3,4'd5, (4'd3+4'd5) & 4'hF);
    check(OP_SUB, 4'd9,4'd2, (4'd9-4'd2) & 4'hF);

    // *
    check(OP_MUL, 4'd3,4'd4, (4'd3*4'd4) & 4'hF);
    check(OP_MUL, 4'd7,4'd7, (4'd7*4'd7) & 4'hF);

    // / y %
    check(OP_DIV, 4'd8,4'd2, 4'd4);
    check(OP_MOD, 4'd9,4'd4, 4'd1);

    // Lógicos / shifts
    check(OP_AND, 4'hA,4'h5, 4'h0);
    check(OP_OR , 4'hA,4'h5, 4'hF);
    check(OP_XOR, 4'hA,4'h5, 4'hF);
    check(OP_SHL, 4'h3,4'hx, 4'h6);
    check(OP_SHR, 4'h8,4'hx,  4'h4);

    $display("Auto-chequeo OK");
    $finish;
  end
endmodule
