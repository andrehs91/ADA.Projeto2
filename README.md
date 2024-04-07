# ADA Tech - Módulo 2 (Conteinerização)

**Observação:** A lógica de negócio e a estrutura básica deste projeto foi aproveitada do projeto entregue no módulo 1.

### Estrutura do Projeto
A solução consiste em:
- Um **producer** (ASP.NET Core Web API) contendo uma interface Swagger para envio das transações para processamento e consulta aos relatórios;
- Um **broker** (RabbitMQ) para comunicação assíncrona entre os serviços;
- Um **consumer** (Worker Service) para processamento das transações;
- Um **cache** (Redis) para melhora no desempenho do processamento das transações;
- Um **sistema de armazenamento de objetos** (MinIO) para armazenamento dos relatórios gerados.

### Regras de Negócio
&nbsp; &nbsp; O **producer** verifica apenas se os dados enviados estão de acordo com as restrições do objeto TransacaoDTO.\
&nbsp; &nbsp; Neste cenário, o **producer** envia a mensagem para uma *exchange* do tipo Fanout, que as distribui entre filas para efetivação da transação e verificação de fraudes.\
&nbsp; &nbsp; O **consumer** implementado neste projeto trata apenas da verificação de fraudes. Utilizando o cache da última transação válida, ele verifica a velocidade de deslocamento do cliente considerando as coordenadas geográficas destas transações.\
&nbsp; &nbsp; Caso uma nova transação seja efetuada no mesmo canal da anterior (Agência, Terminal de Auto Atendimento ou Internet Banking) e a velocidade de deslocamento calculada entre as duas localidades seja superior à 60 Km/h (valor arbitrário) o sistema identificará esta transação como fraudulenta e a incluirá em um conjunto armazenado em cache.\
&nbsp; &nbsp; A consulta aos relatórios deve ser feita no **producer**. As transações fraudulentas permanecerão em cache até que o relatório seja gerado. Quando ele for gerado, um arquivo será criado no MinIO e seu link será fornecido. A lista de links gerados por conta será armazenada em cache e também poderá ser consultada.

### Como Executar este Projeto Localmente

1. (Opcional) Altere os valores das variáveis de ambiente no arquivo ".env", localizado na raiz do projeto;
2. Na raiz do projeto, execute o comando: ` docker compose up `;
3. Acesse a interface do [Swagger](http://localhost:8080/swagger/index.html) e envie algumas transações; [^1]
4. (Opcional) Acompanhe a fila de mensagens através do endereço [localhost:15672](http://localhost:15672/);
5. (Opcional) Acompanhe os registros armazenados em cache através do endereço [localhost:8001](http://localhost:8001/);
6. (Opcional) Acompanhe o processamento das mensagens através dos logs do consumer (os cálculos realizados e o resultado da validação são enviados para o log);
7. Consulte e/ou liste os relatórios de uma conta.

[^1]: Para que os testes possam ser realizados com facilidade, o campo Data é de preenchimento manual e permite inclusive datas passadas.