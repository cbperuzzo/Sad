LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_operativo IS
	GENERIC (
		-- To simplify the code, some generic names are abbreviated
		FSW: POSITIVE; -- full_sample_width = B*P
		B: POSITIVE; -- bits_per_sample
		P: POSITIVE; -- number_parallel_differences
		output_width : POSITIVE;
		iterator_width : POSITIVE
	);
	PORT (
		clk, zi, ci, cpAcpB, zsum, csum, csad_reg : IN STD_LOGIC;
		sample_ori, sample_can : IN STD_LOGIC_VECTOR(FSW- 1 DOWNTO 0);
		less : OUT STD_LOGIC;
		sad_value : OUT STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
		address : OUT STD_LOGIC_VECTOR(iterator_width - 2 DOWNTO 0)
	);
END sad_operativo;

ARCHITECTURE Behavioral OF sad_operativo IS
	SIGNAL pApB_regOut: std_logic_vector(2* FSW- 1 DOWNTO 0);
	SIGNAL subtractorsOut: std_logic_vector((B + 1) * P - 1 DOWNTO 0);
	SIGNAL absolutesOut: std_logic_vector(FSW- 1 DOWNTO 0);
	SIGNAL concatenatorAdder, adderMux, muxSum_reg, sum_regAdder, sum_regSad_reg : STD_LOGIC_VECTOR(output_width - 1 DOWNTO 0);
BEGIN
	---------------------------------------------------------------------
	iterator : ENTITY work.iterator
		GENERIC MAP(iterator_width)
		PORT MAP(clk, zi, ci, less, address);
	---------------------------------------------------------------------
	pApB_reg: entity work.reg
	generic map (2 * FSW)
	port map (clk, cpAcpB, '0', sample_ori & sample_can, pApB_regOut);

	absolute_differences: for i in 0 to (P - 1) generate

		subtractor: entity work.subtractor
		generic map(B)
		port map(
			pApB_regOut((2 * FSW- 1 - B*i) DOWNTO (2 * FSW- B*(i+1))),
			pApB_regOut((FSW- 1 - B*i) DOWNTO (FSW- B*(i+1))),
			subtractorsOut((B + 1) * P - 1 - (B + 1)*i DOWNTO (B + 1) * P - (B + 1)*(i + 1))
		);

		absolute: entity work.absolute
		generic map(B + 1)
		port map(
			subtractorsOut((B + 1) * P - 1 - (B + 1)*i DOWNTO (B + 1) * P - (B + 1)*(i + 1)),
			absolutesOut((FSW- 1 - B*i) DOWNTO (FSW- B*(i+1)))
		);

	end generate absolute_differences;
	

	---------------------------------------------------------------------
	-- Implement generic adder_tree
	---------------------------------------------------------------------
	-- Implement concatenator
	---------------------------------------------------------------------
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

	sad_reg : ENTITY work.reg
		GENERIC MAP(output_width)
		PORT MAP(clk, csad_reg, '0', sum_regSad_reg, sad_value);
	---------------------------------------------------------------------


END Behavioral;