library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Adder_12b is
    Port ( a : in STD_LOGIC_VECTOR (11 downto 0);
           b : in STD_LOGIC_VECTOR (11 downto 0);
           ci : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (11 downto 0));
end Adder_12b;

architecture Behavioral of Adder_12b is

--declaracion de componentes
component Adder_16b is
    Port ( a  : in  std_logic_vector (15 downto 0);
           b  : in  std_logic_vector (15 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (15 downto 0);
           co : out std_logic);
end component;

--Fin declaracion de componentes


--Inicio declaracion de señales
signal a_16b      : std_logic_vector(15 downto 0);
signal b_16b      : std_logic_vector(15 downto 0);
signal s_16b      : std_logic_vector(15 downto 0);
--Fin declaracion de señales

begin

a_16b <= "0000" & a;
b_16b <= "0000" & b;

inst_sum: Adder_16b port map(
      a      => a_16b, --Entra la señal pc al adder
      b      => b_16b,  --suma solo 1b
      ci     => ci,
      s      => s_16b
);

s <= s_16b(11 downto 0);

end Behavioral;
