# frozen_string_literal: true

require 'dry/transaction'
require 'json'

module ThxSeafood

  class FindHotJobs
    include Dry::Transaction


    step :check_or_call_worker
    step :hot_jobs

    def check_or_call_worker(input)
      count = Repository::For[Entity::Hot].all.count
      
      if count == input[:topnum] * 7
        Right(input)
      else      
        request = FindHotJobsRequest.new(input[:topnum], input[:id])
        request_json = FindHotJobsRequestRepresenter.new(request).to_json
        FindHotJobsWorker.perform_async(request_json)
      
        Left(Result.new(:processing, { id: input[:id] }))
      end
    end


    def hot_jobs(input)
      taipei_jobs = Repository::For[Entity::Hot].find_by_city("台北")
      new_taipei_jobs= Repository::For[Entity::Hot].find_by_city("新北")
      taoyuan_jobs = Repository::For[Entity::Hot].find_by_city("桃園")
      hsinchu_jobs = Repository::For[Entity::Hot].find_by_city("新竹")
      taichung_jobs = Repository::For[Entity::Hot].find_by_city("台中")
      tainan_jobs = Repository::For[Entity::Hot].find_by_city("台南")
      kaohsiung_jobs = Repository::For[Entity::Hot].find_by_city("高雄")
      
      city_hot_jobs = CityHotJobs.new(
        taipei_jobs,
        new_taipei_jobs,
        taoyuan_jobs,
        hsinchu_jobs,
        taichung_jobs,
        tainan_jobs,
        kaohsiung_jobs
      )
      
      Right(Result.new(:ok, city_hot_jobs))      
    rescue StandardError     
      Left(Result.new(:internal_error, 'List hot jobs error'))       
    end
  
  
  end
end
