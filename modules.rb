#!/usr/bin/env ruby
# encoding: utf-8
require 'progress_bar'
require './connect_db.rb'
require './connect_fb.rb'

class Page < ActiveRecord::Base
    has_many :posts, dependent: :destroy

    # devolve todos os likes de todos os posts de uma página
    def likes_total
        total = Set.new
        posts.all.each do |post|
            total.merge(post.likes.map(&:user))
        end
        total
    end

    def self.populate (id, limits)
        unless page = Page.where(fb_id: id).first
            fb_page = Facebook.connect(id, 'self')
            page = Page.create(fb_id: id, name: fb_page['name'])
            page.save
        end
        puts "Baixando dados da página #{page.name}..."
        posts = Facebook.connect(id, 'posts')
        Facebook.total(posts) do |post|
            next if Time.parse(post['created_time']) > Time.parse(limits['high']) # too soon
            break if Time.parse(post['created_time']) < Time.parse(limits['low']) # too old
            Post.populate post['id'], page.id
        end
    end
end

class Post < ActiveRecord::Base
    belongs_to :page
    has_many :likes, dependent: :destroy
    def self.populate (id, page_id)
        if p = Post.where(fb_id: id).first
            puts "Post já cadastrado..."
            return
        end
        ActiveRecord::Base.transaction do
            fb_post = Facebook.connect(id, 'self')
            post = Post.create fb_id: id, message: fb_post['message'], page_id: page_id
            post.save
            puts "Baixando dados do post em " + Time.parse(fb_post['created_time']).strftime('%d/%m/%Y %H:%M:%S')
            bar = ProgressBar.new Facebook.total_likes(id)
            post.populate_likes (bar)
        end
    end
    def populate_likes (bar)
        post_likes = Facebook.connect(fb_id, 'likes')
        Facebook.total(post_likes) do |like|
            self.likes.create user_id: like['id']
            bar.increment!
        end
    end
end

class Like < ActiveRecord::Base
    belongs_to :post
end

class Confirmation < ActiveRecord::Base
    belongs_to :event
end

class Event < ActiveRecord::Base
    has_many :confirmations, dependent: :destroy
    def self.populate (id)
        if e = Event.where(fb_id: id).first
            puts "Evento #{e.name} já cadastrado"
            return
        end
        ActiveRecord::Base.transaction do
            fb_event = Facebook.connect(id, 'self')
            event = Event.create(fb_id: id, name: fb_event['name'])
            event.save
            puts "Baixando dados do evento #{event.name}..."
            attending = Facebook.connect(id, 'attending')
            bar = ProgressBar.new(400000)
            Facebook.total(attending) do |user|
                new_user = Confirmation.create user_id: user['id'], event_id: event.id
                new_user.save
                bar.increment!
            end
        end
    end
end
