LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.math_real.ALL;

ENTITY sad IS
	GENERIC (
		B : POSITIVE := 8; -- número de bits por amostra
		N : POSITIVE := 64; -- número de amostras por bloco
		P : POSITIVE := 1 -- número de amostras de cada bloco lidas em paralelo
	);
	PORT (
		clk : IN STD_LOGIC; -- ck
		enable : IN STD_LOGIC; -- iniciar
		reset : IN STD_LOGIC; -- reset
		sample_ori : IN STD_LOGIC_VECTOR (B * P - 1 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (B * P - 1 DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (INTEGER(ceil(log2(real(N)/real(P)))) - 1 DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR (INTEGER(ceil(log2((exp(real(B) * log(real(2))) - real(1)) * real(N)))) - 1 DOWNTO 0); -- SAD
		done : OUT STD_LOGIC -- pronto
	);
END ENTITY;

ARCHITECTURE arch OF sad IS
	CONSTANT output_width : POSITIVE := sad_value'length;
	CONSTANT counter_width : POSITIVE := address'length + 1;
	SIGNAL zi, ci, less, cpAcpB, zsum, csum, csad_reg : STD_LOGIC;
BEGIN

	sad_bc : ENTITY work.sad_controle
		PORT MAP(enable, reset, clk, less, done, read_mem, zi, ci, cpAcpB, zsum, csum, csad_reg);

	sad_bo : ENTITY work.sad_operativo
		GENERIC MAP(B, P, output_width, counter_width)
		PORT MAP(clk, zi, ci, cpAcpB, zsum, csum, csad_reg, sample_ori, sample_can, less, sad_value, address);

END ARCHITECTURE;
