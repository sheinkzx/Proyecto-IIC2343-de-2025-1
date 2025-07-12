library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Reg_Pc is 
Port( 
    clock       :  in std_logic;       -- Señal del clock
    load        :  in std_logic;        --señal de carga 
    clear       :  in std_logic;
    up          : in    std_logic; --usables en un futuro
    reg_in      :  in std_logic_vector(11 downto 0);    --señal de entrada para el registro
    reg_out_pc     : out std_logic_vector(11 downto 0)
); 

end Reg_Pc;


architecture Behavioral of Reg_Pc is

component Reg is 
Port( 
    clock       :  in std_logic;       -- Señal del clock
    load        :  in std_logic;        --señal de carga 
    clear       :  in std_logic;
    reg_in      :  in std_logic_vector(15 downto 0);    --señal de entrada para el registro
    reg_out     : out std_logic_vector(15 downto 0)
); 

end component;


component Adder_16b is
    Port ( a  : in  std_logic_vector (15 downto 0);
           b  : in  std_logic_vector (15 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (15 downto 0);
           co : out std_logic);
end component;

--declarando señales
signal RegIn : std_logic_vector(15 downto 0);
signal RegOut : std_logic_vector(15 downto 0);
signal Adder_out : std_logic_vector(15 downto 0);

signal charge : std_logic; --señal de carga
signal mux_out: std_logic_vector(15 downto 0);
--fin de la declaracion de señales
begin
--Iniciando la declaracion de instancias:


charge <= up or load;

RegIn <= "0000" & reg_in;

Regist: Reg port map(
    clock       => clock,
    load        => charge,    --señal up activa, se guarda
    clear       => clear,
    reg_in      => mux_out,
    reg_out     => RegOut
);

reg_out_pc <= RegOut(11 downto 0);

inst_sum: Adder_16b port map(
        a      => RegOut,
        b      => "0000000000000001",  --suma solo 1b
        ci     => '0',
        s      => Adder_out
);

with load select
    mux_out <=  Adder_out   when '0',
                RegIn  when others;
end Behavioral;
