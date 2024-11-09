LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		clk : IN std_logic;
		enable : IN std_logic;
		reset : IN std_logic;
		next_value : IN std_logic_vector(width - 1 DOWNTO 0);
		current_value : OUT std_logic_vector(width - 1 DOWNTO 0)
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