library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use ieee.math_real.all;

entity adder_tree is 
    generic (
        width: POSITIVE; -- width := B*P
        B: POSITIVE;
        P: POSITIVE
    );

    port(
        input_vector: in std_logic_vector(width - 1 downto 0);
        result: out std_logic_vector((B + log2(P)) - 1 downto 0)
    );
end adder_tree;

architecture Behavioral of adder_tree is
    signal result_left_tree, result_right_tree: std_logic_vector(B + log2(P/2) - 1 downto 0);

begin
    general_case: if (P > 1) generate
        left_tree: entity work.adder_tree
        generic map(width/2, B, P/2)
        port map(input_vector(width - 1 downto width/2), result_left_tree);
        
        right_tree: entity work.adder_tree
        generic map(width/2, B, P/2)
        port map(input_vector(width/2 - 1 downto 0), result_right_tree);


        result <= std_logic_vector(unsigned('0' & result_left_tree) + unsigned('0' & result_right_tree));
    
    end generate;
    
    base_case: if P = 1 generate
        result <= std_logic_vector(unsigned('0' & input_vector(width - 1 downto width/2)) + unsigned('0' & input_vector(width/2 - 1 downto 0)));
    end generate;
    


end Behavioral;