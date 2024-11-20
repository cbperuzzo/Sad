## Instruções para gerar o arquivo estimulos.dat, utilizado pelo testbench do sad-v3

1. Abra o terminal e navegue até a pasta **/golden-model**  utilizando o comando **cd**.

2. Digite os seguintes comandos, na ordem em que aparecem.

	> javac goldenModel.java
	> java goldenModel

3. Após executar os comandos, o arquivo **estimulos.dat** é gerado na raiz do projeto, e a testbench está pronta para ser iniciada.



####  Observações adicionais:

- Caso deseje gerar novos valores para **estimulos.dat** basta executar o seguinte comando novamente.

	> java goldenModel

- É necessário ter uma instalação do jdk (java development kit) no seu sistema para executar este gerador.

- Caso não seja possível a geração automática do arquivo *.dat*, uma versão pré pronta está disponível na pasta **/golden-model** , neste caso é só mover o arquivo *.dat* para a raiz do projeto e iniciar a testbench.


