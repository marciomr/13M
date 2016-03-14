#!/home/marciomr/.rvm/rubies/ruby-2.2.1/bin/ruby
# coding: utf-8

require 'koala'
require 'mechanize'
require 'highline/import'
require 'yaml'
require './modules.rb'


unless File.exist? '.config'
  File.open('.config','w') do |h|
    config = {}
    config['email'] = ask "Digite seu email"
    config['pswd'] = ask("Digite sua senha do Facebook") { |q| q.echo = '*' }
    config['app_id'] = ask "Digite seu app id"
    config['app_secret'] = ask "Digite seu app secret"
    h.write config.to_yaml
  end
end

@config = YAML.load_file(".config")

# 861655597283300
# 5555ce30b9b77d3d80516ee3638c62ca
REDIRECT_URL = "http://gpopai.usp.br/"

def next_page(klass)
  begin
    return klass.next_page if klass
  rescue
    sleep 3
    return next_page klass
  end
end

# o fb pagina alguns resultados
# este metodo pega e conta tudo
def total(klass, &block)
  loop do
    break if(!klass)
    klass.each(&block)
    klass = next_page klass
  end
end

# se a conexão falhar espere 5 segundos e tente de novo
def connect(id, type)
  begin
    return @graph.get_connections(id, type)
  rescue
    sleep 3
    return connect(id, type)
  end
end


# entra na pagina, loga no FB e devolve o código
def get_access_code(page)
  @agent = Mechanize.new
  @agent.redirect_ok = :all
  @agent.follow_meta_refresh = :anywhere

  page = @agent.get page
  form = page.form_with(method: "POST")
  form.email = @config['email']
  form.pass = @config['pswd']
  @agent.submit form
  uri = URI(@agent.page.uri)
  CGI.parse(uri.query)['code'].first  
end

# conecta com a Graph API
@oauth = Koala::Facebook::OAuth.new(@config['app_id'], @config['app_secret'], REDIRECT_URL)
code = get_access_code(@oauth.url_for_oauth_code)
token = @oauth.get_access_token(code)
@graph = Koala::Facebook::API.new(token)

