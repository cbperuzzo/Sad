library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;
entity BOv1 is
generic(
b:positive:=8; --n bits por amostra
n:positive:=64; --n de amostra 
p:positive:=1 --amostras em paralelo por bloco

);
port(
	clk :in std_logic;
	ma,mb :in std_logic_vector(b-1 downto 0);
	menor :out std_logic;
	ssad :out std_logic_vector(13 downto 0);
	ende :out std_logic_vector(integer(ceil(log2(real(n)/real(p))))-1 downto 0);
	zi,ci,cpa,cpb,zsoma,csoma,csadr :in std_logic
	--zi e zsoma sao "resets" dos registradores, e serao invertidos 
	
);
    
end BOv1;


architecture sad_arch of BOv1 is 
	constant biti: integer :=integer(ceil(log2(real(n)/real(p))));
	signal azi : std_logic;
	signal si: std_logic_vector(biti downto 0);
	signal nextSi: std_logic_vector(biti downto 0);
	--------------------------------------------
	signal spa,spb,subab,preabsab:std_logic_vector(7 downto 0);
	signal nextsum,sum,absab:std_logic_vector(13 downto 0);
	signal azsoma: std_logic;
	
begin

	azi<=not zi;
	reg_i: entity work.reg_g
		generic map(7)
		port map(nextSi,si,ci,azi,clk);
	ende<=si(5 downto 0);
	menor<=si(6);
	nextSi<=std_logic_vector(unsigned('0'&si(5 downto 0)) + 1);
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
		port map(sum,ssad,csadr,'1',clk);
	
end sad_arch;