LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_operativo IS
	GENERIC (
		-- To simplify the code, some generic names are abbreviated
		FSW : POSITIVE; -- full_sample_width := B*P
		B : POSITIVE; -- bits_per_sample
		P : POSITIVE; -- number_parallel_differences
		output_width : POSITIVE;
		iterator_width : POSITIVE
	);
	PORT (
		clk, zi, ci, cpAcpB, zsum, csum, csad_reg : IN STD_LOGIC;
		sample_ori, sample_can : IN STD_LOGIC_VECTOR(FSW - 1 DOWNTO 0);
		less : OUT STD_LOGIC;
		sad_value : OUT STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
		address : OUT STD_LOGIC_VECTOR(iterator_width - 2 DOWNTO 0)
	);
END sad_operativo;

ARCHITECTURE Behavioral OF sad_operativo IS
	SIGNAL pApB_regOut : STD_LOGIC_VECTOR(2 * FSW - 1 DOWNTO 0);
	SIGNAL subtractorsOut : STD_LOGIC_VECTOR((B + 1) * P - 1 DOWNTO 0);
	SIGNAL absolutesOut : STD_LOGIC_VECTOR(FSW - 1 DOWNTO 0);
	---------------------------------------------------------------------
	-- Signals for P := 4
	SIGNAL carry_out_1 : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL adders_result_1 : STD_LOGIC_VECTOR(B * 2 - 1 DOWNTO 0);
	SIGNAL carry_out_2 : STD_LOGIC;
	SIGNAL adders_result_2 : STD_LOGIC_VECTOR((B + 1) - 1 DOWNTO 0);
	---------------------------------------------------------------------
	SIGNAL concatenatorAdder, adderMux, muxSum_reg, sum_regAdder, sum_regSad_reg : STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
BEGIN
	---------------------------------------------------------------------
	iterator : ENTITY work.iterator
		GENERIC MAP(iterator_width)
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
	-- Adder Tree implemented for P := 4
	adder_tree_4 : FOR i IN 0 TO 1 GENERATE

		adder1 : ENTITY work.adder
			GENERIC MAP(B)
			PORT MAP(
				absolutesOut((FSW - 1 - B * 2 * i) DOWNTO (FSW - B * (2 * i + 1))),
				absolutesOut((FSW - 1 - B * (2 * i + 1)) DOWNTO (FSW - B * (2 * i + 2))),
				adders_result_1(B * 2 - 1 - B * i DOWNTO B - B * i),
				carry_out_1(1 - i)
			);

	END GENERATE adder_tree_4;

	adder2 : ENTITY work.adder
		GENERIC MAP(B + 1)
		PORT MAP(
			carry_out_1(1) & adders_result_1(B * 2 - 1 DOWNTO B),
			carry_out_1(0) & adders_result_1(B - 1 DOWNTO 0),
			adders_result_2,
			carry_out_2
		);
	---------------------------------------------------------------------
	-- Implement generic adder_tree => :(
	---------------------------------------------------------------------
	concatenatorAdder <= (output_width - (B + 2) - 1 DOWNTO 0 => '0') & carry_out_2 & adders_result_2;
	---------------------------------------------------------------------
	adder3 : ENTITY work.simple_adder
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

	sad_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csad_reg, '0', sum_regSad_reg, sad_value);
	---------------------------------------------------------------------
END Behavioral;