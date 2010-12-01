require 'rss'
set :views, File.join(File.dirname(__FILE__), 'views')

get '/' do
  haml :index
end

post '/' do
  parser = Yajl::Parser.new
  hash = parser.parse(params[:json])
  hash["events"].map do |event|
    case event["message"]["text"]
    when /^!ruby (.+)$/
      begin
        eval $1
      rescue Exception => e
        e.message
      end
    when /^!fav$/
      item = RSS::Parser.new('http://favstar.fm/users/htkymtks/rss').parse.items.choice
      "#{item.title}\n#{item.link}"
    else
      if event["message"]["speaker_id"] == "htkymtks"
        "え？解説してください。"
      else
        nil
      end
    end
  end.join("\n")
end
