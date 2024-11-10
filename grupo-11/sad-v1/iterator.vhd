LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY iterator IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		clk, zi, ci : IN STD_LOGIC;
		less : OUT STD_LOGIC;
		address : OUT STD_LOGIC_VECTOR(width - 2 DOWNTO 0)
	);
END iterator;

ARCHITECTURE Behavioral OF iterator IS
	-- The signals are named after this pattern: origin_destination or name_origin_destination (for those origin components who have more than one output)
	SIGNAL mux_reg, reg_adder, concatenator_mux : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
	SIGNAL carry_adder_concatenator : STD_LOGIC;
	SIGNAL result_adder_concatenator : STD_LOGIC_VECTOR(width - 2 DOWNTO 0);

BEGIN
	mux : ENTITY work.mux2_1
		GENERIC MAP(width)
		PORT MAP(concatenator_mux, (OTHERS => '0'), zi, mux_reg);

	reg : ENTITY work.reg
		GENERIC MAP(width)
		PORT MAP(clk, ci, '0', mux_reg, reg_adder);

	-- Splitter logic and status sign --
	less <= NOT reg_adder(width - 1);
	address <= reg_adder(width - 2 DOWNTO 0);
	------------------------------------

	adder : ENTITY work.adder
		GENERIC MAP(width - 1)
		PORT MAP(reg_adder(width - 2 DOWNTO 0), ((width - 2 DOWNTO 1 => '0') & '1'), result_adder_concatenator, carry_adder_concatenator);

	-- Concatenator logic --
	concatenator_mux <= carry_adder_concatenator & result_adder_concatenator;
	------------------------
	
END Behavioral;