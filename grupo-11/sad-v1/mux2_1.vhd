LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY mux2_1 IS
	GENERIC (
		width : POSITIVE
	);

	PORT (
		D0 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		D1 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		sel : IN STD_LOGIC;
		Y : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
	);
END mux2_1;

ARCHITECTURE Behavioral OF mux2_1 IS
BEGIN
	Y <= D0 WHEN sel = '0' ELSE
		D1;
END Behavioral;