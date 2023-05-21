library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uzed_top is
  generic (
    HEARTBEAT_DEBUG   : boolean := true
  );
  port (
    user_led            : out std_logic_vector(3 downto 0)
  );
end uzed_top;

architecture arch of uzed_top is

  -- Fabric clocks and resets
  signal  fclk        : std_logic_vector(3 downto 0);
  signal  frstn       : std_logic;

begin

  user_led(0)         <= fclk(0);
  user_led(1)         <= fclk(1);
  user_led(2)         <= fclk(2);
  user_led(3)         <= fclk(3);


  ps7 : entity work.zynq_ps
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
    FCLK_CLK0           => fclk(0),
    FCLK_CLK1           => fclk(1),
    FCLK_CLK2           => fclk(2),
    FCLK_CLK3           => fdclk(3),
    FCLK_RESET0_N       => frstn(0),
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

end arch;

