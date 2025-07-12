library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity Reg is 
Port( 
    clock       :  in std_logic;       -- Señal del clock
    load        :  in std_logic;        --señal de carga 
    clear       :  in std_logic;
    up          : in    std_logic; --usables en un futuro
    down        : in    std_logic;
    reg_in      :  in std_logic_vector(15 downto 0);    --señal de entrada para el registro
    reg_out     : out std_logic_vector(15 downto 0)
); 

end Reg;


architecture Behavioral of Reg is

component reg_load_reset is
    Port ( din : in STD_LOGIC;
           dout : out STD_LOGIC;
           load : in STD_LOGIC;
           clear : in STD_LOGIC;
           clk : in STD_LOGIC
           );
end component;

--Inicio la declaracion de señales

-- Fin de la declaracion de señales

begin

-- Creando los 16 flip flop D para cada bit
inst_FFD_1: reg_load_reset port map(
        din  => reg_in(0),
        dout   => reg_out(0),
        clk => clock,
        load => load,
        clear => clear
);

inst_FFD_2: reg_load_reset port map(
        clk => clock,
        din  => reg_in(1),
        dout   => reg_out(1),
        load => load,
        clear => clear
);

inst_FFD_3: reg_load_reset port map(
        clk => clock,
        din  => reg_in(2),
        dout   => reg_out(2),
        load => load,
        clear => clear
);

inst_FFD_4: reg_load_reset port map(
        clk => clock,
        din  => reg_in(3),
        dout   => reg_out(3),
        load => load,
        clear => clear
);

inst_FFD_5: reg_load_reset port map(
        clk => clock,
        din  => reg_in(4),
        dout   => reg_out(4),
        load => load,
        clear => clear
);

inst_FFD_6: reg_load_reset port map(
        clk => clock,
        din  => reg_in(5),
        dout   => reg_out(5),
        load => load,
        clear => clear
);

inst_FFD_7: reg_load_reset port map(
        clk => clock,
        din  => reg_in(6),
        dout   => reg_out(6),
        load => load,
        clear => clear
);

inst_FFD_8: reg_load_reset port map(
        clk => clock,
        din  => reg_in(7),
        dout   => reg_out(7),
        load => load,
        clear => clear
);

inst_FFD_9: reg_load_reset port map(
        clk => clock,
        din  => reg_in(8),
        dout   => reg_out(8),
        load => load,
        clear => clear
);

inst_FFD_10: reg_load_reset port map(
        clk => clock,
        din  => reg_in(9),
        dout   => reg_out(9),
        load => load,
        clear => clear
);

inst_FFD_11: reg_load_reset port map(
        clk => clock,
        din  => reg_in(10),
        dout   => reg_out(10),
        load => load,
        clear => clear
);

inst_FFD_12: reg_load_reset port map(
        clk => clock,
        din  => reg_in(11),
        dout   => reg_out(11),
        load => load,
        clear => clear
);

inst_FFD_13: reg_load_reset port map(
        clk => clock,
        din  => reg_in(12),
        dout   => reg_out(12),
        load => load,
        clear => clear
);

inst_FFD_14: reg_load_reset port map(
        clk => clock,
        din  => reg_in(13),
        dout   => reg_out(13),
        load => load,
        clear => clear
);

inst_FFD_15: reg_load_reset port map(
        clk => clock,
        din  => reg_in(14),
        dout   => reg_out(14),
        load => load,
        clear => clear
);

inst_FFD_16: reg_load_reset port map(
        clk => clock,
        din  => reg_in(15),
        dout   => reg_out(15),
        load => load,
        clear => clear
);



end Behavioral;
