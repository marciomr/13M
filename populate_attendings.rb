#!/home/marciomr/.rvm/rubies/ruby-2.2.1/bin/ruby
# coding: utf-8

require 'koala'
require 'progress_bar'
require './modules.rb'
require './populate_db.rb'

EVENT_ID = "562015653953532"

attending = @graph.get_connections(EVENT_ID, 'interested')
bar = ProgressBar.new(4800)
loop do
  break if !attending
  attending.each do |user|
    new_user = Interested.create user: user['id']
    new_user.save
    bar.increment!
  end
  attending = next_page attending
end
