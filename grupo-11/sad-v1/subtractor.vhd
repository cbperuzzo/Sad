LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY subtractor IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		-- The inputs are absolute numbers typed as std_logic_vector.
		-- The output is a std_logic_vector that represents a two's complement number
		-- Note: the output is a bit larger

		value1, value2 : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		result : OUT STD_LOGIC_VECTOR(width DOWNTO 0)
	);
END subtractor;

ARCHITECTURE Behavioral OF subtractor IS

BEGIN
	-- 0's are concatenated to both values so then they can represent positive numbers in two's complement
	result <= STD_LOGIC_VECTOR(signed('0' & value1) - signed('0' & value2));

END Behavioral;