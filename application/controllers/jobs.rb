# frozen_string_literal: true

module ThxSeafood
  
  class Api < Roda
    plugin :all_verbs

    # /api/v0.1/jobs branch
    route('jobs') do |routing|
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


