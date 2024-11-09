LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE numeric_std.ALL;

ENTITY simple_adder IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		value1, value2 : IN std_logic_vector(width - 1 DOWNTO 0);
		result : OUT std_logic_vector(width - 1 DOWNTO 0)
	);
END simple_adder;

ARCHITECTURE Behavioral OF simple_adder IS
BEGIN
	result <= std_logic_vector(signed(value1) + signed(value2));

END Behavioral;