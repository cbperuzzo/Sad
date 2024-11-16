LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

ENTITY adder_tree IS
	GENERIC (
		width : POSITIVE := 16; -- width := B*P
		B : POSITIVE := 8;
		P : POSITIVE := 2
	);

	PORT (
		input_vector : IN STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
		result : OUT STD_LOGIC_VECTOR((B + INTEGER(log2(real(P)))) - 1 DOWNTO 0)
	);
END adder_tree;

ARCHITECTURE Behavioral OF adder_tree IS
	SIGNAL result_left_tree, result_right_tree : STD_LOGIC_VECTOR(B + INTEGER(log2(real(P)/real(2))) - 1 DOWNTO 0);

BEGIN
	general_case : IF (P > 2) GENERATE
		left_tree : ENTITY work.adder_tree
			GENERIC MAP(width/2, B, P/2)
			PORT MAP(input_vector(width - 1 DOWNTO width/2), result_left_tree);

		right_tree : ENTITY work.adder_tree
			GENERIC MAP(width/2, B, P/2)
			PORT MAP(input_vector(width/2 - 1 DOWNTO 0), result_right_tree);
		result <= STD_LOGIC_VECTOR(unsigned('0' & result_left_tree) + unsigned('0' & result_right_tree));

	END GENERATE;

	base_case : IF P = 2 GENERATE
		result <= STD_LOGIC_VECTOR(unsigned('0' & input_vector(width - 1 DOWNTO width/2)) + unsigned('0' & input_vector(width/2 - 1 DOWNTO 0)));
	END GENERATE;

	pass_case : IF P = 1 GENERATE
		result <= input_vector;
	END GENERATE;

END Behavioral;