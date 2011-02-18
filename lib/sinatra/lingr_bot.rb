require 'sinatra/base'
require 'yajl/json_gem'
require 'hashie/mash'

module Sinatra
  module LingrBot
    def lingr_endpoint(path, &block)
      post path do
        hash = JSON.parse(request.body)

        hash['events'].map {|event|
          instance_exec(Hashie::Mash.new(event), &block)
        }.compact.join("\n")
      end
    end
  end

  register LingrBot
end
