LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY counter IS
	GENERIC (
		width : POSITIVE
	);
	PORT (
		clk, zi, ci : IN STD_LOGIC;
		less : OUT STD_LOGIC;
		address : OUT STD_LOGIC_VECTOR(width - 2 DOWNTO 0)
	);
END counter;

ARCHITECTURE Behavioral OF counter IS
	SIGNAL muxOut, regOut, muxIn : STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
	SIGNAL carryOut : STD_LOGIC;
	SIGNAL adderOut : STD_LOGIC_VECTOR(width - 2 DOWNTO 0);

BEGIN
	mux : ENTITY work.mux2_1
		GENERIC MAP(width)
		PORT MAP(muxIn, (OTHERS => '0'), zi, muxOut);

	reg : ENTITY work.reg
		GENERIC MAP(width)
		PORT MAP(clk, ci, '0', muxOut, regOut);

	-- Splitter logic and status signals --
	less <= NOT regOut(width - 1);
	address <= regOut(width - 2 DOWNTO 0);
	---------------------------------------

	adder : ENTITY work.adder
		GENERIC MAP(width - 1)
		PORT MAP(regOut(width - 2 DOWNTO 0), ((width - 2 DOWNTO 1 => '0') & '1'), adderOut, carryOut);

	-- Concatenator logic --
	muxIn <= carryOut & adderOut;
	------------------------
	
END Behavioral;