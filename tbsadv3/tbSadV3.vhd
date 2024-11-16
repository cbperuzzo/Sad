library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity tbSadV3 is
end tbSadV3;

architecture tb of tbSadV3 is
	CONSTANT t : TIME := 30 ns;
	CONSTANT b : natural := 32;
	signal fin: std_logic := '0';
	signal clk : std_logic := '0';
	signal start : std_logic := '0';
	signal rst : std_logic := '1';
	signal r_mem : std_logic := '0';
	signal done : std_logic;
	signal MEM_A, MEM_B: std_logic_vector(b-1 DOWNTO 0);
	signal addr : std_logic_vector(3 downto 0);
	signal result: std_logic_vector(13 DOWNTO 0);
	
	begin
	

	-- Connect DUV
	DUV: entity work.sad
	PORT MAP (
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
	
	clk <= not clk after t/2 when fin /= '1' else '0';
	

	main: process is
		file arquivo_de_estimulos : text open read_mode is "../../values.dat";
		variable linha_de_estimulos: line;
		variable espaco: character;
		variable valorA: bit_vector(b-1 downto 0);
		variable valorB: bit_vector(b-1 downto 0);
		variable valor_de_saida: bit_vector(13 downto 0);
		variable ntest : integer := 50; --testes totais
		variable lmat : integer := 16; --linhas da matriz
	begin
		rst <= '1';
		start <= '0';
		wait for t;
		rst <= '0';
		start <= '1';
		
		-- ns == t (30)
		wait for 30 ns;
		
		for j in 1 to ntest loop
			for k in 1 to lmat loop
				readline(arquivo_de_estimulos, linha_de_estimulos);
				read(linha_de_estimulos, valorA);
				MEM_A <= to_stdlogicvector (valorA);
				read(linha_de_estimulos, espaco);
				read(linha_de_estimulos, valorB);
				MEM_B <= to_stdlogicvector (valorB);
				wait for 30*3 ns;
			end loop;
			readline(arquivo_de_estimulos, linha_de_estimulos);
			read(linha_de_estimulos, valor_de_saida);
			wait for 30*3 ns;
			assert (result = to_stdlogicvector(valor_de_saida))
			report "erro no teste numero "& integer'image(j);
			wait for 30 ns ;
		end loop;
			
		fin <= '1';
		wait for t;
		assert false report "fim dos testes." severity note;
		wait;
	end process;

end tb;