# Atividade Prática II

Relatório da Atividade Prática II (AP2) de INE5406 em 2024.2. 

## Grupo 11

- caetano borba peruzzo (Matrícula 24102642)
- joão pedro de oliveira anders (Matrícula 24100597)


## Descrição dos circuitos

### adderTree4
soma de quatro números de n bits.
```vhdl
	GENERIC (N : POSITIVE);
	PORT (
		a,b,c,d: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N+1 DOWNTO 0)
);
```
soma "dois a dois".
```vhdl
	p1<= std_logic_vector(unsigned("00"&a)+unsigned("00"&b));
	p2<= std_logic_vector(unsigned("00"&c)+unsigned("00"&d));
	s<= std_logic_vector(unsigned(p1)+unsigned(p2));
```
### reg_g
registrador genérico de que guarda um vetor de g bits.
```vhdl
	generic(g : positive);
	port(
		d : in std_logic_vector(g-1 downto 0);
		s : out std_logic_vector(g-1 downto 0);

		e,r,clk : in std_logic	
	);
```
```vhdl
	reg:process(clk,e,r) is begin
		if r='0' then
			mem <=(others=>'0');
		elsif clk'event and clk = '1' and e='1' then
			mem<=d;
		end if;
	end process;

	s<=mem;
```

### pdif
calcula a diferença (operação de subtração) entre dois números de n bits

```vhdl
	GENERIC (N : POSITIVE);
	PORT (
		a,b: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N-1 DOWNTO 0)
	);
```
```vhdl
	s<= std_logic_vector(signed(a) - signed(b));
```

### absolute
recebe um vetor de n bits em complemento de dois e retorna o módulo desse número em um vetor de n bits sem sinal

```vhdl
 	GENERIC (N : POSITIVE);
	PORT (
		a: IN std_logic_vector (N-1 DOWNTO 0);
		s: OUT std_logic_vector (N-1 DOWNTO 0)
	);
```
```vhdl
        complement <= -signed(a(n-1)&a);
        s <= std_logic_vector(complement(N-1 DOWNTO 0)) WHEN a(N-1) = '1'
        ELSE a(N-1 DOWNTO 0);
	);
```

## sad_operativov1

calculo do valor de sad de um vetor de 64 elementos de 8 bits cada, faz uma operação de diferença por cíclo. faz 64 somas cíclicas para gerar o valor final de sad.


## sad_operativov3
calculo do valor de sad de um vetor de 64 elementos  (ou uma mariz de 16x4)  de 8 bits cada, faz 4 operações de diferença e valor absoluto por cíclo  e dois somas esses 4 valores. faz 16 somas cíclicas para gerar o valor final de sad.

## sad_controle
emite os sinais de controle para realizar a operação de SAD com os blocos operativos à cima. é exatamente igual para as duas versões do bloco operativo.
