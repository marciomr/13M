#!/home/marciomr/.rvm/rubies/ruby-2.2.1/bin/ruby
# coding: utf-8

require 'sqlite3'
require 'active_record'

ActiveRecord::Base.establish_connection(
   :adapter   => 'sqlite3',
   :database  => './13M.db'
)

ActiveRecord::Migration.class_eval do
  create_table :pages do |t|
    t.string :fb_id
    t.string :name
    t.date :creation_date
    t.integer :likes_count
    t.integer :posts_count
  end

  create_table :posts do |t|
    t.string :fb_id
    t.string :cathegory
    t.text :message
    t.integer :likes_count
    t.integer :shares_count
    t.date :creation_date
    t.belongs_to :page, index: true
  end

  create_table :likes do |t|
    t.string :user
    t.belongs_to :post, index: true
  end

  create_table :interesteds do |t|
    t.string :user
    t.belongs_to :event, index: true
  end

  create_table :confirmeds do |t|
    t.string :user
    t.belongs_to :event, index: true
  end
  
end
