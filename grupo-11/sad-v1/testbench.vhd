LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.math_real.ALL;
USE ieee.numeric_std.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE Behavioral OF testbench IS
	CONSTANT t : TIME := 30 ns;
	CONSTANT b : NATURAL := 8;
	SIGNAL fin : STD_LOGIC := '0';
	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL start : STD_LOGIC := '0';
	SIGNAL rst : STD_LOGIC := '1';
	SIGNAL r_mem : STD_LOGIC := '0';
	SIGNAL done : STD_LOGIC;
	SIGNAL MEM_A, MEM_B : STD_LOGIC_VECTOR(b - 1 DOWNTO 0);
	SIGNAL addr : STD_LOGIC_VECTOR(5 DOWNTO 0);
	SIGNAL result : STD_LOGIC_VECTOR(13 DOWNTO 0);

BEGIN
	-- Connect DUV
	DUV : ENTITY work.sad
		PORT MAP(
			clk,
			start,
			rst,
			MEM_A,
			MEM_B,
			r_mem,
			addr,
			result,
			done
		);

	clk <= NOT clk AFTER t/2 WHEN fin /= '1' ELSE '0';
	main : PROCESS IS
		VARIABLE lmat : INTEGER := 64; --linhas da matriz
	BEGIN
		rst <= '1';
		start <= '0';
		WAIT FOR t;
		rst <= '0';
		start <= '1';

		-- ns == t (30)

		WAIT FOR 30 ns;

		--no teste original da nossa sad v1 (usando o .do) todas as linhas da matriz a eram "111111111" e do vetor b "00000001"
		--o resultado final esperado era "11111110000000"

		FOR k IN 1 TO lmat LOOP
			MEM_A <= "11111111"; --"11111111"
			MEM_B <= "00000001"; --"00000001"
			WAIT FOR 30 * 3 ns;
		END LOOP;
		WAIT FOR 30 * 3 ns;
		ASSERT(result = "11111110000000")
		REPORT "saida errada, a saida esperada era 11111110000000";
		WAIT FOR 30 ns;
		fin <= '1';
		WAIT FOR t;
		ASSERT false REPORT "fim do teste." SEVERITY note;
		WAIT;
	END PROCESS;

END Behavioral;
