# coding: utf-8

$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'sinatra'
require 'sinatra/lingr_bot'
require 'sinatra/capture_output'
require 'rss'

set :views, File.join(File.dirname(__FILE__), 'views')

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
    item = RSS::Parser.new('http://favstar.fm/users/htkymtks/rss').parse.items.choice
    "#{item.title}\n#{item.link}"
  else
    if event.message.speaker_id == "htkymtks"
      "え？解説してください。"
    else
      nil
    end
  end
end
