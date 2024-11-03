library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;

entity BOv3 is
generic(
b:positive:=8; --n bits por amostra
n:positive:=64; --n de amostra 
p:positive:=4 --amostras em paralelo por bloco

);
port(
	clk :in std_logic;
	--ma0,ma1,ma2,ma3,mb0,mb1,mb2,mb3 :in std_logic_vector(7 downto 0);
	ma : in std_logic_vector((p*n)-1 downto 0);
	mb : in std_logic_vector((p*n)-1 downto 0);
	menor :out std_logic;
	ssad :out std_logic_vector(13 downto 0);
	ende :out std_logic_vector( integer(ceil(log2(real(n)/real(p))))-1 downto 0);
	zi,ci,papb,zsoma,csoma,csadr :in std_logic
	--zi e zsoma sao "resets" dos registradores, e serao invertidos 
	
);
    
end BOv3;


architecture sad_arch of BOv3 is 
	constant biti: Integer := integer(ceil(log2(real(n)/real(p))));
	signal azi : std_logic;
	signal si: std_logic_vector(biti downto 0);
	signal nextSi: std_logic_vector(biti downto 0);
	--------------------------------------------
	signal spa0,spa1,spa2,spa3,spb0,spb1,spb2,spb3:std_logic_vector(7 downto 0);
	signal subab0,subab1,subab2,subab3,
	absab0,absab1,absab2,absab3
	:std_logic_vector(b-1 downto 0);
	signal nextsum,sum:std_logic_vector(13 downto 0);
	signal absf:std_logic_vector(9 downto 0);
	signal azsoma: std_logic;
	
begin

	azi<=not zi;
	reg_i: entity work.reg_g
		generic map(5)
		port map(nextSi,si,ci,azi,clk);
	ende<=si(3 downto 0);
	menor<=si(4);
	nextSi<=std_logic_vector(unsigned('0'&si(3 downto 0)) + 1);
	----------------------------------------------------------
	

	pa0: entity work.reg_g
		generic map(8)
		port map(ma(31 downto 24),spa0,papb,'1',clk);
	pa1: entity work.reg_g
		generic map(8)
		port map(ma(23 downto 16),spa1,papb,'1',clk);

	pa2: entity work.reg_g
		generic map(8)
		port map(ma(15 downto 8),spa2,papb,'1',clk);
	pa3: entity work.reg_g
		generic map(8)
		port map(ma(7 downto 0),spa3,papb,'1',clk);


	pb0: entity work.reg_g
		generic map(8)
		port map(mb(31 downto 24),spb0,papb,'1',clk);
	pb1: entity work.reg_g
		generic map(8)
		port map(mb(23 downto 16),spb1,papb,'1',clk);
	pb2: entity work.reg_g
		generic map(8)
		port map(ma(15 downto 8),spb2,papb,'1',clk);
	pb3: entity work.reg_g
		generic map(8)
		port map(ma(7 downto 0),spb3,papb,'1',clk);

	dif0: entity work.pdif
		generic map(8)
		port map(spa0,spb0,subab0);
	dif1: entity work.pdif
		generic map(8)
		port map(spa1,spb1,subab1);
	dif2: entity work.pdif
		generic map(8)
		port map(spa2,spb2,subab2);
	dif3: entity work.pdif
		generic map(8)
		port map(spa3,spb3,subab3);

	abss0: entity work.absolute
		generic map(8)
		port map(subab0,absab0);
	

	abss1: entity work.absolute
		generic map(8)
		port map(subab1,absab1);
	

	abss2: entity work.absolute
		generic map(8)
		port map(subab2,absab2);
	

	abss3: entity work.absolute
		generic map(8)
		port map(subab3,absab3);
	
	at: entity work.adderTree4
		generic map(8)
		port map(absab0,absab1,absab2,absab3,absf);
	
	
	

	azsoma<= not zsoma;
	
	reg_sum: entity work.reg_g
		generic map(14)
		port map(nextsum,sum,csoma,azsoma,clk);
	nextsum<=std_logic_vector(signed(sum)+signed("0000"&absf));
	
	reg_sad:entity work.reg_g
		generic map(14)
		port map(sum,ssad,csadr,'1',clk);
	
end sad_arch;
