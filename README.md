# Instale o ruby #
* No Debian/Ubuntu
  * `sudo apt-get install ruby ruby-dev`
  * `sudo gem install bundler`
* No Windows
  * http://rubyinstaller.org/

# Crie uma aplicação no Facebook #
* Visite a página: https://developers.facebook.com/apps
* Clique no botão "Add a new app"
* Escolha a opção "Website"
* Clique uma aplicação de página
* Anote o ID da sua aplicação e o segredo
* Clique "Settings"
* Na aba "Advanced" procure a opção "Valid OAuth redirect URIs"
* Coloque o URL http://gpopai.usp.br
* Salve as alerações

# Baixe o programa #
* `git clone https://github.com/marciomr/13M.git`

# Crie o banco de dados
* Baixe o MySQL. Em Ubuntu, algo como
  * `sudo apt-get install mysql-server-5.6 libmysqlclient-dev`
* Entre no MySQL e crie o usuário e database para o 13M:
```
CREATE USER 13M@'localhost';
SET PASSWORD FOR 13M@'localhost' = PASSWORD('13M');
CREATE DATABASE 13M;
GRANT ALL ON 13M.* TO 13M@'localhost';
```

# Rode o programa #
* Entre na pasta `cd 13M`
* Digite `bundle` para instalar as dependências
* Edite o arquivo `IDs.yaml` para incluir as páginas que você deseja estudar.
* Rode o comando `ruby populate.rb`
* Na primeira execução você terá que digitar
  * o email usado no Facebook,
  * sua senha,
  * o ID da aplicação e
  * o segredo da aplicação.
* O processo demorará algumas horas
* Rode o comando `ruby results.rb` para ver os resultados.
* Quando finalizar por favor nos encaminhe o resultado
