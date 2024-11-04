library ieee;
use ieee.std_logic_1164.all;

entity sad_controle is
    port(
        iniciar, reset, clk: in std_logic;
        menor: in std_logic;
        pronto, read_mem: out std_logic;
        zi, ci, papb, zsoma, csoma, csad_reg: out std_logic
        );
end sad_controle;

architecture comportamento of sad_controle is
    type Tipo_estado is (S0, S1, S2, S3, S4, S5);
    signal EstadoAtual, ProximoEstado : Tipo_estado;
begin
    
    process(clk, reset)
    begin
        if reset = '1' then EstadoAtual <= S0;
        elsif (rising_edge(clk)) then
            EstadoAtual <= ProximoEstado;
        end if;
    end process;


    process (EstadoAtual, iniciar, menor)
    begin
        case EstadoAtual is
            when S0 =>  
                        pronto <= '1'; read_mem <= '0';
                        zi <= '1'; ci <= '0';
                        papb <= '0';
                        zsoma <= '0'; csoma <= '0';
                        csad_reg <= '0';
                
                if iniciar = '1' then ProximoEstado <= S1;
                else ProximoEstado <= S0;
                end if;
            
            when S1 =>  
                        pronto <= '0'; read_mem <= '0'; 
                        zi <= '1'; ci <= '1'; 
                        papb <= '0';
                        zsoma <= '1'; csoma <= '1';
                        csad_reg <= '0';
                
                ProximoEstado <= S2;
            when S2 =>  
                        pronto <= '0'; read_mem <= '0';
                        zi <= '0'; ci <= '0';
                        papb <= '0';
                        zsoma <= '0'; csoma <= '0';
                
                
                if menor = '1' then ProximoEstado <= S3;
                else ProximoEstado <= S5;
                end if;

            when S3 =>  
                        pronto <= '0'; read_mem <= '1';
                        zi <= '0'; ci <= '0';
                        papb <= '1';
                        zsoma <= '0'; csoma <= '0';

                ProximoEstado <= S4;

            when S4 =>  
                        pronto <= '0'; read_mem <= '0';
                        zi <= '0'; ci <= '1';
                        papb <= '0';
                        zsoma <= '0'; csoma <= '1';
                
                ProximoEstado <= S2;

            when S5 =>  
                        pronto <= '0'; read_mem <= '0';
                        zi <= '1'; ci <= '0';
                        papb <= '0';
                        zsoma <= '1'; csoma <= '0';
                        csad_reg <= '1';
                
                ProximoEstado <= S0;

        end case;
    end process;
end comportamento;
   
