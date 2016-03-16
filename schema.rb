#!/usr/bin/env ruby
# encoding: utf-8
require './connect_db.rb'

ActiveRecord::Migration.class_eval do
  create_table :pages do |t|
    t.string :fb_id, null: false
    t.string :name, null: false
  end
  add_index :pages, :fb_id, unique: true

  create_table :posts do |t|
    t.string :fb_id, null: false
    t.text :message # PODE ser nulo (apenas imagem)
    t.belongs_to :page, index: true
  end
  add_index :posts, :fb_id, unique: true

  create_table :likes do |t|
    t.string :user_id, null: false
    t.belongs_to :post, index: true
  end
  add_index :likes, [:user_id, :post_id], unique: true

  create_table :events do |t|
      t.string :fb_id, null: false
      t.text :name, null: false
  end
  add_index :events, :fb_id, unique: true

  create_table :confirmations do |t|
    t.string :user_id, null: false
    t.belongs_to :event, index: true
  end
  add_index :confirmations, [:user_id, :event_id], unique: true
  
end
