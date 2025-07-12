library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (61 downto 0);
           regA: out std_logic_vector(15 downto 0);
           regB: out std_logic_vector(15 downto 0);
           regC: out std_logic_vector(15 downto 0);
           regD: out std_logic_vector(15 downto 0)
);
end CPU;

architecture Behavioral of CPU is

--Inicio de la declaracion de componentes

component Super_Register_File is
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
end component;

component ALU_16b is 
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando.
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando.
           sop      : in  std_logic_vector (2 downto 0);   -- Selector de la operación.
           c        : out std_logic;                       -- Señal de 'carry'.
           z        : out std_logic;                       -- Señal de 'zero'.
           n        : out std_logic;                       -- Señal de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operación.
end component;

component Control_Unit is
    Port ( Rom_dataout : in STD_LOGIC_VECTOR (61 downto 0);
           Flags : in STD_LOGIC_VECTOR (2 downto 0);
           Load_reg : out STD_LOGIC;
           select_first : out STD_LOGIC_VECTOR (1 downto 0);
           select_second : out STD_LOGIC_VECTOR (1 downto 0);
           s_mux_one : out STD_LOGIC_VECTOR (1 downto 0);
           s_mux_two : out STD_LOGIC_VECTOR (1 downto 0);
           load_pc : out STD_LOGIC;
           sel_ALU : out STD_LOGIC_VECTOR (2 downto 0);
           write : out STD_LOGIC;
           select_address : out STD_LOGIC_VECTOR (1 downto 0);
           incSP : out STD_LOGIC;
           decSP : out STD_LOGIC;
           select_datain : out STD_LOGIC;
           select_reg : out STD_LOGIC_VECTOR (1 downto 0);
           sel_pc               : out STD_LOGIC
);
end component;


component Adder_12b is
    Port ( a  : in  std_logic_vector (11 downto 0);
           b  : in  std_logic_vector (11 downto 0);
           ci : in  std_logic;
           s  : out std_logic_vector (11 downto 0)
           
 );          
end component;

--Fin de la declaracion de componentes

--Inicio de la declaracion de señales
signal status_out       : std_logic_vector(2 downto 0); --usable despues
signal sp_out           : std_logic_vector(11 downto 0); --usable despues
signal pc_out           : std_logic_vector(11 downto 0); --Se conecta a la Ram address

signal Adder_out        : std_logic_vector(11 downto 0); --salida adder
signal Adder_out16b     : std_logic_vector(15 downto 0); --salida adder de 16b

signal mux_one_out      : std_logic_vector(15 downto 0); --Salida del mux 1
signal mux_two_out      : std_logic_vector(15 downto 0); --Salida del mux 2
signal pc_in            : std_logic_vector(11 downto 0); --salida del mux pc

signal first_op         : std_logic_vector(15 downto 0); --Salida 1 Super Reg
signal second_op        : std_logic_vector(15 downto 0); --Salida 2 Super Reg

signal ALU_czn          : std_logic_vector(2 downto 0); --Señal de las flags
signal Alu_result       : std_logic_vector(15 downto 0); --Resultado Alu

--señales de la control unit
signal load_reg         : std_logic;  --Señal del SRF
signal select_first     : std_logic_vector(1 downto 0); --Señal del SRF
signal select_second    : std_logic_vector(1 downto 0); --Señal del SRF
signal SelOne           : std_logic_vector(1 downto 0); --Selector mux 1
signal SelTwo           : std_logic_vector(1 downto 0); --Selector mux 2
signal load_pc          : std_logic; --señal de carga del pc
signal sel_ALU          : std_logic_vector(2 downto 0); --selecciona operacion alu
signal sel_address      : std_logic_vector(1 downto 0); --Selector address
signal inc_sp           : std_logic; --señal de incremento sp
signal dec_sp           : std_logic; --señal de decremento sp
signal sel_datain       : std_logic; --Selector datain
signal sel_reg          : std_logic_vector(1 downto 0); --Selector reg del SRF
signal sel_pc           : std_logic; --seelector del mux pc

--Fin de la declaracion de señales
begin

--Inicio de la declaracion de instancias
Super_reg_file: Super_Register_File port map(
        clk             => clock,
        result          => Alu_result,
        select_first    => select_first,
        select_second   => select_second,
        S_REG           => sel_reg,
        L_REG           => load_reg,
        load_pc         => load_pc,
        clear           => clear,
        czn             => ALU_czn,
        first_operator  => first_op,
        second_operator => second_op,
        status_out      => status_out,
        sp_out          => sp_out,
        pc_out          => pc_out,
        dec_sp          => dec_sp,
        inc_sp          => inc_sp,
        PCin            => pc_in,
        regA            => regA,
        regB            => regB,
        regC            => regC,
        regD            => regD
);

rom_address <= pc_out;

inst_ALU: ALU_16b port map(
    a       => mux_one_out,
    b       => mux_two_out,
    sop     => sel_ALU, 
    c       => ALU_czn(2),
    z       => ALU_czn(1),
    n       => ALU_czn(0),
    result  => Alu_result
);

inst_control_unit: Control_Unit port map(
           Rom_dataout      => rom_dataout,
           Flags            => status_out,
           Load_reg         => load_reg,
           select_first     => select_first,
           select_second    => select_second,
           s_mux_one        => SelOne,
           s_mux_two        => SelTwo,
           load_pc          => load_pc,
           sel_ALU          => sel_ALU,
           write            => ram_write,
           select_address   => sel_address,
           incSP            => inc_sp,
           decSP            => dec_sp,
           select_datain    => sel_datain,
           select_reg       => sel_reg,
           sel_pc           => sel_pc
 );

inst_sum: Adder_12b port map(
      a      => pc_out, --Entra la señal pc al adder
      b      => "000000000001",  --suma solo 1b
      ci     => '0',
      s      => Adder_out
);

Adder_out16b <= "0000" & Adder_out;
--Fin de la declaracion de instancias

--Iniciando la declaracion de mux

with SelOne select
    mux_one_out <=  "0000000000000001"  when "01",
                    first_op      when "10",
                    "0000000000000000"  when others;

with SelTwo select
    mux_two_out <=  "0000000000000000"          when "00",
                    second_op                   when "01",
                    rom_dataout(61 downto 46)   when "10", --Lit
                    ram_dataout                when "11";

--Mux pc
with sel_pc select
    pc_in <=    ram_dataout(11 downto 0)        when '0',
                rom_dataout(57 downto 46)        when '1'; --lit
                       

--Mux datain
with sel_datain select
    ram_datain <=   Alu_result      when '0',
                    Adder_out16b    when '1';

--Mux S
with sel_address select
    ram_address <=  second_op(11 downto 0)      when "01",
                    rom_dataout(57 downto 46)    when "10",
                    sp_out                      when others;
                                                    


end Behavioral;

