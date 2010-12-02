require 'bundler'
Bundler.require :default

require './lingr'
run Sinatra::Application
