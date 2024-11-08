LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pdif IS
	GENERIC (N : POSITIVE);
	PORT (
		a,b: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N DOWNTO 0)
	);
END pdif;

ARCHITECTURE arch OF pdif IS
	signal ns : std_logic_vector(N downto 0);
	
BEGIN
	s<= std_logic_vector(unsigned('0'&a) - unsigned('0'&b));

END arch;
