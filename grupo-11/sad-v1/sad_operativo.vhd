LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;
ENTITY sad_operativo IS
	GENERIC (
		B : POSITIVE; --n bits por amostra
		N : POSITIVE; --n de amostra
		P : POSITIVE --amostras em paralelo por bloco

	);
	PORT (
		clk : IN std_logic;
		ma, mb : IN std_logic_vector(B - 1 DOWNTO 0);
		menor : OUT std_logic;
		ssad : OUT std_logic_vector(13 DOWNTO 0);
		ende : OUT std_logic_vector(INTEGER(ceil(log2(real(N)/real(P)))) - 1 DOWNTO 0);
		zi, ci, cpa, cpb, zsoma, csoma, csad_reg : IN std_logic
		--zi e zsoma sao "resets" dos registradores, e serao invertidos
 
	);
 
END sad_operativo;
ARCHITECTURE sad_arch OF sad_operativo IS
	CONSTANT biti : INTEGER := INTEGER(ceil(log2(real(N)/real(P))));
	SIGNAL azi : std_logic;
	SIGNAL si : std_logic_vector(biti DOWNTO 0);
	SIGNAL nextSi : std_logic_vector(biti DOWNTO 0);
	--------------------------------------------
	SIGNAL spa, spb, subab, preabsab : std_logic_vector(7 DOWNTO 0);
	SIGNAL nextsum, sum, absab : std_logic_vector(13 DOWNTO 0);
	SIGNAL azsoma : std_logic;
 
BEGIN
	azi <= NOT zi;
	reg_i : ENTITY work.reg_g
			GENERIC MAP(7)
		PORT MAP(nextSi, si, ci, azi, clk);
		ende <= si(5 DOWNTO 0);
		menor <= NOT si(6);
		nextSi <= std_logic_vector(unsigned('0' & si(5 DOWNTO 0)) + 1);
		----------------------------------------------------------
 

		pa : ENTITY work.reg_g
				GENERIC MAP(8)
			PORT MAP(ma, spa, cpa, '1', clk);

			pb : ENTITY work.reg_g
					GENERIC MAP(8)
				PORT MAP(mb, spb, cpb, '1', clk);

				dif : ENTITY work.pdif
						GENERIC MAP(8)
					PORT MAP(spa, spb, subab);

					abss : ENTITY work.absolutev2
							GENERIC MAP(8)
						PORT MAP(subab, preabsab);
						absab <= "000000" & preabsab;

						azsoma <= NOT zsoma;
 
						reg_sum : ENTITY work.reg_g
								GENERIC MAP(14)
							PORT MAP(nextsum, sum, csoma, azsoma, clk);
							nextsum <= std_logic_vector(signed(sum) + signed(absab));
 
							reg_sad : ENTITY work.reg_g
									GENERIC MAP(14)
								PORT MAP(sum, ssad, csad_reg, '1', clk);
 
END sad_arch;