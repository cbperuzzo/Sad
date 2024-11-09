LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY simple_adder IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		value1, value2 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		result : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
	);
END simple_adder;

ARCHITECTURE Behavioral OF simple_adder IS
BEGIN
	result <= STD_LOGIC_VECTOR(signed(value1) + signed(value2));

END Behavioral;