
**joão depois se possível deixar isso aqui bem bonitinho, e ve se tu consegue rodar esse goldem model no teu pc usando essas intruções**

instruções para gerar o arquivo values.dat, utilizado pelo testbench do sadv3

1 - verifique se o arquivo gm.java está na pasta raiz do projeto

2 - abra o terminal e navegue até a pasta raiz do projeto utilizando o commando cd

3 - digitar os seguintes comandos, na ordem em que aparecem

	javac gm.java
	java gm

4 - após executar os comandos, o arquivo "values.dat" é gerado e os testes podem ser realizados

obs 1, caso deseje gerar novos valores para values.dat basta executar o seguinte comando novamente
	
	java gm

obs 2, é nescessário ter uma instalação do jdk (java development kit) no seu sistema para executar este gerador

obs 3, caso não seja possível a geração automatica do arquivo .dat, uma versão pré pronta está disponivel na pasta values pronto,
neste caso e so mover o arquivo .dat para a raiz do projeto e iniciar a testbench

