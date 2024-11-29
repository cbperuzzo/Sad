LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;

ENTITY sad_operativo IS
	GENERIC (
		B : POSITIVE; -- bits_per_sample
		P : POSITIVE; -- number_parallel_differences
		output_width : POSITIVE;
		counter_width : POSITIVE
	);
	PORT (
		clk, zi, ci, cpAcpB, zsum, csum, csad_reg : IN STD_LOGIC;
		sample_ori, sample_can : IN STD_LOGIC_VECTOR(B*P - 1 DOWNTO 0);
		less : OUT STD_LOGIC;
		sad_value : OUT STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
		address : OUT STD_LOGIC_VECTOR(counter_width - 2 DOWNTO 0)
	);
END sad_operativo;

ARCHITECTURE Behavioral OF sad_operativo IS
	CONSTANT FSW : POSITIVE := B * P; -- full_sample_width
	SIGNAL pApB_regOut : STD_LOGIC_VECTOR(2 * FSW - 1 DOWNTO 0);
	SIGNAL subtractorsOut : STD_LOGIC_VECTOR((B + 1) * P - 1 DOWNTO 0);
	SIGNAL absolutesOut : STD_LOGIC_VECTOR(FSW - 1 DOWNTO 0);
	SIGNAL adder_treeOut: STD_LOGIC_VECTOR((B + INTEGER(log2(real(P)))) - 1 DOWNTO 0);
	---------------------------------------------------------------------
	SIGNAL adderIn1, adderIn2, adderOut, muxOut, sum_regOut : STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
BEGIN
	---------------------------------------------------------------------
	counter : ENTITY work.counter
		GENERIC MAP(counter_width)
		PORT MAP(clk, zi, ci, less, address);
	---------------------------------------------------------------------
	pApB_reg : ENTITY work.reg
		GENERIC MAP(2 * FSW)
		PORT MAP(clk, cpAcpB, '0', sample_ori & sample_can, pApB_regOut);

	absolute_differences : FOR i IN 0 TO (P - 1) GENERATE

		subtractor : ENTITY work.subtractor
			GENERIC MAP(B)
			PORT MAP(
				pApB_regOut((2 * FSW - 1 - B * i) DOWNTO (2 * FSW - B * (i + 1))),
				pApB_regOut((FSW - 1 - B * i) DOWNTO (FSW - B * (i + 1))),
				subtractorsOut((B + 1) * P - 1 - (B + 1) * i DOWNTO (B + 1) * P - (B + 1) * (i + 1))
			);

		absolute : ENTITY work.absolute
			GENERIC MAP(B + 1)
			PORT MAP(
				subtractorsOut((B + 1) * P - 1 - (B + 1) * i DOWNTO (B + 1) * P - (B + 1) * (i + 1)),
				absolutesOut((FSW - 1 - B * i) DOWNTO (FSW - B * (i + 1)))
			);

	END GENERATE absolute_differences;
	---------------------------------------------------------------------
	adder_tree: entity work.adder_tree
	generic map(B, P)
	port map(absolutesOut, adder_treeOut);
	---------------------------------------------------------------------
	-- Concatenator logic
	adderIn2 <= (output_width - adder_treeOut'length - 1 DOWNTO 0 => '0') & adder_treeOut;
	---------------------------------------------------------------------
	adder : ENTITY work.simple_adder
		GENERIC MAP(output_width)
		PORT MAP(adderIn1, adderIn2, adderOut);

	mux : ENTITY work.mux2_1
		GENERIC MAP(output_width)
		PORT MAP(adderOut, (OTHERS => '0'), zsum, muxOut);

	sum_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csum, '0', muxOut, sum_regOut);

	-- Sum result returns to adder (output signal of sum_reg is copied) --
	adderIn1 <= sum_regOut;
	---------------------------------------------------------------------
	sad_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csad_reg, '0', sum_regOut, sad_value);
	---------------------------------------------------------------------
END Behavioral;