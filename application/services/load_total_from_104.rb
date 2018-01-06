# frozen_string_literal: true

require 'dry/transaction'
require 'json'
require 'concurrent'

module ThxSeafood
  # Transaction to load repo from Github and save to database
  class LoadTotalFrom104
    include Dry::Transaction

    step :get_total_page_num
    step :load_jobs_from_104
    step :return_all_page_jobs

    def get_total_page_num(input)
      page_num = A104::JobMapper.new(A104::Api.new).get_total_page_num(input[:jobname])   # Integer
      input[:page_num] = page_num
      Right(input)
    rescue StandardError
      Left(Result.new(:bad_request, 'Caculate page num error'))
    end
    
    def load_jobs_from_104(input)
      total_record_num = A104::JobMapper.new(A104::Api.new).get_total_record_num(input[:jobname])
      load_count = Repository::For[Entity::Job].find_jobs_by_user_query(input[:jobname]).count
    
      if load_count >= total_record_num
        Right(input)
      else

        # round = (input[:page_num] + 19)/20

        # (1..round).each{ |offset|
        #   Concurrent::Promise.execute{
        #     load_data_request = LoadDataRequest.new(input[:page_num], input[:jobname], offset)
        #     load_data_request_json = LoadDataRequestRepresenter.new(load_data_request).to_json
        #     LoadPageDataWorker.perform_async(load_data_request_json)
        #   }
        # }
        
        # 只要送一次就好，要做Promise的是Shoryuken worker，而不是API這邊一直送msg到SQS
        # 這邊使用Promise，可以讓client「馬上」收到202 message
        # Concurrent::Promise.execute{
        #   load_data_request = LoadDataRequest.new(input[:page_num], input[:jobname])
        #   load_data_request_json = LoadDataRequestRepresenter.new(load_data_request).to_json
        #   LoadPageDataWorker.perform_async(load_data_request_json)
        # }.value

        # load_data_request = LoadDataRequest.new(input[:page_num], input[:jobname])
        # load_data_request_json = LoadDataRequestRepresenter.new(load_data_request).to_json
        # LoadPageDataWorker.perform_async(load_data_request_json)
       

        # # 這裡先load前20頁就好，不然worker跑超久，而且可能產生DatabaseBusyError，以及突破SQS收訊限制(之前明明將近48xx多筆資料，卻只有儲存38xx多筆到DB裡面，少掉了一千多筆左右的資料)
        (1..input[:page_num]).each{ |page|
          Concurrent::Promise.execute{
            load_data_request = LoadDataRequest.new(page, input[:jobname], intput[:page_num])
            load_data_request_json = LoadDataRequestRepresenter.new(load_data_request).to_json
            LoadPageDataWorker.perform_async(load_data_request_json)
          }
        }
        
        # # 這邊使用Promise(concurrent)，讓其可以馬上response 202 message給appa端，(假設共248頁)否則會等送完248次訊息到SQS才會response，但這樣的會就可能造成heroku上面的timeout，因而被kill掉process
        # (1..input[:page_num]).each{ |page|
        #   Concurrent::Promise.execute{
        #     load_data_request = LoadDataRequest.new(page, input[:jobname])
        #     load_data_request_json = LoadDataRequestRepresenter.new(load_data_request).to_json
        #     LoadPageDataWorker.perform_async(load_data_request_json)
        #   }
        # }

        Left(Result.new(:processing, 'Processing the total data loading, please come back later'))
      end
      
    rescue StandardError
      Left(Result.new(:bad_request, 'Jobs not found'))
    end
  

    def return_all_page_jobs(input)
      # jobs = Repository::For[Entity::Job].all
      keywords = input[:jobname]
      jobs = Repository::For[Entity::Job].find_jobs_by_user_query(keywords)
      
      if jobs
        Right(Result.new(:ok, jobs))
      else
        Left(Result.new(:not_found, 'Could not find stored jobs from DB'))
      end
    end

  end  
end