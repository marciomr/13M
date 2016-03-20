#!/usr/bin/env ruby
# encoding: utf-8
require 'csv'
require './modules.rb'

IDs = YAML.load_file("IDs.yaml")

IDs["events"].each do |event, ids|
  puts "Resultados #{event}"; puts "Lendo banco de dados..."

  Page.all.each do |p| 
    i = p.interacting
    l = p.likes_total
    puts "Página #{p.name}"
    puts "Interagiram no período: #{i.count}; likes: #{l}; média: #{ (l.to_f / i.count).round(2) } likes por usuário"
    count = i.join("JOIN confirmations").where(events_id: ids).count
    puts "Confirmados em #{event}: #{count}"

    CSV.open("#{event}.csv", "a+") do |csv|
      csv << [p.name, i.count, l, count]
    end
  end
end
