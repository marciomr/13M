require './modules.rb'

def print_posts(posts)
  posts.each do |id, likes|
    post = Post.find(id)
    puts post.page.name
    likes_totais = post.likes.count
    puts "#{likes} de #{likes_totais} (#{100*likes.to_f/likes_total})"
    puts p.message
  end
end

IDs = YAML.load_file("IDs.yaml")

IDs["events"].each do |event, ids|
  puts "Posts mais populares em #{event}"; puts "Lendo banco de dados..."

  events = ids.map do |id|
    Event.find_by_fb_id(id).id
  end

  likes_conf = Like.joins("JOIN confirmations ON confirmations.user_id = likes.user_id")
  posts = likes_conf.where("confirmations.event_id IN (?)", events).group(:post_id)

  bruto = posts.count.sort_by{|k,v| v}[-10..-1]
  percentual = posts.count.sort_by do |k,v|
    v/(Post.find(k).likes.count).to_f
  end[-10..-1]

  puts "Em termos totais"
  print_posts(bruto)

  puts "Em termos relativos"
  print_posts(percentual)
end
