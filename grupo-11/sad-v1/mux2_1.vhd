LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2_1 IS
	GENERIC (
		width : POSITIVE
	);

	PORT (
		D0 : IN std_logic_vector(width - 1 DOWNTO 0);
		D1 : IN std_logic_vector(width - 1 DOWNTO 0);
		sel : IN std_logic;
		Y : OUT std_logic_vector(width - 1 DOWNTO 0)
	);
END mux2_1;

ARCHITECTURE Behavioral OF mux2_1 IS
BEGIN
	Y <= D0 WHEN sel = '0' ELSE
	     D1;
END Behavioral;