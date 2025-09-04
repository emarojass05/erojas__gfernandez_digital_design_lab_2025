module alu #(parameter WIDTH = 8) (
    input  logic clk,
    input  logic [WIDTH-1:0] a, b,
    input  logic [1:0] op,
    output logic [WIDTH-1:0] y
);

    always_ff @(posedge clk) begin
        case(op)
            2'b00: y <= a + b;   // Suma
            2'b01: y <= a - b;   // Resta
            2'b10: y <= a & b;   // AND
            2'b11: y <= a | b;   // OR
            default: y <= '0;
        endcase
    end

endmodule
