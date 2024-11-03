LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use IEEE.math_real.all;

ENTITY sad IS
	GENERIC (
		-- obrigatÃ³rio ---
		-- defina as operaÃ§Ãµes considerando o nÃºmero B de bits por amostra
		B : POSITIVE := 8; -- nÃºmero de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., nÃ£o obrigatÃ³rio) ---
		-- se vocÃª desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		N : POSITIVE := 64; -- nÃºmero de amostras por bloco
		P : POSITIVE := 4 -- nÃºmero de amostras de cada bloco lidas em paralelo
		-----------------------------------------------------------------------
	);
	PORT (
		-- ATENÃ‡ÃƒO: modifiquem a largura de bits das entradas e saÃ­das que
		-- estÃ£o marcadas com DEFINIR de acordo com o nÃºmero de bits B e
		-- de acordo com o necessÃ¡rio para cada versÃ£o da SAD (tentem utilizar
		-- os valores N e P descritos acima para criar apenas uma descriÃ§Ã£o
		-- configurÃ¡vel que funcione tanto para a SAD v1 quanto para a SAD v3).
		-- NÃ£o modifiquem os nomes das portas, apenas a largura de bits quando
		-- for necessÃ¡rio.
		clk : IN STD_LOGIC; -- ck
		enable : IN STD_LOGIC; -- iniciar
		reset : IN STD_LOGIC; -- reset
		sample_ori : IN STD_LOGIC_VECTOR ((P*N)-1 downto 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR ((P*N)-1 downto 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (integer(ceil(log2(real(N)/real(P))))- 1 DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR (13 DOWNTO 0); -- SAD
		done: OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS
	-- descrever
	-- usar sad_bo e sad_bc (sad_operativo e sad_controle)
	-- nÃ£o codifiquem toda a arquitetura apenas neste arquivo
	-- modularizem a descriÃ§Ã£o de vocÃªs...
    signal zi, ci, papb, zsoma, csoma, csad_reg, menor : std_logic;
	 
	 
BEGIN

    sad_bc: ENTITY WORK.sad_controle
        PORT MAP (
            iniciar   => enable,
            reset     => reset,
            clk       => clk,    
            menor     => menor,
            pronto    => done,
            read_mem  => read_mem,
            zi        => zi,
            ci        => ci,
            papb 	  => papb,
            zsoma     => zsoma,
            csoma     => csoma,
            csad_reg  => csad_reg 
        );

    sad_bo: ENTITY WORK.sad_operativo
        GENERIC MAP(B, N, P)
		  PORT MAP (
			clk 	=> clk,
			ma 		=> sample_ori,
			mb 		=> sample_can,
			menor 	=> menor,
			ssad 	=> sad_value,
			ende 	=> address,
			zi 		=> zi,
			ci 		=> ci,
			papb 	=> papb,
			zsoma 	=> zsoma,
			csoma 	=> csoma,
			csad_reg => csad_reg

        );

END ARCHITECTURE; -- arch