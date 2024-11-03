library ieee;
use ieee.std_logic_1164.all;

entity sad is
    port(
        clk, iniciar, reset: in std_logic;
        SAD: out std_logic_vector(13 downto 0);
        read_mem, pronto: out std_logic;
        ende: out std_logic_vector(5 downto 0);
        ma, mb: in std_logic_vector(7 downto 0)
    );
end sad;

architecture arch_sad of sad is
    
    component sad_controle is
    port(
        iniciar, reset, clk: in std_logic;
        menor: in std_logic;
        pronto, read_mem: out std_logic;
        zi, ci, cpa, cpb, zsoma, csoma, csad_reg: out std_logic
        );
    end component;

    component sad_operativo is
    port(
        clk :in std_logic;
        ma,mb :in std_logic_vector(7 downto 0);
        menor :out std_logic;
        ssad :out std_logic_vector(13 downto 0);
        ende :out std_logic_vector(5 downto 0);
        zi,ci,cpa,cpb,zsoma,csoma,csad_reg :in std_logic
	--zi e zsoma sao "resets" dos registradores, e serao invertidos 	
    );
    
    end component;

    signal zi, ci, cpa, cpb, zsoma, csoma, csad_reg, menor: std_logic;

begin

    U_Controle: sad_controle port map(iniciar, reset, clk, menor, pronto, read_mem, zi, ci, cpa, cpb, zsoma, csoma, csad_reg);
    U_Operativo: sad_operativo port map(clk, ma, mb, menor, SAD, ende, zi, ci, cpa, cpb, zsoma, csoma, csad_reg);

end arch_sad;