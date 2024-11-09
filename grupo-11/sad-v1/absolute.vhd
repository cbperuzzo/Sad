LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY absolute IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		-- The input is a two's complement number typed as std_logic_vector
		-- The output is an absolute binary number typed as std_logic_vector
		-- Note: the output is a bit smaller than the input
		value : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		absolute_value : OUT STD_LOGIC_VECTOR(width - 2 DOWNTO 0)
	);
END absolute;

ARCHITECTURE Behavioral OF absolute IS
	SIGNAL complement_value : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
BEGIN
	complement_value <= STD_LOGIC_VECTOR(-signed(value));
	absolute_value <= complement_value(width - 2 DOWNTO 0) WHEN value(width - 1) = '1' ELSE
		value(width - 2 DOWNTO 0);

END Behavioral;