`timescale 1ns/1ps

module tb_alu_frequency_all;

    logic clk;
    logic [1:0] op;

    // Señales para cada ALU de diferente tamaño
    logic [1:0]    a2,  b2,    y2;
    logic [3:0]    a4,  b4,    y4;
    logic [7:0]    a8,  b8,    y8;
    logic [15:0]   a16, b16,   y16;
    logic [31:0]   a32, b32,   y32;

    // Reloj
    initial clk = 0;
    always #5 clk = ~clk;

    // Secuencia de operaciones
    initial begin
        op = 2'b00;
        #20 op = 2'b01;
        #20 op = 2'b10;
        #20 op = 2'b11;
        #20 $stop;
    end

    // Estímulos para las entradas
    initial begin
        a2=2'b01;   b2=2'b10;
        a4=4'h3;    b4=4'h4;
        a8=8'h12;   b8=8'h34;
        a16=16'h1234; b16=16'h4321;
        a32=32'hAAAA5555; b32=32'h5555AAAA;
    end

    // Instancias de ALU con diferentes anchos
    alu #(.WIDTH(2))  alu2  (.clk(clk), .a(a2),  .b(b2),  .op(op), .y(y2));
    alu #(.WIDTH(4))  alu4  (.clk(clk), .a(a4),  .b(b4),  .op(op), .y(y4));
    alu #(.WIDTH(8))  alu8  (.clk(clk), .a(a8),  .b(b8),  .op(op), .y(y8));
    alu #(.WIDTH(16)) alu16 (.clk(clk), .a(a16), .b(b16), .op(op), .y(y16));
    alu #(.WIDTH(32)) alu32 (.clk(clk), .a(a32), .b(b32), .op(op), .y(y32));

endmodule
