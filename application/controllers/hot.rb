# frozen_string_literal: true

require 'json'

module ThxSeafood
  
  class Api < Roda
    plugin :all_verbs
  
    # /api/v0.1/hot branch
    route('hot') do |routing|
      
      routing.is do
        {route: "hot"}.to_json
      end

      # GET /api/v0.1/hot/:topnum
      routing.get String do |topnum|

        request_id = [request.env, request.path, Time.now.to_f].hash  # Integer


        service_result = FindHotJobs.new.call(
          topnum: topnum.to_i,
          id: request_id
        )

        http_response = HttpResponseRepresenter.new(service_result.value)
        response.status = http_response.http_code
        if service_result.success?
          response['Location'] = "/api/v0.1/hot/#{topnum}"
          CityHotJobsRepresenter.new(service_result.value.message).to_json
        else
          http_response.to_json
        end

      end    
    end
  end
end