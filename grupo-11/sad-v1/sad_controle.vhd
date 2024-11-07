LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_controle IS
	PORT (
		iniciar, reset, clk : IN std_logic;
		menor : IN std_logic;
		pronto, read_mem : OUT std_logic;
		zi, ci, cpa, cpb, zsoma, csoma, csad_reg : OUT std_logic
	);
END sad_controle;

ARCHITECTURE comportamento OF sad_controle IS
	TYPE Tipo_estado IS (S0, S1, S2, S3, S4, S5);
	SIGNAL EstadoAtual, ProximoEstado : Tipo_estado;
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			EstadoAtual <= S0;
		ELSIF (rising_edge(clk)) THEN
			EstadoAtual <= ProximoEstado;
		END IF;
	END PROCESS;

	PROCESS (EstadoAtual, iniciar, menor)
		BEGIN
			CASE EstadoAtual IS
				WHEN S0 => 
					pronto <= '1';
					read_mem <= '0';
					zi <= '1';
					ci <= '0';
					cpa <= '0';
					cpb <= '0';
					zsoma <= '1';
					csoma <= '0';
					csad_reg <= '0';
 
					IF iniciar = '1' THEN
						ProximoEstado <= S1;
					ELSE
						ProximoEstado <= S0;
					END IF;
 
				WHEN S1 => 
					pronto <= '0';
					read_mem <= '0';
					zi <= '1';
					ci <= '1';
					cpa <= '0';
					cpb <= '0';
					zsoma <= '1';
					csoma <= '1';
					csad_reg <= '0';
 
					ProximoEstado <= S2;
				WHEN S2 => 
					pronto <= '0';
					read_mem <= '0';
					zi <= '0';
					ci <= '0';
					cpa <= '0';
					cpb <= '0';
					zsoma <= '0';
					csoma <= '0';
 
 
					IF menor = '1' THEN
						ProximoEstado <= S3;
					ELSE ProximoEstado <= S5;
					END IF;

				WHEN S3 => 
					pronto <= '0';
					read_mem <= '1';
					zi <= '0';
					ci <= '0';
					cpa <= '1';
					cpb <= '1';
					zsoma <= '0';
					csoma <= '0';

					ProximoEstado <= S4;

				WHEN S4 => 
					pronto <= '0';
					read_mem <= '0';
					zi <= '0';
					ci <= '1';
					cpa <= '0';
					cpb <= '0';
					zsoma <= '0';
					csoma <= '1';
 
					ProximoEstado <= S2;

				WHEN S5 => 
					pronto <= '0';
					read_mem <= '0';
					zi <= '1';
					ci <= '0';
					cpa <= '0';
					cpb <= '0';
					zsoma <= '0';
					csoma <= '0';
					csad_reg <= '1';
 
					ProximoEstado <= S0;

			END CASE;
		END PROCESS;
END comportamento;