library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Restador completo de 4 bits (usa 4 instancias del de 1 bit para poder crear el de 4 haciendolo en cascada)
entity Restador4Bits is
    Port (
        A     : in  STD_LOGIC_VECTOR(3 downto 0); -- Minuendo (4 bits)
        B     : in  STD_LOGIC_VECTOR(3 downto 0); -- Sustraendo (4 bits)
        Bin   : in  STD_LOGIC;                    -- Préstamo inicial
        D     : out STD_LOGIC_VECTOR(3 downto 0); -- Diferencia (4 bits)
        Bout  : out STD_LOGIC                     -- Préstamo final
    );
end Restador4Bits;

architecture Estructura of Restador4Bits is
    component Restador1Bit
        Port (
            A     : in  STD_LOGIC;
            B     : in  STD_LOGIC;
            Bin   : in  STD_LOGIC;
            D     : out STD_LOGIC;
            Bout  : out STD_LOGIC
        );
    end component;

    signal prestamos : STD_LOGIC_VECTOR(3 downto 0);

begin
    R0: Restador1Bit port map(A(0), B(0), Bin, D(0), prestamos(0));
    R1: Restador1Bit port map(A(1), B(1), prestamos(0), D(1), prestamos(1));
    R2: Restador1Bit port map(A(2), B(2), prestamos(1), D(2), prestamos(2));
    R3: Restador1Bit port map(A(3), B(3), prestamos(2), D(3), prestamos(3));

    Bout <= prestamos(3);
end Estructura;
