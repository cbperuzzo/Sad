LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY absolute IS
	GENERIC (N : POSITIVE);
	PORT (
		a : IN std_logic_vector (N DOWNTO 0);
		s : OUT std_logic_vector (N - 1 DOWNTO 0)
	);
END absolute;

ARCHITECTURE arch OF absolute IS
	SIGNAL complement : signed(N DOWNTO 0);
BEGIN
	complement <= - signed(a);
	s <= std_logic_vector(complement(N - 1 DOWNTO 0)) WHEN a(N) = '1' ELSE
	     a(N - 1 DOWNTO 0);

END arch;