# Atividade Prática III

Atividade desenvolvida pelo grupo 11 da disciplina de Sistemas Digitais (INE5406) em 2024.2. Integrantes:
- João Pedro de Oliveira Anders (24100597)
- Caetano Borba Peruzzo (24102642)
## Introdução
### Proposta da Atividade
A atividade tem como proposta o desenvolvimento de dois *testbenches* para os circuitos da Atividade Prática II, mais especificamente o sad-v1 e o sad-v3
### Implementações e mudanças em relação a Atividade Prática II
Esta atividade foi aproveitada como oportunidade de refatoração total dos circuitos implementados na Atividade Prática II, visto que, nestes se encontravam dois principais problemas:
- Ausência de descrição genérica dos circuitos.
- Erro de lógica na saída do valor de final do *sad*, mais especificamente, o valor se perdia no final do circuito por uma má comunicação entre o bloco operativo e bloco de controle.

Esta atividade também permitiu um enriquecimento quanto aos valores de estímulos, descritos de maneira muito pobre na atividade anterior. Nesse sentido, o circuito da SAD está, agora, descrito integralmente de forma genérica, assim, há três parâmetros principais: B - número de bits de cada amostra; P - número de diferenças absolutas em paralelo; N - número de amostras.

## Circuito da SAD
### Visão geral
Como já mencionado, a SAD foi desenvolvida aqui de maneira genérica, então, tanto a sad-v1 quanto a sad-v3 terão os mesmos arquivos *.vhd*, mudando-se apenas o parâmetro P do *top-level*, com P = 1 para o sad-v1, e P = 4 para o sad-v3.
Vale mencionar também que tanto P quanto N devem ser parametrizados como potências de 2. Sendo, $$P =2^n, n \in\mathbb{N}$$$$ N = 2^n, n \in \mathbb{N}^* $$
### Bloco de controle
O bloco de controle da SAD foi feito a partir de um dos padrões de descrição de FSM's em VHDL. Tem-se, então, dois circuitos sequenciais, dentre os quais um *process* sensível à borda de subida do clock e à mudança do sinal de reset, que descreve a lógica de transição de estado.
```vhdl
PROCESS (clk, reset)
BEGIN
	IF reset = '1' THEN
		CurrentState <= S0;
	ELSIF (rising_edge(clk)) THEN
		CurrentState <= NextState;
	END IF;
END PROCESS;
```
O segundo circuito sequencial é um *process* sensível ao estado atual, ou seja, é avaliado sempre que há uma mudança neste, assim como aos sinais que indicam mudança de estado. Dessa forma, utiliza-se um *case* para descrever a lógica de cada estado.
```vhdl
PROCESS (CurrentState, enable, less)
BEGIN
	CASE CurrentState IS
		WHEN S0 => ...

		WHEN S1 => ...

		WHEN S2 => ...

		WHEN S3 => ...

		WHEN S4 => ...
		
		WHEN S5 => ...

	END CASE;
END PROCESS;
```

### Bloco operativo
O bloco operativo foi modularizado em componentes. Tem-se, então, o *counter* que realiza a lógica para o loop da variável *i*, que conta o número de somas realizadas e o restante do código descreve a lógica das somas das diferenças absolutas. Abaixo, a arquitetura do *counter*.
``` vhdl
BEGIN
	mux : ENTITY work.mux2_1
		GENERIC MAP(width)
		PORT MAP(muxIn, (OTHERS => '0'), zi, muxOut);

	reg : ENTITY work.reg
		GENERIC MAP(width)
		PORT MAP(clk, ci, '0', muxOut, regOut);

	-- Splitter logic and status signal --
	less <= NOT regOut(width - 1);
	address <= regOut(width - 2 DOWNTO 0);
	--------------------------------------

	adder : ENTITY work.adder
		GENERIC MAP(width - 1)
		PORT MAP(regOut(width - 2 DOWNTO 0), ((width - 2 DOWNTO 1 => '0') & '1'), adderOut, carryOut);

	-- Concatenator logic --
	muxIn <= carryOut & adderOut;
	------------------------
	
END Behavioral;
```
Já para a lógica da soma das diferenças absolutas, destaca-se a descrição das diferenças em paralelo com a estrutura *if-generate* e a descrição da *adder tree* genérica. Abaixo, a lógica das diferenças absolutas, em que *FSW* é a multiplicação de *B* por *P*. 
O vetor de bits de entrada em *absolute_differences* é o vetor que sai do registrador *pApB_regOut*, que representa a concatenação entre *sample_ori* e *sample_can*, tendo portando o tamanho de *2FSW*. Cada *subtractor* em paralelo pega o *i-ésimo* valor de *sample_ori* e subtrai dele o *i-ésimo* valor de *sample_can*. Os resultados são armazenados em *subtractorsOut*, que entra nos *absolute*'s em paralelo.
``` vhdl
absolute_differences : FOR i IN 0 TO (P - 1) GENERATE

	subtractor : ENTITY work.subtractor
		GENERIC MAP(B)
		PORT MAP(
			pApB_regOut((2 * FSW - 1 - B * i) DOWNTO (2 * FSW - B * (i + 1))),
			pApB_regOut((FSW - 1 - B * i) DOWNTO (FSW - B * (i + 1))),
			subtractorsOut((B + 1) * P - 1 - (B + 1) * i DOWNTO (B + 1) * P - (B + 1) * (i + 1))
		);

	absolute : ENTITY work.absolute
		GENERIC MAP(B + 1)
		PORT MAP(
			subtractorsOut((B + 1) * P - 1 - (B + 1) * i DOWNTO (B + 1) * P - (B + 1) * (i + 1)),
			absolutesOut((FSW - 1 - B * i) DOWNTO (FSW - B * (i + 1)))
		);

END GENERATE absolute_differences;
```
Enfim, realiza-se a soma dos resultados armazenados no sinal *absolutesOut* utilizando o componente que descreve uma árvore de somas genérica que realiza a soma em pares. Utilizou-se um processo recursivo, conforme descrito abaixo.
``` vhdl
BEGIN
	general_case : IF (P > 2) GENERATE
		left_tree : ENTITY work.adder_tree
			GENERIC MAP(B, P/2)
			PORT MAP(input_vector(width - 1 DOWNTO width/2), left_tree_result);

		right_tree : ENTITY work.adder_tree
			GENERIC MAP(B, P/2)
			PORT MAP(input_vector(width/2 - 1 DOWNTO 0), right_tree_result);
		result <= STD_LOGIC_VECTOR(unsigned('0' & left_tree_result) + unsigned('0' & right_tree_result));

	END GENERATE;

	base_case : IF P = 2 GENERATE
		result <= STD_LOGIC_VECTOR(unsigned('0' & input_vector(width - 1 DOWNTO width/2)) + unsigned('0' & input_vector(width/2 - 1 DOWNTO 0)));
	END GENERATE;

	pass_case : IF P = 1 GENERATE
		result <= input_vector;
	END GENERATE;

END Behavioral;
``` 
## Testes realizados e descrição dos testbenches
Como proposta da atividade III foram realizadas as descrições de dois *testbenches*, para a sad-v1 testou-se o estímulo utilizado na atividade dois, que foi a repetição da soma da diferença entre *11111111* e *00000001*. Esse testbench apenas representa a descrição simples de estímulos, mas feitos em um *testbench*.
Já o *testbench* para a sad-v3 é muito mais completo e testa 50 blocos de 8x8 vetores de 8 bits. O arquivo de estímulos é gerado pelo *golden model* que aplica uma lógica em alto nível para gerar vetores aleatórios de 8 bits e calcula o resultado esperado para o circuito da SAD.

### Golden model
Conforme apresentado em aula, o golden model é um modelo de referência, desenvolvido fora do escopo do projeto, que representa o comportamento correto e esperado do projeto desenvolvido. Nesse sentido, foi utilizada a linguagem de programação Java para geração aleatória de estímulos e o cálculo do resultado esperado, sendo estes feitos em alto nível.
O código do golden model (classe goldenModel) pode ser encontrado no diretório 'golden-model' dentro de 'sad-v3' junto com as instruções para sua compilação.

