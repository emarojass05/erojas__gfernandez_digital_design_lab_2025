library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_TopLevel is
end tb_TopLevel;

architecture sim of tb_TopLevel is
    -- Señales internas para la simulación
    signal A    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal B    : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Bin  : STD_LOGIC := '0';
    signal seg  : STD_LOGIC_VECTOR(6 downto 0);
    signal Bout : STD_LOGIC;
begin
    -- Instanciamos el diseño a probar
    UUT: entity work.TopLevel
        port map (
            A    => A,
            B    => B,
            Bin  => Bin,
            seg  => seg,
            Bout => Bout
        );

    -- Proceso de estímulos
    stim_proc: process
    begin
        -- Caso 1: 7 - 2 = 5
        A <= "0111"; B <= "0010"; Bin <= '0';
        wait for 20 ns;

        -- Caso 2: 5 - 9 = negativo (Borrow activo)
        A <= "0101"; B <= "1001"; Bin <= '0';
        wait for 20 ns;

        -- Caso 3: 15 - 15 = 0
        A <= "1111"; B <= "1111"; Bin <= '0';
        wait for 20 ns;

        -- Caso 4: 0 - 1 = negativo (Borrow activo)
        A <= "0000"; B <= "0001"; Bin <= '0';
        wait for 20 ns;

        -- Terminar simulación
        wait;
    end process;
end sim;
