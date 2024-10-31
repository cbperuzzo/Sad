library ieee;
use ieee.std_logic_1164.all;

entity sad_controle is
    port(iniciar, Reset, ck: in std_logic;
        menor: in std_logic;
        read, pronto: out std_logic;
        zi, ci, cpA, cpB, zsoma, csoma, csad_reg: out std_logic
        );
end sad_controle;

architecture comportamento of sad_controle is
    type Tipo_estado is (S0, S1, S2, S3, S4, S5);
    signal EstadoAtual, ProximoEstado : Tipo_estado;
begin
    process(ck, reset)
    begin
        if Reset = '1' then EstadoAtual <= S0;
        elsif (rising_edge(ck)) then
            EstadoAtual <= ProximoEstado;
        end if;
    end process;

    process (EstadoAtual, iniciar, menor)
    begin
        case EstadoAtual is
            when S0 => pronto <= '1'; read <= '0';
                if iniciar = '1' then ProximoEstado <= S1;
                else ProximoEstado <= S0;
                end if;
            when S1 => pronto <= '0'; zi <= '1'; ci <= '1'; zsoma <= '1'; csoma <= '1';
                ProximoEstado <= S2;
            when S2 => 

            when S3 =>

            when S4 =>

            when S5 =>
        end case;
    end process;
end comportamento;
   
