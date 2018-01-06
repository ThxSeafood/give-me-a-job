# frozen_string_literal: true

require 'json'

module ThxSeafood
  
  class Api < Roda
    plugin :all_verbs
  
    # /api/v0.1/shoryuken branch
    route('shoryuken') do |routing|
      
      routing.is do
        {route: "shoryuken"}.to_json
      end

      # POST /api/v0.1/shoryuken/:jobname
      routing.post String do |jobname|
        service_result = LoadTotalFrom104.new.call(
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