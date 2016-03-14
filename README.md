# Instale o ruby #
* No Linux
  * Instruções em https://rvm.io/rvm/install
  * sudo apt-get install curl
  * curl -sSL https://get.rvm.io | bash
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
* Coloqueo URL "http://gpopai.usp.br"
* Salve as alerações

# Rode a aplicação #
* Vá para um terminal e digite rode o comando "bundle" para instalar as dependências
* Rode o comando "ruby run.rb"
* Na primeira execução você terá que digitar
  * o email usado no Facebook,
  * sua senha,
  * o ID da aplicação e
  * o segredo da aplicação.
* Visite https://github.com/marciomr/13M/issues e escolha uma página ainda não estudada
* O processo demorará algumas horas
* Quando finalizar por favor nos encaminhe o resultado
