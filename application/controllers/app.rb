# require 'sinatra'

# # NOTE: ENV variables should be set directly in terminal for testing on localhost

# # Talk to Facebook
# get '/webhook' do
#   params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
# end

# get "/" do
#   "Hi, there is nothing here"
# end

# frozen_string_literal: true

require 'roda'


module ThxSeafood
  # Web API
  class Api < Roda
    # plugin :halt
    plugin :all_verbs
    plugin :multi_route
    
    require_relative 'jobs'
    require_relative 'shoryuken'
    require_relative 'hot'

    route do |routing|

      response['Content-Type'] = 'application/json'

      response['Access-Control-Allow-Origin'] = 'http://localhost:9292'
      response['Access-Control-Allow-Credentials'] = 'true'
      response['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'


      # GET / request
      routing.root do
        message = "ThxSeafood API v0.1 up in #{Api.environment} mode"
        HttpResponseRepresenter.new(Result.new(:ok, message)).to_json
      end

      # Talk to Facebook
      routing.on '/webhook' do
        routing.get do
          params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
        end
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do          
          @api_root = '/api/v0.1'
          routing.multi_route        
        end        
      end
    end
  end
end
