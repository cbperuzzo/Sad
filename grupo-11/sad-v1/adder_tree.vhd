LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder_tree IS
	GENERIC (
		sample_width : POSITIVE;
		output_width : POSITIVE
	);
	PORT (
		sample_ori, sample_can : IN STD_LOGIC_VECTOR(sample_width - 1 DOWNTO 0);
		clk, cpA, cpB, zsum, csum, csad_reg : IN STD_LOGIC;
		sad_value : OUT STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0)
	);
END adder_tree;

ARCHITECTURE Behavioral OF adder_tree IS
	-- Signal names follow this pattern: ORIGIN__DESTINATION where ORIGIN is the component of origin and DESTINATION is the component of destination
	SIGNAL pA_reg__subtractor, pB_reg__subtractor, absolute__concatenator : STD_LOGIC_VECTOR(sample_width - 1 DOWNTO 0);
	SIGNAL subtractor__absolute : STD_LOGIC_VECTOR(sample_width DOWNTO 0);
	SIGNAL concatenator__adder, adder__mux, mux__sum_reg, sum_reg__adder, sum_reg__sad_reg : STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
BEGIN

	pA_reg : ENTITY work.reg
		GENERIC MAP(sample_width)
		PORT MAP(clk, cpA, '0', sample_ori, pA_reg__subtractor);

	pB_reg : ENTITY work.reg
		GENERIC MAP(sample_width)
		PORT MAP(clk, cpB, '0', sample_can, pB_reg__subtractor);

	subtractor : ENTITY work.subtractor
		GENERIC MAP(sample_width)
		PORT MAP(pA_reg__subtractor, pB_reg__subtractor, subtractor__absolute);

	absolute : ENTITY work.absolute
		GENERIC MAP(sample_width + 1)
		PORT MAP(subtractor__absolute, absolute__concatenator);

	-- Concatenator logic --
	concatenator__adder <= ((output_width - sample_width) - 1 DOWNTO 0 => '0') & absolute__concatenator;
	------------------------

	adder : ENTITY work.simple_adder
		GENERIC MAP(output_width)
		PORT MAP(sum_reg__adder, concatenator__adder, adder__mux);

	mux : ENTITY work.mux2_1
		GENERIC MAP(output_width)
		PORT MAP(adder__mux, (OTHERS => '0'), zsum, mux__sum_reg);

	sum_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csum, '0', mux__sum_reg, sum_reg__sad_reg);

	-- Sum result returns to adder (output signal of sum_reg is copied) --
	sum_reg__adder <= sum_reg__sad_reg;
	----------------------------------------------------------------------

	sad_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csad_reg, '0', sum_reg__sad_reg, sad_value);

END Behavioral;