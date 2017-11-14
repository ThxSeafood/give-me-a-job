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

module ThxSeafood
  # Web API
  class Api < Roda
    plugin :json
    plugin :halt

    route do |routing|
      app = Api

      # GET / request
      routing.root do
        { 'message' => "ThxSeafood API v0.1 up in #{app.environment}" }
      end

      routing.on 'api' do
        # /api/v0.1 branch

        routing.is do
          {api: "api"}
        end
        routing.get "v0.1" do
          {version: "v0.1"}
        end

        routing.on 'v0.1' do
          # /api/v0.1/job branch
          routing.on 'job', String do |jobname|

            # 這邊得改成回傳jobname裡包含keywords的job entity array (得改寫Jobs，也許要加個方法)
            # GET /api/v0.1/jobs/:keywords request
            routing.get do
              job = Repository::For[Entity::Job]
                     .find_jobname(jobname)

              routing.halt(404, error: 'Job not found') unless job
              job.to_h
            end

            # POST /api/v0.1/jobs/:jobname
            routing.post do
              api = A104::Api.new
              job_mapper = A104::JobMapper.new(api)
              begin                
                jobs = job_mapper.load_several(jobname)
              rescue StandardError
                routing.halt(404, error: "No result")
              end

              stored_jobs = jobs.map{ |job| Repository::For[Entity::Job].find_or_create(job) }
              response.status = 201
              response['Location'] = "/api/v0.1/jobs/#{jobname}"
              stored_jobs.map{ |job| job.to_h }
            end
          end
        end
      end
    end
  end
end
