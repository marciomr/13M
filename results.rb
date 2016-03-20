#!/usr/bin/env ruby
# encoding: utf-8
require 'csv'
require './modules.rb'

IDs = YAML.load_file("IDs.yaml")

IDs["events"].each do |event, ids|
  puts "Resultados #{event}"; puts "Lendo banco de dados..."
  events = Event.where(fb_id: ids)
  confirmeds = Set.new
  events.all.each do |e|
    confirmeds.merge(e.confirmations.map(&:user_id))
  end
  # acho que dá pra fazer isso de maneira mais eficiente
#confirmeds = Event.interacting


  Page.all.each { |p| 
    i = p.interacting
    l = p.likes_total
    puts "Página #{p.name}"
    puts "Interagiram no período: #{i.size}; likes: #{l}; média: #{ (l.to_f / i.size).round(2) } likes por usuário"
    count = Set.new( i & confirmeds ).size
    puts "Confirmados em #{event}: #{count}"

    CSV.open("#{event}.csv", "a+") do |csv|
      csv << [p.name, i.size, l, count]
    end
  }
end
