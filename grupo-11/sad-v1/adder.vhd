LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		value1, value2 : IN std_logic_vector(width - 1 DOWNTO 0);
		result : OUT std_logic_vector(width - 1 DOWNTO 0);
		carry_out : OUT std_logic
	);
END adder;

ARCHITECTURE Behavioral OF adder IS
	SIGNAL auxiliar : std_logic_vector(width DOWNTO 0);
BEGIN
	auxiliar <= std_logic_vector(signed('0' & value1) + signed('0' & value2));
	carry_out <= auxiliar(width);
	result <= auxiliar(width - 1 DOWNTO 0);

END Behavioral;