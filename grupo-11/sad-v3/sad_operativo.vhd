LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;

--1.0

ENTITY sad_operativo IS
	GENERIC (
		B : POSITIVE := 8; --n bits por amostra
		N : POSITIVE := 64; --n de amostra
		P : POSITIVE := 4--amostras em paralelo por bloco

	);
	PORT (
		clk : IN std_logic;
		--ma0,ma1,ma2,ma3,mb0,mb1,mb2,mb3 :in std_logic_vector(7 downto 0);
		ma : IN std_logic_vector((P * b) - 1 DOWNTO 0);
		mb : IN std_logic_vector((P * b) - 1 DOWNTO 0);
		menor : OUT std_logic;
		ssad : OUT std_logic_vector(13 DOWNTO 0);
		ende : OUT std_logic_vector(INTEGER(ceil(log2(real(N)/real(P)))) - 1 DOWNTO 0);
		zi, ci, papb, zsoma, csoma, csad_reg : IN std_logic
		--zi e zsoma sao "resets" dos registradores, e serao invertidos
 
	);
 
END sad_operativo;
ARCHITECTURE sad_arch OF sad_operativo IS
	CONSTANT biti : INTEGER := INTEGER(ceil(log2(real(N)/real(P))));
	SIGNAL azi : std_logic;
	SIGNAL si : std_logic_vector(biti DOWNTO 0);
	SIGNAL nextSi : std_logic_vector(biti DOWNTO 0);
	--------------------------------------------
	SIGNAL spa0, spa1, spa2, spa3, spb0, spb1, spb2, spb3 : std_logic_vector(7 DOWNTO 0);
	SIGNAL subab0, subab1, subab2, subab3, absab0, absab1, absab2, absab3 : std_logic_vector(B - 1 DOWNTO 0);
	SIGNAL nextsum, sum : std_logic_vector(13 DOWNTO 0);
	SIGNAL absf : std_logic_vector(9 DOWNTO 0);
	SIGNAL azsoma : std_logic;
 
BEGIN
	azi <= NOT zi;
	reg_i : ENTITY work.reg_g
			GENERIC MAP(5)
		PORT MAP(nextSi, si, ci, azi, clk);
		ende <= si(3 DOWNTO 0);
		menor <= NOT si(4);
		nextSi <= std_logic_vector(unsigned('0' & si(3 DOWNTO 0)) + 1);
		----------------------------------------------------------
 

		pa0 : ENTITY work.reg_g
				GENERIC MAP(8)
			PORT MAP(ma(31 DOWNTO 24), spa0, papb, '1', clk);
			pa1 : ENTITY work.reg_g
					GENERIC MAP(8)
				PORT MAP(ma(23 DOWNTO 16), spa1, papb, '1', clk);
				pa2 : ENTITY work.reg_g
						GENERIC MAP(8)
					PORT MAP(ma(15 DOWNTO 8), spa2, papb, '1', clk);
					pa3 : ENTITY work.reg_g
							GENERIC MAP(8)
						PORT MAP(ma(7 DOWNTO 0), spa3, papb, '1', clk);
						pb0 : ENTITY work.reg_g
								GENERIC MAP(8)
							PORT MAP(mb(31 DOWNTO 24), spb0, papb, '1', clk);
							pb1 : ENTITY work.reg_g
									GENERIC MAP(8)
								PORT MAP(mb(23 DOWNTO 16), spb1, papb, '1', clk);
								pb2 : ENTITY work.reg_g
										GENERIC MAP(8)
									PORT MAP(mb(15 DOWNTO 8), spb2, papb, '1', clk);
									pb3 : ENTITY work.reg_g
											GENERIC MAP(8)
										PORT MAP(mb(7 DOWNTO 0), spb3, papb, '1', clk);

										dif0 : ENTITY work.pdif
												GENERIC MAP(8)
											PORT MAP(spa0, spb0, subab0);
											dif1 : ENTITY work.pdif
													GENERIC MAP(8)
												PORT MAP(spa1, spb1, subab1);
												dif2 : ENTITY work.pdif
														GENERIC MAP(8)
													PORT MAP(spa2, spb2, subab2);
													dif3 : ENTITY work.pdif
															GENERIC MAP(8)
														PORT MAP(spa3, spb3, subab3);

														abss0 : ENTITY work.absolute
																GENERIC MAP(8)
															PORT MAP(subab0, absab0);
 

															abss1 : ENTITY work.absolute
																	GENERIC MAP(8)
																PORT MAP(subab1, absab1);
 

																abss2 : ENTITY work.absolute
																		GENERIC MAP(8)
																	PORT MAP(subab2, absab2);
 

																	abss3 : ENTITY work.absolute
																			GENERIC MAP(8)
																		PORT MAP(subab3, absab3);
 
																		at : ENTITY work.adderTree4
																				GENERIC MAP(8)
																			PORT MAP(absab0, absab1, absab2, absab3, absf);
 
 
 

																			azsoma <= NOT zsoma;
 
																			reg_sum : ENTITY work.reg_g
																					GENERIC MAP(14)
																				PORT MAP(nextsum, sum, csoma, azsoma, clk);
																				nextsum <= std_logic_vector(signed(sum) + signed("0000" & absf));
 
																				reg_sad : ENTITY work.reg_g
																						GENERIC MAP(14)
																					PORT MAP(sum, ssad, csad_reg, '1', clk);
 
END sad_arch;