#!/usr/bin/env ruby
# encoding: utf-8
require './modules.rb'

puts "Resultados 13M"; puts "Lendo banco de dados..."
confirmeds = Event.interacting


Page.all.each { |p| 
    i = p.interacting
    l = p.likes_total
    puts "Página #{p.name}"
    puts "Interagiram no período: #{i.size}; likes: #{l}; média: #{ (l.to_f / i.size).round(2) } likes por usuário"
    count = Set.new( i & confirmeds ).size
    puts "Confirmados nos eventos: #{count}"
}
