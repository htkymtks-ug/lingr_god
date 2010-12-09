# coding: utf-8
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'sinatra'
require 'sinatra/lingr_bot'
require 'sinatra/capture_output'
require 'rss'

set :app_file, __FILE__

get '/' do
  haml :index
end

lingr_endpoint '/' do |event|
  case event.message.text
  when /^!ruby(=)? (.+)$/
    begin
      $1 ? capture_output { eval($2) } : eval($2)
    rescue Exception => e
      e.message
    end
  when /^!fav$/
    item = RSS::Parser.new('http://favstar.fm/users/htkymtks/rss').parse.items.sample
    "#{item.title}\n#{item.link}"
  when /^!chainsaw$/
    "http://farm6.static.flickr.com/5161/5240705190_edc4d29853_m.jpg"
  when /^そんな装備で大丈夫か$/
    "http://image.space.rakuten.co.jp/lg01/10/0001062610/96/imgc4ca50c0zik6zj.gif\n大丈夫だ。問題ない。"
  else
    if event.message.speaker_id == "htkymtks"
      "え？解説してください。"
    else
      nil
    end
  end
end
