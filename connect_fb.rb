#!/usr/bin/env ruby
# encoding: utf-8

require 'koala'
require 'mechanize'
require 'highline/import'
require 'yaml'

class FB
    # Configuracao global?
    REDIRECT_URL = "http://gpopai.usp.br/"

    # Proxima pagina de resultados paginados
    def next_page(klass)
        begin
            return klass.next_page if klass
        rescue
            sleep 3
            return next_page klass
        end
    end
    # o fb pagina alguns resultados
    # este metodo aplica o bloco &block em todas as paginas
    def total(klass, &block)
        loop do
            break if(!klass)
            klass.each(&block)
            klass = next_page klass
        end
    end
    def get_config
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
    end
    # se a conexão falhar espere 5 segundos e tente de novo
    def connect(id, type, args = {})
        begin
            if type == "self"
                return @graph.get_object(id)
            else
                return @graph.get_connections(id, type, args)
            end
        rescue
            puts "Retrying failed connection..."
            sleep 3
            return connect(id, type)
        end
    end
#    def graph
#        @graph
#    end
    def total_likes(id)
        return @graph.get_object(id, fields: "likes.summary(true)")['likes']['summary']['total_count']
    end
    def total_attending(id)
        return @graph.get_object(id, fields: "attending.summary(true)")['attending']['summary']['count']
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
    def initialize
        get_config # le as configuracoes de usuario/senha

        puts "Conectando..."

        # conecta com a Graph API
        @oauth = Koala::Facebook::OAuth.new(@config['app_id'], @config['app_secret'], REDIRECT_URL)
        begin
            code = get_access_code(@oauth.url_for_oauth_code)
        rescue
            puts "Houve um erro ao resgatar o token de autorização. Copie e cole o seguinte URL"
            puts "em um browser, autorize o app e tente novamente"
            puts @oauth.url_for_oauth_code
            exit
        end
        token = @oauth.get_access_token(code)
        @graph = Koala::Facebook::API.new(token)
    end
end

Facebook = FB.new

