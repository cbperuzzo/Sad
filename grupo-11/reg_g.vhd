LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;

ENTITY reg_g IS
	generic(g : positive:=4	);
	port(
		d : in std_logic_vector(g-1 downto 0);
		s : out std_logic_vector(g-1 downto 0);

		e,r,clk : in std_logic	

	);
END reg_g;
	
ARCHITECTURE arch OF reg_g IS
signal mem: std_logic_vector(g-1 downto 0);
	
BEGIN

	reg:process(clk) is begin
		if clk'event and clk = '1' then
			if r = '0' then
				mem <= (others=>'0');
			elsif e = '1' then 
				mem<=d;
			end if;
		end if;
	end process;

	s<=mem;

END arch;