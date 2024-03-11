library ieee;
use ieee.std_logic_1164.all;

entity instr_decoder is
    port (
        IR          : in    std_logic_vector(7 downto 0);
        -- There are 15 addressing modes available to the 65C02
        mode        : out   std_logic_vector(3 downto 0);
        -- Instructions can be 1, 2, or 3 bytes in length
        length      : out   unsigned(1 downto 0);
        -- Number of clock cycles to execute (does not include the extra clock required by
        -- some instructions when crossing page boundaries)
        timing      : out   unsigned(3 downto 0)
    );
end entity instr_decoder;

architecture behavioral of instr_decoder is

    -- There are 15 addressing modes in the WD65C02 
    -- 0000 - implied
    -- 0001 - accumulator
    -- 0011 - immediate
    -- 0100 - absolute

begin

    case IR is

        when x"EA" =>
            mode    <= x"0";
            length  <= 1;
            timing  <= 2;

        when others =>
            mode    <= x"0";
            length  <= 0;
            timing  <= 0;

    end case;

end architecture behavioral;

