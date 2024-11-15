LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder2 IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		value1, value2 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		result : OUT STD_LOGIC_VECTOR(width DOWNTO 0)
	);
END adder2;

ARCHITECTURE Behavioral OF adder2 IS
BEGIN
	result <= STD_LOGIC_VECTOR(signed('0' & value1) + signed('0' & value2));

END Behavioral;