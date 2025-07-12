library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity reg_load_reset is
    Port ( din : in STD_LOGIC;
           dout : out STD_LOGIC;
           load : in STD_LOGIC;
           clear : in STD_LOGIC;
           clk : in STD_LOGIC
           );
end reg_load_reset;

architecture Behavioral of reg_load_reset is

component FFD is
    Port (
        clk : in std_logic;
        d   : in std_logic;
        q   : out std_logic);
end component;

signal mux_out  : std_logic;
signal q        : std_logic;
signal FFD_in   : std_logic;

begin
--instancias
inst_FFD: FFD port map(
        clk => clk,
        d  => FFD_in,
        q   => q
);
 
--fin de instancias

--Creando el mux
with load select
    mux_out <= q      when '0',
               din    when '1';
  
FFD_in <= not(clear) and mux_out;
dout <= q;

end Behavioral;
