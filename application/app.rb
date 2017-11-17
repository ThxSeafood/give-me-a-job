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
    plugin :halt
    
    route do |routing|
      app = Api

      # GET / request
      routing.root do
        { 'message' => "ThxSeafood API v0.1 up in #{app.environment}" }
      end

      # # Talk to Facebook
      # routing.on '/webhook' do
      #   routing.get do
      #     params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
      #   end
      # end

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
          routing.on 'jobs', String do |jobname|
            # GET /api/v0.1/jobs/:keywords request
            routing.get do
              find_result = FindDatabaseJobs.call(
                jobname: jobname
              )
  
              http_response = HttpResponseRepresenter.new(find_result.value)
              response.status = http_response.http_code
              if find_result.success?
                JobsRepresenter.new(JobsResult.new(find_result.value.message)).to_json
              else
                http_response.to_json
              end
            end

            # POST /api/v0.1/jobs/:jobname
            routing.post do
              service_result = LoadFrom104.new.call(
                jobname: jobname
              )

              http_response = HttpResponseRepresenter.new(service_result.value)
              response.status = http_response.http_code
              if service_result.success?
                response['Location'] = "/api/v0.1/jobs/#{jobname}"
                JobsRepresenter.new(JobsResult.new(service_result.value.message)).to_json
              else
                http_response.to_json
              end
            end
          end
        end
      end
    end
  end
end
