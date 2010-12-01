require 'rss'
require 'stringio'

set :views, File.join(File.dirname(__FILE__), 'views')

get '/' do
  haml :index
end

post '/' do
  hash = Yajl::Parser.new.parse(params[:json])

  hash["events"].map {|event|
    case event["message"]["text"]
    when /^!ruby (.+)$/
      begin
        eval $1
      rescue Exception => e
        e.message
      end
    when /^!ruby= (.+)$/
      fds = [STDOUT, STDERR]
      orig_fds = fds.map(&:dup)
      buf = Tempfile.new('god')

      fds.each do |fd|
        fd.reopen(buf)
      end

      begin
        eval $1
        fds.each(&:flush)
        buf.tap(&:rewind).read
      rescue Exception => e
        e.message
      ensure
        fds.zip(orig_fds).each do |fd, orig|
          fd.reopen(orig)
        end

        buf.close
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
  }.join("\n")
end
