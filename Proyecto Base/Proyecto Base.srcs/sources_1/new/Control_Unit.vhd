library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Control_Unit is
    Port ( Rom_dataout : in STD_LOGIC_VECTOR (61 downto 0);
           Flags                : in STD_LOGIC_VECTOR (2 downto 0);
           Load_reg             : out STD_LOGIC;
           select_first         : out STD_LOGIC_VECTOR (1 downto 0);
           select_second        : out STD_LOGIC_VECTOR (1 downto 0);
           s_mux_one            : out STD_LOGIC_VECTOR (1 downto 0);
           s_mux_two            : out STD_LOGIC_VECTOR (1 downto 0);
           load_pc              : out STD_LOGIC;
           sel_ALU              : out STD_LOGIC_VECTOR (2 downto 0);
           write                : out STD_LOGIC;
           select_address       : out STD_LOGIC_VECTOR (1 downto 0);
           incSP                : out STD_LOGIC;
           decSP                : out STD_LOGIC;
           select_datain        : out STD_LOGIC;
           select_reg           : out STD_LOGIC_VECTOR (1 downto 0);
           sel_pc               : out STD_LOGIC
 );
end Control_Unit;

architecture Behavioral of Control_Unit is

--señales flag
signal c : std_logic; -- bit 2
signal z : std_logic; -- bit 1
signal n : std_logic; -- bit 0
begin
--Mux para las operaciones de la ALU
with Rom_dataout(7 downto 0) select
    sel_ALU <=  "000"   when "00000001", --suma
                "001"   when "00000010", --resta
                "010"   when "00000100", --and
                "011"   when "00001000", --or
                "100"   when "00010000", --xor
                "101"   when "00100000", --not
                "110"   when "01000000", --shr
                "111"   when "10000000", --shl
                "000"   when others; --suma en caso de no haber coincidencias
--Carga de registros
Load_reg <= Rom_dataout(8); --Bit de carga

-- Mux para el select first
with Rom_dataout(12 downto 9) select
    select_first <=     "00" when "0001", --Reg A
                        "01" when "0010", --Reg B
                        "10" when "0100", --Reg C
                        "11" when "1000", --Reg D 
                        "00" when others; --Reg A si no coincide 
 
-- Mux para el select second
with Rom_dataout(16 downto 13) select
    select_second <=        "00" when "0001", --Reg A
                            "01" when "0010", --Reg B
                            "10" when "0100", --Reg C
                            "11" when "1000", --Reg D 
                            "00" when others; --Reg A si no coincide  

--Mux para cargar un registro especifico                            
with Rom_dataout(20 downto 17) select         --Carga:
    select_reg <=           "00" when "0001", --Reg A
                            "01" when "0010", --Reg B
                            "10" when "0100", --Reg C
                            "11" when "1000", --Reg D 
                            "00" when others; --Carga Reg A si no coincide                           
                            
-- Mux para seleccionar señal Mux One
with Rom_dataout(23 downto 21) select
     s_mux_one <=   "10"    when "001", --Selecciona el resultado del reg file
                    "01"    when "010", --Selecciona el valor 1
                    "00"    when others; --Selecciona el valor 0     
                                      
-- Mux para seleccionar señal Mux Two 
with Rom_dataout(27 downto 24) select
     s_mux_two <=   "01"    when "0001", --Selecciona el resultado del reg file
                    "00"    when "0010", --Selecciona el valor 0
                    "10"    when "0100", --Selecciona el literal
                    "11"    when "1000", --Selecciona la RAM
                    "00"    when others; -- Valor 0 en otro caso
 
-- Mux para la seleccion del mux datain
with Rom_dataout(29 downto 28) select
    select_datain  <=   '0'   when "01", --selecciona ALU
                        '1'   when "10", --seleccion PC+1
                        '0'   when others; --En caso de otro valor, ALU

--Se activa la señal write
write   <= Rom_dataout(30);

--Mux para la seleccion del mux S
with Rom_dataout(33 downto 31) select
    select_address  <=  "00"    when "100", -- salida sp
                        "01"    when "010", --salida second op
                        "10"    when "001", --Literal
                        "11"    when others; --En caso de otro valor, se autodefine solo

--Señales de inc y dec
incSP <= Rom_dataout(34);
decSP <= Rom_dataout(35);                  
                    
-- Mux para la seleccion del mux pc
with Rom_dataout(45 downto 44) select
    sel_pc  <=   '1'   when "01", --selecciona lit
                 '0'   when "10", --selecciona ram
                 '0'   when others; --En caso de otro valor, Ram                 
                    
--Creando el mux para los saltos incondicionales

c <= flags(2);  
z <= flags(1); 
n <= flags(0);  

with Rom_dataout(43 downto 36) select
    load_pc <= '1'                  when "00000001", --JMP
                z                   when "00000010", --JEQ
                not(z)              when "00000100", --JNE
                not(n) and not(z)   when "00001000", --JGT
                not(n)              when "00010000", --JGE
                n                   when "00100000", --JLT
                n or z              when "01000000", --JLE
                c                   when "10000000", --JCR
                '0'                 when others; --No hace jmp
                

                                              
end Behavioral;
