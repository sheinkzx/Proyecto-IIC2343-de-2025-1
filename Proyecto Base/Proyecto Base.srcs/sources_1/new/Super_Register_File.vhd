library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity Super_Register_File is
    Port (
        clk                 : in std_logic; --CLOCK EL RELOJ
        result              : in  std_logic_vector(15 downto 0);
        select_first        : in  std_logic_vector(1 downto 0);
        select_second       : in  std_logic_vector(1 downto 0);
        S_REG               : in  std_logic_vector(1 downto 0);
        L_REG               : in  std_logic;
        load_pc             : in std_logic;
        clear               : in  std_logic;
        czn                 : in  std_logic_vector(2 downto 0);
        first_operator      : out std_logic_vector(15 downto 0);
        second_operator     : out std_logic_vector(15 downto 0);
        status_out          : out std_logic_vector(2 downto 0);
        sp_out              : out std_logic_vector(11 downto 0);
        pc_out              : out std_logic_vector(11 downto 0);
        dec_sp              : in std_logic;
        inc_sp              : in std_logic;
        PCin                : in std_logic_vector(11 downto 0);
        regA                : out std_logic_vector(15 downto 0);
        regB                : out std_logic_vector(15 downto 0);
        regC                : out std_logic_vector(15 downto 0);
        regD                : out std_logic_vector(15 downto 0)
);
end Super_Register_File;




architecture Behavioral of Super_Register_File is

component Reg_Pc is 
Port( 
    clock       :  in std_logic;       -- Se�al del clock
    load        :  in std_logic;        --se�al de carga 
    clear       :  in std_logic;
    up          : in    std_logic; --usables en un futuro
    reg_in     :  in std_logic_vector(11 downto 0);    --se�al de entrada para el registro
    reg_out_pc     : out std_logic_vector(11 downto 0)
); 

end component;

Component Register_File is
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


end Component;

Component Reg_Sp is 
Port( 
    clock       :  in std_logic;       -- Se�al del clock
    load        :  in std_logic;        --se�al de carga 
    clear       :  in std_logic;
    up          :  in std_logic; --usables en un futuro
    down        :  in std_logic;
    reg_in      :  in std_logic_vector(11 downto 0);    --se�al de entrada para el registro
    reg_out_sp  : out std_logic_vector(11 downto 0)
); 

end Component;

begin

inst_reg_file : Register_file port map(
       Alu_result           => result,
       select_first         => select_first,
       select_second        => select_second,
       Select_reg           => S_REG,
       Load_reg             => L_REG,
       clear                => clear,
       czn                  => czn,
       first_operator       => first_operator, -- salida del first operator
       second_operator      => second_operator, -- salida del second operator
       status_out           => status_out, -- salida del status out 
       clock                => clk, -- el reloj xd
       regA                 => regA,
       regB                 => regB,
       regC                 => regC,
       regD                 => regD
);

Pc : Reg_Pc port map(
    clock       => clk,
    load        => load_pc,
    up          => '1',
    clear       => clear,
    reg_in      => PCin,
    reg_out_pc     => pc_out
);

Sp : Reg_Sp port map(
    clock       => clk,
    load        => clear,
    up          => inc_sp,
    down        => dec_sp,
    clear       => '0',
    reg_in      => "111111111111",
    reg_out_sp  => sp_out
);


end Behavioral;