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
    plugin :all_verbs
    # plugin :multi_route
    
    route do |routing|

      response['Content-Type'] = 'application/json'

      response['Access-Control-Allow-Origin'] = 'http://localhost:4000'
      response['Access-Control-Allow-Credentials'] = 'true'
      response['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE'
      
      app = Api

      # GET / request
      routing.root do
        { 'message' => "ThxSeafood API v0.1 up in #{app.environment}" }.to_s
      end

      # Talk to Facebook
      routing.on '/webhook' do
        routing.get do
          params['hub.challenge'] if ENV["VERIFY_TOKEN"] == params['hub.verify_token']
        end
      end

      routing.on 'api' do
        # /api branch

        routing.is do
          {api: "api"}.to_s
        end

        routing.on 'v0.1' do
          
          # /api/v0.1 branch
          routing.is do
            {version: "v0.1"}.to_s
          end

          # /api/v0.1/job branch
          routing.on 'jobs' do            
            routing.is do

              # GET /api/v0.1/jobs request
              routing.get do
                all_result = FindDatabaseAllJobs.call
                
                http_response = HttpResponseRepresenter.new(all_result.value)
                response.status = http_response.http_code
                if all_result.success?
                  JobsRepresenter.new(JobsResult.new(all_result.value.message)).to_json
                else
                  http_response.to_json
                end
              end

              # DELETE /api/v0.1/jobs request
              Api.configure :development, :test do
                routing.delete do
                  %i[jobs].each do |table|
                    Api.DB[table].delete
                  end
                  http_response = HttpResponseRepresenter
                                  .new(Result.new(:ok, 'deleted tables'))
                  response.status = http_response.http_code
                  http_response.to_json
                end
              end

            end

            # GET /api/v0.1/jobs/:jobname request
            routing.get String do |jobname|
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
            routing.post String do |jobname|
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
