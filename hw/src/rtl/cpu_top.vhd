library ieee;
use ieee.std_logic_1164.all;

entity cpu_top is
    port (
        clk             : in    std_logic;
        clk_en          : in    std_logic;

        rstn            : in    std_logic;

        rd_data         : in    std_logic_vector(7 downto 0);
        wr_data         : out   std_logic_vector(7 downto 0);

        addr            : out   std_logic_vector(15 downto 0);
        rw_n            : out   std_logic;

        -- Negative edge triggered non-maskable interrupt (NMI) input
        nmi_n           : in    std_logic;
        -- Active low interrupt request (IRQ) input
        irq_n           : in    std_logic
    );
end entity cpu_top;

architecture behavioral of cpu_top is

    -- For simplicity, capital letters and very short names, are reserved for
    -- representing processor internal registers, processor flags, and opcodes.

    -- Instruction register (IR)
    signal IR           : std_logic_vector(7 downto 0);
    -- Accumulator register (A)
    signal A            : std_logic_vector(7 downto 0);
    -- Index registers (X and Y)
    signal X            : std_logic_vector(7 downto 0);
    signal Y            : std_logic_vector(7 downto 0);
    -- Processor status register (P)
    signal P            : std_logic_vector(7 downto 0);
    -- Program counter register (PC)
    signal PC           : std_logic_vector(15 downto 0);
    -- Stack register (S)
    signal S            : std_logic_vector(7 downto 0);

    -- Useful to define portions of these signals as aliases
    alias PCH           : std_logic_vector(7 downto 0) is PC(15 downto 8);
    alias PCL           : std_logic_vector(7 downto 0) is PC(7 downto 0);

    -- Individual processor flags
    alias N             : std_logic is P(7);
    alias V             : std_logic is P(6);
    alias B             : std_logic is P(4);
    alias D             : std_logic is P(3);
    alias I             : std_logic is P(2);
    alias Z             : std_logic is P(1);
    alias C             : std_logic is P(0);

begin

    instr_decoder: entity work.instr_decoder
        port map (
            IR          => IR,
            mode        => mode,
            length      => length,
            timing      => timing
        );

    process(clk)
    begin
        if rising_edge(clk) then
            if (rstn = '0') then
                -- The 65C02 only initializes these values during reset. The
                -- remainder are initialized by software.
                B       <= '1';
                D       <= '0';
                I       <= '1';
                -- Additionally, this one is hard wired to 1
                P(5)    <= '1';
            end if;
        end if;
    end process;


end architecture behavioral;

