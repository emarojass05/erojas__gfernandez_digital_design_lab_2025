module contador6bits #(
    parameter N = 6
)(
    input  logic         clk,        // Señal de reloj
    input  logic         async_rst,  // Reset asíncrono
    input  logic         enable,     // Habilitación del contador boton
    input  logic [N-1:0] preset_val, // Valor inicial
    input  logic         preset_en,  // Habilitación de preset boton 
    output logic [N-1:0] count,       // Salida del contador
	 output logic [6:0] HEX0,     // display unidades
    output logic [6:0] HEX1      // display decenas
);

    // Lógica del contador
    always_ff @(posedge clk, posedge async_rst) begin
        if (async_rst) begin
            count <= {N{1'b0}};  // Reset a 0
        end else if (~preset_en) begin
            count <= preset_val;  // Cargar valor inicial
        end else if (~enable) begin
            count <= count + 1;   // Incrementar contador
        end
    end
	 
	 // ========================
    // Conversión a decimal
    // ========================
    logic [3:0] unidades, decenas;
    logic [5:0] temp_q;
	 
	 always_comb begin
        unidades = count % 10;
        decenas  = count / 10;

    end
    

    // ========================
    // Decodificador 7 segmentos
    // ========================
    function [6:0] bin_to_7seg;
        input [3:0] bin;
        begin
            case (bin)
                4'h0: bin_to_7seg = 7'b1000000; // 0
                4'h1: bin_to_7seg = 7'b1111001; // 1
                4'h2: bin_to_7seg = 7'b0100100; // 2
                4'h3: bin_to_7seg = 7'b0110000; // 3
                4'h4: bin_to_7seg = 7'b0011001; // 4
                4'h5: bin_to_7seg = 7'b0010010; // 5
                4'h6: bin_to_7seg = 7'b0000010; // 6
                4'h7: bin_to_7seg = 7'b1111000; // 7
                4'h8: bin_to_7seg = 7'b0000000; // 8
                4'h9: bin_to_7seg = 7'b0010000; // 9
                default: bin_to_7seg = 7'b1111111; // apagado
            endcase
        end
    endfunction

    always_comb begin
        HEX0 = bin_to_7seg(unidades);
        HEX1 = bin_to_7seg(decenas);
    end

endmodule