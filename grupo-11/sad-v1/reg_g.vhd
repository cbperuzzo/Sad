LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY reg_g IS
	GENERIC (g : POSITIVE);
	PORT (
		d : IN std_logic_vector(g - 1 DOWNTO 0);
		s : OUT std_logic_vector(g - 1 DOWNTO 0);

		e, r, clk : IN std_logic 
	);
END reg_g;
 
ARCHITECTURE arch OF reg_g IS
	SIGNAL mem : std_logic_vector(g - 1 DOWNTO 0);
 
BEGIN
	reg : PROCESS (clk, e, r) IS BEGIN
		IF r = '0' THEN
			mem <= (OTHERS => '0');
		ELSIF clk'EVENT AND clk = '1' AND e = '1' THEN
			mem <= d;
		END IF;
	END PROCESS;

	s <= mem;

END arch;