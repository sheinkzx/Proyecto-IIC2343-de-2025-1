library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Reg_Sp is 
Port( 
    clock       :  in std_logic;  
    load        :  in std_logic;        
    clear       :  in std_logic;
    up          :  in std_logic; 
    down        :  in std_logic;
    reg_in      :  in std_logic_vector(11 downto 0);    --seï¿½al de entrada para el registro
    reg_out_sp  :  out std_logic_vector(11 downto 0)
); 

end Reg_Sp;


architecture Behavioral of Reg_Sp is

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
signal RegIn        : std_logic_vector(15 downto 0);
signal RegOut       : std_logic_vector(15 downto 0);
signal Adder_out    : std_logic_vector(15 downto 0);

signal charge       : std_logic; --señal de carga
signal up_or_down   : std_logic; --O aumenta o decrementa
signal mux_out      : std_logic_vector(15 downto 0); --entrada datain

signal lit          : std_logic_vector(15 downto 0); --literal restador
--fin de la declaracion de señales
begin
--Iniciando la declaracion de instancias:

up_or_down <= up or down;
charge <= up_or_down or load;

RegIn <= reg_in & "1111";

Regist: Reg port map(
    clock       => clock,
    load        => charge,    --señal up activa, se guarda
    clear       => clear,
    reg_in      => mux_out,
    reg_out     => RegOut
);

reg_out_sp <= RegOut(11 downto 0);

inst_sum: Adder_16b port map(
        a      => RegOut,
        b      => lit,  --suma o resta 1
        ci     => '0',
        s      => Adder_out
);

--mux selector datain
with up_or_down select
    mux_out <=  RegIn   when '0',
                Adder_out  when others;

-- mux selector suma o resta
with down select
    lit <=  "0000000000000001"  when '0',
            "1111111111111111"  when '1';
            
end Behavioral;
