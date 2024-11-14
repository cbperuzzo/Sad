LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		clk, enable, reset : IN STD_LOGIC;
		next_value : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		current_value : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
	);
END reg;

ARCHITECTURE Behavioral OF reg IS

BEGIN
	reg_logic : PROCESS (clk)
	BEGIN
		IF reset = '1' THEN
			current_value <= (OTHERS => '0');
		ELSIF rising_edge(clk) AND enable = '1' THEN
			current_value <= next_value;
		END IF;
	END PROCESS;

END Behavioral;