# frozen_string_literal: true

require 'dry/transaction'
require 'json'

module ThxSeafood
  # Transaction to load repo from Github and save to database
  class LoadTotalFrom104
    include Dry::Transaction

    step :get_total_page_num
    step :get_jobs_from_104

    def get_total_page_num(input)
      page_num = A104::JobMapper.new(A104::Api.new).get_total_page_num(input[:jobname])   # Integer
      input[:page_num] = page_num
      Right(input)
    rescue StandardError
      Left(Result.new(:bad_request, 'Jobs not found'))
    end
    
    def get_jobs_from_104(input)
      
      (1..input[:page_num]).each{ |page|
        load_data_request_json = {page: page, keywords: input[:jobname]}.to_json
        LoadPageDataWroker.perform_async(load_data_request_json)
      }
      
          
      
      jobs = A104::JobMapper.new(A104::Api.new).load_several(input[:jobname])
      Right(jobs: jobs)
    rescue StandardError
      Left(Result.new(:bad_request, 'Jobs not found'))
    end



  end
end