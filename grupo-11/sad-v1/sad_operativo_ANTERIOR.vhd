library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
entity sad_operativo is
port(
	clk :in std_logic;
	ma,mb :in std_logic_vector(7 downto 0);
	menor :out std_logic;
	ssad :out std_logic_vector(13 downto 0);
	ende :out std_logic_vector(5 downto 0);
	zi,ci,cpa,cpb,zsoma,csoma,csad_reg :in std_logic
	--zi e zsoma sao "resets" dos registradores, e serao invertidos 
	
);
    
end sad_operativo;


architecture sad_arch of sad_operativo is 
	signal azi : std_logic;
	signal si: std_logic_vector(6 downto 0);
	signal nextSi: std_logic_vector(6 downto 0);
	--------------------------------------------
	signal spa,spb,subab,preabsab:std_logic_vector(7 downto 0);
	signal nextsum,sum,absab:std_logic_vector(13 downto 0);
	signal azsoma: std_logic;
	
begin

	azi <= not zi; -- azi ativa o reset síncrono do registrador caso zi seja '1', isso substitui a necessidade de um mux
	reg_i: entity work.reg_g
		generic map(7)
		port map(nextSi,si,ci,azi,clk);
	ende <= si(5 downto 0); -- Endereço da memória a ser acessado. É um valor de 0 (inclusive) a 63 (inclusive), necessitando somente 6 bits
	menor <= not si(6); -- Queremos '1' para 'é menor', '0' para 'é maior ou igual'
	nextSi <= std_logic_vector(unsigned('0'&si(5 downto 0)) + 1); -- Valor a ser carregado no registrador
	----------------------------------------------------------
	

	pa: entity work.reg_g
		generic map(8)
		port map(ma,spa,cpa,'1',clk);

	pb: entity work.reg_g
		generic map(8)
		port map(mb,spb,cpb,'1',clk);

	dif: entity work.pdif
		generic map(8)
		port map(spa,spb,subab);

	abss: entity work.absolutev2
		generic map(8)
		port map(subab,preabsab);
	absab<="000000"&preabsab;

	azsoma<= not zsoma;
	
	reg_sum: entity work.reg_g
		generic map(14)
		port map(nextsum,sum,csoma,azsoma,clk);
	nextsum<=std_logic_vector(signed(sum)+signed(absab));
	
	reg_sad:entity work.reg_g
		generic map(14)
		port map(sum,ssad,csad_reg,'1',clk);
	
end sad_arch;