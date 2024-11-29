LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE ieee.math_real.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.std_logic_textio.ALL;
USE std.textio.ALL;

ENTITY testbench IS
END testbench;

ARCHITECTURE Behavioral OF testbench IS
	CONSTANT t : TIME := 30 ns;
	CONSTANT b : NATURAL := 32;
	SIGNAL fin : STD_LOGIC := '0';
	SIGNAL clk : STD_LOGIC := '0';
	SIGNAL start : STD_LOGIC := '0';
	SIGNAL rst : STD_LOGIC := '1';
	SIGNAL r_mem : STD_LOGIC := '0';
	SIGNAL done : STD_LOGIC;
	SIGNAL MEM_A, MEM_B : STD_LOGIC_VECTOR(b - 1 DOWNTO 0);
	SIGNAL addr : STD_LOGIC_VECTOR(3 DOWNTO 0);
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
		FILE arquivo_de_estimulos : text OPEN read_mode IS "../../estimulos.dat";
		VARIABLE linha_de_estimulos : line;
		VARIABLE espaco : CHARACTER;
		VARIABLE valorA : bit_vector(b - 1 DOWNTO 0);
		VARIABLE valorB : bit_vector(b - 1 DOWNTO 0);
		VARIABLE valor_de_saida : bit_vector(13 DOWNTO 0);
		VARIABLE ntest : INTEGER := 50; --testes totais
		VARIABLE lmat : INTEGER := 16; --linhas da matriz
	BEGIN
		rst <= '1';
		start <= '0';
		WAIT FOR t;
		rst <= '0';
		start <= '1';

		-- ns == t (30)
		WAIT FOR 30 ns;

		FOR j IN 1 TO ntest LOOP
			FOR k IN 1 TO lmat LOOP
				readline(arquivo_de_estimulos, linha_de_estimulos);
				read(linha_de_estimulos, valorA);
				MEM_A <= to_stdlogicvector (valorA);
				read(linha_de_estimulos, espaco);
				read(linha_de_estimulos, valorB);
				MEM_B <= to_stdlogicvector (valorB);
				WAIT FOR 30 * 3 ns;
			END LOOP;
			readline(arquivo_de_estimulos, linha_de_estimulos);
			read(linha_de_estimulos, valor_de_saida);
			WAIT FOR 30 * 3 ns;
			ASSERT (result = to_stdlogicvector(valor_de_saida))
			REPORT "erro no teste numero " & INTEGER'image(j);
			WAIT FOR 30 ns;
		END LOOP;

		fin <= '1';
		WAIT FOR t;
		ASSERT false REPORT "fim dos testes." SEVERITY note;
		WAIT;
	END PROCESS;

END Behavioral;
