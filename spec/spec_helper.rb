require 'rubygems'
require 'bundler'
Bundler.require :default, :test

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rr

  config.before :suite do
    set :environment, :test
  end

  def app
    Sinatra::Application
  end
end
