LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adderTree IS
	GENERIC (N : POSITIVE := 8);
	PORT (
		a,b,c,d: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N+1 DOWNTO 0)
	);
END adderTree;

ARCHITECTURE arch OF adderTree IS
signal sn,an,bn,cn,dn : UNSIGNED(N+1 downto 0);
BEGIN
	an<=UNSIGNED("00"&a);
	bn<=UNSIGNED("00"&b);
	cn<=UNSIGNED("00"&c);
	dn<=UNSIGNED("00"&d);

	sn<=an+bn+cn+dn;
	
	s<=std_logic_vector(sn);

END arch;