# coding: utf-8

#!/usr/bin/env ruby
# encoding: utf-8
require 'csv'
require './modules.rb'

IDs = YAML.load_file("IDs.yaml")

IDs["events"].each do |event, ids|
  puts "Resultados #{event}"; puts "Lendo banco de dados..."

  events = ids.map do |id|
    Event.find_by_fb_id(id).id
  end
  
  Page.all.each do |p| 
    i = p.interacting
    l = p.likes_total
    puts "Página #{p.name}"
    puts "Interagiram no período: #{i.count}; likes: #{l}; média: #{ (l.to_f / i.count).round(2) } likes por usuário"
#
    count = p.likes.joins("JOIN confirmations ON likes.user_id = confirmations.user_id").where("confirmations.event_id IN (?)", events).select(:user_id).distinct.count
    puts "Confirmados em #{event}: #{count}"

    CSV.open("#{event}.csv", "a+") do |csv|
      csv << [p.name, i.count, l, count]
    end
  end
end
