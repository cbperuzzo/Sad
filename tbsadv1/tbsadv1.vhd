library IEEE;
use IEEE.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity tbsadv1 is
end tbsadv1;

architecture tb of tbsadv1 is
	CONSTANT t : TIME := 30 ns;
	CONSTANT b : natural := 8;
	signal fin: std_logic := '0';
	signal clk : std_logic := '0';
	signal start : std_logic := '0';
	signal rst : std_logic := '1';
	signal r_mem : std_logic := '0';
	signal done : std_logic;
	signal MEM_A, MEM_B: std_logic_vector(b-1 DOWNTO 0);
	signal addr : std_logic_vector(5 downto 0);
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
		variable lmat : integer := 64; --linhas da matriz
	begin
		rst <= '1';
		start <= '0';
		wait for t;
		rst <= '0';
		start <= '1';
		
		-- ns == t (30)
	
		wait for 30 ns;
		
		--no teste original da nossa sad v1 (usando o .do) todas as linhas da matriz a eram "111111111" e do vetor b "00000001"
		--o resultado final esperado era "11111110000000"
		
		for k in 1 to lmat loop
			MEM_A <= "11111111"; --"11111111"
			MEM_B <= "00000001"; --"00000001"
			wait for 30*3 ns;
		end loop;
			wait for 30*3 ns;
			assert(result = "11111110000000")
			report "saida errada, a saida esperada era 11111110000000";
			wait for 30 ns;
		
			
		fin <= '1';
		wait for t;
		assert false report "fim do teste." severity note;
		wait;
	end process;

end tb;