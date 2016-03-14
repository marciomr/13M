#!/home/marciomr/.rvm/rubies/ruby-2.2.1/bin/ruby
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
    next if !Post.where(fb_id: post['id']).empty?
    shares_count = post['shares']['count'] if post['shares']

    new_post = page.posts.create fb_id: post['id'],
                                 message: post['message'],
                                 cathegory: post['type'],
                                 shares_count: shares_count
    max = @graph.get_object(post['id'], fields: "likes.summary(true)")['likes']['summary']['total_count']
    @bar = ProgressBar.new(max)
    puts Time.parse(post['created_time']).strftime('%d/%m/%Y %H:%M:%S')
    break if (Time.parse(post['created_time']) < LIMIT)
    new_post.likes_count = populate_likes(page, new_post, post['id'])
    new_post.save
  end
end

# minha página curtiu as páginas mais relevantes do movimento de ocupações
# pego cada uma dessas páginas, cada post dela e cada curtida nos posts
# guardo tudo em um DB usando o ActiveRecord
page = @graph.get_object($id)
new_page = Page.create fb_id: $id,
                       likes_count: page['likes'],
                       name: page['name']

puts "Baixando posts de #{page['name']}."
puts "Serão processados todos os posts até dia #{LIMIT.strftime(%d/%m/%Y)}."
puts "Isso pode levar várias horas."

new_page.posts_count = populate_posts(new_page, $id)
new_page.save

count = 0
Confirmed.all.each do |user|
  count += 1 if new_page.likes_total.include? user
end

puts "#{page['name']}"
puts "Curtidas no último mês: #{new_page.likes_total}"
puts "Número de usuários que curtiram no último mês: #{Set.new(new_page.likes_total).count}"
puts "Número de usuários que confirmaram presença nos eventos: #{count}"
puts "Porcentagem do total de confirmados: #{100*Float(count)/Confirmed.size}\%"
