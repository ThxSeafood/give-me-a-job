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
require 'econfig'
require_relative 'lib/init.rb'

module ThxSeafood
  # Web API
  class Api < Roda
    plugin :environments
    plugin :json
    plugin :halt

    extend Econfig::Shortcut
    Econfig.env = environment.to_s
    Econfig.root = '.'

    route do |routing|
      app = Api

      # GET / request
      routing.root do
        { 'message' => "ThxSeafood API v0.1 up in #{app.environment}" }
      end

      routing.on 'api' do
        # /api/v0.1 branch
        routing.on 'v0.1' do
          # /api/v0.1/:keywords branch
          routing.on 'jobs', String do |keywords|
            A104_api = A104::Api.new
            job_mapper = A104::JobMapper.new(A104_api)
            begin
              jobs = job_mapper.load_several(keywords)
            rescue StandardError
              routing.halt(404, error: 'No results')
            end

            # GET /api/v0.1/:keywords request
            routing.is do
              { jobs: jobs.map{:to_h} }
            end
          end
        end
      end
    end
  end
end
