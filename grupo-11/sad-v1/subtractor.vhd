LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE numeric_std.ALL;

ENTITY subtractor is
generic(
    width: POSITIVE
);
port(
    -- The inputs are absolute numbers typed as std_logic_vector. 
    -- The output is a std_logic_vector that represents a two's complement number
    -- Note: the output is a bit larger

    value1, value2: in std_logic_vector(width - 1 downto 0);
    result: out std_logic_vector(width downto 0)
);
end subtractor;

architecture Behavioral of subtractor is
    
begin
    -- 0's are concatenated to both values so then they can represent positive numbers in two's complement
    result <= std_logic_vector(signed('0'&value1) - signed('0'&value2));

end Behavioral;