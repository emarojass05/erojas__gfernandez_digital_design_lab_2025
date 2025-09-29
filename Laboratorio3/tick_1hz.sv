// tick_1hz.sv — genera un pulso de 1 Hz a partir de clk_pix
module tick_1hz#(
parameter int SYS_CLK_HZ = 50_000_000
)(
    input  logic clk,
    input  logic rst,
    output logic tick_1s
);
    parameter int FREQ = 25_000_000;  // depende del pixel clock

    logic [$clog2(FREQ)-1:0] cnt;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt  <= '0;
            tick_1s <= 1'b0;
        end else if (cnt == FREQ-1) begin
            cnt  <= '0;
            tick_1s <= 1'b1;
        end else begin
            cnt  <= cnt + 1'b1;
            tick_1s <= 1'b0;
        end
    end
endmodule
