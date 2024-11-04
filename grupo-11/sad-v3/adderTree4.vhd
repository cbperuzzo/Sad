LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adderTree4 IS
	GENERIC (N : POSITIVE:=8);
	PORT (
		a,b,c,d: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N+1 DOWNTO 0)
	);
END adderTree4;

ARCHITECTURE arch OF adderTree4 IS
	signal p1,p2: std_logic_vector(n+1 downto 0);
BEGIN
	p1<= std_logic_vector(unsigned("00"&a)+unsigned("00"&b));
	p2<= std_logic_vector(unsigned("00"&c)+unsigned("00"&d));
	s<= std_logic_vector(unsigned(p1)+unsigned(p2));

END arch;