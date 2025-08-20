library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevel is
    Port (
        A    : in  STD_LOGIC_VECTOR(3 downto 0); -- Switches A
        B    : in  STD_LOGIC_VECTOR(3 downto 0); -- Switches B
        Bin  : in  STD_LOGIC;                    -- Switch para préstamo inicial
        seg  : out STD_LOGIC_VECTOR(6 downto 0); -- Salida al display
        Bout : out STD_LOGIC                     -- Préstamo final (opcional en LED)
    );
end TopLevel;

architecture Structural of TopLevel is
    component Restador4Bits
        Port (
            A     : in  STD_LOGIC_VECTOR(3 downto 0);
            B     : in  STD_LOGIC_VECTOR(3 downto 0);
            Bin   : in  STD_LOGIC;
            D     : out STD_LOGIC_VECTOR(3 downto 0);
            Bout  : out STD_LOGIC
        );
    end component;

    component Hexa7Seg
        Port (
            hex : in  STD_LOGIC_VECTOR(3 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    signal diff : STD_LOGIC_VECTOR(3 downto 0);

begin
    U1: Restador4Bits port map(A, B, Bin, diff, Bout);
    U2: Hexa7Seg port map(diff, seg);
end Structural;
