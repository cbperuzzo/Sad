LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sum_absolute_differences IS
	GENERIC (
		sample_width : POSITIVE;
		output_width : POSITIVE
	);
	PORT (
		sample_ori, sample_can : IN STD_LOGIC_VECTOR(sample_width - 1 DOWNTO 0);
		clk, cpA, cpB, zsum, csum, csad_reg : IN STD_LOGIC;
		sad_value : OUT STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0)
	);
END sum_absolute_differences;

ARCHITECTURE Behavioral OF sum_absolute_differences IS
	-- Signal names follow this pattern: originDestination where origin is the component of origin and Destination is the component of destination of the signal
	SIGNAL pA_regSubtractor, pB_regSubtractor, absoluteConcatenator : STD_LOGIC_VECTOR(sample_width - 1 DOWNTO 0);
	SIGNAL subtractorAbsolute : STD_LOGIC_VECTOR(sample_width DOWNTO 0);
	SIGNAL concatenatorAdder, adderMux, muxSum_reg, sum_regAdder, sum_regSad_reg : STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
BEGIN

	pA_reg : ENTITY work.reg
		GENERIC MAP(sample_width)
		PORT MAP(clk, cpA, '0', sample_ori, pA_regSubtractor);

	pB_reg : ENTITY work.reg
		GENERIC MAP(sample_width)
		PORT MAP(clk, cpB, '0', sample_can, pB_regSubtractor);

	subtractor : ENTITY work.subtractor
		GENERIC MAP(sample_width)
		PORT MAP(pA_regSubtractor, pB_regSubtractor, subtractorAbsolute);

	absolute : ENTITY work.absolute
		GENERIC MAP(sample_width + 1)
		PORT MAP(subtractorAbsolute, absoluteConcatenator);

	-- Concatenator logic --
	concatenatorAdder <= ((output_width - sample_width) - 1 DOWNTO 0 => '0') & absoluteConcatenator;
	------------------------

	adder : ENTITY work.simple_adder
		GENERIC MAP(output_width)
		PORT MAP(sum_regAdder, concatenatorAdder, adderMux);

	mux : ENTITY work.mux2_1
		GENERIC MAP(output_width)
		PORT MAP(adderMux, (OTHERS => '0'), zsum, muxSum_reg);

	sum_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csum, '0', muxSum_reg, sum_regSad_reg);

	-- Sum result returns to adder (output signal of sum_reg is copied) --
	sum_regAdder <= sum_regSad_reg;
	----------------------------------------------------------------------

	sad_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csad_reg, '0', sum_regSad_reg, sad_value);

END Behavioral;
