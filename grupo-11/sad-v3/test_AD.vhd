library ieee;
use ieee.std_logic_1164.all;

entity test_AD is
generic(
    FSW: POSITIVE;
    B: POSITIVE;
    P: POSITIVE
);
port(
    pApB_regOut: in std_logic_vector(2* FSW - 1 DOWNTO 0);
    absolutesOut: out std_logic_vector(FSW - 1 DOWNTO 0)
);

end test_AD;

architecture Behavioral of test_AD is
begin
    	absolute_differences: for i in 0 to (P - 1) generate

		subtractor: entity work.subtractor
		generic map(B)
		port map(
			pApB_regOut((2 * FSW- 1 - B*i) DOWNTO (2 * FSW- B*(i+1))),
			pApB_regOut((FSW- 1 - B*i) DOWNTO (FSW- B*(i+1))),
			subtractorsOut((B + 1) * P - 1 - (B + 1)*i DOWNTO (B + 1) * P - (B + 1)*(i + 1))
		);

		absolute: entity work.absolute
		generic map(B + 1)
		port map(
			subtractorsOut((B + 1) * P - 1 - (B + 1)*i DOWNTO (B + 1) * P - (B + 1)*(i + 1)),
			absolutesOut((FSW- 1 - B*i) DOWNTO (FSW- B*(i+1)))
		);

	end generate absolute_differences;
end Behavioral;