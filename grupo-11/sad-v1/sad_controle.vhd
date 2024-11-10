LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_controle IS
	PORT (
		enable, reset, clk : IN STD_LOGIC;
		less : IN STD_LOGIC;
		done, read_mem : OUT STD_LOGIC;
		zi, ci, cpA, cpB, zsum, csum, csad_reg : OUT STD_LOGIC
	);
END sad_controle;

ARCHITECTURE Behavioral OF sad_controle IS
	TYPE type_state IS (S0, S1, S2, S3, S4, S5);
	SIGNAL CurrentState, NextState : type_state;
BEGIN
	PROCESS (clk, reset)
	BEGIN
		IF reset = '1' THEN
			CurrentState <= S0;
		ELSIF (rising_edge(clk)) THEN
			CurrentState <= NextState;
		END IF;
	END PROCESS;

	PROCESS (CurrentState, enable, less)
	BEGIN
		CASE CurrentState IS
			WHEN S0 =>
				-- THE OUTPUT OF THE SAD IS AVAIABLE
				zi <= '0';
				ci <= '0';

				zsum <= '1';
				csum <= '0';

				done <= '1';
				read_mem <= '0';

				cpA <= '0';
				cpB <= '0';

				csad_reg <= '0';
				IF enable = '1' THEN
					NextState <= S1;
				ELSE
					NextState <= S0;
				END IF;

			WHEN S1 =>
				-- CHARGE
				-- Both next value of i and next value of sum are charged with zeros
				-- Registers are activated

				zi <= '1';
				ci <= '1';

				zsum <= '1';
				csum <= '1';

				done <= '0';
				read_mem <= '0';

				cpA <= '0';
				cpB <= '0';

				csad_reg <= '0';

				NextState <= S2;

			WHEN S2 =>
				-- VERIFIES IF i < (LAST MEMORY INDEX + 1). NEXT VALUE OF i <= CURRENT VALUE + 1
				-- Iterator logic is done in this state

				zi <= '0';
				ci <= '0';

				zsum <= '1';
				csum <= '0';

				done <= '0';
				read_mem <= '0';

				cpA <= '0';
				cpB <= '0';

				csad_reg <= '0';

				IF less = '1' THEN
					NextState <= S3;
				ELSE NextState <= S5;
				END IF;

			WHEN S3 =>
				-- READS the sample values stored in the memories, then activates the registers associated with them

				zi <= '0';
				ci <= '0';

				zsum <= '1';
				csum <= '0';

				done <= '0';
				read_mem <= '1';

				cpA <= '1';
				cpB <= '1';

				csad_reg <= '0';

				NextState <= S4;

			WHEN S4 =>
				-- MAKES THE ABSOLUT DIFFERENCE BETWEEN SAMPLE VALUES AND ADD WITH THE PREVIOUS ABSOLUT DIFFERENCE
				-- The subtractor and adder circuit logics are activated in this state
				zi <= '0';
				ci <= '1';

				zsum <= '0';
				csum <= '1';

				done <= '0';
				read_mem <= '0';

				cpA <= '0';
				cpB <= '0';

				csad_reg <= '0';

				NextState <= S2;

			WHEN S5 =>
				-- MARKS THE END OF THE LOOP, THEN ACTIVATES THE OUTPUT REGISTER. THE OUTPUT IS UPDATED IN THE NEXT STATE
				zi <= '0';
				ci <= '0';

				zsum <= '1';
				csum <= '0';

				done <= '0';
				read_mem <= '0';

				cpA <= '0';
				cpB <= '0';

				csad_reg <= '1';

				NextState <= S0;

		END CASE;
	END PROCESS;
END Behavioral;