library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uzed_top is
  generic (
    HEARTBEAT_DEBUG   : boolean := true
  );
  port (
    -- Processing subsystem DDR3 SDRAM interface
    DDR_addr          : inout std_logic_vector(14 downto 0);
    DDR_ba            : inout std_logic_vector(2 downto 0);
    DDR_cas_n         : inout std_logic;
    DDR_ck_n          : inout std_logic;
    DDR_ck_p          : inout std_logic;
    DDR_cke           : inout std_logic;
    DDR_cs_n          : inout std_logic;
    DDR_dm            : inout std_logic_vector(3 downto 0);
    DDR_dq            : inout std_logic_vector(31 downto 0);
    DDR_dqs_n         : inout std_logic_vector(3 downto 0);
    DDR_dqs_p         : inout std_logic_vector(3 downto 0);
    DDR_odt           : inout std_logic;
    DDR_ras_n         : inout std_logic;
    DDR_reset_n       : inout std_logic;
    DDR_we_n          : inout std_logic;
    -- Processing subsystem fixed IO
    FIXED_IO_ddr_vrn  : inout std_logic;
    FIXED_IO_ddr_vrp  : inout std_logic;
    FIXED_IO_mio      : inout std_logic_vector(53 downto 0);
    FIXED_IO_ps_clk   : inout std_logic;
    FIXED_IO_ps_porb  : inout std_logic;
    FIXED_IO_ps_srstb : inout std_logic
    -- Processing subsystem triple timer counters (TTC)
    -- TTC0_WAVE0_OUT_0  : out   std_logic;
    -- TTC0_WAVE1_OUT_0  : out   std_logic;
    -- TTC0_WAVE2_OUT_0  : out   std_logic
  );
end uzed_top;

architecture arch of uzed_top is

  -- Fabric clocks and resets
  signal  fclk        : std_logic_vector(3 downto 0);
  signal  frstn       : std_logic_vector(3 downto 0);

begin

  ps7 : entity work.zynq_ps_wrapper
  port map (
    DDR_addr            => DDR_addr,
    DDR_ba              => DDR_ba,
    DDR_cas_n           => DDR_cas_n,
    DDR_ck_n            => DDR_ck_n,
    DDR_ck_p            => DDR_ck_p,
    DDR_cke             => DDR_cke,
    DDR_cs_n            => DDR_cs_n,
    DDR_dm              => DDR_dm,
    DDR_dq              => DDR_dq,
    DDR_dqs_n           => DDR_dqs_n,
    DDR_dqs_p           => DDR_dqs_p,
    DDR_odt             => DDR_odt,
    DDR_ras_n           => DDR_ras_n,
    DDR_reset_n         => DDR_reset_n,
    DDR_we_n            => DDR_we_n,
    FCLK_CLK0_0         => fclk(0),
    FCLK_RESET0_N_0     => frstn(0),
    FIXED_IO_ddr_vrn    => FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp    => FIXED_IO_ddr_vrp,
    FIXED_IO_mio        => FIXED_IO_mio,
    FIXED_IO_ps_clk     => FIXED_IO_ps_clk,
    FIXED_IO_ps_porb    => FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb   => FIXED_IO_ps_srstb,
    TTC0_WAVE0_OUT_0    => open,
    TTC0_WAVE1_OUT_0    => open,
    TTC0_WAVE2_OUT_0    => open
  );

  -- Tie off the unused clock inputs from the processor for now
  fclk(3 downto 1)    <= (others => '0');
  frstn(3 downto 1)   <= (others => '1');

end arch;

