library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Módulo principal para FPGA
entity TopLevel is
    Port (
        SW    : in  STD_LOGIC_VECTOR(8 downto 0); -- SW[7:4]=A, SW[3:0]=B, SW[8]=Bin
        HEX0  : out STD_LOGIC_VECTOR(6 downto 0); -- Display 7 segmentos con el resultado
        LEDR  : out STD_LOGIC_VECTOR(4 downto 0)  -- LEDs con D(3:0) y Bout
    );
end TopLevel;

architecture Estructura of TopLevel is
    signal A, B, D : STD_LOGIC_VECTOR(3 downto 0);
    signal Bin, Bout : STD_LOGIC;
begin
    -- Mapear switches de entrada
    A   <= SW(7 downto 4);
    B   <= SW(3 downto 0);
    Bin <= SW(8);

    -- Restador de 4 bits
    U1: entity work.Restador4Bits port map(
        A => A, B => B, Bin => Bin, D => D, Bout => Bout
    );

    -- Conversor a display de 7 segmentos
    U2: entity work.Hexa7Seg port map(
        BIN => D, HEX => HEX0
    );

    -- Mostrar resultado también en LEDs
    LEDR(3 downto 0) <= D;
    LEDR(4) <= Bout;
end Estructura;
