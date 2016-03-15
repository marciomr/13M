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
end

class Post < ActiveRecord::Base
  belongs_to :page
  has_many :likes, dependent: :destroy
end

class Like < ActiveRecord::Base
  belongs_to :post
end

class Confirmation < ActiveRecord::Base
end

class Event < ActiveRecord::Base
    def self.populate (id)
        if e = Event.where(fb_id: id).first
            puts "Evento #{e.name} já cadastrado"
            return
        end
        ActiveRecord::Base.transaction do
            fb_event = Facebook.connect(id, 'self')
            event = Event.create(fb_id: id, name: fb_event['name'])
            event.save
            attending = Facebook.connect(id, 'attending')
            bar = ProgressBar.new(4800)
            Facebook.total(attending) do |user|
                new_user = Confirmation.create user_id: user['id'], event_id: event.id
                new_user.save
                bar.increment!
            end
        end
    end
end
