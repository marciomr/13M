#!/usr/bin/env ruby
# coding: utf-8

require 'koala'
require 'highline/import'
require 'progress_bar'
require './modules.rb'
require './populate_db.rb'

LIMIT = Time.new() - 1.month

$id = ask "Digite o ID da página"

# popula a tabela de likes
def populate_likes(page, post, id)
  likes = connect(id, 'likes')
  total(likes) do |like|
    post.likes.create user: like['id']
    @bar.increment!
  end
end

# popula a tabela de posts
def populate_posts(page, id)
  posts = connect(id, 'posts')
  total(posts) do |post|
    # A linha abaixo encerra o laço caso o post esteja fora do limite de tempo
    break if (Time.parse(post['created_time']) < LIMIT)
    # A linha abaixo pula esse post caso já exista no banco de dados:
    next if !Post.where(fb_id: post['id']).empty?
    shares_count = post['shares']['count'] if post['shares']

    # Englobamos o download em uma transação - assim se houver um erro
    # no meio do download, o post não fica salvo pela metade
    ActiveRecord::Base.transaction do
        new_post = page.posts.create fb_id: post['id'],
                                     message: post['message'],
                                     cathegory: post['type'],
                                     shares_count: shares_count
        max = @graph.get_object(post['id'], fields: "likes.summary(true)")['likes']['summary']['total_count']
        puts Time.parse(post['created_time']).strftime('%d/%m/%Y %H:%M:%S')
        @bar = ProgressBar.new(max)
        new_post.likes_count = populate_likes(page, new_post, post['id'])
        new_post.save
    end
  end
end

# minha página curtiu as páginas mais relevantes do movimento de ocupações
# pego cada uma dessas páginas, cada post dela e cada curtida nos posts
# guardo tudo em um DB usando o ActiveRecord
page = @graph.get_object($id)
pageDB = Page.where(fb_id: page['id'])
if !pageDB.empty?
  new_page = pageDB.first
else
  new_page = Page.create fb_id: $id,
                       likes_count: page['likes'],
                       name: page['name']
end

puts "Baixando posts de #{page['name']}..."
puts "Serão processados todos os posts até dia #{LIMIT.strftime('%d/%m/%Y')}."
puts "Isso pode levar várias horas."

new_page.posts_count = populate_posts(new_page, $id)
new_page.save

puts "Calculando a intersecção dos conjuntos..."
count = (Set.new(Confirmed.all.map(&:user)) & new_page.likes_total).size

puts "#{page['name']}"
puts "Curtidas no último mês: #{new_page.likes_total.size}"
puts "Número de usuários que confirmaram presença nos eventos: #{count}"
