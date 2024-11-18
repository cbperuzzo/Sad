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
## Testes realizados e descrição dos testbenches
### SAD-V1
### SAD-V3
#### Golden model
Conforme apresentado em aula, o golden model é um modelo de referência, desenvolvido fora do escopo do projeto, que representa o comportamento correto e esperado do projeto desenvolvido. Nesse sentido, foi utilizada a linguagem de programação Java para geração aleatória de estímulos e o cálculo do resultado esperado, sendo estes feitos em alto nível.
O código do golden model (classe goldenModel) pode ser encontrado no diretório 'golden-model' dentro de 'sad-v3' junto com as instruções para sua compilação.

