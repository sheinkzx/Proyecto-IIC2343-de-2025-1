library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Register_File is
    Port ( Alu_result       : in STD_LOGIC_VECTOR (15 downto 0);
           select_first     : in STD_LOGIC_VECTOR (1 downto 0);
           select_second    : in STD_LOGIC_VECTOR (1 downto 0);
           Select_reg       : in STD_LOGIC_VECTOR (1 downto 0);
           Load_reg         : in STD_LOGIC;
           clear            : in STD_LOGIC;
           czn              : in STD_LOGIC_VECTOR (2 downto 0);
           first_operator   : out STD_LOGIC_VECTOR (15 downto 0);
           second_operator  : out STD_LOGIC_VECTOR (15 downto 0);
           status_out       : out STD_LOGIC_VECTOR (2 downto 0);
           clock            :  in STD_LOGIC;
           regA             : out STD_LOGIC_VECTOR(15 downto 0);
           regB             : out STD_LOGIC_VECTOR(15 downto 0);
           regC             : out STD_LOGIC_VECTOR(15 downto 0);
           regD             : out STD_LOGIC_VECTOR(15 downto 0)
);
end Register_File;

architecture Behavioral of Register_File is

--declaracion de componentes
component Reg is 
Port( 
    clock       :  in std_logic;       -- Señal del clock
    load        :  in std_logic;        --señal de carga 
    clear       :  in std_logic;
    reg_in      :  in std_logic_vector(15 downto 0);    --señal de entrada para el registro
    reg_out     : out std_logic_vector(15 downto 0)
); 

end component;

--fin declaracion de componenetes


--Inicio de la declaracion de señales
--Salidas de registro
signal reg_a_out : std_logic_vector(15 downto 0);
signal reg_b_out : std_logic_vector(15 downto 0);
signal reg_c_out : std_logic_vector(15 downto 0);
signal reg_d_out : std_logic_vector(15 downto 0);

--Salidas del demux
signal load_a   : std_logic;
signal load_b   : std_logic;
signal load_c   : std_logic;
signal load_d    : std_logic;

--señales de status
signal status_in : std_logic_vector(15 downto 0);
signal reg_status_16b : std_logic_vector(15 downto 0);

-- Fin de la declaracion de señales

begin
--Inicio de la declaracion de instancias
Reg_A: Reg port map(
    clock       => clock,
    load        => load_a,
    clear       => clear,
    reg_in      => Alu_result,
    reg_out     => reg_a_out
);

Reg_B: Reg port map(
    clock       => clock,
    load        => load_b,
    clear       => clear,
    reg_in      => Alu_result,
    reg_out     => reg_b_out
);

Reg_C: Reg port map(
    clock       => clock,
    load        => load_c,
    clear       => clear,
    reg_in      => Alu_result,
    reg_out     => reg_c_out
);

Reg_D: Reg port map(
    clock       => clock,
    load        => load_d,
    clear       => clear,
    reg_in      => Alu_result,
    reg_out     => reg_d_out
);
status_in <= "0000000000000" & czn;

Reg_status: Reg port map(
    clock       => clock,
    load        => '1',
    clear       => clear,
    reg_in      => status_in,
    reg_out     => reg_status_16b
);

status_out <= reg_status_16b(2 downto 0);
-- Fin de la declaracion de instancias

--Creando el demux
with Select_reg select
    load_a <=   Load_reg  when "00",
                '0' when others;
             
with Select_reg select
    load_b <=   Load_reg  when "01",
                '0' when others;               

with Select_reg select
    load_c <=   Load_reg  when "10",
                '0' when others;
    
with Select_reg select
    load_d <=   Load_reg  when "11",
                '0' when others;
            
--fin del demux

--creando los 2 muxes de 16b
with select_first select
    first_operator <= reg_a_out     when "00",
                      reg_b_out     when "01",
                      reg_c_out     when "10",
                      reg_d_out     when "11";
        
                      
with select_second select
    second_operator <= reg_a_out     when "00",
                       reg_b_out     when "01",
                       reg_c_out     when "10",
                       reg_d_out     when "11";

--Conectando los registros a las salidas:
regA <= reg_a_out; 
regB <= reg_b_out;
regC <= reg_c_out;
regD <= reg_d_out;   
                  
end Behavioral;
