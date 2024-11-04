library ieee;
use ieee.std_logic_1164.all;

entity mux2_1 is
generic(
	n:positive
);
 port(
	sel: in std_logic;
   	in0, in1: in  std_logic_vector(n-1 downto 0);
   	saida: out std_logic_vector(n-1 downto 0)
);
    
end mux2_1;


architecture m21 of mux2_1 is begin

 Saida <= in0 when sel = '0' else
          in1 when sel = '1';
			 
	
end m21;
