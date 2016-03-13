#!/home/marciomr/.rvm/rubies/ruby-2.2.1/bin/ruby
# coding: utf-8

require 'active_record'

ActiveRecord::Base.establish_connection(
   :adapter   => 'sqlite3',
   :database  => './13M.db'
)

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

class Confirmed < ActiveRecord::Base
end

class Interested < ActiveRecord::Base
end
