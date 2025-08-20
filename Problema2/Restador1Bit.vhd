library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Restador1Bit is
    Port (
        A     : in  STD_LOGIC;
        B     : in  STD_LOGIC;
        Bin   : in  STD_LOGIC;
        D     : out STD_LOGIC;
        Bout  : out STD_LOGIC
    );
end Restador1Bit;

architecture Behavioral of Restador1Bit is
begin
    D    <= A xor B xor Bin;
    Bout <= (not A and B) or ((not (A xor B)) and Bin);
end Behavioral;
