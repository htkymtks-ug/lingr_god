require 'bundler'
Bundler.require :default, :test

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.mock_with :rr
end
