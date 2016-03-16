#!/usr/bin/env ruby
# encoding: utf-8
require './modules.rb'

LOG = "results.log"

puts "Resultados 13M"; puts "Lendo banco de dados..."
confirmeds = Event.interacting

Page.all.each { |p| 
    i = p.interacting
    l = p.likes_total
    puts "Página #{p.name}"
    puts "Interagiram no período: #{i.size}; likes: #{l}; média: #{ (l.to_f / i.size).round(2) } likes por usuário"
    count = Set.new( i & confirmeds ).size
    puts "Confirmados nos eventos: #{count}"
    
    # escreve os resultados no log
    File.open(LOG,'w+') do |f|
      f.write "#{p.name} \n"
      f.write "\t Interagiram no período: #{i.size}\n"
      f.write "\t Likes: #{l}\n"
      f.write "\t Média: #{ (l.to_f / i.size).round(2) } likes por usuário"
      f.write "\t Confirmados nos eventos: #{count}"
    end
}
