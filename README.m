🧩 Atividade de Desenvolvimento – Cadastro de Pessoas

Objetivo:
Desenvolver uma funcionalidade de listagem e cadastro de pessoas, com suporte a edição, exclusão e inclusão de registros, controlando todos os dados localmente dentro do aplicativo.

🖥️ Descrição Geral

Criar uma tela com:

- Listagem de pessoas cadastradas, exibindo informações principais (Nome, CPF e Email).
- Formulário de cadastro/edição, permitindo incluir ou alterar dados.
- Ações disponíveis:
- Cadastrar nova pessoa
- Editar pessoa existente
- Excluir pessoa da lista
- Todas as operações devem refletir diretamente na lista em memória utilizada como armazenamento temporário.

🧱 Estrutura de Dados
-Classe Pessoa
	- ID	Integer	Identificador único da pessoa
	- NomeCompleto	String	Nome completo do indivíduo
	- CPF	String	CPF da pessoa
	- DataNascimento	TDate	Data de nascimento
	- Email	String	Endereço de e-mail
	- Telefone	String	Número de telefone
	- Endereco	Objeto	Objeto do tipo Endereco
- Classe Endereco
	- Propriedade	Tipo	Descrição
	- Logradouro	String	Rua ou avenida
	- Bairro	String	Bairro
	- Cidade	String	Cidade
	- UF	String	Unidade Federativa (Estado)

⚙️ Requisitos Técnicos
- Armazenamento e manipulação de dados devem ser feitos em listas e objetos dentro da aplicação (sem banco de dados).
- As alterações (cadastro, edição e exclusão) devem ser imediatamente refletidas na lista de armazenamento.
- O fechamento do aplicativo não deve gerar MemoryLeaks (fugas de memória).
- O código deve seguir boas práticas de organização e encapsulamento de classes.

