library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Conversor de 4 bits a display de 7 segmentos (En hexadecimal)
entity Hexa7Seg is
    Port (
        BIN : in  STD_LOGIC_VECTOR(3 downto 0); -- Entrada binaria
        HEX : out STD_LOGIC_VECTOR(6 downto 0)  -- Salida a display
    );
end Hexa7Seg;

architecture Comportamiento of Hexa7Seg is
begin
    process(BIN)
    begin
        case BIN is
            when "0000" => HEX <= "1000000"; -- 0
            when "0001" => HEX <= "1111001"; -- 1
            when "0010" => HEX <= "0100100"; -- 2
            when "0011" => HEX <= "0110000"; -- 3
            when "0100" => HEX <= "0011001"; -- 4
            when "0101" => HEX <= "0010010"; -- 5
            when "0110" => HEX <= "0000010"; -- 6
            when "0111" => HEX <= "1111000"; -- 7
            when "1000" => HEX <= "0000000"; -- 8
            when "1001" => HEX <= "0010000"; -- 9
            when "1010" => HEX <= "0001000"; -- A
            when "1011" => HEX <= "0000011"; -- b
            when "1100" => HEX <= "1000110"; -- C
            when "1101" => HEX <= "0100001"; -- d
            when "1110" => HEX <= "0000110"; -- E
            when "1111" => HEX <= "0001110"; -- F
            when others => HEX <= "1111111"; -- Apagado
        end case;
    end process;
end Comportamiento;
