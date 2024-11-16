LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.math_real.ALL;

ENTITY sad IS
	GENERIC (
		-- obrigatório ---
		-- defina as operações considerando o número B de bits por amostra
		B : POSITIVE := 8; -- número de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., não obrigatório) ---
		-- se você desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		N : POSITIVE := 64; -- número de amostras por bloco
		P : POSITIVE := 4 -- número de amostras de cada bloco lidas em paralelo
		-----------------------------------------------------------------------
	);
	PORT (
		-- ATENÇÃO: modifiquem a largura de bits das entradas e saídas que
		-- estão marcadas com DEFINIR de acordo com o número de bits B e
		-- de acordo com o necessário para cada versão da SAD (tentem utilizar
		-- os valores N e P descritos acima para criar apenas uma descrição
		-- configurável que funcione tanto para a SAD v1 quanto para a SAD v3).
		-- Não modifiquem os nomes das portas, apenas a largura de bits quando
		-- for necessário.
		clk : IN STD_LOGIC; -- ck
		enable : IN STD_LOGIC; -- iniciar
		reset : IN STD_LOGIC; -- reset
		sample_ori : IN STD_LOGIC_VECTOR (B*P - 1 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (B*P - 1 DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (integer(ceil(log2(real(N)/real(P)))) - 1 DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR (integer(ceil(log2((exp(real(B) * log(real(2))) - real(1)) * real(N)))) - 1 DOWNTO 0); -- SAD
		done : OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS
	CONSTANT output_width : POSITIVE := integer(ceil(log2((exp(real(B) * log(real(2))) - real(1)) * real(N))));
	CONSTANT iterator_width : POSITIVE := integer(ceil(log2(real(N)/real(P)))) + 1;
	-- Note: the iterator logic only works when N is an exponent of 2, so, using ceil() is kind of redundant

	SIGNAL zi, ci, less, cpAcpB, zsum, csum, csad_reg : STD_LOGIC;
BEGIN
	-- usar sad_bo e sad_bc (sad_operativo e sad_controle)

	sad_bc : ENTITY work.sad_controle
		PORT MAP(enable, reset, clk, less, done, read_mem, zi, ci, cpAcpB, zsum, csum, csad_reg);
	
	sad_bo : ENTITY work.sad_operativo
		GENERIC MAP(B*P, B, P, output_width, iterator_width)
		PORT MAP(clk, zi, ci, cpAcpB, zsum, csum, csad_reg, sample_ori, sample_can, less, sad_value, address);

END ARCHITECTURE; -- arch