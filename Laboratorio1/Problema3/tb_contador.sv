module tb_contador;
    timeunit 1ns;
    timeprecision 1ps;
    
    // Parámetros para diferentes pruebas
    parameter N_2BITS = 2;
    parameter N_4BITS = 4;
    parameter N_6BITS = 6;
    
    // Señales para el contador de 2 bits
    logic clk_2b;
    logic async_rst_2b;
    logic enable_2b;
    logic [N_2BITS-1:0] preset_val_2b;
    logic preset_en_2b;
    logic [N_2BITS-1:0] count_2b;
    logic [6:0] HEX0_2b, HEX1_2b;
    
    // Señales para el contador de 4 bits
    logic clk_4b;
    logic async_rst_4b;
    logic enable_4b;
    logic [N_4BITS-1:0] preset_val_4b;
    logic preset_en_4b;
    logic [N_4BITS-1:0] count_4b;
    logic [6:0] HEX0_4b, HEX1_4b;
    
    // Señales para el contador de 6 bits
    logic clk_6b;
    logic async_rst_6b;
    logic enable_6b;
    logic [N_6BITS-1:0] preset_val_6b;
    logic preset_en_6b;
    logic [N_6BITS-1:0] count_6b;
    logic [6:0] HEX0_6b, HEX1_6b;
    
    // Instancias de los contadores
    contador6bits #(.N(N_2BITS)) dut_2b (
        .clk(clk_2b),
        .async_rst(async_rst_2b),
        .enable(enable_2b),
        .preset_val(preset_val_2b),
        .preset_en(preset_en_2b),
        .count(count_2b),
        .HEX0(HEX0_2b),
        .HEX1(HEX1_2b)
    );
    
    contador6bits #(.N(N_4BITS)) dut_4b (
        .clk(clk_4b),
        .async_rst(async_rst_4b),
        .enable(enable_4b),
        .preset_val(preset_val_4b),
        .preset_en(preset_en_4b),
        .count(count_4b),
        .HEX0(HEX0_4b),
        .HEX1(HEX1_4b)
    );
    
    contador6bits #(.N(N_6BITS)) dut_6b (
        .clk(clk_6b),
        .async_rst(async_rst_6b),
        .enable(enable_6b),
        .preset_val(preset_val_6b),
        .preset_en(preset_en_6b),
        .count(count_6b),
        .HEX0(HEX0_6b),
        .HEX1(HEX1_6b)
    );
    
    // Generación de relojes
    always #5 clk_2b = ~clk_2b;
    always #5 clk_4b = ~clk_4b;
    always #5 clk_6b = ~clk_6b;
    
    // Tarea para verificar el valor del contador
    task automatic verify_count(int bits, logic [15:0] actual, logic [15:0] expected, string test_name);
        if (actual !== expected) begin
            $error("ERROR en %s: Esperado %0d, Obtenido %0d", test_name, expected, actual);
            $finish;
        end else begin
            $display("✓ %s: Count = %0d", test_name, actual);
        end
    endtask
    
    // Tarea para verificar display 7 segmentos
    task automatic verify_display(int bits, logic [6:0] hex_actual, logic [6:0] hex_expected, string digit_name);
        if (hex_actual !== hex_expected) begin
            $error("ERROR en display %s (%0d bits): Esperado %7b, Obtenido %7b", 
                   digit_name, bits, hex_expected, hex_actual);
            $finish;
        end
    endtask
    
    // Función para obtener patrón 7 segmentos esperado
    function logic [6:0] get_expected_7seg(input [3:0] digit);
        case (digit)
            4'h0: return 7'b1000000; // 0
            4'h1: return 7'b1111001; // 1
            4'h2: return 7'b0100100; // 2
            4'h3: return 7'b0110000; // 3
            4'h4: return 7'b0011001; // 4
            4'h5: return 7'b0010010; // 5
            4'h6: return 7'b0000010; // 6
            4'h7: return 7'b1111000; // 7
            4'h8: return 7'b0000000; // 8
            4'h9: return 7'b0010000; // 9
            default: return 7'b1111111; // apagado
        endcase
    endfunction
    
    // Test para contador de 2 bits
    task test_2bits;
        $display("\n=== INICIANDO TEST 2 BITS ===");
        
        // Inicialización
        clk_2b = 0;
        async_rst_2b = 0;
        enable_2b = 1;
        preset_val_2b = 2'b00;
        preset_en_2b = 1;
        
        // Test 1: Reset asíncrono
        async_rst_2b = 1;
        #10;
        async_rst_2b = 0;
        #5;
        verify_count(2, count_2b, 2'b00, "Reset asíncrono");
        verify_display(2, HEX0_2b, get_expected_7seg(0), "Unidades después de reset");
        
        // Test 2: Primer incremento
        enable_2b = 0; // Activar enable (tu lógica usa ~enable)
        #10;
        enable_2b = 1;
        #5;
        verify_count(2, count_2b, 2'b01, "Primer incremento");
        verify_display(2, HEX0_2b, get_expected_7seg(1), "Unidades después de incremento 1");
        
        // Test 3: Segundo incremento
        enable_2b = 0;
        #10;
        enable_2b = 1;
        #5;
        verify_count(2, count_2b, 2'b10, "Segundo incremento");
        verify_display(2, HEX0_2b, get_expected_7seg(2), "Unidades después de incremento 2");
        
        // Test 4: Tercer incremento (debe hacer overflow)
        enable_2b = 0;
        #10;
        enable_2b = 1;
        #5;
        verify_count(2, count_2b, 2'b11, "Tercer incremento");
        verify_display(2, HEX0_2b, get_expected_7seg(3), "Unidades después de incremento 3");
        
        // Test 5: Cuarto incremento (wrap around)
        enable_2b = 0;
        #10;
        enable_2b = 1;
        #5;
        verify_count(2, count_2b, 2'b00, "Wrap around");
        verify_display(2, HEX0_2b, get_expected_7seg(0), "Unidades después de wrap around");
        
        $display("✓ TEST 2 BITS COMPLETADO EXITOSAMENTE");
    endtask
    
    // Test para contador de 4 bits
    task test_4bits;
        $display("\n=== INICIANDO TEST 4 BITS ===");
        
        // Inicialización
        clk_4b = 0;
        async_rst_4b = 0;
        enable_4b = 1;
        preset_val_4b = 4'b0000;
        preset_en_4b = 1;
        
        // Test 1: Reset asíncrono
        async_rst_4b = 1;
        #10;
        async_rst_4b = 0;
        #5;
        verify_count(4, count_4b, 4'b0000, "Reset asíncrono");
        verify_display(4, HEX0_4b, get_expected_7seg(0), "Unidades después de reset");
        verify_display(4, HEX1_4b, get_expected_7seg(0), "Decenas después de reset");
        
        // Test 2: Primer incremento
        enable_4b = 0;
        #10;
        enable_4b = 1;
        #5;
        verify_count(4, count_4b, 4'b0001, "Primer incremento");
        verify_display(4, HEX0_4b, get_expected_7seg(1), "Unidades después de incremento 1");
        
        // Test 3: Segundo incremento
        enable_4b = 0;
        #10;
        enable_4b = 1;
        #5;
        verify_count(4, count_4b, 4'b0010, "Segundo incremento");
        verify_display(4, HEX0_4b, get_expected_7seg(2), "Unidades después de incremento 2");
        
        // Test 4: Tercer incremento
        enable_4b = 0;
        #10;
        enable_4b = 1;
        #5;
        verify_count(4, count_4b, 4'b0011, "Tercer incremento");
        verify_display(4, HEX0_4b, get_expected_7seg(3), "Unidades después de incremento 3");
        
        // Test 5: Preset value
        preset_val_4b = 4'b1001; // 9
        preset_en_4b = 0; // Activar preset (tu lógica usa ~preset_en)
        #10;
        preset_en_4b = 1;
        #5;
        verify_count(4, count_4b, 4'b1001, "Preset value 9");
        verify_display(4, HEX0_4b, get_expected_7seg(9), "Unidades después de preset 9");
        
        $display("✓ TEST 4 BITS COMPLETADO EXITOSAMENTE");
    endtask
    
    // Test para contador de 6 bits
    task test_6bits;
        $display("\n=== INICIANDO TEST 6 BITS ===");
        
        // Inicialización
        clk_6b = 0;
        async_rst_6b = 0;
        enable_6b = 1;
        preset_val_6b = 6'b000000;
        preset_en_6b = 1;
        
        // Test 1: Reset asíncrono
        async_rst_6b = 1;
        #10;
        async_rst_6b = 0;
        #5;
        verify_count(6, count_6b, 6'b000000, "Reset asíncrono");
        verify_display(6, HEX0_6b, get_expected_7seg(0), "Unidades después de reset");
        verify_display(6, HEX1_6b, get_expected_7seg(0), "Decenas después de reset");
        
        // Test 2: Primer incremento
        enable_6b = 0;
        #10;
        enable_6b = 1;
        #5;
        verify_count(6, count_6b, 6'b000001, "Primer incremento");
        verify_display(6, HEX0_6b, get_expected_7seg(1), "Unidades después de incremento 1");
        
        // Test 3: Segundo incremento
        enable_6b = 0;
        #10;
        enable_6b = 1;
        #5;
        verify_count(6, count_6b, 6'b000010, "Segundo incremento");
        verify_display(6, HEX0_6b, get_expected_7seg(2), "Unidades después de incremento 2");
        
        // Test 4: Tercer incremento
        enable_6b = 0;
        #10;
        enable_6b = 1;
        #5;
        verify_count(6, count_6b, 6'b000011, "Tercer incremento");
        verify_display(6, HEX0_6b, get_expected_7seg(3), "Unidades después de incremento 3");
        
        // Test 5: Preset value 25
        preset_val_6b = 6'b011001; // 25 decimal
        preset_en_6b = 0;
        #10;
        preset_en_6b = 1;
        #5;
        verify_count(6, count_6b, 6'b011001, "Preset value 25");
        verify_display(6, HEX0_6b, get_expected_7seg(5), "Unidades después de preset 25");
        verify_display(6, HEX1_6b, get_expected_7seg(2), "Decenas después de preset 25");
        
        // Test 6: Incremento desde 25
        enable_6b = 0;
        #10;
        enable_6b = 1;
        #5;
        verify_count(6, count_6b, 6'b011010, "Incremento desde 25");
        verify_display(6, HEX0_6b, get_expected_7seg(6), "Unidades después de incremento desde 25");
        verify_display(6, HEX1_6b, get_expected_7seg(2), "Decenas después de incremento desde 25");
        
        $display("✓ TEST 6 BITS COMPLETADO EXITOSAMENTE");
    endtask
    
    // Procedimiento principal de test
    initial begin
        $display("INICIANDO SIMULACIÓN DEL CONTADOR PARAMETRIZABLE");
        $display("=============================================");
        
        // Ejecutar tests secuencialmente
        test_2bits();
        test_4bits();
        test_6bits();
        
        $display("\n=============================================");
        $display("✓ TODOS LOS TESTS COMPLETADOS EXITOSAMENTE");
        $display("✓ CONTADOR DE 2, 4 Y 6 BITS VERIFICADOS");
        $display("✓ DISPLAYS 7 SEGMENTOS VERIFICADOS");
        $display("=============================================");
        
        #100;
        $finish;
    end
    
endmodule
