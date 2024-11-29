LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		value1, value2 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		result : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		carry_out : OUT STD_LOGIC
	);
END adder;

ARCHITECTURE Behavioral OF adder IS
	SIGNAL auxiliar : STD_LOGIC_VECTOR(width DOWNTO 0);
BEGIN
	auxiliar <= STD_LOGIC_VECTOR(signed('0' & value1) + signed('0' & value2));
	carry_out <= auxiliar(width);
	result <= auxiliar(width - 1 DOWNTO 0);

END Behavioral;