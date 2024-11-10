LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_operativo IS
	GENERIC (
		sample_width : POSITIVE;
		output_width : POSITIVE;
		iterator_width : POSITIVE
	);
	PORT (
		clk, zi, ci, cpA, cpB, zsum, csum, csad_reg : IN STD_LOGIC;
		sample_ori, sample_can : IN STD_LOGIC_VECTOR(sample_width - 1 DOWNTO 0);
		less : OUT STD_LOGIC;
		sad_value : OUT STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
		address : OUT STD_LOGIC_VECTOR(iterator_width - 2 DOWNTO 0)
	);
END sad_operativo;

ARCHITECTURE Behavioral OF sad_operativo IS
BEGIN

	iterator : ENTITY work.iterator
		GENERIC MAP(iterator_width)
		PORT MAP(clk, zi, ci, less, address);

	adder_tree : ENTITY work.adder_tree
		GENERIC MAP(sample_width, output_width)
		PORT MAP(sample_ori, sample_can, clk, cpA, cpB, zsum, csum, csad_reg, sad_value);

END Behavioral;