LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;

ENTITY adderTree IS
	GENERIC (
		N : POSITIVE := 4; --tamanho do dado
		G: POSITIVE := 4 --quatidade de dados

	);
	PORT (
		d: IN std_logic_vector ((N*G)-1 DOWNTO 0);
		s: OUT std_logic_vector (POSITIVE(ceil(log2(real(G)))) + N - 1 DOWNTO 0)
	);
END adderTree;

ARCHITECTURE arch OF adderTree IS
	constant concatadd : POSITIVE := POSITIVE(ceil(log2(real(G))));
	signal sum : unsigned(concatadd+N-1 downto 0);
BEGIN
	--sum<=(others => '0');
	addTree: process(d) is
	begin
	for I in 0 to G-1 loop
		sum <= UNSIGNED(sum) + UNSIGNED(d( ((I+1)*N)-1 downto I*N ));
	end loop;
end process;
	s<=std_logic_vector(sum);


END arch;
